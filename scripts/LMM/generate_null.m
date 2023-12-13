%% ------ circle shifting ------ %%
%% generate circle shifting behavioral parameters
behav_file_origin = readtable("/Users/ziweizhang/Downloads/HCP37T_LL/output/behav_ratings/brain_score_behav_rating_hrf_for_null.csv");
behav_file = behav_file_origin;

restricted_distance = 5;

behav_file_cir = [];
behav_file_cir_flipped = [];

clip_holder = {};
clip_names = unique(behav_file.('unique_clip_names'));
behav_var_names = behav_file.Properties.VariableNames(2:end);
%%
for v = 1: length(behav_var_names)
    
    behav_var_name = behav_var_names(v);
    for g = 1: length(clip_names)
        rows = (strcmp(behav_file.unique_clip_names,clip_names{g}));
        clip_surprise = behav_file(rows,behav_var_name{1}).(behav_var_name{1});
        
        surprise_cir_i = [];
        surprise_cir_i_flipped = [];
        
        test= clip_surprise';
        if restricted_distance == 0
            n_shift = [(restricted_distance+1):(length(test)-1)]; %n_shift = randi([1 3408],1);
        else
            %n_shift = [(restricted_distance+1):(length(test)-(restricted_distance-1))]; %n_shift = randi([1 3408],1);
            n_shift = [(restricted_distance+1):(length(test)-(restricted_distance+1))];
        end
        
        for idx = 1: length(n_shift)
            idx_shift = n_shift(idx);
            surprise_cir_clip = circshift(test,idx_shift); %size(surprise_BIC_cir_game)=1,344
            surprise_cir_clip_flipped = circshift(flip(test),idx_shift);
            
            surprise_cir_i = vertcat(surprise_cir_i, surprise_cir_clip);
            surprise_cir_i_flipped = vertcat(surprise_cir_i_flipped, surprise_cir_clip_flipped);
        end
        
        surprise_cir_clip_all = vertcat(surprise_cir_i, surprise_cir_i_flipped);
        
        clip_holder{v,g} = surprise_cir_clip_all;
        
        %behav_var_cir_cell{v} = behav_var_hrf;
    end
    
end

l_time = [];
for i=1:length(clip_holder)
    l_time = [l_time size(clip_holder{1,i},2)];
end

%% keep everything and pad with NaN
%loop through all nine games, stack permutations for all nine games
l_perm = [];
for i=1:length(clip_holder)
    l_perm = [l_perm size(clip_holder{i},1)];
end
min(l_perm);

for v = 1: length(behav_var_names)
    behav_var_cir_overall_uncut = NaN(sum(l_time),max(l_perm)); %2968 * 496
    behav_var_name = behav_var_names(v);
    
    for i = 1:max(l_perm)
        all_clip_iter_i = [];
        for g = 1:length(clip_holder)
            clip_cir = clip_holder{v,g};
            
            if i > size(clip_cir,1)
                clip_iter_i = NaN(size(clip_cir,2),1);
            else
                clip_iter_i = clip_cir(i,:)';
            end
            all_clip_iter_i = vertcat(all_clip_iter_i,clip_iter_i);
        end
        behav_var_cir_overall_uncut(:,i) = all_clip_iter_i;
    end
    
    behav_var_cir_overall_uncut_table = array2table(behav_var_cir_overall_uncut);
    fname = ['/Users/ziweizhang/Downloads/HCP37T_LL/output/behav_ratings/' behav_var_name{1} '_cir_all_nshift_05.csv'];
    disp(fname)
    writetable(behav_var_cir_overall_uncut_table, fname);
end

