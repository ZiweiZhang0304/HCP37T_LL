%% organize roi time series mats
%clear; clc
clear fileID tmpfile tmpmat i j
%%
subs          = {'102311', '104416', '105923', '108323', '109123', '111514', '114823', '115017', '118225', '125525', '128935', '130114', '131217', '135124', '137128', '146129', '146432', '146735', '146937', '148133', '155938', '156334', '157336', '158035', '159239', '162935', '164636', '165436', '167036', '167440', '172130', '173334', '175237', '176542', '177140', '177645', '178243', '180533', '181232', '182739', '185442', '187345', '191033', '191336', '191841', '192641', '193845', '195041', '196144', '198653', '199655', '200311', '200614', '203418', '204521', '209228', '212419', '214019', '214524', '239136', '246133', '249947', '251833', '263436', '318637', '330324', '352738', '360030', '380036', '385046', '389357', '393247', '395756', '397760', '401422', '406836', '412528', '429040', '436845', '463040', '467351', '525541', '541943', '573249', '581450', '601127', '617748', '627549', '638049', '654552', '671855', '680957', '690152', '724446', '725751', '732243', '757764', '765864', '770352', '782561', '783462', '789373', '814649', '818859', '826353', '859671', '861456', '872764', '878877', '898176', '899885', '901139', '910241', '927359', '942658', '943862', '958976', '966975', '971160'};
task          = {'tfMRI_MOVIE'};
runs          = {'1_7T_AP','2_7T_PA','3_7T_PA','4_7T_AP'};

datadir       = '/Users/ziweizhang/Downloads/HCP37T_LL/data/brain/netts/';

roi_mats      = cell(length(subs),1);
max_node      = 268;
%max_TR        = 226;
TR            = 0.72;

total_TR_all_roi_all_sub = []; %collect roi flat vector length from all run & sub

%% take a look at how many there are for each person and run
total_TR_all_sub = []; %collect all #TR from all run & sub
total_roi_all_sub = []; %collect all #node from all run & sub

for s = 1:length(subs)
    for t = 1:length(task)  
        for r = 1:length(runs)
            % the actual time series data
            filepath = [datadir subs{s} '/' task{t} runs{r} '_LPI_000.netts'];
            % need ROI labels from netcc files
            node_info_path = ['/Users/ziweizhang/Downloads/HCP37T_LL/data/brain/netcc/' subs{s} '/' task{t} runs{r} '_LPI_000.netcc'];
            
            try
                % Load file
                fileID  = fopen(filepath);
                tmpfile = textscan(fileID,'%s');

                nodefileID = fopen(node_info_path);
                tmpnodefile = textscan(nodefileID,'%s');

                % Get # of nodes and load roi time series
                %n_node{s}(r,1) = str2num(tmpnodefile{1}{2});
                n_node{s}{t}(r,1) = str2num(tmpnodefile{1}{2});
                total_TR_all_roi = size(tmpfile{1},1); %total number of TR (including all ROIs) for this subject, task and run
                
                roi_num = str2num(tmpnodefile{1}{2}); %number of ROIs for this subject, task and run
                TR_num = total_TR_all_roi/roi_num; %number of TRs for this subject, task and run
                
                total_TR_all_roi_all_sub = [total_TR_all_roi_all_sub; s t r total_TR_all_roi];
                total_roi_all_sub = [total_roi_all_sub; s t r roi_num];
                total_TR_all_sub = [total_TR_all_sub; s t r TR_num]; %this is the most needed, store number of TRs for all subject, task and run
                
            end
        end
    end
end

max_TR = max(total_TR_all_sub(:,4));
%%
% total_TR_all_sub = array2table(total_TR_all_sub,'VariableNames',{'subs','task','runs','Number_of_TR'});
% 
% view_idx = total_TR_all_sub.task == 1;
% recall_idx = total_TR_all_sub.task == 2;
% 
% total_TR_all_sub_view = total_TR_all_sub(view_idx,:);
% total_TR_all_sub_recall = total_TR_all_sub(recall_idx,:);
% 
% 
% max_TR_view = max(total_TR_all_sub_view.Number_of_TR)
% max_TR_recall = max(total_TR_all_sub_recall.Number_of_TR)
% 
% f_sum = @(x)sum(x,1);
% TR_per_run = grpstats(total_TR_all_sub_view,"subs",f_sum);  

