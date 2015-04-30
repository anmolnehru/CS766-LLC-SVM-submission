% Example of how to use the BuildPyramid function
% set image_dir and data_dir to your actual directories
image_dir = 'images/im'; 
data_dir = 'data_VQ/im';

% for other parameters, see BuildPyramid

fnames = dir(fullfile(image_dir, '*.jpg'));
num_files = size(fnames,1);
filenames = cell(num_files,1);

for f = 1:num_files
	filenames{f} = fnames(f).name;
end

% return pyramid descriptors for all files in filenames
pyramid_all = BuildPyramid(filenames,image_dir,data_dir);

% compute histogram intersection kernel
K = hist_isect(pyramid_all, pyramid_all); 


