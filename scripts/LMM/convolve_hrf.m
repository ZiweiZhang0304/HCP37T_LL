%% ------ circle shifting ------ %%
%% generate circle shifting behavioral parameters
load('/Users/ziweizhang/Downloads/NCAA_surprise/shared/analysis/in_hrf.mat');

behav_file_origin = readtable("/Users/ziweizhang/Downloads/HCP37T_LL/output/behav_ratings/brain_score_behav_rating.csv");
behav_file = behav_file_origin;

participant_num = unique(behav_file.('participant'));
clip_names = unique(behav_file.('unique_clip_names'));

behav_var_names = behav_file.Properties.VariableNames(5:13);
%% 
for v = 1: length(behav_var_names)
    behav_var_hrf = [];
    
    for s = 1: length(participant_num)
        for g = 1: length(clip_names)
            rows = (strcmp(behav_file.unique_clip_names,clip_names{g}) & behav_file.participant == participant_num(s));
            behav_var_name = behav_var_names(v);
            clip_behav = behav_file(rows,behav_var_name{1}).(behav_var_name{1});
            
            %convolved with hrf
            behav_clip_con = conv(clip_behav(:,1),hrf,'same');
            behav_var_hrf = vertcat(behav_var_hrf, behav_clip_con);
            
            behav_var_hrf_cell{v} = behav_var_hrf;
        end
    end
end
%% save
behav_var_hrf_table = table(behav_var_hrf_cell{:});
behav_var_hrf_table.Properties.VariableNames = {'behav_surprise_hrf','behav_focus_hrf','behav_importance_hrf','behav_boredom_hrf','behav_valence_hrf','behav_comprehension_hrf','behav_curiosity_hrf','behav_relatability_hrf','behav_socialinteraction_hrf'};

writetable(behav_var_hrf_table, '/Users/ziweizhang/Downloads/HCP37T_LL/output/behav_ratings/behav_var_hrf_table.csv');


%% Deal with unequal length after convolving
signal = rand(1,100);%[-1 2 3 -2 0 1 2];
kernel = rand(1,51); %[2 4 -1 1];
same = conv(signal,kernel,'same');
diff = conv(signal,kernel);

% Example for padding: https://discourse.julialang.org/t/convolution-conv-with-same-size-output/38260
padding_count = floor((length(kernel) - 1) / 2);
padded_signal = horzcat(zeros(1,padding_count), signal, zeros(1,padding_count));
convolution = conv(padded_signal, kernel);

