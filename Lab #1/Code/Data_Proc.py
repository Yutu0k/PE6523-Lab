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
	for subdir, _, files in os.walk(root_dir):
		foldername = os.path.basename(subdir)
		for file in files:
			if file.endswith('.txt'):
				filepath = os.path.join(subdir, file)
				print(subdir)
				timestamp = extract_timestamp(file)
				if timestamp:
					eng.post_main(filepath, foldername, root_dir, timestamp, nargout=0)

if __name__ == "__main__":
    main()