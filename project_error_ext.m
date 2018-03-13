% Submitter: tryond(tryon,daniel) - 20621204

function err = project_error_ext(params,X,xL,f,cx,cy)
% Takes as input extrinsic camera parameters to optimize over
% as well as 3D and 2D point sets. Projects the 2D points 
% through the camera with varied parameters and returns the 
% difference between this set and the given 2D locations as 
% the error.

%
% wrap our project function for the purposes of optimization
%  params contains the parameters of the camera we want to 
%  estimate.  X,cx,cy are given.
%

%location of camera center  %not optimized
% cam.f = params(1);
cam.f = f;
cam.c = [cx;cy];
cam.R = buildrotation(params(1),params(2),params(3));
cam.t = params(4:6)';


x = project(X,cam);
err = x-xL;

%{
figure(4);  clf;
plot(x(1,:),x(2,:),'b.'); hold on;
plot(xL(1,:),xL(2,:),'r.');
axis image;
drawnow;
%}
