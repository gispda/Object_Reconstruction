%% Submitter: tryond(tryon,daniel) - 20621204

% Calibrates both intrinsic and extrinsic camera properties 
% by using the TOOLBOX_calib GUI. This method provided 
% mediocre results; the computed extrinsic parameters were 
% solely used as initial parameters for the 
% calibrate_left_ext2 and calibrate_right_ext2 functions.

addpath('TOOLBOX_calib');

%% Calibrate each

% navigate to teapot\teapot\calib\
calib

% extract corners
% calibrate
% compute extrinsic

% save calibration
% change name to Calibrate_Results_left.mat
% change name to Calibrate_Results_right.mat

% save l_ext.mat Tc_ext omc_ext Rc_ext
% save r_ext.mat Tc_ext omc_ext Rc_ext

%% Stereo calibration

% navigate to source directory
stereo_gui

% load left and right calibration
% perform stereo

% save results: Calib_Results_stereo.mat

%% Set camL

clear
load Calib_Results_stereo.mat
load l_ext.mat

camL.f = mean(fc_left);
camL.c = cc_left';
camL.t = Tc_ext;
camL.R = Rc_ext;

%% Set camR

load r_ext.mat

camR.f = mean(fc_right);
camR.c = cc_right';
camR.t = Tc_ext;
camR.R = Rc_ext;

%% Save cams

save cams.mat camL camR

%% Set xL, xR, Xtrue

xL = x_left_2;
xR = x_left_2;
Xtrue = X_left_2;

%% Save points 

save points.mat xL xR Xtrue

%% Test parameters

% navigate to reconstruct script




