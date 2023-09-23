function [Fitness, Accuracy, Complexity, weighting] = obj(solution)

global classifier_method nclass

if sum(solution)==0 %no feature is selected
    Fitness    = 0;
    Accuracy   = 0;
    Complexity = 0;
    weighting  = 0;
    return;
end

global Data
groups   = Data(:,size(Data,2));
meas     = Data(:,solution);
Data_All = [meas groups];
k        = 5;   % k-fold in cross  validation (CV)

% https://www.mathworks.com/help/bioinfo/ref/crossvalind.html
indices = crossvalind('Kfold',size(Data_All,1),k);

%  cp = classperf(Data);
Accuracy   = zeros(1,k);
leng_total = zeros(1,k);
class      = 0;

 for i = 1:k
    test   = (indices == i); train = ~test;
    
    % select the classifier
    %classifier_method = 1;
    switch classifier_method
      
      case 1, % k-nearest neighbor classification (kNN)
        k_neigh   = 3;
        dis_model = 2;
        switch dis_model
            case 1, dist = 'euclidean';
            case 2, dist = 'cityblock';
            case 3, dist = 'cosine';
            case 4, dist = 'correlation';     
        end % switch dis_model
        
        model = fitcknn(meas(train,:), groups(train,:), ...
            'NumNeighbors', k_neigh, 'Distance', dist);
        class = predict(model, meas(test,:));
%         class  = knnclassify(meas(test,:),meas(train,:), ...
%                  groups(train,:),k_neigh, dist);
        % 'cityblock' — Sum of absolute differences'cityblock'

         
      case 2, % Random forest, https://github.com/karpathy/Random-Forest-Matlab
        addpath(genpath('Random  forest'))
        opts              = struct;
        opts.depth        = 8; %9;
        opts.numTrees     = 10;  % 100
        opts.numSplits    = 3;
        opts.verbose      = false; %true;
        opts.classifierID = 2; % weak learners to use. Can be an array for mix of weak learners too
        model             = forestTrain(meas(train,:), groups(train,:), opts);
        class             = forestTest(model, meas(test,:));
        
      case 3, % KSVM, https://github.com/Xiaoyang-Rebecca/PatternRecognition_Matlab
        addpath(genpath('Pattern recognition'))  
        FeatureReductor     = 'NONE';  K = []; Dim = [];
        Classifier          = 'KSVM';     
        [AccuracyPR,class] = PatternRecog(meas(train,:)', groups(train,:), ...
                                           meas(test,:)',  groups(test,:),...
                                           FeatureReductor,Dim,Classifier,K);
      
      case 4, % GaussianML, https://github.com/Xiaoyang-Rebecca/PatternRecognition_Matlab
        addpath(genpath('Pattern recognition'))  
        FeatureReductor     = 'NONE';  K = []; Dim = [];
        Classifier          = 'GaussianML';     
        [AccuracyPR,class] = PatternRecog(meas(train,:)', groups(train,:), ...
                                           meas(test,:)',  groups(test,:),...
                                           FeatureReductor,Dim,Classifier,K);
          
      case 5, % GMM, https://github.com/Xiaoyang-Rebecca/PatternRecognition_Matlab
        addpath(genpath('Pattern recognition'))  
        FeatureReductor     = 'NONE';  K = 3; % no. clusters
        Dim = [];
        Classifier          = 'GMM';     
        [AccuracyPR,class] = PatternRecog(meas(train,:)', groups(train,:), ...
                                           meas(test,:)',  groups(test,:),...
                                           FeatureReductor,Dim,Classifier,K);
    end
  
    Actual = groups(test,:);
   
    for j = 1:length(class)
      if (class(j)== Actual(j)),
        Accuracy(i) = Accuracy(i) + 1;
      end
      leng_total(i) = length(class);
    end
 end
 
 Accuracy    = sum(Accuracy)/sum(leng_total);
 weighting   = 0.7; %0.55; %0.55; % 0.2; %0.8
 Complexity  = (1-(sum(solution)/(length(solution))));
 Fitness     = weighting*Accuracy + (1-weighting)*Complexity;  % maximization
 
%  if (sum(solution) < 3),  % penalty
%    Fitness = 0;  
%  end
end



