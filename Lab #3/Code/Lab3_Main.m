%% Retract Data
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
singleIntensity = [];

% 遍历所有温度
for i = 1:length(subFolders)
	% 跳过 . 和 .. 文件夹
	if strcmp(subFolders(i).name, '.') || strcmp(subFolders(i).name, '..')
		continue;
	end

	Temp_in_Celsius = [Temp_in_Celsius, str2double(subFolders(i).name)];
	[I, imageI, ~] = Lab3_GetOneAve(fullfile(parentFolder, subFolders(i).name), 'showfigure', false);

	Intensity = [Intensity, I];
	singleIntensity = [singleIntensity, imageI];
end

%% Fitting, Use 20 Celsius as the reference temperature
Temp_in_Kelvin = Temp_in_Celsius + 273.15;
Intensity_Rel = Intensity(1) ./ Intensity ;
Temp_in_Kelvin_Rel = Temp_in_Kelvin / Temp_in_Kelvin(1);
% 利用Stern-Volmer方程进行拟合
ft = fittype('A*x^B+C');
[curve, gof] = fit(Temp_in_Kelvin_Rel', Intensity_Rel', ft, 'StartPoint', [0,17,0]); % 进行拟合
params = [curve.A, curve.B, curve.C];
x_fit = linspace(min(Temp_in_Kelvin_Rel), max(Temp_in_Kelvin_Rel), 100);
fittedIntensity = params(1) * x_fit .^ params(2) + params(3);


%% Plot the relation
figure('Position', [100, 100, 800, 600]); % 指定figure大小，宽800，高600
plot(x_fit, fittedIntensity, '-', 'LineWidth', 2, 'Color', [250/255, 192/255, 15/255], 'DisplayName', 'Regression');
hold on
scatter(Temp_in_Kelvin_Rel, Intensity_Rel, 50, 'filled', 'MarkerFaceColor', [1/255, 86/255, 153/255], 'DisplayName', 'Data Point');
hold off
legend('show', 'FontSize', 14, 'FontName', 'Times New Roman', 'Location', 'southeast');
xlim([1,1.112])

equationText = sprintf('$\\frac{I_{ref}}{I} = %.2f (\\frac{T}{T_{ref}})^{%.2f} + %.2f$\n$R^2 = %.4f$', params(1), params(2), params(3), gof.rsquare);
% textPositionX = max(Temp_in_Celsius) + 0.125 * range(Temp_in_Celsius);
% textPositionY = max(fittedIntensity) - 0.22 * range(fittedIntensity);
text(1.109, 1.3, equationText, 'FontSize', 14, 'FontName', 'Times New Roman', 'Interpreter', 'latex', 'HorizontalAlignment', 'right');


ax = gca;
ax.Box = 'on';
ax.LineWidth = 1.2; % 设置边框线宽度
ax.GridLineStyle = '--'; % 设置网格线为虚线
ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
title("TSP Temperature - Intensity", 'FontSize', 12, 'Interpreter', 'none', 'FontName', 'Times New Roman');
xlabel('$T/T_{ref}$', 'FontSize', 12, 'FontName', 'Times New Roman', 'interpreter', 'latex');
ylabel('$I_{ref}/I$', 'FontSize', 12, 'FontName', 'Times New Roman', 'interpreter', 'latex');
grid on;
hold off;

saveas(gcf, fullfile(output_folder, 'TSP_Temperature_Intensity_Relation.png'));


%% Plot including the errorbar
singleIntensity_Rel = Intensity(1) ./ singleIntensity;
error = std(singleIntensity_Rel, 0, 1);

figure('Position', [100, 100, 800, 600]); % 指定figure大小，宽800，高600
plot(x_fit, fittedIntensity, '-', 'LineWidth', 2, 'Color', [250/255, 192/255, 15/255], 'DisplayName', 'Regression');
hold on

errorbar(Temp_in_Kelvin_Rel, Intensity_Rel, error, 'o', 'MarkerFaceColor', [1/255, 86/255, 153/255], 'MarkerEdgeColor', 'none', 'Color', [1/255, 86/255, 153/255], 'DisplayName', 'Data Point with Error');

hold off
legend('show', 'FontSize', 14, 'FontName', 'Times New Roman', 'Location', 'southeast');
xlim([1,1.112])
ylim([0.95, 2.6])

ax = gca;
ax.Box = 'on';
ax.LineWidth = 1.2; % 设置边框线宽度
ax.GridLineStyle = '--'; % 设置网格线为虚线
ax.FontName = 'Times New Roman'; % 设置坐标轴数字字体为 Times New Roman
title("TSP Temperature - Intensity", 'FontSize', 12, 'Interpreter', 'none', 'FontName', 'Times New Roman');
xlabel('$T/T_{ref}$', 'FontSize', 12, 'FontName', 'Times New Roman', 'interpreter', 'latex');
ylabel('$I_{ref}/I$', 'FontSize', 12, 'FontName', 'Times New Roman', 'interpreter', 'latex');
grid on;
hold off;

saveas(gcf, fullfile(output_folder, 'TSP_Temperature_Intensity_Relation_Errorbar.png'));