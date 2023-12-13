import subprocess
import os
from shutil import copyfile
import pandas as pd

subjects_names = pd.read_csv('/project2/mdrosenberg/LL/HCP37T/fmri_preprocessing/hcpparticipants.csv',header=None)
subjects_names['quoted_name'] = subjects_names[0].apply(lambda x: str(x) )
subjects = subjects_names['quoted_name'].tolist()
print(subjects)

runs = ['tfMRI_MOVIE1_7T_AP','tfMRI_MOVIE2_7T_PA','tfMRI_MOVIE3_7T_PA','tfMRI_MOVIE4_7T_AP']

# TESTING! GOING TO RM THIS
subjects = subjects[0:]
#subjects = subjects[0:]

for sub in subjects:
    print(sub)
    for run in runs:
        base = '/project2/abcd/user_folders/HS/HCP37T/preprocess'
        demean_file_path = f'{base}/{sub}/{run}/regressor_motion.1D'
        
        if os.path.exists(demean_file_path):
            new_path = f'/project2/mdrosenberg/LL/HCP37T/data/compiled_motion/{sub}_{run}_regressor_motion.1D'
            copyfile(demean_file_path, new_path)

        else:
            print('missing:')
            print(demean_file_path)
