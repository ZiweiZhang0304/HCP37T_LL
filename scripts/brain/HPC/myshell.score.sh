#!/bin/bash
#SBATCH --account=pi-mdrosenberg

for ((jobnum=1; jobnum<=12; jobnum+=1))
do
     sbatch myscript.slurm.score.sh "$jobnum"
done

## to submit jobs type in the terminal sbatch myshell.score.sh
