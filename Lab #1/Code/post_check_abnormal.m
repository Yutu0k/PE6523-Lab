% 异常值剔除
function [u_out,v_out] = post_check_abnormal(img_size, u,v,calu,calv, valid_vel, do_stdev_check, stdthresh, do_local_median, method, neigh_thresh)
	%% velocity limits
	if numel(valid_vel)>0 	%velocity limits were activated
		umin=valid_vel(1);
		umax=valid_vel(2);
		vmin=valid_vel(3);
		vmax=valid_vel(4);
		u(u*calu<umin)=NaN;
		u(u*calu>umax)=NaN;
		v(u*calu<umin)=NaN;
		v(u*calu>umax)=NaN;
		v(v*calv<vmin)=NaN;
		v(v*calv>vmax)=NaN;
		u(v*calv<vmin)=NaN;
		u(v*calv>vmax)=NaN;
	end

    %% median check
    if do_local_median==1
        switch lower(method)
            case 'local'
                % Local Median Test
                % X direction Filtering
                neigh_filt=medfilt2(u,[3,3],'symmetric');
                try
                    neigh_filt=misc.inpaint_nans(neigh_filt);
                catch
                    neigh_filt=NaN(size(neigh_filt));
                end
                neigh_filt=abs(neigh_filt-u);
                u(neigh_filt>neigh_thresh)=nan;

                % Y direction Filtering
                neigh_filt=medfilt2(v,[3,3],'symmetric');
                try
                    neigh_filt=misc.inpaint_nans(neigh_filt);
                catch
                    neigh_filt=NaN(size(neigh_filt));
                end
                neigh_filt=abs(neigh_filt-v);
                v(neigh_filt>neigh_thresh)=nan;

            case 'normalized'
                % Normalized Median Test
                img_size_x = img_size(1);
                img_size_y = img_size(2);
                u = reshape(u, img_size_x, img_size_y)';
				v = reshape(v, img_size_x, img_size_y)';

                % X direction Filtering
                med_u = medfilt2(u,[3,3],'symmetric');
                try
                    med_u = misc.inpaint_nans(med_u);
                catch
                    med_u = NaN(size(med_u));
                end
                
                % 计算局部标准差
                std_u = zeros(size(u));
                for i = 2:size(u,1)-1
                    for j = 2:size(u,2)-1
                        window = u(i-1:i+1, j-1:j+1);
                        std_u(i,j) = std(window(:), 'omitnan');
                    end
                end
                
                % 标准化差值
                norm_diff_u = abs(med_u - u) ./ (std_u + eps);
                u(norm_diff_u > neigh_thresh) = nan;

                % Y direction Filtering
                med_v = medfilt2(v,[3,3],'symmetric');
                try
                    med_v = misc.inpaint_nans(med_v);
                catch
                    med_v = NaN(size(med_v));
                end
                
                % 计算局部标准差
                std_v = zeros(size(v));
                for i = 2:size(v,1)-1
                    for j = 2:size(v,2)-1
                        window = v(i-1:i+1, j-1:j+1);
                        std_v(i,j) = std(window(:), 'omitnan');
                    end
                end
                
                % 标准化差值
                norm_diff_v = abs(med_v - v) ./ (std_v + eps);
                v(norm_diff_v > neigh_thresh) = nan;

                % Reshape into original shape
                u = reshape(u', img_size_x*img_size_y, 1);
                v = reshape(v', img_size_x*img_size_y, 1);
        end
    end

	%% stddev check
	if do_stdev_check==1
		meanu=mean(u(:),'omitnan');
		meanv=mean(v(:),'omitnan');
		std2u=std(reshape(u,size(u,1)*size(u,2),1),'omitnan');
		std2v=std(reshape(v,size(v,1)*size(v,2),1),'omitnan');
		minvalu=meanu-stdthresh*std2u;
		maxvalu=meanu+stdthresh*std2u;
		minvalv=meanv-stdthresh*std2v;
		maxvalv=meanv+stdthresh*std2v;
		u(u<minvalu)=NaN;
		u(u>maxvalu)=NaN;
		v(v<minvalv)=NaN;
		v(v>maxvalv)=NaN;
	end

	u(isnan(v))=NaN;
	v(isnan(u))=NaN;
	u_out=u;
	v_out=v;

end