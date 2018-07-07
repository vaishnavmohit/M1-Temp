clc
clear
close all

%% Change the folder name to the place where the output has to be saved
foldername = 'output\';

%% For naming the file in the folder, it should be referenced to the proper 
... parameter whose value is altered 
paraname = 'strongfeature';

%% Loop for changing the parameter for various  variables in bagoffeatures 
... function its end is on line no 143, 
    ...this is currently enabled at strongest feature
%for iter = 6:.5:9.5

%% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;
trainset = {};
imgSets = [];
valset = {};
imgSets_val = [];
iter = 8;

%% train and test classifier for each class
for i=1:VOCopts.nclasses
    cls=VOCopts.classes{i};
   % [fp,tp,auc]=VOCroc(VOCopts,'comp1',cls,true); 
    
%% load 'train' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'train'),'%s %d');

%% Create a temp variable to store each class output which are to be 
... appended to form a bag.
trainingset_tmp = [];
% extract features for each image
    for j=1:length(ids)
        if classifier.gt(j) == 1
        % Load Images
            trainingset_tmp = [trainingset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
        end
    end
    
%%     % Creating image set from it.
    imgSet_val = [imgSet_val, imageSet(trainingset_tmp)];
    imgSet_val(1,i).Description = char(cls);
    
        
%% load 'validation' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'val'),'%s %d');

%% Create a temp variable to store each class output which are to be 
... appended to form a bag.
valset_tmp = [];
% extract features for each image
    for j=1:length(ids)
        if classifier.gt(j) == 1
        % Load Images
            valset_tmp = [valset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
        end
    end
    
%%     % Creating image set from it.
    imgSets_val = [imgSets_val, imageSet(valset_tmp)];
    imgSets_val(1,i).Description = char(cls);
    
    %% load 'test' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'test'),'%s %d');

%% Create a temp variable to store each class output which are to be 
... appended to form a bag.
testset_tmp = [];
% extract features for each image
    for j=1:length(ids)
        if classifier.gt(j) == 1
        % Load Images
            testset_tmp = [testset_tmp, {sprintf(VOCopts.imgpath,ids{j})}];
        end
    end
    
%%     % Creating image set from it.
    imgSets_test = [imgSets_test, imageSet(testset_tmp)];
    imgSets_test(1,i).Description = char(cls);

    
end

%% Dividing the imageset in different partition.
    trainingSets = imgSets;
    validationSets = imgSets_val;
    testSets = imgSets_test;
    t_Set = [trainingSets.Count] % show the count of images
    v_Set = [validationSets.Count] % show the count of images
    test_Set = [testSets.Count]

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
      
    %% Additionally, the bagOfFeatures object provides an |encode| method for
    % counting the visual word occurrences in an image. It produced a histogram
    % that becomes a new and reduced representation of an image.
    h = figure;
    for i=1:VOCopts.nclasses
    I = read(imgSets(i), 1);
    [featureVector,words] = encode(bag, I);
    %% Plot the histogram of visual word occurrences
    subplot(5,2,i);
    bar(featureVector); title(VOCopts.classes{i})
    end
    
    %% Naming the figures obtained 
    fignamebar = strcat(foldername,paraname,'_featurevector_',num2str(iter),'.jpg');
    drawnow;
    saveas(h,fignamebar,'jpg')
    
    
    %% Show locations of visual words.
    for i=1:VOCopts.nclasses
        I = read(imgSets(i),1);
        figname = strcat(foldername,paraname,'_10commonword_',VOCopts.classes{i},'_',num2str(iter),'.jpg');
        [featureVector,words] = encode(bag, I);
%         [sortedValues,idx] = sort(featureVector, 'descend');

%% To plot all the points.
%         pts = double(words.Location);
%         figure, imshow(I);title(VOCopts.classes{i});
%         hold on
%         plot(pts(:,1), pts(:,2), 'g.');
        
%% Show locations of the 10 most words on the example image from each class.
%         h = figure; imshow(I);title(VOCopts.classes{i});
%         hold on 
%         for j=1:10
%             pts = double(words.Location(words.WordIndex==idx(j),:));
%             plot(pts(:,1), pts(:,2), 'g*');
%         end
%         saveas(h,figname,'jpg')

%% To show all the points
%         figure,imshow(I); title(VOCopts.classes{i});
%         for j=1:words.Count
%             text(pts(j,1), pts(j,2), sprintf('%d', words.WordIndex(j)), ...
%             'Color', 'g', 'FontSize', 8);
%         end 
    end
%     drawnow;
   
%%
%     img = read(imgSets(1), 1);
%     featureVector = encode(bag, img);
%     
    categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);
    confMatrix = evaluate(categoryClassifier, validationSets);

    %confMatrix = evaluate(categoryClassifier, trainingSets);

%% Compute average accuracy
    a = mean(diag(confMatrix));
    
    resultfile = strcat(paraname,'_Result','_',num2str(iter),'.txt');
%% To save the result file with  variables like confusion matrix,
... partitioned sections, mean accuracy and time taken in ascii format.
    save(resultfile, 'confMatrix','t_Set','v_Set', 'a', 'tim', '-ascii')
%%    To predict any given image
%     img = (read(imgSets(1), 2));
%     [labelIdx, scores] = predict(categoryClassifier, img);
%     % Display the string label
%     categoryClassifier.Labels(labelIdx)

%end
