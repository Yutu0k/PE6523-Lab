% 数据读取
function [X, Y, X_pix, Y_pix, X_mm, Y_mm, U_m_s, V_m_s] = post_read_data(filename)
	data = readmatrix(filename);
	X = data(:, 1);
	Y = data(:, 2);
	X_pix = data(:, 3);
	Y_pix = data(:, 4);
	X_mm = data(:, 5);
	Y_mm = data(:, 6);
	U_m_s = data(:, 9);
	V_m_s = data(:, 10);
end