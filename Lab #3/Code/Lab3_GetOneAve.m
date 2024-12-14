function Intensity = Lab3_GetOneAve(parentFolder)

	% 获取所有子文件夹的信息
	subFolders = dir(parentFolder);
	subFolders = subFolders([subFolders.isdir]); % 仅保留文件夹
	
	
	% 初始化图像堆栈
	imageStack = [];
	
	% 遍历所有子文件夹
	for i = 1:length(subFolders)
		% 跳过 . 和 .. 文件夹
		if strcmp(subFolders(i).name, '.') || strcmp(subFolders(i).name, '..')
			continue;
		end
		
		% 获取子文件夹的路径
		subFolderPath = fullfile(parentFolder, subFolders(i).name);
		
		% 获取子文件夹中的所有tif文件的信息
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
		end
	end
	
	denoisedImage = mean(imageStack, 3);
	% figure;
	% imshow(denoisedImage, []);
	% title('降噪后的图像');
	
	Intensity = mean(denoisedImage, 'all');
	fprintf('平均强度值为：%f\n', Intensity);

end