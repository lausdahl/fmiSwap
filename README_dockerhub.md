# Supported tags

* latest
* 2.3.0-model-swap

# What's Maestro

Maestro is an orchestration engine for [FMI](https://fmi-standard.org/) co-simulation. This image embeds the maestro cli. The main entry points will attempt to run: 
* `/work/model/run.sh`
* `/work/model/post-process.sh`

it is expected that the folder `/work/model` contains these scripts including any FMUs and Mabl specification or multi-model files. The latter in the format produced by the [INTO-CPS Application](https://into-cps-association.readthedocs.io/projects/desktop-application/en/latest/)

The tag `*-model-swap` includes a test model showing how model swapping can be utilized.


# Usage

To run the container use:

```
docker run lausdahl/maestro:latest
```

This will run the following scripts:

* `/work/model/run.sh`
* `/work/model/post-process.sh`

See Watertank Model Swap Example for the model included in the tag 2.3.0-model-swap.

# Configuration

# Mount points

* To use another model with maestro mount it in `/work/model` and make sure to have one of the above-mentioned scripts in the root of this folder

# Environment variables

`MAESTRO_EXT_CP` can be set to include any additional jars on the maestro classpath. This is intended for maestro extensions. All necessary jars for the extension must be added explicitly seperated by `:`


# Watertank Model Swap Example

The tag `2.3.0-model-swap` contains the model needed for running the experiment of model swapping the controller in the watertank-controller simulation. The swap consists of dynamically changing the model structure by adding a water leak detector and a replacement for the controller that mitigates a detected water leak (mocked by fault injection). (Experiment presented in "Dynamic Runtime Integration of New Models in Digital Twins" [H. Ejersbo, K. Lausdahl, M. Frasheri, L. Esterle]).

## Running the Experiment


Run the embedded example and inspect the result as follows:

```
docker run -v ${PWD}:/work/model/post lausdahl/maestro:2.3.0-model-swap
```
This will run maestro with the embeded example model by performing the following steps:
* Import the multi-model configurations into the Mabl language
* Execute the mabl specification
* The embedded model will use a model specific python script to plot the results to the `/work/model/post/result.pdf` folder

## Details

The input multi-model files for this experiment are the mm1.json and mm2.json. The mm1.json file contains the specification of the originating (before model swapping) co-simulation scenario of the watertank and its controller. The mm2.json file contains the swap specification scenario (i.e. including the swapped in mitigating controller and leak detector).

Running the `/work/model/run.sh` script (the `import` commands) outputs the corresponding MaBL specs obtained from parsing the multi-model files by Maestro. The generated files are placed in folders stage1 and transition/stage2 for mm1.json and mm2.json, respectively.

Running the `/work/model/run.sh` script (the `interpret` command) runs the co-simulation starting in stage1/spec.mabl and swapping to transition/stage2/spec.mabl. The script run Maesto with the cmd line option '-tms 50', which specifies that Maestro should pick up the swap specification in transition/stage2/spec.mabl after 50 simulation steps. This serves a means to control in details when you want the swap specification to become available and avoids the need to have additional scripts that copies the swap spec in place based on e.g. time.




