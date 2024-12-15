import os
import re
import matlab.engine

def extract_timestamp(filename):
	match = re.search(r'Export\.\w+\.\d+-([\d.]+)', filename)
	if match:
		return match.group(1)
	return None

def main():
	eng = matlab.engine.connect_matlab()

	root_dir = '../Raw/'
	for count, (subdir, _, files) in enumerate(os.walk(root_dir)):
		foldername = os.path.basename(subdir)
		u_array = []
		v_array = []
		for file in files:
			if file.endswith('.txt'):
				filepath = os.path.join(subdir, file)
				timestamp = extract_timestamp(file)
				if timestamp:
					ret0, ret1 = eng.post_peak_lock(filepath, foldername, root_dir, timestamp, nargout = 2)
					
					u_array.append(ret0)
					v_array.append(ret1)
					# eng.scatter(matlab.double(ret0), matlab.double(ret1),1,'blue')
		if len(files) == 0:
			continue

		eng.eval(f"figure({count+1})",nargout=0)
		eng.title("u histogram", nargout=0)
		u_array_mat = matlab.double(u_array)
		print(len(u_array), len(u_array[0]))
		u_array_mat.reshape((len(u_array)*len(u_array[0]),1))
		eng.histogram(u_array_mat, 100, 'FaceColor', 'blue', 'EdgeColor', 'none')


	input("按回车键继续...")


if __name__ == "__main__":
	main()