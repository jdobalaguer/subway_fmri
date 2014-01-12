%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% batch script zur automatisierten Vorverarbeitung von fMRT-Daten mit SPM8
% modified from spm5 script (fimlab, 05/2007) by CS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = preprocessing()

    disp(' ')
    disp('dont forget to check results of each processing step!')
    disp(' ')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     GENERAL SETTINGS    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DIRECTORIES

    spm_dir = ['/users/christianeahlheim/MATLAB/spm8/'];
    study_dir = ['/Volumes/bigbipsy/cahlheim/hossa/'];

    topdir = study_dir; 

    subject_dir = ['2022*';'2251*'];

    runs_dir = ['/Volumes/bigbipsy/cahlheim/hossa/fmri/raw/bold']; 
    % runs_dir = ['Session2\emoreg\epis\run1'; 'Session2\emoreg\epis\run2'; 'Session2\emoreg\epis\run3'; 'Session2\emoreg\epis\run4']; 
    %runs_dir = [fullfile('epis','run1');fullfile('epis','run2');fullfile('epis','run3');fullfile('epis','run4')];
    anatomy_dir = ['/Volumes/bigbipsy/cahlheim/hossa/fmri/raw/2d'];
    highRes_dir = ['/Volumes/bigbipsy/cahlheim/hossa/fmri/raw/anat'];



    % FILES
    %highres_file = 's192.img';
    %lowres_file = 's001.img,1';
    %meanepi_file ='meanuf001.img';
    template_for_normalise_file = 'templates/T1.nii,1';
    param_for_normalise_file = 's192_seg_sn.mat'; %use segemented parameters!
    epitemplate_for_normalise_file = 'templates/EPI.nii,1';


    % PATHS AND FILES FOR UNWARP:
    %vdm_dir = fullfile('Session2','affflanker','epis','fieldmap','fieldmap2'); %LOCATION OF VDM FILES
    % vdm = {'vdm5_scf001_session1.img', 'vdm5_scf001_session2.img'}; %VDM FILE NAME per run
    % vdm = {'vdm5_scf001_session1.img', 'vdm5_scf001_session2.img',  'vdm5_scf001_session3.img',  'vdm5_scf001_session4.img'};
    %vdm = {'vdm5_scf001.img'};

    % wei� nicht ob das stimm, oder ob man f�r alle 4 runs, die
                    % allgemeine VDM File (ohne "utest") nehmen sollte?!
                    % unwarp erstmal auskommentiert (h�ngt scheinbar mit
                    % realignment zusammen, s.u.)


    % VARIABLES
    number_subjects = size(subject_dir, 1); 
    %number_runs = size(runs_dir, 1);        was sagen mir die runs? wie viele
    %sessions pro subject?

    % PARAMETERS
    number_slices = 28;
    TR = 2;
    ref_slice = number_slices/2; %d.h. 14. slice von unten
    %slice_order = [1:2:38 2:2:37];  % interleaved 
    slice_order = [number_slices:-1:1]; % desending
    timegap = 0; 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     JOBS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % !!! IMPORTANT !!! >>> SET PREFIX!

    tic
    realignment('')
    %realign_unwarp('') %schreibt ein 'u' vor die files %!!!
    slicetiming('u')
    %coregistration_meanepi_lowres('a')
    %coregistration_epi_highres('a')
    coregistration_highres_meanepi('au')
    segmentation()
    %normalise_111_anatomy('') %not used for normwrite epi when segment is done
    write_333_epis('au')
    write_333_meanepi('')
    %normalise_333_epis_template('au')
    %write_333_anatomy_meanepi('a')
    smoothing('wau')
