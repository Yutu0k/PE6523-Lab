function [u_cal, v_cal] = post_interp(img_size, X, Y, u, v, method)

	img_size_x = img_size(1);
	img_size_y = img_size(2);


    switch(lower(method))
		case 'griddata'
			% 使用griddata进行样条插值填补NaN值
			U_cal_filled = reshape(u, img_size_x, img_size_y)';
			V_cal_filled = reshape(v, img_size_x, img_size_y)';
		
			nan_indices_u = isnan(u);
			nan_indices_v = isnan(v);
		
			U_cal_filled(nan_indices_u) = griddata(X(~nan_indices_u), Y(~nan_indices_u), u(~nan_indices_u), X(nan_indices_u), Y(nan_indices_u), 'natural');
			V_cal_filled(nan_indices_v) = griddata(X(~nan_indices_v), Y(~nan_indices_v), v(~nan_indices_v), X(nan_indices_v), Y(nan_indices_v), 'natural');


		case 'scatteredinterpolant'
			[xq, yq] = meshgrid(0:1:img_size_x-1, 0:1:img_size_y-1);

			nan_indices_u = isnan(u);
			nan_indices_v = isnan(v);

			F_U = scatteredInterpolant(X(~nan_indices_u), Y(~nan_indices_u), u(~nan_indices_u), 'natural', 'linear');
			U_cal_filled = F_U(xq,yq);

			F_V = scatteredInterpolant(X(~nan_indices_v), Y(~nan_indices_v), v(~nan_indices_v), 'natural', 'linear');
			V_cal_filled = F_V(xq,yq);


    end

	u_cal = reshape(U_cal_filled', img_size_x*img_size_y, 1);
	v_cal = reshape(V_cal_filled', img_size_x*img_size_y, 1);
end