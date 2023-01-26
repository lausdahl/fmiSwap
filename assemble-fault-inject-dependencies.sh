#!/bin/sh
mvn --version

REPO=m2

rm -rf dependencies


curl -L -o /tmp/faultinject-root.pom https://raw.githubusercontent.com/INTO-CPS-Association/fault-injection-maestro/development/pom.xml

V="1.0.0-SNAPSHOT"
AID="root"
GID="org.into-cps.maestro.faultinject"
FPATH="/tmp/faultinject-root.pom"
mvn org.apache.maven.plugins:maven-install-plugin:3.1.0:install-file  -Dfile=$FPATH -DpomFile=$FPATH -DgroupId=$GID -DartifactId=$AID -Dversion=$V -Dpackaging=pom -DlocalRepositoryPath=$REPO



curl -L -o /tmp/faultinject.jar https://github.com/INTO-CPS-Association/fault-injection-maestro/releases/download/v1.0.0/faultinject-1.0.0-SNAPSHOT.jar


V="1.0.0-SNAPSHOT"
AID="faultinject"
GID="org.into-cps.maestro.faultinject"
FPATH="/tmp/faultinject.jar"
mvn org.apache.maven.plugins:maven-install-plugin:3.1.0:install-file  -Dfile=$FPATH -DgroupId=$GID -DartifactId=$AID -Dversion=$V -Dpackaging=jar -DlocalRepositoryPath=$REPO




cat <<EOF > pom.xml

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0-SNAPSHOT</version>
 
 
  <dependencies>
    <dependency>
      <groupId>$GID</groupId>
      <artifactId>$AID</artifactId>
      <version>$V</version>
       <exclusions>
          <exclusion>
             <groupId>org.into-cps.maestro</groupId>
            <artifactId>interpreter</artifactId>
          </exclusion>
           <exclusion>
             <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
          </exclusion>
           <exclusion>
             <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-api</artifactId>
          </exclusion>
          <exclusion>
             <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-1.2-api</artifactId>
          </exclusion>
          <exclusion>
             <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-slf4j-impl</artifactId>
          </exclusion>
        </exclusions>
    </dependency>
    <!--    <dependency>
                <groupId>commons-io</groupId>
                <artifactId>commons-io</artifactId>
                <version>2.7</version>
                <scope>compile</scope>
            </dependency>

           
            <dependency>
                <groupId>org.apache.commons</groupId>
                <artifactId>commons-lang3</artifactId>
                <version>3.11</version>
            </dependency>

        
            <dependency>
                <groupId>org.apache.commons</groupId>
                <artifactId>commons-text</artifactId>
                <version>1.9</version>
            </dependency>

            <dependency>
                <groupId>com.fasterxml.jackson.core</groupId>
                <artifactId>jackson-databind</artifactId>
                <version>2.12.6.1</version>
            </dependency> -->
            <!-- https://mvnrepository.com/artifact/commons-lang/commons-lang -->
<dependency>
    <groupId>commons-lang</groupId>
    <artifactId>commons-lang</artifactId>
    <version>2.6</version>
</dependency>

  </dependencies>
</project>

EOF


echo Install completed
echo Getting dependencies for $GID:$AID:$V:jar
mvn -Dmaven.repo.local=$REPO org.apache.maven.plugins:maven-dependency-plugin:3.4.0:copy-dependencies  -DoutputDirectory=dependencies -Dmdep.addParentPoms=true


cd dependencies
#find . -name "*.jar" -exec unzip -o {} \;
