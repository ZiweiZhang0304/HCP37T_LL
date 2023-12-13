import pandas as pd
subjects_names = pd.read_csv('/project2/mdrosenberg/LL/HCP37T/fmri_preprocessing/hcpparticipants.csv',header=None)
subjects_names['quoted_name'] = subjects_names[0].apply(lambda x: str(x) )
subjects = subjects_names['quoted_name'].tolist()
