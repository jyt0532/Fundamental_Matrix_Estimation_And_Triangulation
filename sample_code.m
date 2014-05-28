%%
%% load images and match files for the first example
%%

%I1 = imread('house1.jpg');
%I2 = imread('house2.jpg');
I1 = imread('library1.jpg');
I2 = imread('library2.jpg');
%matches = load('house_matches.txt'); 
matches = load('library_matches.txt');
N = size(matches,1);
% this is a N x 4 file where the first two numbers of each row
% are coordinates of corners in the first image and the last two
% are coordinates of corresponding corners in the second image: 
% matches(i,1:2) is a point in the first image
% matches(i,3:4) is a corresponding point in the second image


%%
%% display two images side-by-side with matches
%% this code is to help you visualize the matches, you don't need
%% to use it to produce the results for the assignment
%%
imshow([I1 I2]); hold on;
plot(matches(:,1), matches(:,2), '+r');
plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');

%%
%% display second image with epipolar lines reprojected 
%% from the first image
%%

% first, fit fundamental matrix to the matches

matches = find_matches_by_harris_code(I1, I2);

figure(10);
showMatchedFeatures(I1,I2,matches(:,1:2),matches(:,3:4),'montage','PlotOptions',{'ro','ro','r-'});
pause;
  
matches = RANSAC(matches);
N = size(matches,1);
[F , residual] = fit_fundamental(matches, 'groundtruth_normalize'); % this is a function that you should write
%[F , residual] = fit_fundamental(matches, 'groundtruth');
%%
%F = estimateFundamentalMatrix(matches(:,1:2), matches(:,3:4));
%%

L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from  %% Fx = l'
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

sum_dis_1 = 0;
for i = 1:size(matches, 1)
    sum_dis_1 = sum_dis_1 + sqrt(dist2(closest_pt(i,:), matches(i,3:4)));
end

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure(7);
imshow(I2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');


%%
%% display first image with epipolar lines reprojected 
%% from the second image
%%


L = (F' * [matches(:,3:4) ones(N,1)]')'; % transform points from  %% Fx = l'
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,1:2) ones(N,1)],2);
closest_pt = matches(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

sum_dis_2 = 0;
for i = 1:size(matches, 1)
    sum_dis_2 = sum_dis_2 + sqrt(dist2(closest_pt(i,:), matches(i,1:2)));
end

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure(8);
imshow(I1); hold on;
plot(matches(:,1), matches(:,2), '+r');
line([matches(:,1) closest_pt(:,1)]', [matches(:,2) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');

%% Part4
%P1 = load('house1_camera.txt');
%P2 = load('house2_camera.txt');

%matches = load('house_matches.txt'); 
P1 = load('library1_camera.txt');
P2 = load('library2_camera.txt');

matches = load('library_matches.txt'); 
N = size(matches,1);

coordinate_3d = zeros(N, 3);
for i = 1:N
    x1_cross = [    0               -1          matches(i, 2); 
                    1               0          -matches(i, 1);
                -matches(i, 2)  matches(i, 1)        0       ];
    x2_cross = [    0               -1          matches(i, 4); 
                    1               0          -matches(i, 3);
                -matches(i, 4)  matches(i, 3)        0       ];
    D = [x1_cross*P1; x2_cross*P2];
    % solve for DX = 0
    [U,S,V]=svd(D); 
    X = V(:,end);
    coordinate_3d(i, 1:3) = [X(1)/X(4), X(2)/X(4), X(3)/X(4)];
end
%P=[M|?MC]
M1 = P1(1:3, 1:3)*-1;
M1C = P1(1:3, 4);
P1_coordinate = inv(M1)*M1C;

M2 = P2(1:3, 1:3)*-1;
M2C = P2(1:3, 4);
P2_coordinate = inv(M2)*M2C;

figure();
plot3(coordinate_3d(:,3),coordinate_3d(:, 1),coordinate_3d(:, 2), '.');
hold on;
xlabel('z');
ylabel('x');
zlabel('y');
set(gca,'XDir','reverse');
%set(gca,'YDir','reverse')
plot3(P1_coordinate(3),P1_coordinate(1),P1_coordinate(2), 'ro');
plot3(P2_coordinate(3),P2_coordinate(1),P2_coordinate(2), 'ro');
text(P1_coordinate(3),P1_coordinate(1),P1_coordinate(2), 'camera_1');
text(P2_coordinate(3),P2_coordinate(1),P2_coordinate(2), 'camera_2');
axis equal;

total_residual_1 = 0;
total_residual_2 = 0;
for i = 1:N
    X1 = P1*[coordinate_3d(i, 1:3) 1]';
    total_residual_1  = total_residual_1 + sqrt(dist2([X1(1)/X1(3) X1(2)/X1(3)], [matches(i, 1) matches(i, 2)]));
    X2 = P2*[coordinate_3d(i, 1:3) 1]';
    total_residual_2  = total_residual_2 + sqrt(dist2([X2(1)/X2(3) X2(2)/X2(3)], [matches(i, 3) matches(i, 4)]));
end

