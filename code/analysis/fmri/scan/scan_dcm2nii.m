
function scan_dcm2nii()
    %% GENERAL SETTINGS    
    % DIRECTORIES AND FILES
    dir_dcm                     = [pwd(),filesep,'data',filesep,'dcm',filesep];
    dir_dcm_subs                = dir([dir_dcm,'sub_*']); dir_dcm_subs = strcat(dir_dcm,strvcat(dir_dcm_subs.name),'/');
    dir_dcm_strs                = strcat(dir_dcm_subs,'MRUZ_JAN - 1',filesep,'t1_mpr_sag_p2_iso_11',filesep);
    dir_dcm_epis4_1             = strcat(dir_dcm_subs,'MRUZ_JAN - 1',filesep,'ep2d_64mx_35mm_TE_30ms_4',filesep);
    dir_dcm_epis4_2             = strcat(dir_dcm_subs,'MRUZ_JAN - 1',filesep,'ep2d_64mx_35mm_TE_30ms_5',filesep);
    dir_dcm_epis4_3             = strcat(dir_dcm_subs,'MRUZ_JAN - 1',filesep,'ep2d_64mx_35mm_TE_30ms_6',filesep);
    dir_dcm_epis4_4             = strcat(dir_dcm_subs,'MRUZ_JAN - 1',filesep,'ep2d_64mx_35mm_TE_30ms_7',filesep);
    dir_dcm_epis4_5             = strcat(dir_dcm_subs,'MRUZ_JAN - 1',filesep,'ep2d_64mx_35mm_TE_30ms_8',filesep);
    dir_nii                     = [pwd(),filesep,'data',filesep,'nii',filesep];
    
    %% VARIABLES
    nb_subjects = size(dir_dcm_subs, 1);
    u_subject   = 1:nb_subjects;
    
    %% CONVERT SUBJECTS
    for i_subject = 1:length(u_subject)
        path_dcm = '';
        path_nii = '';
        subject  = u_subject(i_subject);
        convert_subject();
    end
    
    %% CONVERT SUBJECT()
    function convert_subject()
        fprintf('\n');
        fprintf('participant %02i ------------------------ \n',subject);
        fprintf('--------------------------------------- \n');
        convert_str();
        convert_epi4_1();
        convert_epi4_2();
        convert_epi4_3();
        convert_epi4_4();
        convert_epi4_5();
    end
    
    %% CONVERT STRUCTURAL
    function convert_str()
        path_dcm = dir_dcm_strs(i_subject,:);
        path_nii = sprintf('%ssub_%02i/str/',dir_nii,subject);
        mkdirp(path_nii);
        dicm2nii(path_dcm,path_nii,'.nii');
        delete([path_nii,'dcmHeaders.mat']);
        file_from = sprintf('%st1_mpr_sag_p2_iso.nii',path_nii);
        file_to   = sprintf('%simages_000_mprax111recommended1001.nii',path_nii);
        movefile(file_from,file_to);
    end
    
    %% CONVERT EPI4
    function convert_epi4_1()
        path_dcm = dir_dcm_epis4_1(i_subject,:);
        path_nii = sprintf('%ssub_%02i/epi4/',dir_nii,subject);
        mkdirp(path_nii);
        dicm2nii(path_dcm,path_nii,'.nii');
        delete([path_nii,'dcmHeaders.mat']);
        file_from = sprintf('%sep2d_64mx_3_5mm_TE_30ms.nii',path_nii);
        file_to   = sprintf('%simages_ep2dP2RUN1.nii',path_nii);
        movefile(file_from,file_to);
    end
    
    function convert_epi4_2()
        path_dcm = dir_dcm_epis4_2(i_subject,:);
        path_nii = sprintf('%ssub_%02i/epi4/',dir_nii,subject);
        mkdirp(path_nii);
        dicm2nii(path_dcm,path_nii,'.nii');
        delete([path_nii,'dcmHeaders.mat']);
        file_from = sprintf('%sep2d_64mx_3_5mm_TE_30ms.nii',path_nii);
        file_to   = sprintf('%simages_ep2dP2RUN2.nii',path_nii);
        movefile(file_from,file_to);
    end
    
    function convert_epi4_3()
        path_dcm = dir_dcm_epis4_3(i_subject,:);
        path_nii = sprintf('%ssub_%02i/epi4/',dir_nii,subject);
        mkdirp(path_nii);
        dicm2nii(path_dcm,path_nii,'.nii');
        delete([path_nii,'dcmHeaders.mat']);
        file_from = sprintf('%sep2d_64mx_3_5mm_TE_30ms.nii',path_nii);
        file_to   = sprintf('%simages_ep2dP2RUN3.nii',path_nii);
        movefile(file_from,file_to);
    end
    
    function convert_epi4_4()
        path_dcm = dir_dcm_epis4_4(i_subject,:);
        path_nii = sprintf('%ssub_%02i/epi4/',dir_nii,subject);
        mkdirp(path_nii);
        dicm2nii(path_dcm,path_nii,'.nii');
        delete([path_nii,'dcmHeaders.mat']);
        file_from = sprintf('%sep2d_64mx_3_5mm_TE_30ms.nii',path_nii);
        file_to   = sprintf('%simages_ep2dP2RUN4.nii',path_nii);
        movefile(file_from,file_to);
    end
    
    function convert_epi4_5()
        path_dcm = dir_dcm_epis4_5(i_subject,:);
        path_nii = sprintf('%ssub_%02i/epi4/',dir_nii,subject);
        mkdirp(path_nii);
        dicm2nii(path_dcm,path_nii,'.nii');
        delete([path_nii,'dcmHeaders.mat']);
        file_from = sprintf('%sep2d_64mx_3_5mm_TE_30ms.nii',path_nii);
        file_to   = sprintf('%simages_ep2dP2RUN5.nii',path_nii);
        movefile(file_from,file_to);
    end
    
end