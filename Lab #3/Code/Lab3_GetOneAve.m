% 获得一个工况（文件夹）下每张图片的Intensity值
% 
% Input: parentFolder: 父文件夹路径，e.g. ./Raw/20/
% 
% Output: Intensity: 平均强度值，imageIntensity: 每张图片的强度值，imageStack: 图像堆栈

function [Intensity, imageIntensity, imageStack] = Lab3_GetOneAve(parentFolder, varargin)

	% Parse the Input
	p = inputParser;
	addParameter(p, 'showfigure', false, @islogical);
	parse(p, varargin{:});
	showfigure = p.Results.showfigure;

	% 获取所有子文件夹的信息
	subFolders = dir(parentFolder);
	subFolders = subFolders([subFolders.isdir]); % 仅保留文件夹
	
	% 初始化图像堆栈
	imageStack = [];
	imageIntensity = [];
	
	% 遍历所有子文件夹
	for i = 1:length(subFolders)
		if strcmp(subFolders(i).name, '.') || strcmp(subFolders(i).name, '..')
			continue;
		end
		
		% 文件夹下还有一个子文件夹
		subFolderPath = fullfile(parentFolder, subFolders(i).name);
		tifFiles = dir(fullfile(subFolderPath, '*.tif'));
		
		% 读取所有tif文件
		for k = 1:length(tifFiles)
			filePath = fullfile(tifFiles(k).folder, tifFiles(k).name);
			
			img = imread(filePath);
			
			ThresLevel = graythresh(img);  %求取二值化的阈值
			Mapping = imbinarize(img, ThresLevel);   %按阈值进行二值化
	
			% 将 Mapping 转换为双精度类型
			filteredImg = uint16(double(Mapping) .* double(img));
			
			% 将过滤后的图像添加到堆栈中
			imageStack = cat(3, imageStack, filteredImg);
			imageIntensity = cat(1, imageIntensity, mean(filteredImg, 'all'));
		end
	end
	
	denoisedImage = mean(imageStack, 3);
	Intensity = mean(denoisedImage, 'all');
	fprintf('平均强度值为：%f\n', Intensity);

	if showfigure
		figure;
		imshow(denoisedImage, []);
		title('Denoised Image');
	end

end