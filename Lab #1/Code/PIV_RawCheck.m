clc;
clear;

% 读取txt文件

raw_folder = '../Orig/';
subfolders = dir(raw_folder);

% 过滤掉 . 和 .. 以及非文件夹项
subfolder_names = {subfolders([subfolders.isdir]).name};
subfolder_names = subfolder_names(~ismember(subfolder_names, {'.', '..'}));
subfolder_names = string(subfolder_names);

output_folder = '../Fig/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 遍历每个子文件夹
for i = 1:length(subfolder_names)
    subfolder_path = fullfile(raw_folder, subfolder_names(i));
    txt_files = dir(fullfile(subfolder_path, '*.txt'));
    
    figure;


    % 遍历每个txt文件
    for j = 1:length(txt_files)
        filename = fullfile(subfolder_path, txt_files(j).name);
        
        % 读取数据
        [X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename);
        
        % 处理数据（这里以绘制散点图为例）
        scatter(U_m_s, V_m_s, 1, 'filled', 'MarkerFaceColor', [120/255, 143/255, 208/255]);
        hold on;
    end
    ax = gca;
    ax.Box = 'on';
    ax.LineWidth = 1.2; % 设置边框线宽度
    ax.GridLineStyle = '--'; % 设置网格线为虚线
    ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
    title("U-V Plot - " + subfolder_names(i), 'FontSize', 12, 'Interpreter', 'none', 'FontName', 'Times New Roman');
    xlabel('U (m/s)', 'FontSize', 12, 'FontName', 'Times New Roman');
    ylabel('V (m/s)', 'FontSize', 12, 'FontName', 'Times New Roman');
    grid on;
    hold off;

    saveas(gcf, fullfile(output_folder, "fig_raw_" + subfolder_names(i) + ".png"));
end
