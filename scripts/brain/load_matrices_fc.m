%% load in FC
subs          = {'102311', '104416', '105923', '108323', '109123', '111514', '114823', '115017', '118225', '125525', '128935', '130114', '131217', '135124', '137128', '146129', '146432', '146735', '146937', '148133', '155938', '156334', '157336', '158035', '159239', '162935', '164636', '165436', '167036', '167440', '172130', '173334', '175237', '176542', '177140', '177645', '178243', '180533', '181232', '182739', '185442', '187345', '191033', '191336', '191841', '192641', '193845', '195041', '196144', '198653', '199655', '200311', '200614', '203418', '204521', '209228', '212419', '214019', '214524', '239136', '246133', '249947', '251833', '263436', '318637', '330324', '352738', '360030', '380036', '385046', '389357', '393247', '395756', '397760', '401422', '406836', '412528', '429040', '436845', '463040', '467351', '525541', '541943', '573249', '581450', '601127', '617748', '627549', '638049', '654552', '671855', '680957', '690152', '724446', '725751', '732243', '757764', '765864', '770352', '782561', '783462', '789373', '814649', '818859', '826353', '859671', '861456', '872764', '878877', '898176', '899885', '901139', '910241', '927359', '942658', '943862', '958976', '966975', '971160'};
task          = {'tfMRI_MOVIE'};
runs          = {'1_7T_AP','2_7T_PA','3_7T_PA','4_7T_AP'};

datadir       = '/Users/ziweizhang/Downloads/HCP37T_LL/data/brain/netcc/';
fc_mats       = cell(length(subs),1); %cell(length(task),length(runs))
max_node      = 268;
missing_nodes_HCP = [];
missing_runs  = [];

for s = 1:length(subs)
    fc_mats{s} = cell(length(task),1);
    
    for t = 1:length(task)

        fc_mats{s}{t} = NaN(max_node,max_node,length(runs));
        
        for r = 1:length(runs)
            filepath = [datadir subs{s} '/' task{t} runs{r} '_LPI_000.netcc'];

            try
                % Load file
                fileID  = fopen(filepath);
                tmpfile = textscan(fileID,'%s');
                
                % Get # of nodes and load Fisher z matrix
                n_node{s}{t}(r) = str2num(tmpfile{1}{2});
                for i = 1:n_node{s}{t}(r)
                    rois{s}{t}{r}(i,1)= str2num(tmpfile{1}{16+i}); % 16 b/c of the col names
                end
                tmpmat = dlmread(filepath,'\t',7+n_node{s}{t}(r),0);
                
                % Read in available rows/columns of matrix
                for i = 1:n_node{s}{t}(r)
                    for j = 1:n_node{s}{t}(r)
                        fc_mats{s}{t}(rois{s}{t}{r}(i),rois{s}{t}{r}(j),r) = tmpmat(i,j);
                    end
                end
                
                % Check for missing nodes
                for i = 1:n_node{s}{t}(r)
                    if fc_mats{s}{t}(i,i,r) ~= 4
                        missing_nodes_HCP = [missing_nodes_HCP; s t r i];
                    end
                end
                
                % Close file and clear temporary variables
                fclose(fileID);
                %clear fileID tmpfile tmpmat i j
            catch    
            end
            clear filepath
        end
    end
end

% open 03_01_recall_01_LPI_000.netcc and check
% sub_03_recall_run01 = fc_mats{3}{2}(:,:,1);

% open 15_01_view_03_LPI_000.netcc and check
%subs{15} == '15'
% sub_15_view_run03 = fc_mats{15}{1}(:,:,3);

%% remove missing nodes
% clear sub_03_recall_run01 sub_15_view_run03
missing_view = missing_nodes_HCP(find(missing_nodes_HCP(:,2)==2),4);
missing_recall = missing_nodes_HCP(find(missing_nodes_HCP(:,2)==1),4);
missing = unique(missing_view); % union of missing nodes from all subjects

%%
for s = 1:length(subs)
    for t = 1:length(task)
        test_fc_mats{s}{t} = NaN(max_node,max_node,length(runs));
        
        for r = 1:length(runs)
            sub_fc = fc_mats{s}{t}(:,:,r);
            sub_fc(:,missing) = NaN; %[] if remove
            sub_fc(missing,:) = NaN;
            test_fc_mats{s}{t}(:,:,r) = sub_fc;
        end
    end
end