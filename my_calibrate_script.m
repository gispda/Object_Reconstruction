% Submitter: tryond(tryon,daniel) - 20621204

% Hard codes the cameras intrinsic parameters and utilizes 
% calibrate_left_ext2 and calibrate_right_ext2 to calculate 
% and set camera extrinsic properties

%% Hard Code Instrinsic Parameters

camL.f = mean([1856.90556 1863.13475]);
camL.c = [ 1403.64394 869.11608 ];
camR.f = mean([1844.49412 1843.96528]);
camR.c = [ 1376.02154 942.95783 ]; 

%% Set Intrinsic Parameters

lFile = 'teapot\teapot\calib\l_calib_02.jpg';
rFile = 'teapot\teapot\calib\r_calib_02.jpg';

[camL,xL,Xtrue] = calibrate_left_ext2(lFile,camL);
[camR,xR,Xtrue] = calibrate_right_ext2(rFile,camR);

%% Save Values 

save cams.mat camL camR
save points.mat xL xR Xtrue
