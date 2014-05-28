function [matches, T] = noramlize_match_points(matches)
    u1 = mean(matches(:, 1));
    matches(:,1) = matches(:,1) - u1;
    u2 = mean(matches(:, 2));
    matches(:,2) = matches(:,2) - u2;
    dist = sqrt(matches(:,1).^2 + matches(:,2).^2);
    dist_mean = mean(dist);
    scale = 2/dist_mean;
    matches = matches*scale;
    T = [scale    0     -scale*u1
           0    scale   -scale*u2
           0      0         1   ]; 
end