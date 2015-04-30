
%Final run script for Matlab
%Run this script with the train and test scripts in the database directory
%of the pyramid outputs. i.e copy this file to the database directory and
%run it from there, this allows you to do any number of runs from multiple
%databases without specifying the folder for each case


%% Training labels for the datases 15*100
train_labels(1:1500)=double(0);
for i = 1:1:15
    train_labels(100*(i-1)+1:100*i)=i;
end

train_labels=train_labels';


%% Setting the labels up for testing - This is rest of the images

test_labels(1:116)=1; %bedroom
test_labels(117:257)=2;%cal suburb
test_labels(258:468)=3;%industrial
test_labels(469:578)=4; %kitchen
test_labels(579:767)=5; %livingroom
test_labels(768:1027)=6; %mitcoast
test_labels(1028:1255)=7; %mmitforest
test_labels(1256:1415)=8; %mithighway
test_labels(1416:1623)=9; %mitcity
test_labels(1624:1897)=10; %mitmountain
test_labels(1898:2207)=11; %mitopencountry
test_labels(2208:2399)=12; %mitstreet
test_labels(2400:2655)=13; %mit tall
test_labels(2656:2770)=14; %office
test_labels(2771:2985)=15; %store

test_labels=test_labels';



%% Shell scripts and pyramid data analysis

%Shell script commands which will move around the data image pyramid
%descriptors for easy processing into buckets.

%If you can't do that, you could alternately copy paste the code from the
%individual files into this script to deploy directly from here.

fprintf('Isolating the training data...\n');
! sh train.sh 
%! sh move.sh
fprintf('Isolating the testing data...\n');
! sh test.sh

% The files above are self explanatory from their contents


%%
%Load the training data into the workspace as a data structure to be used
%to input into the SVM classifier operated via LIBLINEAR
fprintf('Loading training data into classifier...Please be patient :) \n');
cd train
files = dir('*.mat');
for i=1:length(files)
    train_data(i)=load(files(i).name);
end

train_data=train_data';
%keyboard;
%train_data=rmfield(train_data,'label');



temp=struct2cell(train_data);

temp=cell2mat(temp);
temp=temp';
final_train_data=sparse(temp);

% temp=temp';
% final_train_data=sparse(cell2mat(temp)); - had to comment it out and use
% alternative code due a bug in elucidating the cell2mat command.

%train_data=double(sparse(struct2array(train_data)));
%train_data=double(sparse(train_data));
%train_data=sparse(train_data);
%train_data=double(train_data);
cd ..


%%
%Load the testing data into the workspace as a data structure to be used
%to input into the SVM classifier operated via LIBLINEAR
fprintf('Laoding the testing data into the classifier... Please be patient :)\n');
cd test
files = dir('*.mat');
for i=1:length(files)
    test_data(i)=load(files(i).name);
end

test_data=test_data';
%keyboard;
%test_data=rmfield(test_data,'label');
temp=struct2cell(test_data);
%temp=temp';

temp=cell2mat(temp);
temp=temp';
final_test_data=sparse(temp);

%test_data=double(sparse(struct2array(test_data)));
%test_data=double(sparse(test_data));
%test_data=sparse(test_data);
%test_data=double(test_data);
cd ..

%keyboard;
%% The core of the SVM phase-desceding into the matlab liblinear realm
cd ../liblinear-1.96/matlab/.

fprintf('Classifying...\n');

% Train the classifier
model=train(train_labels,final_train_data);

fprintf('Testing...\n');
%keyboard;
% Test of the classifier
[pred_label,accu,dec_val]=predict(test_labels,final_test_data,model);


fprintf('Generating the confusion matrix...\n');
%Generation of the confusion matrix using Matlab's inbuilt command.
[c,order]=confusionmat(pred_label,test_labels);
X = sprintf('\n \n ***The confusion matrix ladies and gentlemen! *** \n \n');
disp(X)
confusion_matrix=bsxfun(@rdivide,c,sum(c)) %Normalised % Some vodoo

%%The End %%