toc
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	REALIGNMENT: Estimate and Write
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = realignment(prefix)

    for i = 1:number_subjects

        disp('Realignment for: ')
        disp(subject_dir(i,:))

        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.quality = 0.9; % Quality (Default: 0.9)
        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.sep = 6; % Separation (Default: 4) 
        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.fwhm = 5; % Smoothing (FWHM) (Default: 5)
        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.rtm = 1; % Num Passes (Default: Register to mean) 
        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.interp = 4; % Interpolation (Default: 2nd Degree B-Spline)
        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
        jobs{1}.spatial{1}.realign{1}.estwrite.eoptions.weight = {}; % Weighting (Default: None) 

        jobs{1}.spatial{1}.realign{1}.estwrite.roptions.which = [0 1]; % Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image) 
        jobs{1}.spatial{1}.realign{1}.estwrite.roptions.interp = 5; % Interpolation (Default: 4th Degree B-Spline) 
        jobs{1}.spatial{1}.realign{1}.estwrite.roptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
        jobs{1}.spatial{1}.realign{1}.estwrite.roptions.mask = 1; % Masking (Default: Mask images) 

    end

        for j = 1:number_runs
            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:)); 
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$');
            filenames_for_realign{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 
            jobs{1}.spatial{1}.realign{1}.estwrite.data(j) = cellstr(filenames_for_realign{j});
        end % end j loop

        spm_jobman('run', jobs);
        clear jobs

    end % end i loop
    disp('Realignment done')

end % end function realignment


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % REALIGN & UNWARP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Einstellungen hab ich einfach von REALIGN �bernommen, abgesehen von vdm
    %files nat�rlich
function [] = realign_unwarp(prefix)

    for i = 1:number_subjects 

        disp('Realign and Unwarp for: ')
        disp(subject_dir(i,:))

        jobs{1}.spatial{1}.realignunwarp.eoptions.quality = 0.9; % Quality (Default: 0.9)
        jobs{1}.spatial{1}.realignunwarp.eoptions.sep = 6; % Separation (Default: 4) 
        jobs{1}.spatial{1}.realignunwarp.eoptions.fwhm = 5; % Smoothing (FWHM) (Default: 5)
        jobs{1}.spatial{1}.realignunwarp.eoptions.rtm = 1;% Num Passes (Default: Register to mean) 
        jobs{1}.spatial{1}.realignunwarp.eoptions.einterp = 4;% Interpolation (Default: 2nd Degree B-Spline)
        jobs{1}.spatial{1}.realignunwarp.eoptions.ewrap = [0 0 0]; % Wrapping (Default: No wrap) 
        jobs{1}.spatial{1}.realignunwarp.eoptions.weight = {}; % Weighting (Default: None) {''};
        jobs{1}.spatial{1}.realignunwarp.uwroptions.uwwhich = [2 1];% Resliced Images ([0 1] > Only Mean Image; Default: [2 1] > All Images + Mean Image)       
                            % Bei UNWARP gibt es nur die Optionen "Alle Images"
                            % oder "Alle Images + MEAN". Man muss also direkt
                            % schreiben. Stimmt dann die Reihenfolge mit
                            % slice-timing nocH?
        jobs{1}.spatial{1}.realignunwarp.uwroptions.rinterp = 5;% Interpolation (Default: 4th Degree B-Spline) 
        jobs{1}.spatial{1}.realignunwarp.uwroptions.wrap = [0 0 0]; % Wrapping (Default: No wrap) 
        jobs{1}.spatial{1}.realignunwarp.uwroptions.mask = 1; % Masking (Default: Mask images) 

        %Die Einstellungen hier drunter wei� ich nicht, habe ich von Batch die
        %Defaults �bernommen
        jobs{1}.spatial{1}.realignunwarp.uweoptions.basfcn = [12 12];
        jobs{1}.spatial{1}.realignunwarp.uweoptions.regorder = 1;
        jobs{1}.spatial{1}.realignunwarp.uweoptions.lambda = 100000;
        jobs{1}.spatial{1}.realignunwarp.uweoptions.jm = 0;
        jobs{1}.spatial{1}.realignunwarp.uweoptions.fot = [4 5];
        jobs{1}.spatial{1}.realignunwarp.uweoptions.sot = [];
        jobs{1}.spatial{1}.realignunwarp.uweoptions.uwfwhm = 4;
        jobs{1}.spatial{1}.realignunwarp.uweoptions.rem = 1;
        jobs{1}.spatial{1}.realignunwarp.uweoptions.noi = 5;
        jobs{1}.spatial{1}.realignunwarp.uweoptions.expround = 'Average';
        jobs{1}.spatial{1}.realignunwarp.uwroptions.prefix = 'u';

        for j = 1:number_runs
            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:)); 
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$');  %for all filters: use prefix of your rawdata_t1coreg
            filenames_for_realign{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 
            jobs{1}.spatial{1}.realignunwarp.data(j).scans = cellstr(filenames_for_realign{j}); %(j)
            jobs{1}.spatial{1}.realignunwarp.data(j).pmscan = {fullfile(study_dir,subject_dir(i,:),vdm_dir,vdm{j})};
        end % end j loop


        spm_jobman('run', jobs); %!!!
        clear jobs

    end % end i loop
    disp('Realign & Unwarp done')

end % end function realign & unwarp
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	SLICE TIMING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = slicetiming(prefix)

    for i = 1:number_subjects

        disp('Slice-Timing for: ')
        disp(subject_dir(i,:))

        jobs{1}.temporal{1}.st.nslices = number_slices; % Number of Slices: 
        jobs{1}.temporal{1}.st.refslice = ref_slice; % Reference Slice
        jobs{1}.temporal{1}.st.so = slice_order; % Slice order
        jobs{1}.temporal{1}.st.tr =TR; % TR
        jobs{1}.temporal{1}.st.ta = (TR - timegap) - ((TR - timegap) / number_slices); % TA = TR-(TR/nslices), MIND THE GAP!

        for j = 1:number_runs
            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:)); 
            disp(epi_dir)
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$')
            filenames_for_st{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 
            jobs{1}.temporal{1}.st.scans{j} = cellstr(filenames_for_st{j});

        end % end j loop

        spm_jobman('run', jobs);
        clear jobs

    end % end i loop
    disp('End of the Slice Timing')

end % end function slicetiming

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % 	COREGISTRATION: Estimate I (Meanepi to lowres)
    % no lowres here .. skip that
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    % function [] = coregistration_meanepi_lowres(prefix)
    % 
    % for i=1:number_subjects
    % 
    %     disp('Coregistration (Meanepi to Lowres) for: ')
    %     disp(subject_dir(i,:))
    %     
    %     meanepi_dir = [study_dir, subject_dir(i,:), '/tasdt/epis/run1'];
    %     lowres_dir = [study_dir, subject_dir(i,:), '/tasdt/anatomy/lowres'];
    %     highres_dir = [study_dir, subject_dir(i,:), '/tasdt/anatomy/highres'];
    %     
    %     jobs{1}.spatial{1}.coreg{1}.estimate.ref = {[lowres_dir filesep lowres_file]};
    %     jobs{1}.spatial{1}.coreg{1}.estimate.source = {[meanepi_dir filesep meanepi_file]};
    %     
    %     jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.cost_fun = 'nmi';
    %     jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.sep = [4 2];
    %     jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
    %     jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.fwhm = [7 7];
    %     
    %     for j=1:number_runs
    %         epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:));
    %         spm_select('clearvfiles');
    %         [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$')
    %         filenames_for_coreg{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 
    %     end % end j loop
    %          
    %     jobs{1}.spatial{1}.coreg{1}.estimate.other = cellstr(strvcat(filenames_for_coreg));
    %     
    %     spm_jobman('run',jobs);
    %     clear jobs
    % 
    % end  % end i loop  
    % disp('Coregistration (Meanepi to Lowres) done')
    % 
    % end % end function coregistration


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	COREGISTRATION: Estimate I (Meanepi (& all other epis) to Highres)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = coregistration_epi_highres(prefix)

    for i=1:number_subjects

        disp('Coregistration for: ')
        disp(subject_dir(i,:))

        meanepi_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/epis/run1'];
        highres_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/anatomy'];

        jobs{1}.spatial{1}.coreg{1}.estimate.ref = {[highres_dir filesep highres_file]};
        jobs{1}.spatial{1}.coreg{1}.estimate.source = {[meanepi_dir filesep meanepi_file]};

        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.cost_fun = 'nmi';
        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.sep = [4 2];
        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.fwhm = [7 7];

        for j=1:number_runs
            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:));
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$')
            filenames_for_coreg{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 
        end % end j loop

        jobs{1}.spatial{1}.coreg{1}.estimate.other = cellstr(strvcat(filenames_for_coreg));

        spm_jobman('run',jobs);
        clear jobs

    end  % end i loop  
    disp('Coregistration done')

end % end function coregistration



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	COREGISTRATION: Estimate I  (Highres to meanepi)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = coregistration_highres_meanepi(prefix)

    for i=1:number_subjects

        disp('Coregistration for: ')
        disp(subject_dir(i,:))

        meanepi_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/epis/run1'];
        highres_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/anatomy'];

        jobs{1}.spatial{1}.coreg{1}.estimate.ref = {[meanepi_dir filesep meanepi_file]};
        jobs{1}.spatial{1}.coreg{1}.estimate.source = {[highres_dir filesep highres_file]};

        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.cost_fun = 'nmi';
        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.sep = [4 2];
        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.tol = [0.0200 0.0200 0.0200 0.0010 0.0010 0.0010 0.0100 0.0100 0.0100 0.0010 0.0010 0.0010];
        jobs{1}.spatial{1}.coreg{1}.estimate.eoptions.fwhm = [7 7];
    % 
    %     for j=1:number_runs
    %         epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:));
    %         spm_select('clearvfiles');
    %         [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$')
    %         filenames_for_coreg{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 
    %     end % end j loop
    %          
    %     jobs{1}.spatial{1}.coreg{1}.estimate.other = cellstr(strvcat(filenames_for_coreg));
        jobs{1}.spatial{1}.coreg{1}.estimate.other =  {''};

        spm_jobman('run',jobs);
        clear jobs

    end  % end i loop  
    disp('Coregistration done')

end % end function coregistration
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   SEGMENTATION SETTINGS                  %
    % Note that if we segment, a file with normztn parameters  %
    % is produced (*seg_sn.mat; see SPM5 manual p. 38, Â§5.2)   %
    % so we do not need to have a normalize.estimate component %
    %                                                          %
    %            these are all default settings                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = segmentation()

    for i=1:number_subjects
        disp('Segmentation will start for: ')
        disp(subject_dir(i,:))

        source_image_dir = [study_dir, subject_dir(i,:) filesep anatomy_dir];

        % Output files	
        jobs{1}.spatial{1}.preproc.output.GM = [0 0 1]; % GM: Grey Matter, hier Modulated Normalised
        jobs{1}.spatial{1}.preproc.output.WM = [0 0 1]; % WM: White Matter, hier Modulated Normalised
        jobs{1}.spatial{1}.preproc.output.CSF = [0 0 0]; % CSF: Cerebro-Spinal Fluid, hier None
        jobs{1}.spatial{1}.preproc.output.biascor = 1; % Bias corrected
        jobs{1}.spatial{1}.preproc.output.cleanup = 2; % don´t do cleanup of any partitions

        % Tissue Probability maps	
        jobs{1}.spatial{1}.preproc.opts.tpm{1,1} = [spm_dir, 'tpm' filesep 'grey.nii'];
        jobs{1}.spatial{1}.preproc.opts.tpm{2,1} = [spm_dir,'tpm',filesep,'white.nii'];
        jobs{1}.spatial{1}.preproc.opts.tpm{3,1} = [spm_dir,'tpm',filesep,'csf.nii'];

        jobs{1}.spatial{1}.preproc.opts.ngaus = [2 2 2 4]; % Gaussians per class
        jobs{1}.spatial{1}.preproc.opts.regtype = 'mni'; % ICBM space template - European Brains
        jobs{1}.spatial{1}.preproc.opts.warpreg = 1; % Warping Regularisation
        jobs{1}.spatial{1}.preproc.opts.warpco = 25; % Warp Frequency Cutoff
        jobs{1}.spatial{1}.preproc.opts.biasreg = .01; % Very light regularisation
        % regularization = how much divergence from the normalization template to tolerate.
        jobs{1}.spatial{1}.preproc.opts.biasfwhm = 60; % 60mm cutoff
        jobs{1}.spatial{1}.preproc.opts.samp = 3; % sample distance

        jobs{1}.spatial{1}.preproc.opts.msk{1} = ''; % Masking image, hier None


        % The Image file to be segmented	
        jobs{1}.spatial{1}.preproc.data = {[source_image_dir filesep highres_file]};

        % Execute the job (Segmentation)
        spm_jobman('run',jobs);
        clear jobs
    end % End of i-loop
    disp('Segmentation finished');

end % End of function segmentation()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	NORMALISE (Estimate and Write for HIGHRES)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = normalise_111_anatomy(prefix)

    for i=1:number_subjects

        disp('Normalise Anatomy for: ')
        disp(subject_dir(i,:))

        highres_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/anatomy']; 

        jobs{1}.spatial{1}.normalise{1}.estwrite.subj.source = {[highres_dir filesep highres_file]}; % Image to estimate warping parameters: HIGHRES
        jobs{1}.spatial{1}.normalise{1}.estwrite.subj.wtsrc = {}; % Source Weighting Image: None
        jobs{1}.spatial{1}.normalise{1}.estwrite.subj.resample = {[highres_dir filesep highres_file]}; % Images to write according to warping parameters: HIGHRES

        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.template = {[spm_dir template_for_normalise_file]}; % Template Image
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.weight = {}; % Template Weighting Imaging, Default: None
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.smosrc = 8;  % Source Image Smoothing, Default: 8
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.smoref = 0;  % Template Image Smoothing, Default: 0
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.regtype = 'mni'; % Affine Regularisation, Default: ICBM/MNI Space Template
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.cutoff = 25; % Nonlinear Frequency Cutoff, Default: 25
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.nits = 16; % Nonlinear Iterations, Default: 16
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.reg = 1; % Nonlinear Regularisation, Default: 1

        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.preserve = 0; % Default: 0 = Preserve Concentrations
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.bb = [-78 -112 -50;78 76 85]; % Bounding Box
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.vox = [1 1 1]; % Voxel Sizes [2 2 2] is default
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.interp = 7;    % Interpolation (Default: 1)
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.wrap = [0 0 0]; % Wrapping, 0: No

        spm_jobman('run',jobs);
        clear jobs

    end % end i loop
    disp('Normalise Highres [1 1 1] done')

end % end function normalise_111_anatomy


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	NORMALISE (Write EPIS)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = write_333_epis(prefix)

    for i = 1:number_subjects

        disp('Writing the normalized epis for ')
        disp(subject_dir(i,:))

        %lowres_dir = [study_dir, subject_dir(i,:), '/tasdt/anatomy/lowres'];
        highres_dir =[study_dir, subject_dir(i,:), filesep anatomy_dir];
        meanepi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(1,:)); 

        jobs{1}.spatial{1}.normalise{1}.write.roptions.preserve = 0;
        jobs{1}.spatial{1}.normalise{1}.write.roptions.bb = [-78 -112 -50;78 76 85];
        jobs{1}.spatial{1}.normalise{1}.write.roptions.vox = [3 3 3];
        jobs{1}.spatial{1}.normalise{1}.write.roptions.interp = 7;% (Default: 1)
        jobs{1}.spatial{1}.normalise{1}.write.roptions.wrap = [0 0 0];

        for j = 1:number_runs

            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:));
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$')
            filenames_for_normalise{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}); 

        end % end j loop

        jobs{1}.spatial{1}.normalise{1}.write.subj.matname = {[highres_dir filesep param_for_normalise_file]}; % '_sn.mat' containing spatial normalisation parameters
         jobs{1}.spatial{1}.normalise{1}.write.subj.resample = cellstr(strvcat(filenames_for_normalise));%{filenames_for_normalise}; % LOWRES anatomy + meanEpi + Epis
        spm_jobman('run', jobs); 
        clear jobs

    end % end i loop
    disp('Normalise  Epis [3 3 3] done')

