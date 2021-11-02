clear;

%Case study regarding the flow profiling

%====================
file = open('data\ISP(2).mat');
data_name = 'ISP(2)';

%==========
feats = file.feats; %Flow feature matrix, i.e., F
TAG_list = file.TAG; %Edge list of the TAG
[num_flows, num_feats] = size(feats); %Get number of flows (edges) & discrete features
num_nodes = max(max(TAG_list)); %Number of nodes
%==========
%Construct the link structure matrix, i.e., B
links = zeros(num_flows, num_nodes);
for i=1:num_flows
    src_idx = TAG_list(i, 1);
    dst_idx = TAG_list(i, 2);
    links(i, src_idx) = 1;
    links(i, dst_idx) = 1;
end
%==========
num_feat_clus = 6; %Number of feature clusters
num_topo_clus = 7; %Number of topology clusters
num_levels = 30; %Number of discrete levels for each feature item

%====================
alpha = 1;
lambd1 = 1;
lambd2 = 1;
max_iter = 1e4; %Maximum number of iterations
min_err = 1e-5; %Minimum relative error to determine the convergence
[flow_mem,feat_desc,trans,node_mem,loss] = HFC(feats,links,num_feat_clus,num_topo_clus,alpha,lambd1,lambd2,max_iter,min_err);
%==========
%Transform the propensity values to probabilities
for r=1:num_feat_clus
    feat_desc(:, r) = feat_desc(:, r)/max(sum(feat_desc(:, r)), realmin);
end
for k=1:num_topo_clus
    trans(:, k) = trans(:, k)/max(sum(trans(:, k)), realmin);
    node_mem(:, k) = node_mem(:, k)/max(sum(node_mem(:, k)), realmin);
end
%==========
num_feat_items = num_feats/num_levels; %Number of feature items
sem_desc = zeros(num_feat_clus, num_feat_items); %Semantic description matrix for the case study
for r=1:num_feat_clus
    for j=1:num_feat_items
        j_start = (j-1)*num_levels+1;
        j_end = j*num_levels;
        seq = feat_desc(j_start:j_end, r);
        [~, max_index] = max(seq);
        sem_desc(r, j) = max_index;
    end
end
%==========
num_rep_nodes = 10; %Number of representative nodes in each cluster
link_mem = zeros(num_topo_clus, num_rep_nodes);
for r=1:num_topo_clus
    [~, idxs] = sort(node_mem(:, r), 'descend');
    link_mem(r,:) = idxs(1:num_rep_nodes);
end

%====================
%Save the results
dlmwrite('res/feat_desc.txt', feat_desc, '\t');
dlmwrite('res/sem_desc.txt', sem_desc, '\t');
dlmwrite('res/trans.txt', trans, '\t');
dlmwrite('res/node_mem.txt', node_mem, '\t');
dlmwrite('res/link_mem.txt', link_mem, '\t');
