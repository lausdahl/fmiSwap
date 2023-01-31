# Watertank Model Swap Example

The Maestro tag `2.3.0-model-swap` (see further down for details on Mastro itself) contains the model needed for running the experiment of model swapping the controller in the watertank-controller simulation. The swap consists of dynamically changing the model structure by adding a water leak detector and a replacement for the controller that mitigates a detected water leak (mocked by fault injection). (Experiment presented in "Dynamic Runtime Integration of New Models in Digital Twins" [H. Ejersbo, K. Lausdahl, M. Frasheri, L. Esterle]).

## Running the Experiment

Run the embedded example and inspect the result as follows:

```bash
docker run -v ${PWD}:/work/model/post lausdahl/maestro:2.3.0-model-swap
```

This will run maestro with the embeded example model by performing the following steps:
* Import the multi-model configurations into the Mabl language
* Execute the mabl specification
* The embedded model will use a model specific python script to plot the results to the `/work/model/post/result.pdf` folder

## Details

The input multi-model files for this experiment are the ```mm1.json``` and ```mm2.json```. The ```mm1.json``` file contains the specification of the originating (before model swapping) co-simulation scenario of the watertank and its controller. The ```mm2.json``` file contains the swap specification scenario (i.e. including the swapped in mitigating controller and leak detector).

Running the `/work/model/run.sh` script (the `import` commands) outputs the corresponding MaBL specs obtained from parsing the multi-model files by Maestro. The generated files are placed in folders stage1 and transition/stage2 for mm1.json and mm2.json, respectively.

Running the `/work/model/run.sh` script (the `interpret` command) runs the co-simulation starting in stage1/spec.mabl and swapping to transition/stage2/spec.mabl. The script runs Maesto with the cmd line option '-tms 50', which specifies that Maestro should pick up the swap specification in transition/stage2/spec.mabl after 50 simulation steps. This serves a means to control in details when you want the swap specification to become available and avoids the need to have additional scripts that copies the swap spec in place based on e.g. time.

## Playing with the example

One can easily modify the min and max levels for the tank, in ```mm1.json``` look for:

```json
"parameters": {
    "{x1}.controller.maxlevel": 2,
    "{x1}.controller.minlevel": 1
  }
```

and in ```mm2.json``` for:

```json
"parameters": {
    "{x1}.controller.maxlevel": 2,
    "{x1}.controller.minlevel": 1,
    "{x4}.leak_controller.maxlevel": 2,
    "{x4}.leak_controller.minlevel": 1
  }
```

and change min/max (for old controller and new leak controller) to some other values, maintaining the min smaller than max condition true.

In order to run the updated experiment, rebuild the image:

```bash
docker build . --tag lausdahl/maestro:2.3.0-model-swap
```

and then run:

```bash
docker run -v ${PWD}:/work/model/post lausdahl/maestro:2.3.0-model-swap
```

Additionally, one could also change the level of the leak as follows, find the ```wt_fault.xml``` file which contains:

```xml
<events>
    <event id="id-A" when="t&gt;=12.0" other="(var_17&gt;1.6) &amp; (var_16=0.0)" vars="var_17,var_16">
        <variable valRef="16" type="real" newVal="1.0-var_16" vars="var_16," />
    </event>
    <!-- <event id="id-A" when="t&gt;=0.5" other="(var_17&gt;1.5) &amp; (var_16=0.0)" vars="var_17,var_16" > -->
    <!--     <variable valRef="17" type="real" newVal="-0.001*var_17+1.5" vars="var_17," /> -->
    <!-- </event> -->
</events>
```

You can change ```when``` the fault is injected, as well specify other conditions as in ```other```. In this case we inject the fault in the water tank when ```var_17``` (referring to the level in the tank)
is greater than 1.6, and when ```var_16```(referring to the valve in the tank) is closed. The fault is injected to the valve, where the value of the valve is flipped ```newVal="1.0-var_16"```.
One could for example change the leak level, instead of 1.6 to another value.

Always remember to rebuild the docker image after the changes before running the experiment.

# What's Maestro

Maestro is an orchestration engine for [FMI](https://fmi-standard.org/) co-simulation. The image you have been working with so far embeds the maestro cli. The main entry points will attempt to run: 
* `/work/model/run.sh`
* `/work/model/post-process.sh`

it is expected that the folder `/work/model` contains these scripts including any FMUs and Mabl specification or multi-model files. The latter in the format produced by the [INTO-CPS Application](https://into-cps-association.readthedocs.io/projects/desktop-application/en/latest/)

The tag `*-model-swap` includes a test model showing how model swapping can be utilized.

# Supported Maestro tags

* latest
* 2.3.0-model-swap

# Usage

To run the container use:

```bash
docker run lausdahl/maestro:latest
```

This will run the following scripts:

* `/work/model/run.sh`
* `/work/model/post-process.sh`

See Watertank Model Swap Example for the model included in the tag 2.3.0-model-swap.

# Configuration

## Mount points

* To use another model with maestro mount it in `/work/model` and make sure to have one of the above-mentioned scripts in the root of this folder

## Environment variables

`MAESTRO_EXT_CP` can be set to include any additional jars on the maestro classpath. This is intended for maestro extensions. All necessary jars for the extension must be added explicitly seperated by `:`

