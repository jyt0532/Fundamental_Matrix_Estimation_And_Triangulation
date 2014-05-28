Fundamental_Matrix_Estimation_And_Triangulation
===============================================

ComputerVision MP4

##Steps
1. Load the image pair and matching points file into MATLAB (see sample code in the data file).

2. Fit a fundamental matrix to the matching points. Use the sample code provided to visualize the results. Implement both the normalized and the unnormalized algorithms (see this lecture for the methods). In each case, report your residual, or the mean squared distance in pixels between points in both images and the corresponding epipolar lines.

3. Now use your putative match generation and RANSAC code from Assignment 3 to estimate fundamental matrices without ground-truth matches. For this part, only use the normalized algorithm. Report the number of inliers and the average residual for the inliers. In your report, compare the quality of the result with the one you get from ground-truth matches. 

4. Load the camera matrices for the two images (they are stored as 3x4 matrices and can be loaded with the load command, i.e., P1 = load('house1_camera.txt'); Find the centers of the two cameras. Use linear least squares to triangulate the position of each matching pair of points given the two cameras (see this lecture for the method). Display the two camera centers and reconstructed points in 3D. Also report the residuals between the observed 2D points and the projected 3D points in the two images.

Note: you do not need the camera centers to solve the triangulation problem. They are used just for the visualization.

Note 2: it is sufficient to only use the provided ground-truth matches for this part. But if you wish, feel free to also generate and compare results with the inlier matches you have found in #3 above.
Tips and Details

##Tips and Details

1. For fundamental matrix estimation, don't forget to enforce the rank-2 constraint. This can be done by taking the SVD of F, setting the smallest singular value to zero, and recomputing F.

2. Lecture 15 shows two slightly different linear least squares setups for estimating the fundamental matrix (one involves a homogeneous system and one involves a non-homogeneous system). You may want to compare the two and determine which one is better in terms of numerics.

3. Recall that the camera centers are given by the null spaces of the matrices. They can be found by taking the SVD of the camera matrix and taking the last column of V.

4. For triangulation with linear least squares, it is not necessary to use data normalization (in my implementation, normalization made very little difference for this part).

5. Plotting in 3D can be done using the plot3 command. Use the axis equal option to avoid automatic nonuniform scaling of the 3D space. To show the structure clearly, you may want to include snapshots from several viewpoints. In the past, some students have also been able to produce animated GIF's, and those have worked really well.

##Usage

1. Input images is assigned in sample_code.m
2. Run the sample_code
