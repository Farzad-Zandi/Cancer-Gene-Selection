% Crow Search Algorithm
% Orignal code: https://www.mathworks.com/matlabcentral/fileexchange/64609-binary-chaotic-crow-search-algorithm

% Feature selection via a novel chaotic crow search algorithm
% https://link.springer.com/article/10.1007/s00521-017-2988-6https://link.springer.com/article/10.1007/s00521-017-2988-6

close all; clear; clc; warning off
global Data classifier_method nclass

fprintf('------------------------------------------------------------------------------\n');
fprintf('Feature selection based on crow search and kNN classifier - v1.0 16/10/2018\n');

fprintf('Leandro dos Santos Coelho, Viviana Cocco Mariani, Mohammad Goodarzi\n');
fprintf('------------------------------------------------------------------------------\n\n');

classifier_method_label = {'k-nearest neighbor classification (kNN)', ...
                           'Random forest (RF)', ...
                           'Kernel Support Vector Machine (KSVM)', ...
                           'Gaussian Machine Learning (GaussianML)', ...
                           'Gaussian Mixture Model (GMM)'};

for dataset                   = 4:4   % dataset
    
 for AP_fl_method             = 1:9   % tuning of control parameters of crow search algorithm   
 for feature_selection_method = 1:6   % feature selection method
 for classifier_method        = 1:1   % 1:5   % classifier method   
     
     
  fprintf('Crow search to feature selection using the AP_fl_method = %d\n',AP_fl_method);
  fprintf('Feature selection method = %d\n',feature_selection_method);
  fprintf('Classifier method = %d\n',classifier_method);
  
  % benchmark microarray gene expression datasets
  switch dataset
    % http://www.biolab.si/supp/bi-cancer/projections/info/SRBCT.html
    % small round blue cell tumors (SRBCTs)     % samples x features
    case 1    % http://archive.ics.uci.edu/ml/datasets/zoo
               S = 'zoo.dat';          % 101     x 17 - toy problem,
               dataset_label = 'zoo';
               
    case 2    
               S = 'srbct3.mat';       % 83      x 2308  
               dataset_label = 'SRBCT3'; 
               % 4 classes:  http://mixomics.org/case-studies/splsda-srbct/3/
               % 8 Burkitt Lymphoma (BL), 
               % 23 Ewing Sarcoma (EWS), 
               % 12 neuroblastoma (NB), and 
               % 20 rhabdomyosarcoma (RMS)
               
    case 3    
               S = 'Leukemia3.mat';    % 72      x 7129
               dataset_label = 'Leukemia3';
               
    case 4    
               S = 'Prostate3.mat';    % 136     x 12600
               dataset_label = 'Prostate3';
  end
  load(S)  % data: 2308 features x 83 samples
  
  if dataset > 1
    data = data';          % N x M, example: dataset = 2 -> 2308 x 83 -> 83 x 2308
    Data = [data,label];   % label => Data(:,end) 
    % N is the number of the experimental samples and
    % M is the number of genes involved in the experiments
    
    nclass = size(unique(Data(:,end)),1);
    fprintf('Dataset: %d - %s (%d samples and %d features) for %d classes\n', ...
        dataset,dataset_label,size(data,1),size(data,2),nclass);
  else  % toy problem
    Data    = zoo(:,1:end)';
    label   = zoo(:,17);
    numVar2 = 16;
    nclass = size(unique(label),1);
    fprintf('Dataset: %d - %s (%d samples and %d features) for %d classes\n',...
        dataset,dataset_label,size(data,1),size(data,2)-1, nclass);
  end

  for numVar = 50:50 % MAX number of features to the CSA find a subset of these features
    nruns = 10;        % To test use nruns = 1; nruns = 30 to FULL statistical analysis
    for run = 1:nruns
    
      rand('state',run);     % for reproducity
      if (run==1)  
        fprintf('Original data (dataset = %d): %d x %d\n\n', ...
          dataset,size(data));
      end
      
      % Fisher criterion employs the
      % statistical properties of each gene in different classes as a potential
      % measure of discriminant ability for classification
      
      %feature_selection_method = 6;  % 0 - without feature selection
      switch feature_selection_method
       case 0 % without fature selection (uses ALL data)
          numVar  = size(data,2);
          Data  = data;                       % data WITHOUT label
          Data  = [Data,label];               % include label in Data
          
       case 1 % Fisher score
          addpath(genpath('Feature selection'))
          [ranking, scor]  = FisherSc(data,label(1: size(data,1)) );  % 1 x Nfeatures
          if (dataset== 1),        numVar2 = 10;      else        numVar2 = numVar;      end
          Data  = data(:,ranking(1:numVar2));    % data WITHOUT label
          Data  = [Data,label];               % include label in Data
   
       case 2,  % LASSO (least absolute shrinkage and selection operator)
          % https://www.mathworks.com/matlabcentral/fileexchange/56937-feature-selection-library 
          addpath(genpath('Feature selection'))
          lambda      = 25;  % The objective is to reduce overfitting
                             % a way to reduce overfitting is then to artificially 
                             % penalize higher degree polynomials
          B           = lasso(data, label(1: size(data,1)));
          [v,ranking] = sort(B(:,lambda),'descend');
          if (dataset== 1),        numVar2 = 10;      else        numVar2 = numVar;      end
          Data        = data(:,ranking(1:numVar2));    % data WITHOUT label
          Data        = [Data,label];                  % include label in Data
          
       case 3, % Relief feature selection   
          % https://www.mathworks.com/matlabcentral/fileexchange/56937-feature-selection-library 
          addpath(genpath('Feature selection'))
          if (dataset== 1),        numVar2 = 10;      else        numVar2 = numVar;      end
          % https://en.wikipedia.org/wiki/Relief_(feature_selection)
          [ranking, w] = reliefF( data, label(1: size(data,1)), numVar2);
          Data         = data(:,ranking(1:numVar2));    % data WITHOUT label
          Data         = [Data,label];                  % include label in Data          
  
       case 4, % mutInfFS   
          % https://www.mathworks.com/matlabcentral/fileexchange/56937-feature-selection-library 
          addpath(genpath('Feature selection'))
          if (dataset== 1),        numVar2 = 10;      else        numVar2 = numVar;      end
          % https://en.wikipedia.org/wiki/Relief_(feature_selection)
          [ranking, w] = mutInfFS( data, label(1: size(data,1)), numVar2 );
          Data         = data(:,ranking(1:numVar2));    % data WITHOUT label
          Data         = [Data,label];                  % include label in Data         
          
       case 5, % Laplacian   
          % https://www.mathworks.com/matlabcentral/fileexchange/56937-feature-selection-library 
          addpath(genpath('Feature selection'))
          if (dataset== 1),        numVar2 = 10;      else        numVar2 = numVar;      end
          % He, X., Cai, D., Niyogi, P.: Laplacian score for feature selection. In: Advances in Neural
          % Information Processing Systems 18 (2005)
          % https://papers.nips.cc/paper/2909-laplacian-score-for-feature-selection.pdf
          W               = dist(data');     % IT USES ONLY POSITIVE VALUES  
          W               = -W./max(max(W)); % it's a similarity
          [lscores]       = LaplacianScore(data, W);
          [junk, ranking] = sort(-lscores);
        
          Data         = data(:,ranking(1:numVar2));    % data WITHOUT label
          Data         = [Data,label];                  % include label in Data       

       case 6, % fsvFS   
          % https://www.mathworks.com/matlabcentral/fileexchange/56937-feature-selection-library 
          addpath(genpath('Feature selection'))
          if (dataset== 1),        numVar2 = 10;      else        numVar2 = numVar;      end
          % Bradley, P.S., Mangasarian, O.L.: Feature selection via concave minimization and support
          % vector machines. In: ICML. pp. 82–90. Morgan Kaufmann (1998)
          % https://dl.acm.org/citation.cfm?id=657467
          [ranking , w] = fsvFS (data, label(1: size(data,1)), numVar2);
          Data         = data(:,ranking(1:numVar2));    % data WITHOUT label
          Data         = [Data,label];                  % include label in Data          
      end
      
      if (run==1),  
        fprintf('Modified data (dataset = %d after Fisher score): %d x %d\n\n', ...
          dataset,size(Data,1),size(Data,2)-1);
        str = cellstr(classifier_method_label{classifier_method}) ;
        fprintf('Classifier: %d  %s\n\n', classifier_method,str{1});
      end
      
      % Dimension of optimization problem
      dim             = size(Data,2)-1;  
    
      SearchAgents_no = 20;              % Number of search agents
      Max_iter        = 100;             % Maximum number of iterations
      fobj            = 'obj';           % Maximization problem
  
      [Positions Fitness] = BinaryInitialization(fobj,SearchAgents_no,dim,1,0);
    
      %AP_fl_method            = 7;  % 1,2,3,4,..,8
      Control_parameters_flag = 2;
      
      switch Control_parameters_flag 
        case 0,  % CONSTANT 0.5
           RandVec = 0.5*ones(10,Max_iter);
           [Best_score,Selected_Features_CCSA,Convergence_curve_CCSA, ...
             acc_best_ALL, comp_best_ALL,nfeatures_best]= BCCSA(Positions, ...
             run,nruns,Fitness,SearchAgents_no,Max_iter,  0, 1,dim, fobj,...
             RandVec(1,:),AP_fl_method,feature_selection_method);  
         
        case 1,  % RAND in range [0,1]
           RandVec = rand(10,Max_iter);
           [Best_score,Selected_Features_CCSA,Convergence_curve_CCSA , ...
             acc_best_ALL, comp_best_ALL,nfeatures_best]= BCCSA(Positions, ...
             run,nruns,Fitness,SearchAgents_no,Max_iter,  0, 1,dim, fobj,...
             RandVec(1,:),AP_fl_method,feature_selection_method);  
    
        case 2,  % CHAOTIC
            ChaosVec = zeros(10,Max_iter);
            % Calculate chaos vector, function O=chaos(index,max_iter,Value)            
            for i = 1:10
              ChaosVec(i,:) = chaos(i,Max_iter,1);
            end
            % Change ChaosVec(i,:), i= 1 , ..., 10 to select chaotic vector.
           [Best_score,Selected_Features_CCSA,Convergence_curve_CCSA, ...
              acc_best_ALL, comp_best_ALL,nfeatures_best] = BCCSA(Positions, ...
              run,nruns,Fitness,SearchAgents_no,Max_iter,  0, 1,dim, fobj,...
              ChaosVec(1,:),AP_fl_method,feature_selection_method);
      end % switch Chaos_flag 
      
      flag_figure = 1;      
      if flag_figure
        plot(Convergence_curve_CCSA);
        xlabel('generation')
        ylabel('objective function');
      end
      hold on
      fprintf('\n');
      
      % store best results
      best_score_ALL(1,run)             = Best_score;
      Selected_Features_CCSA_all(:,run) = Selected_Features_CCSA;
      Convergence_curve_CCSA_all(run,:) = Convergence_curve_CCSA;
      acc_best_ALL_store(1,run)         = acc_best_ALL;
      comp_best_ALL_store(1,run)        = comp_best_ALL;
      nfeatures_best_store(1,run)       = nfeatures_best;
      
      
      % show features obtained by best solution in EACH run (run = 30 for example) 
      size_best = size(ranking(Selected_Features_CCSA_all(:,run) ),2);
      fprintf('\n\nNumber of features of BEST solution obtained by optimizer CSA = %d (run = %d)\n\n', ...
          size_best,run);
      
      cont_feat = 0;
      for j = 1:size_best
         if (Selected_Features_CCSA_all(j,run) == 1), 
           cont_feat = cont_feat + 1;
           fprintf('feature number %d:\t\t%d\n', ...
                    cont_feat, ranking(j));
         end
      end
      fprintf('\n\n');
      
    end      % for run = 1:nruns          

    % statistics
    fprintf('---- STATISTICS for %d runs:\n',nruns);
    fprintf('Best OF (max,min,mean,std): %f %f %f %f\n',...
          max(best_score_ALL),  min(best_score_ALL), ...
          mean(best_score_ALL), std(best_score_ALL));
      
    fprintf('Best accuracy (max,min,mean,std): %f %f %f %f\n',...
          max(acc_best_ALL_store), min(acc_best_ALL_store), ...
          mean(acc_best_ALL_store), std(acc_best_ALL_store));
       
    fprintf('Best no. features (max,min,mean,std): %d %d %.2f %.2f\n',...
          max(nfeatures_best_store),  min(nfeatures_best_store), ...
          mean(nfeatures_best_store), std(nfeatures_best_store));
     
    % save results in file
    output_file = ['res_CS_dataset_' num2str(dataset) '_APfl_' num2str(AP_fl_method) ];
    output_file = [output_file '_numVar_' num2str(numVar) '_Cpf_' num2str(Control_parameters_flag)];
    output_file = [output_file '_fs_' num2str(feature_selection_method)];
    output_file = [output_file '_CL_' num2str(classifier_method)];
    save(output_file);
    
  end    % for numVar = 500:500
 end     % for classifier_method        = 1:1   % classifier method    
 end     % for feature_selection_method = 1:6  
 end     % for AP_fl_method = 1:9 
end      % for dataset    = 4:4

