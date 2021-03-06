function s_est_attributes_combined =  combine_results_to_text ( str_results )

    s_est_attributes_combined = {};
    
    i_numObjects = size(str_results.str_detected_faces.i_face_regions,1);
    
    for idxObj=1:i_numObjects
        s_est_attributes_combined{idxObj} = '';
        
        if ( isfield(str_results, 'str_results_novelty_detection' ) )
           % do something here.
        end
        
        if ( isfield(str_results, 'str_results_identification' ) )
            if ( length(str_results.str_results_identification.s_names) >= idxObj )
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', str_results.str_results_identification.s_names{idxObj}];
            else
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', 'unknown'];
            end
        end
        
        if ( isfield(str_results, 'str_results_age_estimation' ) )            
            if ( length(str_results.str_results_age_estimation.f_ages) >= idxObj )
                s_formatSpec = '%2.1f';
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', num2str(str_results.str_results_age_estimation.f_ages(idxObj), s_formatSpec), 'y'];
            else
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', '?', 'y'];
            end
        end        
        
        if ( isfield(str_results, 'str_results_age_group_estimation' ) )
            if ( length(str_results.str_results_age_group_estimation.s_age_groups) >= idxObj )
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', str_results.str_results_age_group_estimation.s_age_groups{idxObj}];            
            else
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', 'unknown age group'];            
            end
        end  
        
        if ( isfield(str_results, 'str_results_gender_estimation' ) )
            if ( length(str_results.str_results_gender_estimation.s_genders) >= idxObj )
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', str_results.str_results_gender_estimation.s_genders{idxObj}];            
            else
                s_est_attributes_combined{idxObj} = [ s_est_attributes_combined{idxObj} , ' - ', 'unknown gender'];            
            end
        end          
    
        % removing trailing ' - '
        idxOfConcatSymb = findstr ( s_est_attributes_combined{idxObj},  ' - ' );
        if ( ismember ( 1, idxOfConcatSymb ) )
            s_est_attributes_combined{idxObj} = s_est_attributes_combined{idxObj} ( length(' - ')+1:end );
        end
    end
    

end