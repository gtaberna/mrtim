function spm_mrtim = tbx_cfg_mrtim
% Configuration file for toolbox 'MRTIM'
%_______________________________________________________________________
%
% Authors: Gaia Amaranta Taberna, Dante Mantini

if ~isdeployed, addpath(fullfile(spm('dir'),'toolbox','MRTIM')); end

% ---------------------------------------------------------------------
% anat_image Individual structural MRI
% ---------------------------------------------------------------------
anat_image         = cfg_files;
anat_image.tag     = 'anat_image';
anat_image.name    = 'Individual structural MR image';
anat_image.help    = {'Select the individual structural MR image to be processed.'};
anat_image.filter = 'image';
anat_image.ufilter = '.nii';
anat_image.num     = [1 1];

% ---------------------------------------------------------------------
% odir Output directory
% ---------------------------------------------------------------------
output_folder         = cfg_files;
output_folder.tag     = 'output_folder';
output_folder.name    = 'Output directory';
output_folder.help    = {'Select the directory where the segmented image(s) will be saved.'};
output_folder.filter = 'dir';
output_folder.ufilter = '.*';
output_folder.num     = [1 1];


% ---------------------------------------------------------------------
% res Resampling (mm)
% ---------------------------------------------------------------------
res         = cfg_entry;
res.tag     = 'res';
res.name    = 'Resampling (mm)';
res.val     = {1};
res.strtype = 'r';
res.help    = {'Resampled images will have the selected voxel dimension in mm (isotropic).'};
res.num     = [1 1];

% ---------------------------------------------------------------------
% smooth Smoothing FWHM (mm)
% ---------------------------------------------------------------------
smooth         = cfg_entry;
smooth.tag     = 'smooth';
smooth.name    = 'Smoothing FWHM (mm)';
smooth.val     = {1};
smooth.strtype = 'r';
smooth.help    = {'Full width at half maximum (FWHM) of the Gaussian smoothing kernel in mm (isotropic).'};
smooth.num     = [1 1];

%--------------------------------------------------------------------------
% biasreg Bias regularisation
%--------------------------------------------------------------------------
biasreg         = cfg_menu;
biasreg.tag     = 'biasreg';
biasreg.name    = 'Bias regularisation';
biasreg.help    = {
                   'MR images are usually corrupted by a smooth, spatially varying artifact that modulates the intensity of the image (bias). These artifacts, although not usually a problem for visual inspection, can impede automated processing of the images.'
                   ''
                   'An important issue relates to the distinction between intensity variations that arise because of bias artifact due to the physics of MR scanning, and those that arise due to different tissue properties.  The objective is to model the latter by different tissue classes, while modelling the former with a bias field. We know a priori that intensity variations due to MR physics tend to be spatially smooth, whereas those due to different tissue types tend to contain more high frequency information. A more accurate estimate of a bias field can be obtained by including prior knowledge about the distribution of the fields likely to be encountered by the correction algorithm. For example, if it is known that there is little or no intensity non-uniformity, then it would be wise to penalise large values for the intensity non-uniformity parameters. This regularisation can be placed within a Bayesian context, whereby the penalty incurred is the negative logarithm of a prior probability for any particular pattern of non-uniformity.'
                   'Knowing what works best should be a matter of empirical exploration.  For example, if your data has very little intensity non-uniformity artifact, then the bias regularisation should be increased.  This effectively tells the algorithm that there is very little bias in your data, so it does not try to model it.'
                   }';
biasreg.labels = {
                  'no regularisation (0)'
                  'extremely light regularisation (0.00001)'
                  'very light regularisation (0.0001)'
                  'light regularisation (0.001)'
                  'medium regularisation (0.01)'
                  'heavy regularisation (0.1)'
                  'very heavy regularisation (1)'
                  'extremely heavy regularisation (10)'
                  }';
biasreg.values = {
                  0
                  1e-05
                  0.0001
                  0.001
                  0.01
                  0.1
                  1
                  10
                  }';
biasreg.val    = {0.001};

