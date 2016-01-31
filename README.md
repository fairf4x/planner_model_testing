# Picat model testing
This repository contains a bunch of scripts for running experiments with planning domain models in [Picat](http://www.picat-lang.org/).

## Workflow:

1. Get picat models from PDDL domain and problem descriptions:
  1. Prepare all your PDDL files in a directory (refered as `pddl_dir`). Domain file has to be named `domain.pddl` to be recognized by scripts.
  2. Call `./prepareDomain.sh domainName pddl_dir` to prepare directory structure
  3. Call `./runTranslator.sh domainName` to translate PDDL files to Picat
2. Edit files `mod_list`, `pla_list` and `prob_list` to configure your experiment. These files has to be simple lists - one record on one line.
  + `mod_list` - names of picat domain model to use (those are stored in `models` directory for each domain). Models are listed without `.pi` extension.
  + `pla_list` - names of picat planners to use. One planner on the line (e.g.: `best_plan`). Planners listed here will be used to replace `###PLANNER###` string in model code.
  + `prob_list` - list of problems from `problems` directory to use in the experiment.
3. Call `./run.sh domainName` to run the experiment. Results of the experiment will be stored in `results/domainName`

## Scripts:

1. `run.sh` - this script automatically runs all the experiments. If provided with list of parameters it runs experiments only for selected domains.
  e.g.:
  ```
  ./run.sh depots nomystery
  ``` 
  runs experiments only with *depots* and *nomystery* domains 
  *Parameters:*  
  + `CPU_CNT` .. number of parallel threads to launch
2. `run_one.sh` - this scipt is called by the **run.sh** script for each domain that is to be processed
  *Parameters:*  
  + `TIME_LIMIT` .. time limit for execution of one problem instance  
  + `MEM_LIMIT` .. memory limit for execution of one problem instance
3. `runTranslator.sh` - script used to call Picat translator program `pddlPiTranslator.pi` (work of Marco De Bortoli debortoli.marco.1 at spes.uniud.it) to generate:  
  + `<domain>.pi` file in the `models` directory
  + problem files in `problems` directory
4. `prepareDomain.sh` - script to load pddl domain and problems from iven directory and prepare them for further processing
