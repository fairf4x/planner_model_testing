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
  3. Call `./runTranslator.sh domainName` to translate PDDL files to Picat
2. Edit files `mod_list`, `pla_list` and `prob_list` to configure your experiment. These files has to be simple lists - one record on one line. Number of experiments run will be `#models X #planners X #problems`.
  + `mod_list` - names of picat domain model to use (those are stored in `models` directory for each domain). Models are listed without `.pi` extension.
  + `pla_list` - names of picat planners to use. One planner on the line (e.g.: `best_plan`). Planners listed here will be used for planning. 
  + `prob_list` - list of problems from `problems` directory to use in the experiment.
3. Call `./cplan_all.sh domainName` to submit jobs to cluster. Results of the experiment will be stored in `results/domainName` and logs will be in `logs/domanName`

## Scripts

1. `cplan_all.sh` - this script automatically submits all the experiments for all domains to cluster. If provided with list of parameters it submits jobs only for selected domains.
  e.g.:
  ```
  ./cplan_all.sh depots nomystery
  ``` 
  submits only jobs for *depots* and *nomystery* domains 
    
2. `cplan_one.sh` - this scipt is called by the `cplan_all.sh` script for each domain that is to be processed
  *Parameters for SGE (example):*
```
   #$ -wd /path/to/picat_model_testing
   #$ -q queue@tauri*
   #$ -l mem_free=1G
   #$ -l h_vmem=1G
   #$ -l h_rt=0:30:00
```
  + `-wd <DIR>` sets the SGE working directory
  + `-q <queue-spec>` sets the SGE queue
  + `-l mem_free=<soft-memory-limit>` using memory over soft limit may not cause job termination
  + `-l h_vmem=<hard-memory-limit>` using memory over hard limit will cause job termination
  + `-l h_rt=HH:MM:SS` job will be terminated if it does not finish within given time limit
3. `runTranslator.sh` - script used to call Picat translator program `pddlPiTranslator.pi` (work of Marco De Bortoli debortoli.marco.1 at spes.uniud.it) to generate:  
  + `<domain>.pi` file in the `models` directory
  + problem files in `problems` directory
4. `prepareDomain.sh` - script to load pddl domain and problems from given directory and prepare them for further processing
