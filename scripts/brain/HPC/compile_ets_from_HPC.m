function compile_ets_from_HPC(jobnum)

%% Compile files
subs_all    = {'102311', '104416', '105923', '108323', '109123', '111514', '114823', '115017', '118225', '125525', '128935', '130114', '131217', '135124', '137128', '146129', '146432', '146735', '146937', '148133', '155938', '156334', '157336', '158035', '159239', '162935', '164636', '165436', '167036', '167440', '172130', '173334', '175237', '176542', '177140', '177645', '178243', '180533', '181232', '182739', '185442', '187345', '191033', '191336', '191841', '192641', '193845', '195041', '196144', '198653', '199655', '200311', '200614', '203418', '204521', '209228', '212419', '214019', '214524', '239136', '246133', '249947', '251833', '263436', '318637', '330324', '352738', '360030', '380036', '385046', '389357', '393247', '395756', '397760', '401422', '406836', '412528', '429040', '436845', '463040', '467351', '525541', '541943', '573249', '581450', '601127', '617748', '627549', '638049', '654552', '671855', '680957', '690152', '724446', '725751', '732243', '757764', '765864', '770352', '782561', '783462', '789373', '814649', '818859', '826353', '859671', '861456', '872764', '878877', '898176', '899885', '901139', '910241', '927359', '942658', '943862', '958976', '966975', '971160'};
runs        = {'1','2','3','4'};

if (jobnum~=12)
    subs = subs_all( ((jobnum-1)*10 +1) : (jobnum*10));
else
    subs = subs_all( ((jobnum-1)*10 +1) : length(subs_all));
end
%% add path to data and function
addpath('/project/mdrosenberg/LL/HCP37T/scripts/func/');
addpath('/project/mdrosenberg/LL/HCP37T/data/brain/');

%%
% all_ets should be in (time_external by feat_num by subj_num_external)
% dimension
for s = 1:length(subs)
    subject_ets = [];
    
    for r = 1:length(runs)
        subject_run_ets_name = ['/project/mdrosenberg/LL/HCP37T/data/brain/ets/' subs{s} '/' subs{s} '_run_' runs{r} '_ets.mat'];
        
        subject_run_ets = load(subject_run_ets_name).subject_run_ets;

        subject_ets = vertcat(subject_ets, subject_run_ets);
    end
    all_ets_cell{s} = subject_ets;
end

all_ets = cat(3,all_ets_cell{:});

save('/project/mdrosenberg/LL/HCP37T/data/brain/ets/all_ets.mat', 'all_ets');
%% Calculate surprise EFPM score

% Load masks
load('/project/mdrosenberg/LL/HCP37T/data/brain/masks/surprise_EFPM/surprise_EFPM_pos_mask.txt');
load('/project/mdrosenberg/LL/HCP37T/data/brain/masks/surprise_EFPM/surprise_EFPM_neg_mask.txt');

At = surprise_EFPM_pos_mask.';
m  = triu(true(size(At)),1);
pos_flat  = At(m).';

At = surprise_EFPM_neg_mask.';
m  = triu(true(size(At)),1);
neg_flat  = At(m).';

% Apply surprise EFPM and obtain time resolved edge score in the EFPM [avg(high) - avg(low)]
[surprise_EFPM_score, surprise_EFPM_score_pos, surprise_EFPM_score_neg] = get_EFPM_score(all_ets, length(subs), pos_flat, neg_flat);
writetable(array2table(surprise_EFPM_score), ['/project/mdrosenberg/LL/HCP37T/data/brain/score/surprise_EFPM_score_' num2str(jobnum, '% 03.f') '.csv']);
writetable(array2table(surprise_EFPM_score_pos),['/project/mdrosenberg/LL/HCP37T/data/brain/score/surprise_EFPM_score_pos_' num2str(jobnum, '% 03.f') '.csv']);
writetable(array2table(surprise_EFPM_score_neg),['/project/mdrosenberg/LL/HCP37T/data/brain/score/surprise_EFPM_score_neg_' num2str(jobnum, '% 03.f') '.csv']);

end
