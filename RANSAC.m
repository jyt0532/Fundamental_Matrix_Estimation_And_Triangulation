function [ new_matches ] = RANSAC( matches )
    threshold = 3;
    current_match_num = 8;
    n = 1;
    iterations = 100;
    N = size(matches, 1);
    while(n < iterations)
        if current_match_num == 8
            inliers_points = randsample(N, 8);
        end
        new_matches = [];
        for i = 1:size(inliers_points, 1)
            new_matches = [new_matches; matches(inliers_points(i), :)];
        end
        
        [F , residual] = fit_fundamental(new_matches, 'groundtruth_normalize');
        L = (F * [matches(:,1:2) ones(N,1)]')'; 
        L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
        pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
        closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
        
        num_of_inliers = 0;
        inliers_points = [];
        residual = [];            
        for i = 1:N
            dis = sqrt(dist2(closest_pt(i,:), matches(i,3:4)));
            if(dis < threshold)
                inliers_points = [inliers_points; i];
                residual = [residual; dis];
                num_of_inliers = num_of_inliers+1;
            end
        end
        num_of_inliers
        if(num_of_inliers < 10)
            current_match_num = 8;
        else
           current_match_num = num_of_inliers;
           n = n+1;
        end
    end
end

