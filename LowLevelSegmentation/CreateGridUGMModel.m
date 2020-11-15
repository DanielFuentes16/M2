function [edgePot,edgeStruct]=CreateGridUGMModel(NumFils, NumCols, K, lambda, im)
%
%
% NumFils, NumCols: image dimension
% K: number of states
% lambda: smoothing factor



tic

% Define the number of nodes and states
nNodes = NumFils*NumCols;
nStates = K;

% Create sparse matrix
adj = sparse(nNodes,nNodes);

% Add Down Edges
ind = 1:nNodes;
exclude = sub2ind([NumFils NumCols],repmat(NumFils,[1 NumCols]),1:NumCols); % No Down edge for last row
ind = setdiff(ind,exclude);
adj(sub2ind([nNodes nNodes],ind,ind+1)) = 1;
 
% Add Right Edges
ind = 1:nNodes;
exclude = sub2ind([NumFils NumCols],1:NumFils,repmat(NumCols,[1 NumFils])); % No right edge for last column
ind = setdiff(ind,exclude);
adj(sub2ind([nNodes nNodes],ind,ind+NumFils)) = 1;
 
% Add Up/Left Edges
adj = adj+adj';

% Create structure
edgeStruct = UGM_makeEdgeStruct(adj,nStates);

% Standardize Features
Xstd = UGM_standardizeCols(reshape(im,[1 1 nNodes]),1);

% adj is a sparse matrix defining the nodes and their connections

% Define the pairwise potentials (Potts model)
edgePot = zeros(nStates,nStates,edgeStruct.nEdges);

for e = 1:edgeStruct.nEdges 
   n1 = edgeStruct.edgeEnds(e,1);
   n2 = edgeStruct.edgeEnds(e,2);

   pot_same = exp(lambda(1) + lambda(2)*1/(1+abs(Xstd(n1)-Xstd(n2))));
   edgePot(:,:,e) = (pot_same)*eye(K)+(ones(K)-eye(K));
   %pot_same in the diagonal and 1 elsewhere
end


toc;