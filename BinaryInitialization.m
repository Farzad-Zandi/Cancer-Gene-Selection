function [X,fit]=BinaryInitialization(fobj,SearchAgents_no,dim,ub,lb)

    for i = 1 : SearchAgents_no
        X( i, : ) = (lb + (ub-lb) .* rand( 1, dim )) > 0.5; 
        fit( i ) = feval(fobj,X(i,:));
    end
end