end % end function write_333_epis

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	NORMALISE (Write MEANEPI)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = write_333_meanepi(prefix)

    for i = 1:number_subjects

        disp('Writing the normalized meanepi Image for ')
        disp(subject_dir(i,:))

        highres_dir = [study_dir, subject_dir(i,:), filesep anatomy_dir];
        meanepi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(1,:));
       % meanepi_dir = [study_dir, subject_dir(i,:), '/tas/epis/run1'];

        jobs{1}.spatial{1}.normalise{1}.write.roptions.preserve = 0;
        jobs{1}.spatial{1}.normalise{1}.write.roptions.bb = [-78 -112 -50;78 76 85];
        jobs{1}.spatial{1}.normalise{1}.write.roptions.vox = [3 3 3];
        jobs{1}.spatial{1}.normalise{1}.write.roptions.interp = 7;% (Default: 1)
        jobs{1}.spatial{1}.normalise{1}.write.roptions.wrap = [0 0 0];

      %  for j = 1 %meanepi in first run


            spm_select('clearvfiles');
            [raw_func_filenames{1}, dirs] = spm_select('List', meanepi_dir, '^mean.*\.img$')
            filenames_for_normalise{1} = strcat(meanepi_dir,filesep,prefix,raw_func_filenames{1}); 

        %end % end j loop

        jobs{1}.spatial{1}.normalise{1}.write.subj.matname = {[highres_dir filesep param_for_normalise_file]}; % '_sn.mat' containing spatial normalisation parameters
         jobs{1}.spatial{1}.normalise{1}.write.subj.resample = cellstr(strvcat(filenames_for_normalise));%{filenames_for_normalise}; % LOWRES anatomy + meanEpi + Epis
        spm_jobman('run', jobs); 
        clear jobs

    end % end i loop
    disp('Normalise  meanepi [3 3 3] done')

