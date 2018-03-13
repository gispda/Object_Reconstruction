% Submitter: tryond(tryon,daniel) - 20621204

% Takes as input the 3D point cloud, 2D point locations, 
% and the color buffer. This script applies bounding box 
% trimming to the point cloud by moving its center of mass 
% to the origin, and proceeding to trim any points that fall 
% outside the set thresholds.

% scan we are working on
scandir = 'C:\Users\danny\Google Drive\CS SPRING 17\117 - Vision\Teapot\';

sets = 10;

for mesh_no = 1:sets

    % load in results of reconstruct 
    scanFile = strcat(num2str(mesh_no),'_scandata.mat');
    load([scandir scanFile]);

    % Compute average 
    x_center = mean(X(1,:));
    y_center = mean(X(2,:));
    z_center = mean(X(3,:));

    % Move center of mass to the origin
    X(1,:) = X(1,:) - x_center;
    X(2,:) = X(2,:) - y_center;
    X(3,:) = X(3,:) - z_center;

    % Remove Points Outside of Bounding Box

    %
    % cleaning step 1: remove points outside known bounding box
    %

    x_min = -20; % -20;
    x_max = -1;

    y_min = -11; % -11;
    y_max = 12;

    z_min = 0;
    z_max = 20;

    goodpoints = find( (X(1,:)>x_min) & (X(1,:)<x_max) & (X(2,:)>y_min) & (X(2,:)<y_max) & (X(3,:)>z_min) & (X(3,:)<z_max) );
    fprintf('dropping %2.2f %% of points from scan',100*(1 - (length(goodpoints)/size(X,2))));
    X = X(:,goodpoints);
    xR = xR(:,goodpoints);
    xL = xL(:,goodpoints);
    xColor = xColor(:,goodpoints);

    % Visualize Point Cloud
    %{
    scatter3(X(1,:),X(2,:),X(3,:),'.','b');
    hold on;
    scatter3(0,0,0,'k','filled');
    scatter3(10,0,0,'g','filled');
    scatter3(20,0,0,'g','filled');
    scatter3(0,10,0,'y','filled');
    scatter3(0,20,0,'y','filled');
    scatter3(0,0,10,'m','filled');
    scatter3(0,0,20,'m','filled');

    ylabel('y');
    zlabel('z');
    axis image;
    axis vis3d;
    %}
    
    % Write Clean Point Cloud   
    wFile = strcat(num2str(mesh_no),'_bottom_cleandata.mat');
    save([scandir wFile],'X','xColor','xL','xR','camL','camR','scandir');

end


