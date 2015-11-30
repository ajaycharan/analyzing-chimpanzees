function results = chimpansee_age_regression( dataset_chimpansees, settings )

    if ( nargin < 2 ) 
        settings = [];
    end
    
    settingsData = getFieldWithDefault( settings, 'settingsData', [] );
    datasplits = getFieldWithDefault ( settingsData, 'datasplits', struct( 'idxTrain', {}, 'idxTest', {} ) );    
    results    = struct ( 's_name', {}, 'f_arr', {}, 'datasplits', datasplits);
    
    b_verbose  =  getFieldWithDefault ( settings, 'b_verbose', true );    

    %% load data and settings
    %% load data split
    if ( ~isempty(  datasplits ) )
        idxTrain = getFieldWithDefault( datasplits,   'idxTrain', [] );
        idxTest  = getFieldWithDefault( datasplits,   'idxTest', [] ); 
    else
        idxTrain = [];
        idxTest  = [];            
    end    
    
    if ( isempty ( idxTrain ) || isempty ( idxTest ) ) 
        i_numTrainPerClass     = getFieldWithDefault ( settingsData, 'i_numTrainPerAge', 0.9 );
        i_numTrainMinPerClass  = getFieldWithDefault ( settingsData, 'i_numTestPerAge', '' );
        i_numTestPerClass      = getFieldWithDefault ( settingsData, 'i_numIntervals', 5);

        % TODO show histogram of class frequencies...
        [ idxTrain, idxTest ] = split_chimpansees_for_regression (  ...
                dataset_chimpansees, ...
                i_numTrainPerAge, ...
                i_numTestPerAge, ...
                i_numIntervals ...
                );
        if ( getFieldWithDefault ( settingsData, 'b_data_reclassif', false ) )    
            idxTest = idxTrain;
        end
    end
    
    %% prepare data
    
    featCNN = load ( settings.s_destFeat);
    featCNN = cell2mat(featCNN.struct_feat);
    
    dataTrain   = featCNN( :,idxTrain );
    labelsTrain = dataset_chimpansees.f_ages( idxTrain )';
    
    dataTest   = featCNN( :,idxTest );
    labelsTest = dataset_chimpansees.f_ages( idxTest )';
    
    %% train regression model
    
    gpnoise  = 0.1;
    
    infFct   = @infExact;    
    meanFct  = @meanZero; 
    covFunc  = @covSEisoU;   
    likFct   = @likGauss;
    
    % default hyper parameters for gp functions
    loghyper.cov  = 7;
    loghyper.lik  = gpnoise;
    loghyper.mean =[];        

    
    %TODO optimize noise and cov using either marginal likelihood or
    %cross-validation
    
    loghyper.mean =[];  
    
    K           = feval( covFunc, loghyper.cov, dataTrain', dataTrain');
    model.L     = chol(K+gpnoise*eye(length(labelsTrain)))';
    model.alpha = ( model.L'\(model.L\labelsTrain') );
    
     %% apply regression model to test data
    
    Ks      = feval( covFunc, loghyper.cov, dataTrain', dataTest');
    age_est = Ks'*model.alpha;

    f_error = sum(power(abs(labelsTest  - age_est'),1))/double(length(labelsTest));
    
    if ( b_verbose ) 
        disp ( sprintf('Regression error L1: %f', f_error) )
    end
    
    
    results                 = [];
    results.f_error         = f_error;        
    %
    mydatasetsplit.idxTrain = idxTrain;
    mydatasetsplit.idxTest  = idxTest;    
    results.datasplits      = mydatasetsplit;    
    %
    results.age_est         = age_est;    
    results.labelsTest      = labelsTest;    
    results.labelsTrain     = labelsTrain;
    
    
end
