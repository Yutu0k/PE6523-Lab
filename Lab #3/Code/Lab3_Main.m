clear; clc;

% 获取上一级文件夹的路径
parentFolder = fullfile('..', 'Raw');
subFolders = dir(parentFolder);
subFolders = subFolders([subFolders.isdir]); % 仅保留文件夹
output_folder = '../Fig/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 初始化数据
Temp_in_Celsius = [];
Intensity = [];

% 遍历所有温度
for i = 1:length(subFolders)
	% 跳过 . 和 .. 文件夹
	if strcmp(subFolders(i).name, '.') || strcmp(subFolders(i).name, '..')
		continue;
	end

	Temp_in_Celsius = [Temp_in_Celsius; str2double(subFolders(i).name)];
	Intensity = [Intensity; Lab3_GetOneAve(fullfile(parentFolder, subFolders(i).name))];
end

%% Plot

% 进行线性回归
[p, S] = polyfit(Temp_in_Celsius, Intensity, 1);
temp = 15:1:55;
fittedIntensity = polyval(p, temp);

% 绘制结果
figure;
plot(temp, fittedIntensity, '-', 'LineWidth', 2, 'Color', [250/255, 192/255, 15/255], 'DisplayName', 'Regression');
hold on
scatter(Temp_in_Celsius, Intensity, 30, 'filled', 'MarkerFaceColor', [1/255, 86/255, 153/255], 'DisplayName', 'Data Point');
hold off
legend('show', 'FontSize', 12, 'FontName', 'Times New Roman');
% xlim([15,55]);


% 显示线性回归方程
equationText = sprintf('$I = %.2f T + %.2f$\n$R^2 = %.4f$', p(1), p(2), S.rsquared);
textPositionX = max(Temp_in_Celsius) + 0.125 * range(Temp_in_Celsius);
textPositionY = max(fittedIntensity) - 0.22 * range(fittedIntensity);
text(textPositionX, textPositionY, equationText, 'FontSize', 12, 'FontName', 'Times New Roman', 'Interpreter', 'latex', 'HorizontalAlignment', 'right');


ax = gca;
ax.Box = 'on';
ax.LineWidth = 1.2; % 设置边框线宽度
ax.GridLineStyle = '--'; % 设置网格线为虚线
ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
title("PSP Temperature - Intensity", 'FontSize', 12, 'Interpreter', 'none', 'FontName', 'Times New Roman');
xlabel('Temperature(°C)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('Intensity(Relative)', 'FontSize', 12, 'FontName', 'Times New Roman');
grid on;
hold off;

saveas(gcf, fullfile(output_folder, 'PSP_Temperature_Intensity.png'));