%--------------------------------------------------------------------------
% biasfwhm Bias FWHM
%--------------------------------------------------------------------------
biasfwhm        = cfg_menu;
biasfwhm.tag    = 'biasfwhm';
biasfwhm.name   = 'Bias FWHM';
biasfwhm.help   = {'FWHM of Gaussian smoothness of bias. If your intensity non-uniformity is very smooth, then choose a large FWHM. This will prevent the algorithm from trying to model out intensity variation due to different tissue types. The model for intensity non-uniformity is one of i.i.d. Gaussian noise that has been smoothed by some amount, before taking the exponential. Note also that smoother bias fields need fewer parameters to describe them. This means that the algorithm is faster for smoother intensity non-uniformities.'};
biasfwhm.labels = {
                   '30mm cutoff'
                   '40mm cutoff'
                   '50mm cutoff'
                   '60mm cutoff'
                   '70mm cutoff'
                   '80mm cutoff'
                   '90mm cutoff'
                   '100mm cutoff'
                   '110mm cutoff'
                   '120mm cutoff'
                   '130mm cutoff'
                   '140mm cutoff'
                   '150mm cutoff'
                   'No correction'
                   }';
biasfwhm.values = {
                   30
                   40
                   50
                   60
                   70
                   80
                   90
                   100
                   110
                   120
                   130
                   140
                   150
                   Inf
                   }';
biasfwhm.val    = {30};

% ---------------------------------------------------------------------
% lowint Low intensity threshold (%)
% ---------------------------------------------------------------------
lowint         = cfg_entry;
lowint.tag     = 'lowint';
lowint.name    = 'Low intensity threshold (%)';
lowint.val     = {5};
lowint.strtype = 'r';
lowint.help    = {'Grayscale intensities lower than this threshold are set to zero.'};
lowint.num     = [1 1];

% ---------------------------------------------------------------------
% prepro STEP 1/3 - Image pre-processing
% ---------------------------------------------------------------------
prepro         = cfg_branch;
prepro.tag     = 'prepro';
prepro.name    = 'STEP 1/3 - Image pre-processing';
prepro.val     = {res smooth biasreg biasfwhm lowint};
prepro.help    = {'The MR image is denoised and prepared for further analyses.'};


% ---------------------------------------------------------------------
% tpm_image 4-D TPM image
% ---------------------------------------------------------------------
tpmimg         = cfg_files;
tpmimg.tag     = 'tpmimg';
tpmimg.name    = 'TPM image (12 tissues)';
tpmimg.help    = {'Select the 4-D image with the 12 tissue probability maps.'
    'The default TPM image can be found in subfolder ''../external/NET/template/tissues_MNI/eTPM12.nii''.'};
tpmimg.filter = 'image';
tpmimg.ufilter = '.nii';
tpmimg.num     = [1 1];

%--------------------------------------------------------------------------
% mrf MRF Parameter
%--------------------------------------------------------------------------
mrf         = cfg_entry;
mrf.tag     = 'mrf';
mrf.name    = 'MRF Parameter';
mrf.help    = {'When tissue class images are written out, a few iterations of a simple Markov Random Field (MRF) cleanup procedure are run.  This parameter controls the strength of the MRF. Setting the value to zero will disable the cleanup.'};
mrf.strtype = 'r';
mrf.num     = [1 1];
mrf.val     = {1};

%--------------------------------------------------------------------------
% cleanup Clean up any partitions
%--------------------------------------------------------------------------
cleanup         = cfg_menu;
cleanup.tag     = 'cleanup';
cleanup.name    = 'Clean Up';
cleanup.help    = {
    'This uses a crude routine for extracting the brain from segmented images.'
    'It begins by taking the white matter, and eroding it a couple of times to get rid of any odd voxels.  The algorithm continues on to do conditional dilations for several iterations, where the condition is based upon gray or white matter being present.This identified region is then used to clean up the grey and white matter partitions.  Note that the fluid class will also be cleaned, such that aqueous and vitreous humour in the eyeballs, as well as other assorted fluid regions (except CSF) will be removed.'
    ''
    'If you find pieces of brain being chopped out in your data, then you may wish to disable or tone down the cleanup procedure. Note that the procedure uses a number of assumptions about what each tissue class refers to.  If a different set of tissue priors are used, then this routine should be disabled.'
    }';
