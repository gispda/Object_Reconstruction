% Submitter: tryond(tryon,daniel) - 20621204

% Takes as input the both cameras? intrinsic and extrinsic
% parameters along with the 2D and 3D point sets (for 
% calibration visualization). This script loads in each sets 
% structured light images, decodes them (using gray code), 
% finds correspondences between left and right images, and 
% produces a 3D point cloud. The script also prunes any 
% points which could not be rectified in the 3D point cloud.
% A 3D color buffer is also produced by averaging the values 
% at each correspondence. 

% directory where the scan data is stored
scandir = 'C:\Users\danny\Google Drive\CS SPRING 17\117 - Vision\Teapot\';

% Number of meshes to be constructed
sets = 10;

% Get from CALIBRATE_TEST
load cams.mat
load points.mat

for s = 1:sets
    
    thresh = 0.001;
    
    % Construct file
    hFile = strcat('teapot\teapot\set_',num2str(s));
    rFile = strcat(hFile,'\r_');
    lFile = strcat(hFile,'\l_');

    [R_h,R_h_good] = decode([scandir rFile],1,10,thresh);
    [R_v,R_v_good] = decode([scandir rFile],11,20,thresh);
    [L_h,L_h_good] = decode([scandir lFile],1,10,thresh);
    [L_v,L_v_good] = decode([scandir lFile],11,20,thresh);

    %
    % combine horizontal and vertical codes
    % into a single code and mask.
    %
    Rmask = R_h_good & R_v_good;
    R_code = R_h + 1024*R_v;
    Lmask = L_h_good & L_v_good;
    L_code = L_h + 1024*L_v;

    %
    % now find those pixels which had matching codes
    % and were visible in both the left and right images
    %
    % only consider good pixels
    Rsub = find(Rmask(:));
    Lsub = find(Lmask(:));
    % find matching pixels 
    [matched,iR,iL] = intersect(R_code(Rsub),L_code(Lsub));
    indR = Rsub(iR);
    indL = Lsub(iL);
    % indR,indL now contain the indices of the pixels whose 
    % code value matched

    % pull out the pixel coordinates of the matched pixels
    [h,w] = size(Rmask);
    [xx,yy] = meshgrid(1:w,1:h);
    xL = []; xR = [];
    xR(1,:) = xx(indR);
    xR(2,:) = yy(indR);
    xL(1,:) = xx(indL);
    xL(2,:) = yy(indL);

    %
    % while we are at it, we can use the same indices (indR,indL) to
    % pull out the colors of the matched pixels
    %

    % array to store the (R,G,B) color values of the matched pixels
    xColor = zeros(3,size(xR,2));

    % Construct RGB reference files
    rFileRGB = strcat(hFile,'\r_rgb.jpg');
    lFileRGB = strcat(hFile,'\l_rgb.jpg');
    
    % load in the images and seperate out the red, green, blue
    % color channels into separate matrices
    rgbL = imread([scandir lFileRGB]);
    rgbL_R = rgbL(:,:,1); 
    rgbL_G = rgbL(:,:,2);
    rgbL_B = rgbL(:,:,3);

    rgbR = imread([scandir rFileRGB]);
    rgbR_R = rgbR(:,:,1);
    rgbR_G = rgbR(:,:,2);
    rgbR_B = rgbR(:,:,3);

    % use the average of the color in the left and 
    % right image.  depending on the scan, it may
    % be better to just use one or the other.
    xColor(1,:) = 0.5*(rgbR_R(indR) + rgbL_R(indL));
    xColor(2,:) = 0.5*(rgbR_G(indR) + rgbL_G(indL));
    xColor(3,:) = 0.5*(rgbR_B(indR) + rgbL_B(indL));

    %
    % now triangulate the matching pixels using the calibrated cameras
    %
    X = triangulate(xL,xR,camL,camR);

    %
    % save the results of all our hard work
    %
    % Construct scandata file
    scandata = strcat(num2str(s),'_scandata.mat');
    save([scandir scandata],'X','xColor','xL','xR','camL','camR','scandir');

end