% Calculate ets
subs        = {'102311', '104416', '105923', '108323', '109123', '111514', '114823', '115017', '118225', '125525', '128935', '130114', '131217', '135124', '137128', '146129', '146432', '146735', '146937', '148133', '155938', '156334', '157336', '158035', '159239', '162935', '164636', '165436', '167036', '167440', '172130', '173334', '175237', '176542', '177140', '177645', '178243', '180533', '181232', '182739', '185442', '187345', '191033', '191336', '191841', '192641', '193845', '195041', '196144', '198653', '199655', '200311', '200614', '203418', '204521', '209228', '212419', '214019', '214524', '239136', '246133', '249947', '251833', '263436', '318637', '330324', '352738', '360030', '380036', '385046', '389357', '393247', '395756', '397760', '401422', '406836', '412528', '429040', '436845', '463040', '467351', '525541', '541943', '573249', '581450', '601127', '617748', '627549', '638049', '654552', '671855', '680957', '690152', '724446', '725751', '732243', '757764', '765864', '770352', '782561', '783462', '789373', '814649', '818859', '826353', '859671', '861456', '872764', '878877', '898176', '899885', '901139', '910241', '927359', '942658', '943862', '958976', '966975', '971160'};
runs        = {'1_7T_AP','2_7T_PA','3_7T_PA','4_7T_AP'};
max_node    = 268;

ets_mats    = cell(length(subs),1);
upper_tri_size = (max_node * max_node - max_node)/2; % =35778

for s = 1:length(subs)
    for r = 1:length(runs)
        ts = roi_mats{s}{1}{r}(:,:);
        % first check if the input matches with fcn_edgets.m requirement: ts, time series, size: (time)x(node)
        [T,N] = size(ts); % M = N*(N - 1)/2; M = lower_tri_size

        ets = fcn_edgets_v1(ts,1); % z-scored if second arg == 1

        ets_mats{s}{r}(:,:) = ets;
    end
end
%save('./output/ets/ets_mats.mat', 'ets_mats', '-v7.3');
