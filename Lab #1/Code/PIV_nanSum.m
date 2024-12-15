clc;
clear;

raw_folder = '../Orig/';
subfolders = dir(raw_folder);

% 过滤掉 . 和 .. 以及非文件夹项
subfolder_names = {subfolders([subfolders.isdir]).name};
subfolder_names = subfolder_names(~ismember(subfolder_names, {'.', '..'}));
subfolder_names = string(subfolder_names);

subfolder_path = fullfile(raw_folder, subfolder_names(7));
txt_files = dir(fullfile(subfolder_path, '*.txt'));

nan_percent = [];

for j = 1:length(txt_files)
    filename = fullfile(subfolder_path, txt_files(j).name);
    
    % 读取数据
    [X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename);
    
    % 检查异常值，平滑数据
    img_size_x = sum(Y==0);
    img_size_y = Y(end) + 1;
    [U_cal, V_cal] = post_check_abnormal([img_size_x, img_size_y],U_m_s, V_m_s, 1, 1, ...
        [-0.5,0.5,-0.5,0.5], false, 3, true, 'normalized', 1.5);
    fprintf('U缺失值比例: %f\nV缺失值比例：%f\n', sum(isnan(U_cal))/length(U_cal), sum(isnan(V_cal))/length(V_cal));
    
    nan_percent(j, :) = [sum(isnan(U_cal))/length(U_cal), sum(isnan(V_cal))/length(V_cal)];

end

%% 
clc
clear

output_folder = '../Fig/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 读取txt文件
filename = '../Raw/60_1500us/Export.80mhz4rl.000000-0.0000.txt';
% 读取数据
[X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename);

% 检查异常值，平滑数据
img_size_x = sum(Y==0);
img_size_y = Y(end) + 1;
[U_cal, V_cal] = post_check_abnormal([img_size_x, img_size_y],U_m_s, V_m_s, 1, 1, ...
    [-0.5,0.5,-0.5,0.5], false, 3, true, 'normalized', 1.5);

nan_indices = isnan(U_cal) | isnan(V_cal);

figure;
scatter(U_m_s, V_m_s, 5, 'filled', 'MarkerFaceColor', [120/255, 143/255, 208/255]);
hold on
% scatter(U_cal, V_cal, 5, 'filled', 'MarkerFaceColor', [250/255, 192/255, 15/255]);
scatter(U_m_s(nan_indices), V_m_s(nan_indices),  5, 'filled', 'MarkerFaceColor', [250/255, 192/255, 15/255]); % 绘制NaN点

ax = gca;
ax.Box = 'on';
ax.LineWidth = 1.2; % 设置边框线宽度
ax.GridLineStyle = '--'; % 设置网格线为虚线
ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
% title("\text{60% -1500 $\mu$s 剔除的速度场坏矢量}", 'FontSize', 12, 'Interpreter', 'latex');
xlabel('U (m/s)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('V (m/s)', 'FontSize', 12, 'FontName', 'Times New Roman');
legend("原始数据", "剔除数据" , 'FontName', '宋体')
grid on;

saveas(gcf, fullfile(output_folder, "fig_nan_illustration.png"));


