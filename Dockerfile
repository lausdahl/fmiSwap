
# Prepare the FaultInject extension
FROM maven:3-openjdk-18-slim
RUN apt-get update && apt install -y unzip && rm -rf /var/lib/apt/lists/*

ADD assemble-fault-inject-dependencies.sh /tools/
RUN cd /tools && sh assemble-fault-inject-dependencies.sh

# Create the maestro docker image
FROM adoptopenjdk/openjdk11

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3-pip unzip && \
    rm -rf /var/lib/apt/lists/*

# Set python
RUN ln -s /usr/bin/python3 /bin/python 

# Make sure the image supports unifmu by default
RUN pip install protobuf==3.17.3 zmq

WORKDIR /work/model

# Add maestro with helper to support extensions on classpath
ADD https://github.com/INTO-CPS-Association/maestro/releases/download/Release%2F2.3.0/maestro-2.3.0-jar-with-dependencies.jar /tools/maestro.jar
ADD maestro /bin/maestro
RUN chmod +x /bin/maestro

#RUN mkdir -p /tools/classpath && cd /tools/classpath && unzip /tools/maestro.jar
# Add entry point script
ADD run.sh /tools/run.sh

# Add model swap example

ADD leak_controller.fmu /work/model/
ADD leak_detector.fmu  /work/model/
ADD singlewatertank-20sim.fmu /work/model/
ADD watertankcontroller-c.fmu /work/model/

ADD FaultInject.mabl /work/model/
ADD wt_fault.xml /work/model/
ADD mm1.json /work/model/
ADD mm2.json /work/model/
ADD wt-run.sh /work/model/run.sh
ADD simulation-config.json /work/model/
ADD requirements.txt /work/model/
ADD post-process.sh /work/model/
ADD plot.py /work/model/
# Add the FaultInjec extension jars to the model classpath
COPY --from=0 /tools/dependencies /work/model/classpath

ENTRYPOINT ["sh","/tools/run.sh"]
