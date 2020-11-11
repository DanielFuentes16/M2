clearvars
clc
% Input image
im = imread('3_12_s.bmp');
K = 3;

% Prepare data for GMM
im = rgb2gray(im);
im=double(im);
nRows = size(im,1);
nCols = size(im,2);
x=reshape(im,[size(im,1)*size(im,2),1]);
gmm_color = gmdistribution.fit(x,K);
mu_color=gmm_color.mu;

%% Estimate Unary potentials (GMM)
data_term=gmm_color.posterior(x);
[~,c] = max(data_term,[],2);
nodePot = zeros(size(data_term));
for i=1:size(data_term,1)
    nodePot(i,c(i)) = data_term(i,c(i));
end

%% Estimate Pairwise potentials
[edgePot, edgeStruct] = CreateGridUGMModel(size(im,1),size(im,2),K,0.5);

%% Solve using ICM
ICMDecoding = UGM_Decode_ICM(nodePot,edgePot,edgeStruct);
figure;
colormap gray
subplot(1,3,1)
imshow(im/255)
subplot(1,3,2)
for i=1:K
    ICMDecoding(ICMDecoding==i) = mu_color(i);
end
im_seg = reshape(ICMDecoding,nRows,nCols);
imagesc(im_seg)
axis image

