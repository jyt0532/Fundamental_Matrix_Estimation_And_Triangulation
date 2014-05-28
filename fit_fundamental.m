function [F residual] = fit_fundamental(matches, method)
    F = zeros(3,3);
    threshold = 2;
    num_of_matches = size(matches, 1);
    %method = 'groundtruth_normalize'; %'groundtruth'

    if strcmp(method, 'groundtruth_normalize')
        [matches(:,1:2), T1] = noramlize_match_points(matches(:,1:2));
        [matches(:,3:4), T2] = noramlize_match_points(matches(:,3:4));
    elseif strcmp(method, 'groundtruth')
        T1 = eye(3);
        T2 = eye(3);
    end
    inliers_points = [1:num_of_matches]';
    A = build_matrix_A(matches, inliers_points);
    %solve AF = 0
    [U,S,V]=svd(A); 
    F = reshape(V(:,end), 3, 3)';%V(:,end) is the solution
    %enforce rank-2 constrain
    [U,S,V] = svd(F,0);
    F = U*diag([S(1,1) S(2,2) 0])*V';
    F = T2'* F * T1;
    residual = [];
    for i = 1:num_of_matches
        X = F * [matches(i, 1) matches(i, 2) 1]';
        residual = [residual; abs([matches(i, 3),matches(i, 4), 1]*X)];
    end    
        
end