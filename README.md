Fundamental_Matrix_Estimation_And_Triangulation
===============================================

##Steps
1. Download the data file, including all the 101 images and a measurement matrix consisting of 215 points visible in each of the 101 frames (see readme file inside archive for details).

2. Load the data matrix and normalize the point coordinates by translating them to the mean of the points in each view (see lecture for details).

3. Apply SVD to the 2M x N data matrix to express it as D = U * W * V' where U is a 2Mx3 matrix, W is a 3x3 matrix of the top three singular values, and V is a Nx3 matrix. Derive structure and motion matrices from the SVD as explained in the lecture.

4. Use plot3 to display the 3D structure (in your report, you may want to include snapshots from several viewpoints to show the structure clearly). Discuss whether or not the reconstruction has an ambiguity.

5. Display three frames with both the observed feature points and the estimated projected 3D points overlayed. Report your total residual (sum of squared Euclidean distances, in pixels, between the observed and the reprojected features) over all the frames, and plot the per-frame residual as a function of the frame number.


##Usage

1. Input images is assigned in sample_code.m
2. Run the sample_code
