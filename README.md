# Picat model testing
This repository contains a bunch of scripts for running experiments with planning domain models in [Picat](http://www.picat-lang.org/).

## Prerequisities
Scripts described below has some dependencies:

1. working **picat** instalation. It is recommended to download latest version [here](http://picat-lang.org/download.html). Executable **picat** should be available on `PATH`.
2. working **perl** instalation. Perl is required only to run the script **constrain** which is used to enforce time and memory limits while running experiments. The script itself should be available on `PATH`.
3. working GNU [**parallel**](http://www.gnu.org/software/parallel/) utility. The utility is used to run experiments in parallel - the number of threads depends on the content of `CPU_CNT` variable in the script `run.sh`.

## Workflow
Following steps should provide enough guidance to run your own set of experiments.

1. Get picat models from PDDL domain and problem descriptions:
  1. Prepare all your PDDL files in a directory (refered as `pddl_dir`). Domain file has to be named `domain.pddl` to be recognized by scripts.
  2. Call `./prepareDomain.sh domainName pddl_dir` to prepare directory structure
  3. Call `./runTranslator.sh domainName` to translate PDDL files to Picat
2. Edit files `mod_list`, `pla_list` and `prob_list` to configure your experiment. These files has to be simple lists - one record on one line. Number of experiments run will be `#models X #planners X #problems`.
  + `mod_list` - names of picat domain model to use (those are stored in `models` directory for each domain). Models are listed without `.pi` extension.
  + `pla_list` - names of picat planners to use. One planner on the line (e.g.: `best_plan`). Planners listed here will be used for planning. 
  + `prob_list` - list of problems from `problems` directory to use in the experiment.
3. Call `./plan_all.sh domainName` to run the experiment. Results of the experiment will be stored in `results/domainName`

## Scripts

1. `plan_all.sh` - this script automatically runs all the experiments. If provided with list of parameters it runs experiments only for selected domains.
  e.g.:
  ```
  ./plan_all.sh depots nomystery
  ``` 
  runs experiments only with *depots* and *nomystery* domains 
  *Parameters:*  
  + `CPU_CNT` .. number of parallel threads to launch
2. `plan_one.sh` - this scipt is called by the **run.sh** script for each domain that is to be processed
  *Parameters:*  
  + `TIME_LIMIT` .. time limit for execution of one problem instance  
  + `MEM_LIMIT` .. memory limit for execution of one problem instance
3. `runTranslator.sh` - script used to call Picat translator program `pddlPiTranslator.pi` (work of Marco De Bortoli debortoli.marco.1 at spes.uniud.it) to generate:  
  + `<domain>.pi` file in the `models` directory
  + problem files in `problems` directory
4. `prepareDomain.sh` - script to load pddl domain and problems from iven directory and prepare them for further processing
