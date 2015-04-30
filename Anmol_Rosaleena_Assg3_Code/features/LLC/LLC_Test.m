clear all; close all; clc;

% -------------------------------------------------------------------------
% parameter setting
pyramid = [1, 2];                % spatial block structure for the SPM
knn = 8;                            % number of neighbors for local coding

nRounds = 10;                       % number of random test on the dataset
tr_num  = 30;                       % training examples per category
mem_block = 3000;                   % maxmum number of testing features loaded each time  


% -------------------------------------------------------------------------

img_dir = 'image';       % directory for the image database                             
data_dir = 'data_LLC';       % directory for saving SIFT descriptors
fea_dir = 'features_LLC';    % directory for saving final image features

% -------------------------------------------------------------------------
% extract SIFT descriptors, we use Prof. Lazebnik's matlab codes in this package
% change the parameters for SIFT extraction inside function 'extr_sift'
LLC_extr_sift(img_dir, data_dir);

% -------------------------------------------------------------------------
% retrieve the directory of the database and load the codebook
database = LLC_retr_database_dir(data_dir);

if isempty(database),
    error('Data directory error!');
end

Bpath = ['dictionary_LLC/dictionary_2048.mat'];

load(Bpath);
nCodebook = size(dictionary', 2);              % size of the codebook

% -------------------------------------------------------------------------
% extract image features

dFea = sum(nCodebook*pyramid.^2);
nFea = length(database.path);

fdatabase = struct;
fdatabase.path = cell(nFea, 1);         % path for each image feature
fdatabase.label = zeros(nFea, 1);       % class label for each image feature

for iter1 = 1:nFea,  

    fpath = database.path{iter1};
    flabel = database.label(iter1);
    
    load(fpath);
    [rtpath, fname] = fileparts(fpath);
    feaPath = fullfile(fea_dir, num2str(flabel), [fname '.mat']);
    
 
    fea = LLC_pooling(feaSet, dictionary', pyramid, knn);
    label = database.label(iter1);

    if ~isdir(fullfile(fea_dir, num2str(flabel))),
        mkdir(fullfile(fea_dir, num2str(flabel)));
    end      
    save(feaPath, 'fea');

    
    fdatabase.label(iter1) = flabel;
    fdatabase.path{iter1} = feaPath;
end;

