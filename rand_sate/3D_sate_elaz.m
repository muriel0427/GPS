% Observer position
observer = [0, 0, 0];

% Satellite position
satellite = [3, 4, 5];

% Plot the Earth coordinate system with observer at the origin
figure;
hold on;
quiver3(0, 0, 0, 1, 0, 0, 'r', 'LineWidth', 2); % East (x)
quiver3(0, 0, 0, 0, 1, 0, 'g', 'LineWidth', 2); % North (y)
quiver3(0, 0, 0, 0, 0, 1, 'b', 'LineWidth', 2); % Up (z)

% Plot the satellite position relative to the observer at the origin
satellite_relative = satellite - observer;
plot3(satellite_relative(1), satellite_relative(2), satellite_relative(3), 'mo', 'MarkerSize', 10, 'LineWidth', 2);
line([observer(1), satellite_relative(1)], [observer(2), satellite_relative(2)], [observer(3), satellite_relative(3)], 'Color', 'm', 'LineWidth', 2);

% Draw a sphere representing the Earth
[X, Y, Z] = sphere(50);
surf(X, Y, Z, 'FaceAlpha', 0.1, 'EdgeColor', 'none');

% Annotate the points
text(satellite_relative(1), satellite_relative(2), satellite_relative(3), '  Satellite', 'Color', 'm', 'FontSize', 12);
text(0, 0, 0, 'Observer', 'Color', 'k', 'FontSize', 12);

% Set plot limits
xlim([-6, 6]);
ylim([-6, 6]);
zlim([-6, 6]);

% Labels and title
xlabel('East (x)');
ylabel('North (y)');
zlabel('Up (z)');
title('3D View of Satellite Azimuth and Elevation with Observer at Origin');
legend('East (x)', 'North (y)', 'Up (z)', 'Satellite', 'Location', 'best');
grid on;
hold off;
