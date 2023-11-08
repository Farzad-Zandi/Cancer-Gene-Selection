% -------------------------------------------------
% Citation details:
% G. Sayed, A. Hassanien and A. Taher, “Feature selection via a novel chaotic crow search algorithm”,
% Neural Computing and Applications, DOI  10.1007/s00521-017-2988- , 1-32,
% 2017.

% -------------------------------------------------
% This demo implements chaotic CSA as feature selection aglorithm
% -------------------------------------------------

function [Destination_fitness,Destination_position,Convergence_curve, ...
          acc_best_ALL, comp_best_ALL,nfeatures_best]=BCCSA(x,...
          current_run,total_runs,ft,N,tmax,l,u,pd,fobj,Vec,AP_fl_method,feature_selection_method)

global classifier_method
format long; 
new_mem        = 0;
acc_best_ALL   = 0;
comp_best_ALL  = 0;

xn             = x;
mem            = x; % Memory initialization
fit_mem        = ft; % Fitness of memory positions
f_best_ALL     = 0;  % MAXIMIZATION PROBLEM
nfeatures_best = size(l,2);


for t = 1:tmax

      switch AP_fl_method
        %---- using constante values  
        case 1, % classical constant AP and fl values adopted in <Main_crow_search.m>      
          AP = 0.1;
          fl = 2;
        %--- using beta distribution  
        case 2,
          AP = betarnd(0.05*rand,rand,1);
          fl = betarnd(rand,0.05*rand,1);
        case 3,
          AP = betarnd(0.1*rand,rand,1);
          fl = betarnd(rand,0.1*rand,1);
        case 4,
          AP = betarnd(0.15*rand,rand,1);
          fl = betarnd(rand,0.15*rand,1);
        case 5,
          AP = betarnd(0.2*rand,rand,1);
          fl = betarnd(rand,0.2*rand,1);  
      
        %---- using decreasing and increasing  values
        case 6,  % both decreasing
          ri = 0.20; rf = 0.05;   AP = (rf - ri)*(t/tmax) + ri; 
          ri = 2.00; rf = 1.00;   fl = (rf - ri)*(t/tmax) + ri; 
        case 7,  % both increasing
          ri = 0.05; rf = 0.20;   AP = (rf - ri)*(t/tmax) + ri; 
          ri = 1.00; rf = 2.00;   fl = (rf - ri)*(t/tmax) + ri;           
        case 8,  % one increasing, other  decreasing
          ri = 0.05; rf = 0.20;   AP = (rf - ri)*(t/tmax) + ri; 
          ri = 2.00; rf = 1.00;   fl = (rf - ri)*(t/tmax) + ri; 
        case 9, % one increasing, other  decreasing
          ri = 0.20; rf = 0.05;   AP = (rf - ri)*(t/tmax) + ri; 
          ri = 1.00; rf = 2.00;   fl = (rf - ri)*(t/tmax) + ri;           
      end  % switch AP_fl_method

    num = ceil(N*rand(1,N)); % Generation of random candidate crows for following (chasing)
    
    % ********************** Chaotic Part *********************
    rvalue = Vec(t);

    for i=1:N
        if rand>AP
            xnew(i,:)= (x(i,:)+fl*rvalue*(mem(num(i),:)-x(i,:)))>0.5; % Generation of a new position for crow i (state 1)
            v1=sigmf(xnew(i,:),[10 0.9]);%eq. 25
            r=rand;
            v1(v1<r)=0;
            v1(v1>=r)=1;
            xnew(i,:)=(xnew(i,:)+v1)>=1;
        else
            for j=1:pd
                xnew(i,j)=(l-(l-u)*rvalue)>0.5; % Generation of a new position for crow i (state 2)
                v1=sigmf(xnew(i,j),[10 0.9]);%eq. 25
                if v1<rand
                   v1=0;
                else
                   v1=1;
                end
                xnew(i,j)=(xnew(i,j)+v1)>=1;
            end
        end
       
    end

    xn = xnew;
    for ii = 1:N
     [ft(ii), Accuracy(ii), Complexity(ii), weighting] = feval(fobj,xn(ii,:));
    end
    
    for i = 1:N % Update position and memory
        if xnew(i,:) >= l & xnew(i,:) <= u
            x(i,:) = xnew(i,:);           % Update position
            if ft(i) > fit_mem(i)         % MAXIMIZATION PROBLMM
                mem(i,:)       = xnew(i,:); % Update memory
                fit_mem(i)     = ft(i);
                 
                new_mem        = xnew(i,:);
                new_accuracy   = Accuracy(i);
                new_complexity = Complexity(i);
            end
        end
    end
    [ffit(t), position] = max(fit_mem); % Best found value until iteration t
    
    if ffit(t) > f_best_ALL
      nfeatures_best  = sum(new_mem);
      if (nfeatures_best > 1),  % NO for ONLY 1 feature
        [aux,pos_1]     = find(new_mem>0);
      
        f_best_ALL      = ffit(t);
        acc_best_ALL    = new_accuracy;
        comp_best_ALL   = new_complexity;
      end
    end
    
    % Display the iteration and best optimum obtained so far
    fprintf('FS%d CS%d CL%d R:%d/%d, It:%d/%d, OF:%f (%d feat:%.2f #max), Acc:%.4f Compl:%.4f w:%.2f\n', ...
        feature_selection_method,AP_fl_method,classifier_method,...
        current_run,total_runs,t,tmax, f_best_ALL,nfeatures_best, ...
        nfeatures_best/size(x,2), acc_best_ALL, comp_best_ALL,weighting);
    
%     if ((nfeatures_best < 10) & (t>5)),
%       fprintf('\tFeatures: '); 
%       for k = 1:size(pos_1,2)
%         fprintf('%d ', pos_1(k)); 
%       end
%     end
%     fprintf('\n');
    
end
Destination_fitness  = max(fit_mem);
ngbest               = find(fit_mem== max(fit_mem));
g_best               = mem(ngbest(1),:); % Solutin of the problem
Destination_position = g_best;
Convergence_curve    = ffit;
end


