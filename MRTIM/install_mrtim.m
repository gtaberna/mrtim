function install_mrtim()

fprintf([ ...
    '\n' ...
    '================================================== \n' ...
    ' __   __  ______           _______  ___   __   __ \n' ...
    '|  |_|  ||    _ |         |       ||   | |  |_|  | \n' ...
    '|       ||   | ||   ____  |_     _||   | |       | \n' ...
    '|       ||   |_||_ |____|   |   |  |   | |       | \n' ...
    '|       ||    __  |         |   |  |   | |       | \n' ...
    '| ||_|| ||   |  | |         |   |  |   | | ||_|| | \n' ...
    '|_|   |_||___|  |_|         |___|  |___| |_|   |_|   v2.1\n' ...
    '\n    * MR-BASED HEAD TISSUE MODELLING Toolbox * \n' ...
    '================================================== \n \n' ...
    ]);

fprintf(':: MR-TIM INSTALLATION :: \n');

mrtim_folder = fileparts(mfilename('fullpath'));

confirm = 0;
while confirm == 0
    valid_confirm = 0;
    fprintf('\nChoose SPM12 main folder... \n\n');
    spm_folder = 0;
    while spm_folder == 0
        if exist('spm','file')
            spm_folder = uigetdir(spm('Dir'));
        else
            spm_folder = uigetdir();
        end
    end
    fprintf(['Selected folder:\n' spm_folder '\n\n']);
    
    while valid_confirm == 0
        str_confirm = input('Confirm your choice (''y/Y''), select another folder (''n/N'') or quit installation (''q/Q''): ','s');
        if strcmpi(str_confirm,'y')
            confirm = 1;
            valid_confirm = 1;
        elseif strcmpi(str_confirm,'n')
            confirm = 0;
            valid_confirm = 1;
        elseif strcmpi(str_confirm,'q')
            confirm = 2;
            fprintf('\n:: MR-TIM toolbox NOT installed. ::\n');
            break
        else
            fprintf('\nInput not valid. \n');
        end
    end
end

if confirm == 1
    toolbox_folder = [spm_folder filesep 'toolbox' filesep 'MRTIM'];
    if ~exist(toolbox_folder,'dir')
        mkdir(toolbox_folder);
    end
    movefile([mrtim_folder filesep '*'],toolbox_folder);
    addpath(genpath(spm_folder));
    fprintf(['\n:: MR-TIM toolbox successfully INSTALLED! ::\n' ...
        ':: ' toolbox_folder ' ::\n\n']);
end