clear;
%Demonstration of HFC w/ different parameter settings

%=====================
%Keio_1
file = open('data\Keio(1).mat');
data_name = 'Keio(1)';
%==========
%Keio_2
%file = open('data\Keio(2).mat');
%data_name = 'Keio(2)';
%===========
%file = open('data\WIDE(1).mat');
%data_name = 'WIDE(1)';
%==========
%file = open('data\WIDE(2).mat');
%data_name = 'WIDE(2)';
%==========
%file = open('data\ISP(1).mat');
%data_name = 'ISP(1)';
%==========
%file = open('data\ISP(2).mat');
%data_name = 'ISP(2)';

%====================
feats = file.feats; %Flow feature matrix, i.e., F
TAG_list = file.TAG; %Edge list of the TAG
gnd = file.gnd; %Clustering/classification ground-truth
num_clus = max(gnd); %Number of clusters
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

%=====================
%Test the performance of HFC w/ different parameter settings
num_feat_clus = num_clus; %Number of feature clusters
num_topo_clus = num_clus; %Number of topology clusters
max_iter = 1e4; %Maximum number of iterations
min_err = 1e-5; %Minimum relative error to determine the convergence
%==========
fid = fopen(['res/HFC_demo_', data_name, '.txt'], 'at');
for alpha = [0.1:0.1:1.0, 1:1:10]
    for lambd1 = [0, 0.01, 0.1:0.1:1.0, 2.0]
        for lambd2 = [0, 0.1, 1:1:10]
            tic;
            [flow_mem,flow_desc,trans,mem_node,loss] = HFC(feats,links,num_feat_clus,num_topo_clus,alpha,lambd1,lambd2,max_iter,min_err);
            toc;
            runtime = toc;
            %====================
            %Evaluate the performcne w.r.t. current parameter settings
            [~, labels] = max(flow_mem, [], 2);
            res = bestMap(gnd, labels);
            AC = length(find(gnd == res))/length(gnd);
            NMI = compute_NMI(gnd, labels);
            fprintf('Alpha %f Lam1 %f Lam2 %f AC %8.4f NMI %8.4f Time %8.4f\n', [alpha, lambd1, lambd2, AC, NMI, runtime]);
            fprintf(fid, 'Alpha %f Lam1 %f Lam2 %f AC %8.4f NMI %8.4f Time %8.4f\n', [alpha, lambd1, lambd2, AC, NMI, runtime]);
        end
    end
end
fclose(fid);
