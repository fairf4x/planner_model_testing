# Picat model testing
This repository contains a bunch of scripts for running experiments with planning domain models in [Picat](http://www.picat-lang.org/).

## Prerequisities
Scripts described below has some dependencies:

1. working **picat** instalation. It is recommended to download latest version [here](http://picat-lang.org/download.html). Executable **picat** should be available on `PATH`.
2. SGE environment (tested on SGE 8.1.7). In particular the command **qsub** which is used in `cplan_all.sh` script.
 
## Workflow
Following steps should provide enough guidance to run your own set of experiments.

1. Get picat models from PDDL domain and problem descriptions:
  1. Prepare all your PDDL files in a directory (refered as `pddl_dir`). Domain file has to be named `domain.pddl` to be recognized by scripts.
  2. Call `./prepareDomain.sh domainName pddl_dir` to prepare directory structure
2. Edit files `mod_list`, `pla_list` and `prob_list` to configure your experiment. These files has to be simple lists - one record on one line. Number of experiments run will be `#models X #planners X #problems`.
  + `mod_list` - names of picat domain model to use (those are stored in `models` directory for each domain). Models are listed with `.pddl` extension.
  + `pla_list` - names of planners to use. One planner on the line (e.g.: `best_plan`). Planners listed here refers to configuration files in the `planners` directory. 
  + `prob_list` - list of problems from `problems` directory to use in the experiment.
3. Call `./generate_array_file.sh domainName` to generate file `array.in`. The file lists one experiment configuration on line.
4. Call `./launch_array.sh array.in`. This will submit an array job to cluster. Results of the experiment will be stored in `results/domainName` and logs will be in `logs` directory.

## Scripts

1. `launch_array.sh` - this script takes one parameter - the name of array file with descriptions of experiments. It submits an array job to the cluster. Batch size can be modified by changing `BATCH_SIZE`
    
2. `cplan_array.sh` - this scipt is called by the `launch_array.sh` script for each experiment configuration that is to be processed
  *Parameters for SGE (example):*
```
   #$ -wd /path/to/picat_model_testing
   #$ -q queue@machine*
   #$ -l mem_free=1G
   #$ -l h_vmem=1G
   #$ -l h_rt=0:30:00
```
  + `-wd <DIR>` sets the SGE working directory
  + `-q <queue-spec>` sets the SGE queue
  + `-l mem_free=<soft-memory-limit>` using memory over soft limit may not cause job termination
  + `-l h_vmem=<hard-memory-limit>` using memory over hard limit will cause job termination
  + `-l h_rt=HH:MM:SS` job will be terminated if it does not finish within given time limit

3. `generate_array_file.sh` - this script is used to generate all experiment configuration based on the `mod_list`, `pla_list` and `prob_list` files in each domain from the `domains` directory. By default it generate experiments for all domains in the `domains` directory. You can select domains for which you want to generate experiments by passing their list as arguments.
  e.g.:
  ```
  ./generate_array_file.sh depots nomystery
  ``` 
  generates only task configurations for *depots* and *nomystery* domains 
4. `prepareDomain.sh` - script to initialize directory structure for new domain
