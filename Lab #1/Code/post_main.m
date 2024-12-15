function post_main(filepath, foldername, workingDir, timestamp)
	[X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filepath);

	% 检查异常值，平滑数据
	img_size_x = sum(Y==0);
	img_size_y = Y(end) + 1;

	[U_cal, V_cal] = post_check_abnormal([img_size_x, img_size_y],U_m_s, V_m_s, 1, 1, ...
		[-0.5,0.5,-0.5,0.5], true, 3, true, 'normalized', 1.8);

	% Kriging数据插值
	[U_interp, V_interp] = post_interp([img_size_x, img_size_y], X, Y, U_cal, V_cal, 'scatteredInterpolant');

	post_export_data(X, Y, X_pix, Y_pix, X_mm, Y_mm, U_interp, V_interp, timestamp, [workingDir, '/', foldername]);

end