function post_export_data(X, Y, X_pix, Y_pix, X_mm, Y_mm, U, V, timestamp, filepath)
	% Export data to txt file
	file_name = [filepath, '_', timestamp, '.txt'];
	fid = fopen(file_name, 'w');
	fprintf(fid, 'Timestamp: %s\n', timestamp);
	fprintf(fid, 'X\tY\tX_pix\tY_pix\tX_mm\tY_mm\tU_m_s\tV_m_s\n');
	for i = 1:length(X)
		fprintf(fid, '%d\t%d\t%.1f\t%.1f\t%.17f\t%.17f\t%.17f\t%.17f\n', X(i), Y(i), X_pix(i), Y_pix(i), X_mm(i), Y_mm(i), U(i), V(i));
	end
	fclose(fid);

end

