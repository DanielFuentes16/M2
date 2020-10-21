clearvars;
close all;

SRC = 'girl';
DST = 'lena';

src = double(imread(strcat(SRC, '.png'))); % flipped girl, because of the eyes
dst = double(imread(strcat(DST, '.png')));
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%Masks to exchange: Eyes
mask_src=logical(imread(strcat(SRC, '_mask_eyes.png')));
mask_dst=logical(imread(strcat(DST, '_mask_eyes.png')));

for nC = 1: nChannels
    
    %TO DO: COMPLETE the ??
    drivingGrad_i = sol_DiBwd(src(:,:,nC), param.hi) - sol_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = sol_DjBwd(src(:,:,nC), param.hj) - sol_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j;
    
    driving_on_dst = zeros(size(src(:,:,1)));   
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G10_Laplace_Equation_Axb(dst(:,:,nC), mask_dst,  param);
end


subplot(1,5,1);
imshow(src/256);
title('Source image');

subplot(1,5,2);
imshow(dst/256);
title('Destination image');

subplot(1,5,3);
imshow(driving_on_src/256);
title('Gradient of source image');

subplot(1,5,4);
imshow(driving_on_dst/256);
title('Source gradient on destination image');

subplot(1,5,5);
imshow(dst1/256);
title('Result');


%% Mouth
%Masks to exchange: Mouth
mask_src=logical(imread(strcat(SRC, '_mask_mouth.png')));
mask_dst=logical(imread(strcat(DST, '_mask_mouth.png')));

for nC = 1: nChannels
    
    %TO DO: COMPLETE the ??
    drivingGrad_i = sol_DiBwd(src(:,:,nC), param.hi) - sol_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = sol_DjBwd(src(:,:,nC), param.hj) - sol_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j;
    
    driving_on_dst = zeros(size(src(:,:,1)));  
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G10_Laplace_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
end

figure
subplot(1,5,1);
imshow(src/256);
title('Source image');

subplot(1,5,2);
imshow(dst/256);
title('Destination image');

subplot(1,5,3);
imshow(driving_on_src/256);
title('Gradient of source image');

subplot(1,5,4);
imshow(driving_on_dst/256);
title('Source gradient on destination image');

subplot(1,5,5);
imshow(dst1/256);
title('Result');


%% Nose
%Masks to exchange: Nose
mask_src=logical(imread(strcat(SRC, '_mask_nose.png')));
mask_dst=logical(imread(strcat(DST, '_mask_nose.png')));

for nC = 1: nChannels
    
    %TO DO: COMPLETE the ??
    drivingGrad_i = sol_DiBwd(src(:,:,nC), param.hi) - sol_DiFwd(src(:,:,nC), param.hi);
    drivingGrad_j = sol_DjBwd(src(:,:,nC), param.hj) - sol_DjFwd(src(:,:,nC), param.hj);

    driving_on_src = drivingGrad_i + drivingGrad_j;
    
    driving_on_dst = zeros(size(src(:,:,1)));  
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    
    param.driving = driving_on_dst;

    dst1(:,:,nC) = G10_Laplace_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
end

figure
subplot(1,5,1);
imshow(src/256);
title('Source image');

subplot(1,5,2);
imshow(dst/256);
title('Destination image');

subplot(1,5,3);
imshow(driving_on_src/256);
title('Gradient of source image');

subplot(1,5,4);
imshow(driving_on_dst/256);
title('Source gradient on destination image');

subplot(1,5,5);
imshow(dst1/256);
title('Result');
