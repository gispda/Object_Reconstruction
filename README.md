Script/Function List:

my_calibrate_script.m: 
Hard codes the cameras intrinsic parameters and utilizes calibrate_left_ext2 and calibrate_right_ext2 to calculate and set camera extrinsic properties

project_error_ext: 
Takes as input extrinsic camera parameters to optimize over as well as 3D and 2D point sets. Projects the 2D points through the camera with varied parameters and returns the difference between this set and the given 2D locations as the error.

my_calibrate_toolbox_script:
Calibrates both intrinsic and extrinsic camera properties by using the TOOLBOX_calib GUI. This method provided mediocre results; the computed extrinsic parameters were solely used as initial parameters for the calibrate_left_ext2 and calibrate_right_ext2 functions.

calibrate_left_ext2:
Calibrates the left camera’s extrinsic properties by minimizing the projection error. This is done by solving the nonlinear least-squares problem that minimizes the error by varying extrinsic parameters. Uses results from the left TOOLBOX_calib as the initial parameters.

calibrate_right_ext2:
Calibrates the right camera’s extrinsic properties by minimizing the projection error. This is done by solving the nonlinear least-squares problem that minimizes the error by varying extrinsic parameters. Uses results from the right TOOLBOX_calib as the initial parameters.

my_reconstruct:
Takes as input the both cameras’ intrinsic and extrinsic parameters along with the 2D and 3D point sets (for calibration visualization). This script loads in each sets structured light images, decodes them (using gray code), finds correspondences between left and right images, and produces a 3D point cloud. The script also prunes any points which could not be rectified in the 3D point cloud. A 3D color buffer is also produced by averaging the values at each correspondence. 

my_clean_point_cloud:
Takes as input the 3D point cloud, 2D point locations, and the color buffer. This script applies bounding box trimming to the point cloud by moving its center of mass to the origin, and proceeding to trim any points that fall outside the set thresholds.

my_create_mesh:
Takes as input the 3D point cloud, applies neighbor thresholding, performs Delaunay triangulation, and trims any triangles that have any edge longer than the edge threshold. Next, smoothing is performed on the mesh by taking the average value of each 3D point’s neighborhood and applying it to said location. The resulting mesh is saved as a ply file.

project:
Takes a set of 3D points and a camera struct as inputs. The points are then projected through the camera, applying both intrinsic and extrinsic properties, to attain a 2D point set.

buildrotation:
Takes as input 3 rotation values for rotation about the x, y, and z axes respectively. The function then constructs a 3x3 rotation matrix by converting each x, y, z rotation to its own 3x3 rotation matrix and multiplying the results together.

decode:
Takes as input a set of images along with a brightness threshold. The function iterates through the images, finding out whether or not each image falls in (1) or out (0) of the structured light. If it is ambiguous, the pixel is marked as undecodable in the output binary image. After all sets have been assigned 10 digit gray codes, each are then decoded and converted into unique decimal numbers. The array of decoded values along with the binary image of decodable pixels are returned.

triangulate:
Takes as input two cameras (left and right) and 2 corresponding 2D point sets. The function takes each corresponding point in the 2D sets and creates a 3D point set that represents its location. The 3D point locations are returned as the output. 

nbr_error:
Takes as input corresponding 2D and 3D point locations. The function performs Delaunay triangulation on the 2D points and computes the distance between the point in 3D and the median location of its neighbor. This distance is returned as the error along with the Delaunay triangulation.

tri_error:
Takes as input corresponding 2D and 3D point locations. The function performs Delaunay triangulation on the 2D points and computes the length of the longest edge for each triangle. This length is returned as the error along with the Delaunay triangulation.

nbr_smooth:
Takes as input a set of triangles, 3D point locations, and the desired amount of rounds of smoothing. The function smooths the 3D locations of points by moving each point to the mean location of its neighbors.




# Object_Reconstruction
