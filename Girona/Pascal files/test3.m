%% Author: Mohit Vaishnav and Malav Bateriwala
%% SSI Course: Image Classification
%%
%clearing the workspace
clc
clear
close all

%% Change the folder name to the place where the output has to be saved
foldername = 'output\SVM\';
para = 'NR\L1QPPoly10';

%% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;
trainset = {};
valset = {};
imgSets_val = [];
imgSet_train =[];
imgSets_test =[];
iter = 8;

%% train and test classifier for each class
for i=1:VOCopts.nclasses
    cls=VOCopts.classes{i};
    
%% load 'train' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'train'),'%s %d');

%% Defining Training Set
trainingset_tmp = [];
% extract features for each image
    for j=1:length(ids)
        if classifier.gt(j) == 1
        % Load Images
            trainingset_tmp = [trainingset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
        end
    end
    
    % Creating image set from it.
    imgSet_train = [imgSet_train, imageSet(trainingset_tmp)];
    imgSet_train(1,i).Description = char(cls);
    
        
%% load 'validation' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'val'),'%s %d');

% Create a temp variable to store each class output which are to be 
... appended to form a bag.
valset_tmp = [];
% extract features for each image
    for j=1:length(ids)
        if classifier.gt(j) == 1
        % Load Images
%             trainingset_tmp = [trainingset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
            valset_tmp = [valset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
       end
    end
    
%   % Creating image set from it.
    imgSets_val = [imgSets_val, imageSet(valset_tmp)];
    imgSets_val(1,i).Description = char(cls);
    
%% load 'test' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'test'),'%s %d');

% Create a temp variable to store each class output which are to be 
... appended to form a bag.
testset_tmp = [];
% extract features for each image
    for j=1:length(ids)
        if classifier.gt(j) == 1
        % Load Images
            testset_tmp = [testset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
        end
    end
    
    % Creating image set from it.
    imgSets_test = [imgSets_test, imageSet(testset_tmp)]; %change this
    imgSets_test(1,i).Description = char(cls);

    
end

%% Dividing the imageset in different partition.
    trainingSets = imgSet_train;
    validationSets = imgSets_val;
    testSets = imgSets_test;
    t_Set = [trainingSets.Count] % show the count of training images
    v_Set = [validationSets.Count] % show the count of validation images
    test_Set = [testSets.Count] % show the count of test images

%% Show examples of images.
    for i=1:VOCopts.nclasses
    I = read(trainingSets(i),1);
    subplot(5,2,i), imshow(I); title(VOCopts.classes{i})
    end
    drawnow;
    
%% Starts the time taken to build the features
    tic;
    bag = bagOfFeatures(trainingSets, ...
            'VocabularySize', 500, ... 500 (default) | integer scalar
            'StrongestFeatures', 0.8, ... 0.8 (default) | [0,1]
            'Verbose', true, ...
            'PointSelection', 'Grid', ... % 'Grid' (default) | 'Detector'
            'GridStep', [8 8], ... % [8 8] (default) | 1-by-2 [x y] vector
            'BlockWidth', [32 64 96 128], ... % [32 64 96 128] (default) | 1-by-N vector
            'Upright', true ... % true (default) | logical scalar
            );
      tim =   toc;
      
%% Training the classifier with SVM using Polunomial Kernel
      c = cvpartition(t_Set,'KFold'); % to create Cross validation partition using KFold
    mySVM = templateSVM('KernelFunction','polynomial','PolynomialOrder',10,...
            'KernelScale','auto','Standardize',true, 'Solver','L1QP','RemoveDuplicates',true...
            );
        %'CVPartition',c,'Holdout',0.3,'OptimizeHyperparameters','auto','OutlierFraction',0.001
    
        % To use the defined SVM template
        categoryClassifier = trainImageCategoryClassifier(trainingSets, bag, 'LearnerOptions', mySVM);
    figure;
    
    % Define the inbuild SVM classifier
    %categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);
    
%% Evaluate the Validation Set
    [confMatrix1,knownLabelIdx,predictedLabelIdx,score] = evaluate(categoryClassifier, validationSets);
    for i = 1: 10
        [X,Y,T,AUC] = perfcurve((knownLabelIdx==predictedLabelIdx),score(:,i),'true');
        h = plot(X,Y)
        xlabel('False positive rate') 
        ylabel('True positive rate')
        title(strcat(VOCopts.classes{i},'__AUC__',string(AUC)))
        fignamebar = strcat(foldername,para,'Val_',VOCopts.classes{i},'.jpg');
        drawnow;
        saveas(h,fignamebar,'jpg')
    end
    % Compute average accuracy
    a = mean(diag(confMatrix1));
    resultfile = strcat(para,'Result','.txt');
    
    % To save the result file with  variables like confusion matrix,
    ... partitioned sections, mean accuracy and time taken in ascii format.
    
    save(resultfile, 'confMatrix1','t_Set','v_Set', 'a', 'tim', '-ascii')
    
%% Evaluate the Test Set

    [confMatrix2,knownLabelIdx,predictedLabelIdx,score] = evaluate(categoryClassifier,testSets);
    % Compute average accuracy
    b = mean(diag(confMatrix2));
    for i = 1: 10
        [X,Y,T,AUC] = perfcurve((knownLabelIdx==predictedLabelIdx),score(:,i),'true');
        h = plot(X,Y)
        xlabel('False positive rate') 
        ylabel('True positive rate')
        title(strcat(VOCopts.classes{i},'__AUC__',string(AUC)))
        fignamebar = strcat(foldername,para,'_Test_',VOCopts.classes{i},'.jpg');
        drawnow;
        saveas(h,fignamebar,'jpg')
    end

    resultfile2 = strcat(para,'Result_Test','.txt');
%% To save the result file with  variables like confusion matrix,
... partitioned sections, mean accuracy and time taken in ascii format.
    save(resultfile2, 'confMatrix2','test_Set', 'b', '-ascii')
