#!/bin/bash

#SBATCH --job-name=test
#SBATCH --partition=cpu-large
#SBATCH --output=test.out
#SBATCH --error=test.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jodafons@lps.ufrj.br

python -c "from time import sleep; sleep(30); print('foi')"