%%
for s = 1:length(subs)
    disp(subs{s})
    roi_mats{s} = cell(length(task),1);
    
    for t = 1:length(task)
        disp(task{t})
        
        roi_mats{s}{t} = cell(length(runs),1);
        for r = 1:length(runs)
            disp(runs{r})
            % the actual time series data
            filepath = ['/Users/ziweizhang/Downloads/HCP37T_LL/data/brain/netts/' subs{s} '/' task{t} runs{r} '_LPI_000.netts'];
            % need ROI labels from netcc files
            node_info_path = ['/Users/ziweizhang/Downloads/HCP37T_LL/data/brain/netcc/' subs{s} '/' task{t} runs{r} '_LPI_000.netcc'];
            
            try
                % Load file
                fileID  = fopen(filepath);
                tmpfile = textscan(fileID,'%s');
                
                nodefileID = fopen(node_info_path);
                tmpnodefile = textscan(nodefileID,'%s');
                
                % Get # of nodes and load roi time series
                %n_node{s}(r,1) = str2num(tmpnodefile{1}{2});
                n_node{s}{t}(r,1) = str2num(tmpnodefile{1}{2});
                
                for i = 1:n_node{s}{t}(r) %n_node{s}(r)
                    rois{s}{t}{r}(i,1) = str2num(tmpnodefile{1}{16+i});
                    %rois{s,r}(i,1) = str2num(tmpnodefile{1}{16+i});
                end
                
                tmpmat = dlmread(filepath,'\t'); %,7+n_node{r,session}(s),0
                
                roi_mats{s}{t}{r} = NaN(max_node, size(tmpmat,2));
                % Read in available rows/columns of matrix
                for x = 1:n_node{s}{t}(r) %n_node{s}(r)
                    roi_mats{s}{t}{r}(rois{s}{t}{r}(x),:) = tmpmat(x,:);
                    %roi_mats{s}{t}(:,rois{s,r}(i),r) = tmpmat(i,:)'; %s=32, (268,226,4); (:,rois{s,r}(j),r)
                end
                
                % Close file and clear temporary variables
                fclose(fileID);
                %clear fileID tmpfile tmpmat i j
            end
            clear filepath
        end
    end      
end


%% Some checks
% open 04_01_view_03_LPI_000.netts and check
% sub_04_view_run3 = roi_mats{4}{1}(:,:,3);


% open 20_01_recall_3_LPI_000.netcc and check
%sub_20_recall_run3 = roi_mats{20}{2}(:,:,3);
sub_20_recall_run3 = roi_mats{20}{2}{3};


%% remove missing nodes
missing = []; % There are no missing nodes in this dataset?

for s = 1:length(subs)
    raw_roi_mats{s} = cell(length(task),1);
    
    for t = 1:length(task)
        if (strcmp(task{t}, 'view') && strcmp(subs{s}, '04')) || (strcmp(task{t}, 'view') && strcmp(subs{s}, '05')) 
            runs = {'00','01','02','03'};
        else
            runs = {'01','02','03'};
        end
        raw_roi_mats{s}{t} = cell(length(runs),1);
                
        for r = 1:length(runs)
            sub_roi = roi_mats{s}{t}{r};
            sub_roi(:,any(sub_roi,1)==0)=NaN;
            
            sub_roi(missing,:) = NaN; %[] if remove
            raw_roi_mats{s}{t}{r} = sub_roi;
        end
    end
end

%% saving some files

% save './output/ts/raw_time_series.mat' roi_mats

%%
function cel = index(x, idx)
    cel = x(idx); end                                