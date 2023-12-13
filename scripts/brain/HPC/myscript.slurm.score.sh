#!/bin/bash
#SBATCH --job-name=calculate_subject_network_score
#SBATCH --account=pi-mdrosenberg
#SBATCH --partition=caslake
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=100GB
#SBATCH --cpus-per-task=10 ##(THIS IS NOT A COMMENT)
#SBATCH --output=calculate_subject_network_score.out
#SBATCH --error=calculate_subject_network_score.err

# LOAD MODULES (THIS IS A COMMENT)
module load matlab/2020b

# EXECUTE JOB [Run whatever code you want using the resources you requested]
jobnum=$1

matlab -nodisplay -r "compile_ets_from_HPC(${jobnum})"
