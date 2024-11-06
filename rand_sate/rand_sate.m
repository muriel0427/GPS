function [sate_position, receiver_position] = rand_sate(num_sate)
rng(123);
% 生成地球上的隨機座標
radius_earth = 1;
theta_earth = 2 * pi * rand(1); 
phi_earth = acos(2 * rand(1) - 1); 

% 地球上的隨機座標
x_u = radius_earth * sin(phi_earth) * cos(theta_earth);
y_u = radius_earth * sin(phi_earth) * sin(theta_earth);
z_u = radius_earth * cos(phi_earth);

%確認座標平方和=半徑和^2
sum = x_u^2+y_u^2+z_u^2;
%disp(sum)

%印出地球上的座標
%fprintf('x座標：%f\n', x_u);
%fprintf('y座標：%f\n', y_u);
%fprintf('z座標：%f\n', z_u);
%fprintf('和：%f\n', sum);

% 設定法向量和點坐標
receiver_position = [x_u y_u z_u];
n = [x_u; y_u; z_u];
p = [x_u; y_u; z_u];

% 定義平面
x_p = -5:0.5:5;
y_p = -5:0.5:5;
[X_p, Y_p] = meshgrid(x_p, y_p);
Z_p = (-n(1)*X_p - n(2)*Y_p + dot(n,p)) / n(3); % 平面方程

sate_position = zeros(num_sate, 3);
% 隨機生成n個位於平面上方的點

i=1;
while i<=num_sate 
    % 定義衛星座標球面半徑
    radius_sate = 5;
    theta_sate = 2 * pi * rand(1);
    phi_sate = acos(2 * rand(1) - 1);
    % 衛星的隨機座標
    x_i = radius_sate * sin(phi_sate) .* cos(theta_sate);
    y_i = radius_sate * sin(phi_sate) .* sin(theta_sate);
    z_i = radius_sate * cos(phi_sate);
    % 檢查是否位於平面上方
    points = [x_i, y_i, z_i];
    if dot(points' - p, n) > 0
        sate_position(i, :) = points;
        i=i+1;
    end    
end
%衛星座標
%disp(sate_position)
% 繪製地球球面
[X, Y, Z] = sphere(25);
X = radius_earth * X;
Y = radius_earth * Y;
Z = radius_earth * Z;

% 繪製衛星球面
[X_i, Y_i, Z_i] = sphere(15);
X_i = radius_sate * X_i;
Y_i = radius_sate * Y_i;
Z_i = radius_sate * Z_i;

% 繪製平面、球面和點
figure;
earth = surf(X, Y, Z, 'EdgeColor', '[0.5 0.7 1]', 'FaceColor', 'none', 'FaceAlpha', 0.3);
hold on;
plane = surf(X_p, Y_p, Z_p, 'EdgeColor', 'none', 'FaceColor', '[0.2 0.8 0.9]', 'FaceAlpha', 0.3);
hold on;
sate = surf(X_i, Y_i, Z_i, 'EdgeColor', 'none', 'FaceColor', 'none', 'FaceAlpha', 0);
axis equal;

% 標記三軸和範圍
xlabel('X'); ylabel('Y'); zlabel('Z');
axis([-10 10 -10 10 -10 10])
grid on;

% 標註地球上座標
plot3(x_u, y_u, z_u, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
text(x_u + 0.1, y_u, z_u ,sprintf('(%0.2f,%0.2f,%0.2f)',x_u,y_u,z_u));

% 標註衛星座標
for i = 1:num_sate
   point = sate_position(i, :);
   plot3(point(1), point(2), point(3), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
   text(point(1)+0.1, point(2), point(3), sprintf('(%0.2f,%0.2f,%0.2f)',point(1),point(2),point(3)));
end
disp(['user_position: (', num2str(x_u), ', ', num2str(y_u), ', ', num2str(z_u), ')']);
end