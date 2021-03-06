%close all;
clearvars;
clc

%I=double(imread('zigzag_mask.png'));
%I=mean(I,3); %To 2D matrix
%I=double(imread('noisedCircles.tif'));
%I=double(imread('circles.png'));
%I=double(imread('phantom17.bmp'));
I=double(imread('phantom18.bmp'));
%I=double(imread('phantom19.bmp'));
%I=double(imread('Image_to_Restore.png'));
%I=double(imread('che.jpg'));

I=mean(I,3);
I=I-min(I(:));
I=I/max(I(:));

[ni, nj]=size(I);



%Lenght and area parameters
%circles.png mu=1, mu=2, mu=10
%noisedCircles.tif mu=0.1
%phantom17 mu=1, mu=2, mu=10
%phantom18 mu=0.2 mu=0.5
%hola carola mu=1
mu=0.1;
nu=0;


%%Parameters
lambda1=1;
lambda2=1;
%lambda1=10^-3; %Hola carola problem
%lambda2=10^-3; %Hola carola problem

epHeaviside=1;
%eta=0.01;
eta=1;
tol=0.000001;
%dt=(10^-2)/mu; 
dt=(10^-1)/mu;

iterMax=300
%reIni=100; %Try both of them
%reIni=500;
reIni=0;
[X, Y]=meshgrid(1:nj, 1:ni);

%%Initial phi
phi_0=(-sqrt( ( X-round(ni/2)).^2 + (Y-round(nj/2)).^2)+50);
%%Initial phi: regularized
%phi_0= sin(pi/5 * X) .* sin(pi/5 * Y);

%%% This initialization allows a faster convergence for phantom 18
%phi_0=(-sqrt( ( X-round(ni/2)).^2 + (Y-round(nj/4)).^2)+50);
% Normalization of the initial phi to [-1 1]
% phi_0=phi_0-min(phi_0(:));
% phi_0=2*phi_0/max(phi_0(:));
% phi_0=phi_0-1;

%phi_0=I; %For the Hola carola problem

phi_0=phi_0-min(phi_0(:));
phi_0=2*phi_0/max(phi_0(:));
phi_0=phi_0-1;


%%Explicit Gradient Descent

%Plot every vis iterations 
vis = 0;
%output as .avi file
vid = false;
phi=sol_ChanVeseIpol_GDExp( I, phi_0, mu, nu, eta, lambda1, lambda2, tol, epHeaviside, dt, iterMax, reIni, vis, vid );

figure('Position',[100, 100, 1200, 500]);
%%Plot the final result
%Plot the level sets surface
subplot(1,2,1) 
    %The level set function
    surfc(phi)  %TODO 16: Line to complete 
    hold on
    %The zero level set over the surface
    contour(phi,1,'r'); %TODO 17: Line to complete
    hold off
    title('Phi Function');

%Plot the curve evolution over the image
subplot(1,2,2)
    imagesc(I);        
    colormap gray;
    hold on;
    contour(phi,1,'r') %TODO 18: Line to complete
    title('Image and zero level set of Phi')

    axis off;
    hold off