cleanup.labels = {
                  'Dont do cleanup'
                  'Light Clean'
                  'Thorough Clean'
}';
cleanup.values = {0 1 2};
cleanup.val    = {1};

% ---------------------------------------------------------------------
% tpmopt STEP 2/3 - Tissue probability mapping
% ---------------------------------------------------------------------
tpmopt         = cfg_branch;
tpmopt.tag     = 'tpmopt';
tpmopt.name    = 'STEP 2/3 - Tissue probability mapping';
tpmopt.val     = {tpmimg mrf cleanup};
tpmopt.help    = {'Tissue probability maps in individual space are generated from the MR image.'};


% ---------------------------------------------------------------------
% gapfill Gap filling
% ---------------------------------------------------------------------
gapfill         = cfg_menu;
gapfill.tag     = 'gapfill';
gapfill.name    = 'Gap filling';
gapfill.val     = {1};
gapfill.help    = {'A maximum likelihood approach based on the TPMs is used to fill gaps after preliminary segmentation.'
    'Note that if choosing ''No'', the final segmentation could include voxels with no tissue classification (label -1).'};
gapfill.labels  = {
             'Yes'
             'No'
}';
gapfill.values  = {1 0};

% ---------------------------------------------------------------------
% tiss_mask Single-tissue masks
% ---------------------------------------------------------------------
tiss_mask         = cfg_menu;
tiss_mask.tag     = 'tiss_mask';
tiss_mask.name    = 'Single-tissue masks';
tiss_mask.val     = {0};
tiss_mask.help    = {'The single-tissue binary masks are saved in ''tissue_masks'' subfolder. One mask per tissue is created, plus a ''gap'' mask if ''Gap filling'' option is set to ''No''.'};
tiss_mask.labels  = {
             'Yes'
             'No'
}';
tiss_mask.values  = {1 0};

% ---------------------------------------------------------------------
% segtiss STEP 3/3 - Tissue segmentation
% ---------------------------------------------------------------------
segtiss         = cfg_branch;
segtiss.tag     = 'segtiss';
segtiss.name    = 'STEP 3/3 - Tissue segmentation';
segtiss.val     = {gapfill tiss_mask};
segtiss.help    = {'Information from all the tissue probability maps is integrated such that each voxel in the MR image is assigned to a specific tissue.'
    'The final output of the tissue segmentation is a 3D image named ''anatomy_prepro_segment.nii'', with voxel values in the range from 0 to 12 (from -1 to 12, if ''Gap filling'' option is set to ''No'').'};


% ---------------------------------------------------------------------
% run Run MRTIM
% ---------------------------------------------------------------------
run         = cfg_exbranch;
run.tag     = 'run';
run.name    = 'Run';
run.val     = {anat_image output_folder prepro tpmopt segtiss};
run.help    = {'MR-TIM performs head tissue modelling from structural magnetic resonance (MR) images. It automatically segments T1-weighted MR images in 12 tissues: brain gray matter (GM), cerebellar GM, brain white matter (WM), cerebellar WM, brainstem, cerebrospinal fluid, spongy bone, compact bone, muscle, fat, eyes and skin.'};
run.prog = @spm_mrtim_run;

% ---------------------------------------------------------------------
% spm_mrtim
% ---------------------------------------------------------------------
spm_mrtim         = cfg_choice;
spm_mrtim.tag     = 'spm_mrtim';
spm_mrtim.name    = 'MRTIM';
spm_mrtim.help    = {
                  'MRTIM is a SPM12 toolbox for head tissue modelling from structural magnetic resonance (MR) images. It performs automated segmentation of whole-head T1-weighted MR images in 12 tissues: brain gray matter (GM), cerebellar GM, brain white matter (WM), cerebellar WM, brainstem, cerebrospinal fluid, spongy bone, compact bone, muscle, fat, eyes and skin.'
}';
spm_mrtim.values  = {run};


