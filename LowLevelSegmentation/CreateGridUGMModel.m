function [edgePot,edgeStruct]=CreateGridUGMModel(NumFils, NumCols, K, lambda, im, multiple_channels, lab)
%
%
% NumFils, NumCols: image dimension
% K: number of states
% lambda: smoothing factor



tic

% Define the number of nodes and states
nNodes = NumFils*NumCols;
nStates = K;

% Create sparse matrix (defining the nodes and their connections)
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
if multiple_channels % Use the three channels
    XstdL = UGM_standardizeCols(reshape(im(:,:,1),[1 1 nNodes]),1);
    Xstda = UGM_standardizeCols(reshape(im(:,:,2),[1 1 nNodes]),1);
    Xstdb = UGM_standardizeCols(reshape(im(:,:,3),[1 1 nNodes]),1);
else
    if lab % Use only luminance
        Xstd  = UGM_standardizeCols(reshape(im(:,:,1),[1 1 nNodes]),1);
    else   % Use grayscale image
        Xstd  = UGM_standardizeCols(reshape(rgb2gray(im),[1 1 nNodes]),1);
    end
end

% Define the pairwise potentials (Potts model)
edgePot = zeros(nStates,nStates,edgeStruct.nEdges);

for e = 1:edgeStruct.nEdges 
   % Diagonal: probability of 2 adjacent pixels to have the same color
   % Others: probability of 2 non-adjacent pixels to have the same color
   
   % Option 1: pot_same in the diagonal and 1 elsewhere
   n1 = edgeStruct.edgeEnds(e,1);
   n2 = edgeStruct.edgeEnds(e,2);
   
   % Option 1A: the squared error for all three components gives a better description
   % of the pixel diff
   if multiple_channels
       pot_same = exp(lambda(1) + lambda(2)*1/(1+sqrt( ...
           (XstdL(n1)-XstdL(n2))^2 + (Xstda(n1)-Xstda(n2))^2 + (Xstdb(n1)-Xstdb(n2))^2)));
       edgePot(:,:,e) = (pot_same)*eye(K)+(ones(K)-eye(K));
   
   % Option 1B: use only one channel
   else
        pot_same = lambda(1)*exp(lambda(2) + lambda(3)*1/(1+abs(Xstd(n1)-Xstd(n2))));
        edgePot(:,:,e) = (pot_same)*eye(K)+(ones(K)-eye(K));
   end
   
   % Option 2: use directly lambda(1) for the diagonal and lambda(2) for the rest
   %edgePot(:,:,e) = (exp(1+lambda(1)))*eye(K)+(exp(1+lambda(2)))*(ones(K)-eye(K));
   
   % Option 3: change manually values (for K=3)
   %edgePot(:,:,e) =  [4     1       1;
                      %1     4       1;
                      %1     1       4];
end

% Option 4: scale diagonals according to colors
%edgePot(1,1,:) = edgePot(1,1,:).*10;
%edgePot(2,2,:) = edgePot(2,2,:).*1;
%edgePot(3,3,:) = edgePot(3,3,:).*10;

toc;