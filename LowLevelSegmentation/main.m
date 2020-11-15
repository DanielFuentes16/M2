%% Set Base directory
clearvars
clc
basedir='UGM/';
addpath(basedir);
addpath(genpath(basedir))
%% Variables
% Input image
imname = '7_9_s';
lab = true;
K = 3; % Number of color clusters (=number of states of hidden variables)
smooth_term = [5 2.5];

im = imread(strcat(imname,'.bmp'));
im_gt = imread(strcat(imname,'_GT.bmp'));
nRows = size(im,1);
nCols = size(im,2);
nChannels = size(im,3);
%% Prepare data for GMM
if lab
    im = RGB2Lab(im);
end
im=double(im);
x=reshape(im,[nRows*nCols,nChannels]);
gmm_color = gmdistribution.fit(x,K);
mu_color=gmm_color.mu;

%% Estimate Unary potentials (GMM)
data_term=gmm_color.posterior(x); % Posterior probabilities
                                  % ROWS: each of the pixels
                                  % COLS: each of the color clusters
[~,c] = max(data_term,[],2); % Take the index (=color cluster) of the
                             % maximum probability for each pixel

%% Estimate Pairwise potentials
x1 = reshape(rgb2gray(im/255),[nRows*nCols,1]);
[edgePot, edgeStruct] = CreateGridUGMModel(nRows,nCols,K,smooth_term,x1);

%% Solve using different methods
% GMM image
im_c=reshape(mu_color(c,:),size(im));

% Infer LBP
[nodeBelLBP,edgeBelLBP,logZLBP] = UGM_Infer_LBP(data_term,edgePot,edgeStruct);
[~,im_lbp] = max(nodeBelLBP,[],2); %Grab the index with max prob
im_lbp = reshape(mu_color(im_lbp,:),size(im)); %Use the color with max prob

% Decode LBP
decodeLBP = UGM_Decode_LBP(data_term,edgePot,edgeStruct);
im_bp = reshape(mu_color(decodeLBP,:),size(im));

% Extra inference algorithms: MeanField
[nodeBelMeanField, ~, ~] = UGM_Infer_MeanField(data_term,edgePot,edgeStruct);
[~,im_mf] = max(nodeBelMeanField,[],2); % Take the index (=color cluster) of the
                                         % maximum probability for each pixel
im_mf = reshape(mu_color(im_mf,:),size(im)); %Use the color with max prob

% Extra inference algorithms: Chain
[nodeBelChain, ~, ~] = UGM_Infer_Chain(data_term,edgePot,edgeStruct)
[~,im_chain] = max(nodeBelChain,[],2); % Take the index (=color cluster) of the
                                         % maximum probability for each pixel
im_chain = reshape(mu_color(im_chain,:),size(im)); %Use the color with max prob
%%
% Plotting
figure
if lab
    subplot(2,4,1), imshow(Lab2RGB(im)); xlabel('Original') ;
    subplot(2,4,2), imshow(Lab2RGB(im_lbp)); xlabel('Infer LBP') ;
    subplot(2,4,3), imshow(Lab2RGB(im_bp)); xlabel('Decode LBP') ;
    subplot(2,4,4), imshow(Lab2RGB(im_c)); xlabel('GMM') ;
    subplot(2,4,5), imshow(Lab2RGB(im_mf)); xlabel('Infer Mean Field') ;
    subplot(2,4,6), imshow(Lab2RGB(im_chain)); xlabel('Infer Chain') ;
    subplot(2,4,7), imshow(im_gt); xlabel('GT') ;
else
    subplot(2,4,1), imshow(im/255); xlabel('Original') ;
    subplot(2,4,2), imshow(im_lbp/255); xlabel('Infer LBP') ;
    subplot(2,4,3), imshow(im_bp/255); xlabel('Decode LBP') ;
    subplot(2,4,4), imshow(im_c/255); xlabel('GMM') ;
    subplot(2,4,5), imshow(im_mf/255); xlabel('Infer Mean Field') ;
    subplot(2,4,6), imshow(im_chain/255); xlabel('Infer Chain') ;
    subplot(2,4,7), imshow(im_gt); xlabel('GT') ;
end







