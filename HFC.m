function [flow_mem, flow_desc, trans, node_mem, loss] = HFC(feats, links, num_feat_clus, num_topo_clus, alpha, lambd1, lambd2, max_iter, min_err)
%Function to implement the HFC method
%feats: flow feature matrix, i.e., F
%links: link structure matrix, i.e., B
%num_feat_clus: number of feature clusters, i.e., K_1
%num_topo_clus: number of topologu clusters, i.e., K_2
%alpha, lambd1, lambd2: hyper-parameters
%max_iter: maximum number of iterations
%min_err: minimum relative error to determine the convergence
%flow_mem: feature membership matrix, i.e., X
%flow_desc: feature description matrix, i.e., Y
%trans: transition matrix, i.e., U
%node_mem: node membership matrix, i.e., R
%loss: converged loss function
    
    %====================
    %Initialize model parameters via NNDSVD
    [flow_mem, flow_desc] = NNDSVD(feats, num_feat_clus, 0);
    flow_desc = flow_desc';
    [A, node_mem] = NNDSVD(links, num_topo_clus, 0);
    node_mem = node_mem';
    [~, trans] = NNDSVD(A, num_feat_clus, 0);
    
    %====================
    %Compute the loss function
    loss = norm(feats - flow_mem*flow_desc', 'fro')^2;
    loss = loss + alpha*norm(links - flow_mem*trans*node_mem', 'fro')^2;
    loss = loss + lambd1*norm(flow_desc, 'fro')^2;
    loss = loss + lambd2*norm(flow_mem*ones(num_feat_clus, 1), 'fro')^2;
    %==========
    iter_cnt = 0; %Iteration countor
    error = 1e3; %Relative error
    while iter_cnt==0 || (error>=min_err && iter_cnt<=max_iter)
        pre_loss = loss; %Loss function of previous iteration
        %====================
        %X-Step: update the feature membership matrix
        aux_1 = node_mem*trans';
        numer = feats*flow_desc + alpha*links*aux_1; %Numerator
        denom = flow_mem*(flow_desc'*flow_desc + lambd2*ones(num_feat_clus, num_feat_clus) + alpha*(aux_1'*aux_1)); %Denominator
        flow_mem = flow_mem.*(numer./max(denom, realmin));
        %====================
        %Y-Step: update the feature description matrix
        numer = feats'*flow_mem; %Numberator
        denom = flow_desc*(flow_mem'*flow_mem + lambd1*eye); %Denominator
        flow_desc = flow_desc.*(numer./max(denom, realmin));
        %====================
        %U-Step: update the trainsition matrix
        numer = flow_mem'*links*node_mem; %Numerator
        denom = (flow_mem'*flow_mem)*trans*(node_mem'*node_mem); %Denominator
        trans = trans.*(numer./max(denom, realmin));
        %====================
        %R-Step: update the node membership matrix 
        aux_2 = flow_mem*trans;
        numer = links'*aux_2; %Numerator
        denom = node_mem*(aux_2'*aux_2); %Denominator
        node_mem = node_mem.*(numer./max(denom, realmin));
        %====================
        %Compute the loss function w.r.t. current iteration
        loss = norm(feats - flow_mem*flow_desc', 'fro')^2;
        loss = loss + alpha*norm(links - flow_mem*trans*node_mem', 'fro')^2;
        loss = loss + lambd1*norm(flow_desc, 'fro')^2;
        loss = loss + lambd2*norm(flow_mem*ones(num_feat_clus, 1), 'fro')^2;
        %==========
        %Compute the relative error
        error = abs(loss-pre_loss)/pre_loss;
        iter_cnt = iter_cnt+1;
        %fprintf('#%d Loss: %8.6f; Error: %8.8f\n', [iter_cnt, loss, error]);
    end
end

