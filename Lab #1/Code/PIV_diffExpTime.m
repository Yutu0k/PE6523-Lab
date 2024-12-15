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

output_folder = '../Fig/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

colors = [
    0/255, 86/255, 150/255;
    80/255, 198/255, 200/255;
    78/255, 89/255, 108/255;
    253/255, 191/255, 54/255;
    249/255, 118/255, 82/255;
    225/255, 32/255, 26/255;
];

% 遍历每个子文件夹
for i = 7:length(subfolder_names)
    subfolder_path = fullfile(raw_folder, subfolder_names(i));
    txt_files = dir(fullfile(subfolder_path, '*.txt'));
    U = [];V = [];
    
    % 创建两个图形窗口
    figure(1);
    hold on;
    % title("U Histogram - " + subfolder_names(i), 'FontSize', 12, 'Interpreter', 'none', 'FontName', 'Times New Roman');
    xlabel('U (m/s)', 'FontSize', 12, 'FontName', 'Times New Roman');
    ylabel('Frequency', 'FontSize', 12, 'FontName', 'Times New Roman');
    grid on;
    
    figure(2);
    hold on;
    % title("V Histogram - " + subfolder_names(i), 'FontSize', 12, 'Interpreter', 'none', 'FontName', 'Times New Roman');
    xlabel('V (m/s)', 'FontSize', 12, 'FontName', 'Times New Roman');
    ylabel('Frequency', 'FontSize', 12, 'FontName', 'Times New Roman');
    grid on;
    
    % 遍历每个txt文件
    for j = 1:length(txt_files)
        filename = fullfile(subfolder_path, txt_files(j).name);
        
        % 读取数据
        [X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename);
        
        % 绘制U_m_s的直方图
        % histogram(U_m_s, 'FaceColor', [120/255, 143/255, 208/255]);
        
        % 绘制V_m_s的直方图
        % histogram(V_m_s, 'FaceColor', [250/255, 192/255, 15/255]);
        U = [U;U_m_s];
        V = [V;V_m_s];
    end
    
    % 设置图形属性
    figure(1);
    hold on;
    histogram(U, 'FaceColor', colors(i-6,:), 'EdgeColor', 'none');
    ax = gca;
    ax.Box = 'on';
    ax.LineWidth = 1.2; % 设置边框线宽度
    ax.GridLineStyle = '--'; % 设置网格线为虚线
    ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
    legend_entries_U{i-6} = "\fontname{宋体}曝光时间\fontname{Times New Roman}: " + extractAfter(subfolder_names(i), 3);
    
    
    figure(2);
    hold on;
    histogram(V, 'FaceColor', colors((i-6)+3,:), 'EdgeColor', 'none');
    ax = gca;
    ax.Box = 'on';
    ax.LineWidth = 1.2; % 设置边框线宽度
    ax.GridLineStyle = '--'; % 设置网格线为虚线
    ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
    legend_entries_V{i-6} = "\fontname{宋体}曝光时间\fontname{Times New Roman}: " + extractAfter(subfolder_names(i), 3);
    
end

figure(1);
legend(legend_entries_U);
saveas(gcf, fullfile(output_folder, "fig_U_histogram.png"));
figure(2);
legend(legend_entries_V);
saveas(gcf, fullfile(output_folder, "fig_V_histogram.png"));