end % end function write_333_meanepi

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	NORMALISE (Estimate and Write for EPIS with EPI-template)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] =normalise_333_epis_template(prefix)
    [source_image_dir filesep highres_file]
    for i=1:number_subjects

        disp('Normalise epis to epi template for: ')
        disp(subject_dir(i,:))

        highres_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/anatomy']; 
        meanepi_dir = [study_dir, subject_dir(i,:), '/Session2/affflanker/epis/run1'];

        jobs{1}.spatial{1}.normalise{1}.estwrite.subj.source = {[meanepi_dir filesep meanepi_file]}; % Image to estimate warping parameters for: HIGHRES
        jobs{1}.spatial{1}.normalise{1}.estwrite.subj.wtsrc = {}; % Source Weighting Image: None
        %jobs{1}.spatial{1}.normalise{1}.estwrite.subj.resample = {[highres_dir filesep highres_file]}; % Images to write according to warping parameters: HIGHRES

        for j = 1:number_runs

            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:));
            anatomy_sbjdir = fullfile(topdir, subject_dir(i,:), anatomy_dir);
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$')
            filenames_for_normalise{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j}) ; 
          %  filenames_for_normalise_array = strvcat(filenames_for_normalise);
           % anatomy_file = strcat(anatomy_sbjdir,filesep, highres_file);
            %all_files = strvcat(filenames_for_normalise, anatomy_file);

        end % end j loop
        jobs{1}.spatial{1}.normalise{1}.estwrite.subj.resample = cellstr(strvcat(filenames_for_normalise))
       %  jobs{1}.spatial{1}.normalise{1}.estwrite.subj.resample = cellstr(filenames_for_normalise_array, anatomy_file)

        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.template = {[spm_dir epitemplate_for_normalise_file]}; % Template Image
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.weight = {}; % Template Weighting Imaging, Default: None
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.smosrc = 8;  % Source Image Smoothing, Default: 8
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.smoref = 0;  % Template Image Smoothing, Default: 0
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.regtype = 'mni'; % Affine Regularisation, Default: ICBM/MNI Space Template
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.cutoff = 25; % Nonlinear Frequency Cutoff, Default: 25
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.nits = 16; % Nonlinear Iterations, Default: 16
        jobs{1}.spatial{1}.normalise{1}.estwrite.eoptions.reg = 1; % Nonlinear Regularisation, Default: 1

        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.preserve = 0; % Default: 0 = Preserve Concentrations
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.bb = [-78 -112 -50;78 76 85]; % Bounding Box
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.vox = [3 3 3]; % Voxel Sizes [2 2 2] is default
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.interp = 7;    % Interpolation (Default: 1)
        jobs{1}.spatial{1}.normalise{1}.estwrite.roptions.wrap = [0 0 0]; % Wrapping, 0: No

        spm_jobman('run',jobs);
        clear jobs

    end % end i loop
    disp('Normalise epis [3 3 3] done')

end % end function normalise_111_anatomy


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 	SMOOTH
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = smoothing(prefix)

    for i = 1:number_subjects

        disp('Smoothing for: ')
        disp(subject_dir(i,:))

        jobs{1}.spatial{1}.smooth.fwhm = [8 8 8]; % FWHW, Default: 8 8 8
        jobs{1}.spatial{1}.smooth.type = 0; % data_t1coreg type, Default: Same

        for j = 1:number_runs
            epi_dir = fullfile(topdir, subject_dir(i,:), runs_dir(j,:)); 
            spm_select('clearvfiles');
            [raw_func_filenames{j}, dirs] = spm_select('List', epi_dir, '^f.*\.img$');
            filenames_for_smooth{j} = strcat(epi_dir,filesep,prefix,raw_func_filenames{j});          

        end % end j loop

        jobs{1}.spatial{1}.smooth.data = cellstr(strvcat(filenames_for_smooth));

        spm_jobman('run',jobs);
        clear jobs

    end % end i loop

    disp('Smoothing done');

end % end function smoothing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%