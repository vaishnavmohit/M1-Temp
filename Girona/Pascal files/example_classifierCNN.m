function example_classifier

clc;
clear all;
close all;

% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% Folder name
foldername = 'output\';


% initialize VOC options
VOCinit;


run('/media/mohit/01D3B5938BD2E2F0/MS/Girona/Visual Perception/Lab 2/vlfeat-0.9.21/toolbox/vl_setup')
%run ('E:\UdG-2nd Semeter\Segmentation\pascal_2006\pascal_new\pascal_2006\matconvnet-1.0-beta25\matconvnet-1.0-beta25\matlab\vl_setupnn')
%imds = imageDatastore('E:\UdG-2nd Semeter\Segmentation\pascal_2006\pascal_new\pascal_2006\VOCdevkit\VOC2006\PNGImages','FileExtensions',{'.png','.PNG'});
%bag = bagOfFeatures(imds,'Verbose',false);

%load('net.mat')
%load('imagenet-matconvnet-vgg-m.mat')

%Import the ALexnet
global net
net = alexnet


%net.Layers
%net1 = fullfile('net.mat');

%cnnMatFile = fullfile('E:\UdG-2nd Semeter\Segmentation\pascal_2006\pascal_new\pascal_2006\VOCdevkit','imagenet-matconvnet-vgg-m.mat');
%convnet = helperImportMatConvNet(cnnMatFile);
%net = vl_simplenn(net1);

% train and test classifier for each class
for i=1:VOCopts.nclasses
    cls=VOCopts.classes{i};
   
    
%     classifier=train(VOCopts,cls);                  % train classifier
%     
%     test(VOCopts,cls,classifier);                   % test classifier
     [w,b] = svmtrainCNN(VOCopts,cls,0.00001,3);
 
    
    
    svmtestCNN(VOCopts,cls,w,b,0.00001,3);
    
    
    h = figure;
    [fp,tp,auc]=VOCroc(VOCopts,'comp1',cls,true);   % compute and display ROC
    
    if i<VOCopts.nclasses
        fprintf('press any key to continue with next class...\n');
        %pause;
    end
    fignamebar = strcat(foldername,'_class_',cls,'.jpg');
%     drawnow;
%     saveas(h,fignamebar,'jpg')
end


% train classifier
function classifier = train(VOCopts,cls)

% load 'train' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'train'),'%s %d');


% extract features for each image
classifier.FD=zeros(0,length(ids));
tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: train: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end

    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd=extractfd(VOCopts,I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
    
    classifier.FD(1:length(fd),i)=fd;
end

% run classifier on test images
function test(VOCopts,cls,classifier)

% load test set ('val' for development kit)
[ids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,VOCopts.testset),'%s %d');

% create results file
fid=fopen(sprintf(VOCopts.clsrespath,'comp1',cls),'w');



% classify each image
tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: test: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end
    
    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd=extractfd(VOCopts,I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end

    % compute confidence of positive classification
    c=classify(VOCopts,classifier,fd);
    
    % write to results file
    fprintf(fid,'%s %f\n',ids{i},c);
end

% close results file
fclose(fid);


% trivial feature extractor: compute mean RGB

% Features are extracted from CNN layer 
% function fd = extractfd(VOCopts,I)
% 
% fd = [];
% [nr,nc,nz] = size(I);
% for i=1:10,
% 	for j=1:10,
% 		dv = I(floor(1+(i-1)*nr/10):floor(i*nr/10),floor(1+(j-1)*nc/10):floor(j*nc/10),:);
% 		fd = [fd;sum(sum(double(dv)))/(size(dv,1)*size(dv,2))];
% %fd=squeeze(sum(sum(double(I)))/(size(I,1)*size(I,2)));
% 	end
% end
% fd = fd(:);

% trivial classifier: compute ratio of L2 distance betweeen
% nearest positive (class) feature vector and nearest negative (non-class)
% feature vector
% 
% 

%Changed the classifier

% function c = classify(VOCopts,classifier,fd)
% 
% d=sum(fd.*fd)+sum(classifier.FD.*classifier.FD)-2*fd'*classifier.FD;
% dp=min(d(classifier.gt>0));
% dn=min(d(classifier.gt<0));
% c=dn/(dp+eps);

% Extract features using CNN
function fd = extractnetfd(VOCopts,I)
global net
% Some images may be grayscale. Replicate the image 3 times to
% create an RGB image.
if ismatrix(I)
    I = cat(3,I,I,I);
end

% Resize the image as required for the CNN.
Iout = imresize(I, [227 227]);

%fprintf('1 \n ') 

% Extract features using CNN
featureLayer = 'fc7';
%fd = activations( net , Iout, featureLayer, ...
    ...'MiniBatchSize', 32, 'OutputAs', 'columns');

function svmtestCNN(VOCopts,cls,w,b,lambda,kernel)

% load test set ('val' for development kit)
[ids,gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,VOCopts.testset),'%s %d');

% create results file
fid=fopen(sprintf(VOCopts.clsrespath,'comp1',cls),'w');

% classify each image
tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: test: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end
    
    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd=extractnetfd(VOCopts,I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end

    % compute confidence of positive classification
    if (kernel ~= -1)
        hom.kernel = 'KChi2';
        hom.order = kernel;
        dataset = vl_svmdataset(fd, 'homkermap', hom);
        [~,~,~,scores] = vl_svmtrain(dataset, 1000, lambda, 'model', w, 'bias', b, 'solver', 'none');
    else
        scores=(w'*fd + b);
    end
    
    % write to results file
    fprintf(fid,'%s %f\n',ids{i},scores);
end

% close results file
fclose(fid);

function [w,b] = svmtrainCNN(VOCopts,cls,lambda,kernel)

% load 'train' image set for class
[ids,classifier.gt]=textread(sprintf(VOCopts.clsimgsetpath,cls,'train'),'%s %d');
% extract features for each image
classifier.FD=zeros(0,length(ids));
tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: train: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end

    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd=extractnetfd(VOCopts,I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
    classifier.FD(1:length(fd),i)=fd;
end
if (kernel ~= -1)
    hom.kernel = 'KChi2';
    hom.order = kernel;
    dataset = vl_svmdataset(classifier.FD, 'homkermap', hom);
else
    dataset = classifier.FD;
end
[w b ~] = vl_svmtrain(dataset, double(classifier.gt), lambda);


