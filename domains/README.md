# Domains

This directory should contain a directory for each domain we want to experiment with.

## Directory structure for one domain

```
<domain>
 |- [problems] .. directory with problem instances
 |\- [modelX] .. for each model file modelX from the [models] directory there should be one directory named modelX containing problem instances for this model
 |- [models] .. directory with domain models (files with planning domain definition)
 |- mod_list .. list of models to use in experiment (names of files from the [models] directory)
 |- pla_list .. choice of planners to use (see planners directory )
 |- prob_list .. selected list of problem instances to use in the experiments
 \- <domain>_problems .. list of all problem files available (just for convenience)
```
