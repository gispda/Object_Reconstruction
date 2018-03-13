% Submitter: tryond(tryon,daniel) - 20621204

% Step 1: Calibrate the cameras
% my_calibrate_script
load cams.mat
load points.mat

% Step 2: Decode structured light and create point cloud
% returns XX_scandata.mat, where XX is the set number (in data)
% my_reconstruct

% Step 3: Moves mesh to origin and applies bounding box trimming
% returns XX_cleandata.mat, where XX is the set number (in data)
% my_clean_point_cloud

% Step 4: Cleans mesh further (smoothing, etc.) and saves as ply file
% returns XX_mesh.ply, where XX is the set number (in data)
% my_create_mesh

% Step 5: Mesh alignment
% Meshlab mesh alignment (export one ply file)

% Step 6: Clean the final mesh
% Poisson Surface Reconstruction for final ply file

% Final Result: 
% load('teapot_final.ply');
% display teapot