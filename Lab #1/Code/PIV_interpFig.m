clc
clear

output_folder = '../Fig/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 读取txt文件
filename = '../Raw/60_1500us/Export.80mhz4rl.000000-0.0000.txt';
% filename = '../Raw/30_1500us/Export.80mibepx.000001-6.2487.txt';
% 读取数据
[X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename);

% 检查异常值，平滑数据
img_size_x = sum(Y==0);
img_size_y = Y(end) + 1;
[U_cal, V_cal] = post_check_abnormal([img_size_x, img_size_y],U_m_s, V_m_s, 1, 1, ...
    [-0.5,0.5,-0.5,0.5], true, 3, true, 'normalized', 1.5);

[U_interp, V_interp] = post_interp([img_size_x, img_size_y], X, Y, U_cal, V_cal, 'scatteredInterpolant');



nan_indices = isnan(U_cal) | isnan(V_cal);

figure;
quiver(X, Y, U_cal, V_cal, 1, 'Color', [250/255, 192/255, 15/255], 'LineWidth', 1.5);
hold on;
quiver(X(nan_indices), Y(nan_indices), U_interp(nan_indices), V_interp(nan_indices), 1, 'Color', [120/255, 143/255, 208/255], 'LineWidth', 1.5);
xlim([-1, 119]);
ylim([-1, 74]);


ax = gca;
ax.Box = 'on';
ax.LineWidth = 1.2; % 设置边框线宽度
ax.GridLineStyle = '--'; % 设置网格线为虚线
ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
% title("\text{60% -1500 $\mu$s 剔除的速度场坏矢量}", 'FontSize', 12, 'Interpreter', 'latex');
xlabel('X (Pix)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Y (Pix)', 'FontSize', 12, 'FontName', 'Times New Roman');
legend("\fontname{宋体}待插值数据", "\fontname{宋体}插值数据");
grid on;

saveas(gcf, fullfile(output_folder, "fig_interp_illustration.png"));