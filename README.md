# Watertank Model Swap Example

This "watertank" folder contains the artifacts needed for running the experiment of model swapping the controller in the watertank-controller simulation. The swap consists of dynamically changing the model structure by adding a water leak detector and a replacement for the controller that mitigates a detected water leak (mocked by fault injection). (Experiment presented in "Dynamic Runtime Integration of New Models in Digital Twins" [H. Ejersbo, K. Lausdahl, M. Frasheri, L. Esterle]).

The "watertank" folder is self-contained and uses no external refs.

## Running the Experiment

Prerequisites: Bash environment and dependencies installed to run Maestro from the cmd line (i.e. you need Java). And if you want the graphs in the contained Jupyter notebook, you need Python and Jupyter.

Running the experiment is a simple as starting bash terminal and typing:

```bash
./start.sh
```

The runs the simulation including the model swap and produces outputs from the simulation visualized like this:

https://github.com/INTO-CPS-Association/model_swap_example/blob/master/watertank/Untitled.ipynb

If you change the mm files for any reason, the MaBL specs must be re-generated. Do this by:

```bash
./generate.sh
```

## Details

The input multimodel files for this experiment are the mm1.json and mm2.json. The mm1.json file contains the specification of the originating (before model swapping) co-simulation scenario of the watertank and its controller. The mm2.json file contains the swap specification scenario (i.e. including the swapped in mitigating controller and leak detector).

Running the ./generate.sh script outputs the corresponding MaBL specs obtained from parsing the multimodel files by Maestro. The generated files are placed in folders stage1 and transition/stage2 for mm1.json and mm2.json, respectively.

Running the ./start.sh script runs the co-simulation starting in stage1/spec.mabl and swapping to transition/stage2/spec.mabl. The script run Maesto with the cmd line option '-tms 50', which specifies that Maestro should pick up the swap specification in transition/stage2/spec.mabl after 50 simulation steps. This serves a means to control in details when you want the swap specfication to become available and avoids the need to have additional scripts that copies the swap spec in place based on e.g. time.




