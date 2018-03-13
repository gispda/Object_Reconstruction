% Submitter: tryond(tryon,daniel) - 20621204

function [cam,x,X] = calibrate_right_ext2(imfile,cam)

%
% calibrate only the extrinsic parameters from a single checkerboard pattern
% this code assumes that the focal length of cam is already set.
%

%
% first load in the calibration images
%
I = im2double(rgb2gray(imread(imfile)));

% get the grid corner points
% x = mapgrid(I,10,8);
fprintf('click on the corners of each of the three faces\n');
fprintf('always start at the origin point and go around in a circle\n');
fprintf('XY plane (9x6 squares) -> go along the 9 edge first in the same order in both images\n');
x = mapgrid(I,10,7);

% XY = mapgrid(I,10,7);


% true 3D cooridnates  (for a planar pattern)
% [yy,xx] = meshgrid(linspace(0,19.55,8),linspace(0,25.2,10));
% zz = zeros(size(xx(:)));
% X = [xx(:) yy(:) zz(:)]';  

[yy,xx] = meshgrid( linspace(0,7*2.45,7), linspace(0,10*2.45,10));
zz = zeros(size(yy(:)));
X = [xx(:) yy(:) zz(:)]';


% now calibrate the camera
% thx = pi;
% thy = 0;
% thz = 0;
% tx = -30;
% ty = -30;
% tz = 30;

% left 
% thx_l = 1.95;
% thy_l = 2.08;
% thz_l = 0.35;
% tx_l = -63.62;
% ty_l = -112.87;
% tz_l = 413.92;

% right
thx = -1.92;
thy = -2.06;
thz = 0.37;
tx = -151.51;
ty = -125.17;
tz = 510.94;

pinit = [thx,thy,thz,tx,ty,tz];

%we can specify lower and upper bounds, this can be
% useful in getting the optimization to converge to
% a reasonable solution
ub = [inf inf inf    inf inf inf];
lb = [-inf -inf -inf -inf -inf 0];
opts = optimset('maxfunevals',100000,'maxiter',5000);
pfinal = lsqnonlin( @(params) project_error_ext(params,X,x,cam.f,cam.c(1),cam.c(2)),pinit,lb,ub,opts);

thx = pfinal(1);
thy = pfinal(2);
thz = pfinal(3);
tx = pfinal(4);
ty = pfinal(5);
tz = pfinal(6);

fprintf('final rot = %2.2f %2.2f %2.2f\n',thx,thy,thz);

cam.t= [tx;ty;tz];
cam.R = buildrotation(thx,thy,thz);
xest = project(X,cam);

figure(1); clf;
imagesc(I);
hold on;
plot(x(1,:),x(2,:),'b.')
plot(xest(1,:),xest(2,:),'r.')
axis image;

