function [A] = build_matrix_A(matches, inliers_points)
    A = [];
    for i = 1:size(inliers_points,1)
        u = matches(inliers_points(i), 1);
        v = matches(inliers_points(i), 2);
        u_ = matches(inliers_points(i), 3);
        v_ = matches(inliers_points(i), 4); 
        A = [A; u_*u u_*v u_ v_*u v_*v v_ u v 1];
    end
end