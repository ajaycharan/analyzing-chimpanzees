function [ idxTrain, idxTest ] = split_chimpansees_for_regression (  dataset, i_numTrainPerAge, i_numTestPerAge, i_numIntervals )
%function [ idxTrain, idxTest ] = split_chimpansees_for_regression (  dataset, i_numTrainPerAge, i_numTestPerAge, i_numIntervals )
%
% INPUT
%  dataset               -- struct with at least the following fields:
%     f_ages              -- nx1 vector, integer
%     s_images           -- nx1 cell array of strings
%  i_numTrainPerCategory -- 1x1 scalar, integer or float ( only in [0,1) ),
%                           a float value indicates the ratio used for
%                           training
%  i_numTestPerCategory  -- 1x1 scalar, integer, if empty, all non-training
%                           images are considered more testing
%  i_numIntervals        -- 1x1 scalar, integer, number of age intervals to
%                           draw from equally
%
% OUTPUT
%  idxTrain              -- (#classes *i_numTrainPerCategory) x 1 vector, int-indices
%  idxTest               -- (#classes *i_numTestPerCategory)  x 1 vector, int-indices
% 

    
    idxTrain   = [];
    idxTest    = [];  
    

    f_min      = min (dataset.f_ages);
    f_max      = max (dataset.f_ages);
    f_stepsize = (f_max-f_min)/double(i_numIntervals);
    
    f_intervals = f_min:f_stepsize:f_max;
    
    for idx=1:(length(f_intervals)-1)
        f_interval     = f_intervals(idx);
        f_intervalNext = f_intervals(idx+1);
        
        if idx==1
            b_idxOfAgeExamples = (dataset.f_ages >= f_interval )    & ...
                                   (dataset.f_ages <= f_intervalNext ) & ...        
                                   dataset.b_idxValid ;
        else
            b_idxOfAgeExamples = (dataset.f_ages > f_interval )    & ...
                                   (dataset.f_ages <= f_intervalNext ) & ...        
                                   dataset.b_idxValid ;            
        end

        i_idxOfAgeExamples = find(  b_idxOfAgeExamples  );
        
        % security check
        if ( isempty( i_numTestPerAge ) )
            if ( length(i_idxOfAgeExamples) < (i_numTrainPerAge) )      
                continue;
            end            
        else
            if ( length(i_idxOfAgeExamples) < (i_numTrainPerAge + i_numTestPerAge) )
                s_error = sprintf( 'Too few examples for interval %03d', idx );
                throw(s_error)
            end            
        end
                               
                               
        i_perm = randperm( length(i_idxOfAgeExamples) ); 
        
        if ( i_numTrainPerAge < 1)
        	i_numTrain = floor ( i_numTrainPerAge * length(i_idxOfAgeExamples) );
        else
            i_numTrain = i_numTrainPerAge;
        end        
        
        idxTrain = [ idxTrain; i_idxOfAgeExamples( i_perm (1:i_numTrain) )];        
 
             
         if ( (nargin >= 2 ) && (~isempty(i_numTestPerAge) ) && (~isinf( i_numTestPerAge )) )
             idxTest( ...
                        ((idx-1)*i_numTestPerAge+1): ...
                        ((idx)*i_numTestPerAge)...
                     ) = ...  
                     i_idxOfAgeExamples( i_perm  ((i_numTrain+1):(i_numTrain + i_numTestPerAge) ) );             
         else
             idxTest = [ idxTest ; ...
                         i_idxOfAgeExamples( i_perm  ((i_numTrain+1):end ) );              ...
                       ];

         end             
             
    end
    
    

end