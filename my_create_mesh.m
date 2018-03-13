% Submitter: tryond(tryon,daniel) - 20621204

% Takes as input the 3D point cloud, applies neighbor 
% thresholding, performs Delaunay triangulation, and 
% trims any triangles that have any edge longer than 
% the edge threshold. Next, smoothing is performed on 
% the mesh by taking the average value of each 3D point?s 
% neighborhood and applying it to said location. The
% resulting mesh is saved as a ply file.

% scan we are working on
scandir = 'C:\Users\danny\Google Drive\CS SPRING 17\117 - Vision\Teapot\';

sets = 10;
for mesh_no = 1:sets

    %
    % threshold for pruning neighbors
    %  TODO: These thresholds depend on the details of the scanning (e.g. how large
    %  the object is that you are scanning and how far away it from the projector 
    %  so you will likely need to experiment with them to get the best results).
    %
    nbrthresh = 0.1;
    trithresh = 1;

    % load in results of reconstruct 
    scanFile = strcat(num2str(mesh_no),'_cleandata.mat');
    load([scandir scanFile]);

    % %% cleaning step 2: remove points whose neighbors are far away
    % %%
    fprintf('filtering right image neighbors\n');
    [tri,pterrR] = nbr_error(xR,X);

    fprintf('filtering left image neighbors\n');
    [tri,pterrL] = nbr_error(xL,X);

    goodpoints = find((pterrR<nbrthresh) & (pterrL<nbrthresh));
    fprintf('dropping %2.2f %% of points from scan\n',100*(1-(length(goodpoints)/size(X,2))));
    X = X(:,goodpoints);
    xR = xR(:,goodpoints);
    xL = xL(:,goodpoints);
    xColor = xColor(:,goodpoints);

    %
    % cleaning step 3: remove triangles which have long edges
    %
    [tri,terr] = tri_error(xL,X);
    subt = find(terr<trithresh);
    tri = tri(subt,:);

    c1 = tri(:,1);
    c2 = tri(:,2);
    tri(:,1) = c2;
    tri(:,2) = c1;
    
    %
    % cleaning step 4: simple smoothing
    %
    Y = nbr_smooth(tri,X,3);
    
    % visualize results of smooth with
    % mesh edges visible
    figure(2); clf;
    h = trisurf(tri,Y(1,:),Y(2,:),Y(3,:));
    set(h,'edgecolor','flat')
    axis image; axis vis3d;
    camorbit(120,0); camlight left;
    camorbit(120,0); camlight left;
    lighting flat;
    set(gca,'projection','perspective')
    set(gcf,'renderer','opengl')
    set(h,'facevertexcdata',xColor'/255);
    material dull

    % %%
    %
    % TODO: you will be running this for multiple scans so you
    %  should set up some way to systematically organize and save
    %  out the data for different scans.
    %

    wFile = strcat(num2str(mesh_no),'_mesh.ply');
    filePath = [scandir wFile];
    mesh_2_ply(Y,xColor,tri,filePath);
    
end



