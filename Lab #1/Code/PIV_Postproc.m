clc;
clear;

% 读取txt文件
% filename = '../Raw/30_1500us/Export.80mibepx.000001-6.2487.txt';
filename = '../Raw/60_1500us/Export.80mhz4rl.000000-0.0000.txt';
% 读取数据
[X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename);

% 检查异常值，平滑数据
img_size_x = sum(Y==0);
img_size_y = Y(end) + 1;
[U_cal, V_cal] = post_check_abnormal([img_size_x, img_size_y],U_m_s, V_m_s, 1, 1, ...
    [-0.5,0.5,-0.5,0.5], true, 3, true, 'normalized', 1.5);
fprintf('U缺失值比例: %f\nV缺失值比例：%f\n', sum(isnan(U_cal))/length(U_cal), sum(isnan(V_cal))/length(V_cal));

% Kriging数据插值
[U_interp, V_interp] = post_interp([img_size_x, img_size_y], X, Y, U_cal, V_cal, 'scatteredInterpolant');


% post_export_data(X, Y, X_pix, Y_pix, X_mm, Y_mm, U_interp, V_interp, '0.00', 'test');
%% Show in Figure (2 Figures)
figure;
quiver(X, Y, U_m_s, V_m_s, 1, 'b');
xlim([-1, 119]);
ylim([-1, 74]);

figure;
quiver(X, Y, U_cal, V_cal, 1, 'r');
xlim([-1, 119]);
ylim([-1, 74]);

figure;
quiver(X, Y, U_interp, V_interp, 1, 'g');
xlim([-1, 119]);
ylim([-1, 74]);
%% Show in Figure(1 Figure)
figure;
quiver(X, Y, U_m_s, V_m_s, 1, 'b');
hold on
quiver(X, Y, U_cal, V_cal, 1, 'r');
quiver(X, Y, U_interp, V_interp, 1, 'g');
xlim([-1, 119]);
ylim([-1, 74]);
legend('Original', 'Corrected', 'Interpolated');


%% Scatter plot to show peak lock
figure;
scatter(U_interp, V_interp, 2, 'b');