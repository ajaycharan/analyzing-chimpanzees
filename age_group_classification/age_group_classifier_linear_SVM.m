function str_out = age_group_classifier_linear_SVM ( str_extracted_features, str_settings )
% 
%  BRIEF:
% 
%  INPUT:
% 
%  OUTPUT:
%     str_out.s_age_groups = estimated age groups of the detected chimpansees in the
%                            image, cell array of char arrays
%

    svmmodel               = getFieldWithDefault ( str_settings, 'svmmodel', [] );
    settingsLibLinear      = getFieldWithDefault ( str_settings, 'settingsLibLinear', [] ); 
    s_possible_age_groups  = getFieldWithDefault ( str_settings, 's_possible_age_groups', [] ); 
    
    
    assert ( ~isempty ( svmmodel ),          'No trained SVM model for identification provided!' );
    assert ( ~isempty ( settingsLibLinear ), 'No LibSVM settings for identification provided!' );
        


    [predicted_age_group_ids, ~, ~] = liblinear_test ( zeros(size(str_extracted_features.features,2),1), sparse(double(str_extracted_features.features')), svmmodel, settingsLibLinear );
   
    predicted_age_groups = s_possible_age_groups( predicted_age_group_ids );

    %% assign outputs
    str_out              = [];
    str_out.s_age_groups = predicted_age_groups;
    
end