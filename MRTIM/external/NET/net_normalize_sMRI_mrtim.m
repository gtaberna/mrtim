function net_normalize_sMRI_mrtim(structural_file,template,tpm,optnorm)

[dd ff ext]=fileparts(structural_file);

output_directory=[dd filesep 'tmp'];

if isdir(output_directory)
    rmdir(output_directory,'s');   
end
mkdir(output_directory);

copyfile(structural_file,[output_directory filesep 'mstructural3D.nii'],'f');

optmrf = optnorm.mrf;
optclean = optnorm.cleanup;

spm('defaults', 'FMRI');
spm_jobman('initcfg'); 


[bb_t,vox_t]=net_world_bb([template ',1']);

[bb_i,vox_i]=net_world_bb([output_directory filesep 'mstructural3D.nii,1']);


disp('performing first normalization step...');



spm_dir=spm('Dir');


clear matlabbatch;


matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.source = {[output_directory filesep 'mstructural3D.nii,1']};
matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.resample = {[output_directory filesep 'mstructural3D.nii,1']};
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.template = {[spm_dir filesep 'canonical' filesep 'single_subj_T1.nii,1']};
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smoref = 8;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.nits = 0;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.reg = 0.0001; %.0000000001;%0.000001;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.bb = bb_t;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.vox = vox_t;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';


spm_jobman('run',matlabbatch);


V=spm_vol([output_directory filesep 'wmstructural3D.nii,1']);
data=spm_read_vols(V);
data(data<0.05*prctile(data(:),95))=0;
spm_write_vol(V,data);



disp('performing second normalization step...');



clear matlabbatch

matlabbatch{1}.spm.spatial.preproc.channel.vols = {[output_directory filesep 'wmstructural3D.nii,1']};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = Inf;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[tpm ',1']};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[tpm ',2']};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[tpm ',3']};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[tpm ',4']};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[tpm ',5']};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[tpm ',6']};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf         = optmrf; %1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup     = optclean; %1;
matlabbatch{1}.spm.spatial.preproc.warp.reg         = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg      = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm        = 1;
matlabbatch{1}.spm.spatial.preproc.warp.samp        = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write       = [0 0];

spm_jobman('run',matlabbatch);


%------------

Vm=spm_vol([output_directory filesep 'wmstructural3D.nii,1']);
V1=spm_vol([output_directory filesep 'c1wmstructural3D.nii,1']);
V2=spm_vol([output_directory filesep 'c2wmstructural3D.nii,1']);
V3=spm_vol([output_directory filesep 'c3wmstructural3D.nii,1']);
V4=spm_vol([output_directory filesep 'c4wmstructural3D.nii,1']);
V5=spm_vol([output_directory filesep 'c5wmstructural3D.nii,1']);
datam=spm_read_vols(Vm);
datam=smooth3(datam,'gauss',5);
data1=spm_read_vols(V1);
data1=smooth3(data1,'gauss',5);
data2=spm_read_vols(V2);
data2=smooth3(data2,'gauss',5);
data3=spm_read_vols(V3);
data3=smooth3(data3,'gauss',5);
data4=spm_read_vols(V4);
data4=smooth3(data4,'gauss',5);
data5=spm_read_vols(V5);
data5=smooth3(data5,'gauss',5);
mask=zeros(size(datam));
mask(data1+data2+data3>0.5)=1;
mask2=zeros(size(datam));
mask2(datam>0.05*prctile(datam(:),95))=1;
mask3= imfill(mask2,4,'holes');
Vm.fname=[output_directory filesep 'structural3D_masked.nii'];
spm_write_vol(Vm,datam.*mask);
Vm.fname=[output_directory filesep 'structural3D_fullmask.nii'];
spm_write_vol(Vm,mask3);

vect1=datam(data1>0.5);
vect2=datam(data2>0.5);
vect3=datam(data3>0.5);
mx=max([vect1 ; vect2 ; vect3]);
nbin=1000;
base=[mx/1000:mx/(nbin-1):mx];
h1=histc(vect1,base);
h2=histc(vect2,base);
h3=histc(vect3,base);
[val,p1]=max(h1); p1=base(p1);
[val,p2]=max(h2); p2=base(p2);
[val,p3]=max(h3); p3=base(p3);
%figure; plot(base,[h1' ; h2' ; h3']);
base13=(base>p3 & base < p1);
[val,t13]=min(abs(h1(base13)-h3(base13)));
base13=find(base13);
t13=base(base13(t13));
base12=(base>p1 & base < p2);
[val,t12]=min(abs(h1(base12)-h2(base12)));
base12=find(base12);
t12=base(base12(t12));
[val,segment]=max([h1' ; h2' ; h3'],[],1);
data_bin=zeros(size(datam));
data_bin(datam>0 & datam <t13)=4;
data_bin(datam>=t13 & datam<=t12)=3;
data_bin(datam>t12)=2;
data_bin(mask==0 & mask3==0)=0;
data_bin(mask==0 & mask3==1)=1;
Vm.pinfo=[1;0;0];
Vm.dt=[4 0];
Vm.fname=[output_directory filesep 'wxstructural3D.nii'];
spm_write_vol(Vm,data_bin);


copyfile(template,[output_directory filesep 'template.nii']);


clear matlabbatch

matlabbatch{1}.spm.spatial.coreg.write.ref = {[tpm ',1']};
matlabbatch{1}.spm.spatial.coreg.write.source = {[output_directory filesep 'template.nii']};
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 1;
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';

spm_jobman('run',matlabbatch);


Vm=spm_vol([output_directory filesep 'rtemplate.nii']);
V1=spm_vol([tpm ',1']);
V2=spm_vol([tpm ',2']);
V3=spm_vol([tpm ',3']);
V4=spm_vol([tpm ',4']);
V5=spm_vol([tpm ',5']);
datam=spm_read_vols(Vm);
datam=smooth3(datam,'gauss',5);
data1=spm_read_vols(V1);
data1=smooth3(data1,'gauss',5);
data2=spm_read_vols(V2);
data2=smooth3(data2,'gauss',5);
data3=spm_read_vols(V3);
data3=smooth3(data3,'gauss',5);
data4=spm_read_vols(V4);
data4=smooth3(data4,'gauss',5);
data5=spm_read_vols(V5);
data5=smooth3(data5,'gauss',5);
mask=zeros(size(datam));
mask(data1+data2+data3>0.5)=1;
mask2=zeros(size(datam));
mask2(datam>0.05*prctile(datam(:),95))=1;
mask3= imfill(mask2,4,'holes');
Vm.fname=[output_directory filesep 'mni_mask_in.nii'];
Vm.pinfo=[1;0;0];
Vm.dt=[2 0];
spm_write_vol(Vm,mask);
Vm.fname=[output_directory filesep 'mni_mask_out.nii'];
Vm.pinfo=[1;0;0];
Vm.dt=[2 0];
spm_write_vol(Vm,mask3);

vect1=datam(data1>0.5 & datam>0);
vect2=datam(data2>0.5 & datam>0);
vect3=datam(data3>0.5 & datam>0);
mx=max([vect1 ; vect2 ; vect3]);
nbin=1000;
base=[mx/1000:mx/(nbin-1):mx];
h1=histc(vect1,base);
h2=histc(vect2,base);
h3=histc(vect3,base);
[val,p1]=max(h1); p1=base(p1);
[val,p2]=max(h2); p2=base(p2);
[val,p3]=max(h3); p3=base(p3);
%figure; plot(base,[h1' ; h2' ; h3']);
base13=(base>p3 & base < p1);
[val,t13]=min(abs(h1(base13)-h3(base13)));
base13=find(base13);
t13=base(base13(t13));
base12=(base>p1 & base < p2);
[val,t12]=min(abs(h1(base12)-h2(base12)));
base12=find(base12);
t12=base(base12(t12));
[val,segment]=max([h1' ; h2' ; h3'],[],1);
data_bin=zeros(size(datam));
data_bin(datam>0 & datam <t13)=4;
data_bin(datam>=t13 & datam<=t12)=3;
data_bin(datam>t12)=2;
data_bin(mask==0 & mask3==0)=0;
data_bin(mask==0 & mask3==1)=1;
Vm.pinfo=[1;0;0];
Vm.dt=[4 0];
Vm.fname=[output_directory filesep 'xtemplate.nii'];
spm_write_vol(Vm,data_bin);






disp('performing second normalization...');





clear matlabbatch;


matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.source = {[output_directory filesep 'wxstructural3D.nii,1']};
matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
matlabbatch{1}.spm.tools.oldnorm.estwrite.subj.resample = {
    [output_directory filesep 'wmstructural3D.nii,1']
    [output_directory filesep 'wxstructural3D.nii,1']
    };
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.template = {[output_directory filesep 'xtemplate.nii,1']};
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smoref = 8;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 18; %12
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.nits = 1;
matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.reg = 0.01; %.0.01;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.bb = bb_t;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.vox = vox_t;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';


spm_jobman('run',matlabbatch);


disp('performing third normalization step...');


clear matlabbatch

matlabbatch{1}.spm.spatial.preproc.channel.vols = {[output_directory filesep 'wwmstructural3D.nii,1']};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = Inf;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[tpm ',1']};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[tpm ',2']};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[tpm ',3']};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[tpm ',4']};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[tpm ',5']};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[tpm ',6']};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf         = optmrf; %1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup     = optclean; %1;
matlabbatch{1}.spm.spatial.preproc.warp.reg         = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg      = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm        = 1;
matlabbatch{1}.spm.spatial.preproc.warp.samp        = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write       = [1 1];

spm_jobman('run',matlabbatch);



clear matlabbatch

matlabbatch{1}.spm.util.defs.comp{1}.def = {[output_directory filesep  'iy_wwmstructural3D.nii']};
matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {[output_directory filesep 'wwmstructural3D.nii']};
matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.push.fov.bbvox.bb = bb_t;
matlabbatch{1}.spm.util.defs.out{1}.push.fov.bbvox.vox = vox_t;
matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.push.prefix = 'w';

spm_jobman('run',matlabbatch);



V=spm_vol([output_directory filesep 'wwwmstructural3D.nii,1']);
data=spm_read_vols(V);
mask=zeros(size(data));
mask(data>0.05*prctile(data(:),95))=1;
mask2=imfill(mask,4,'holes');
spm_write_vol(V,data.*mask2);


disp('combining deformations to derive total direct and inverse transformations...');

clear matlabbatch

matlabbatch{1}.spm.util.defs.comp{1}.sn2def.matname = {[output_directory filesep  'mstructural3D_sn.mat']};
matlabbatch{1}.spm.util.defs.comp{1}.sn2def.vox = vox_i;
matlabbatch{1}.spm.util.defs.comp{1}.sn2def.bb = 2*bb_i; 
matlabbatch{1}.spm.util.defs.comp{2}.sn2def.matname = {[output_directory filesep  'wxstructural3D_sn.mat']};
matlabbatch{1}.spm.util.defs.comp{2}.sn2def.vox = vox_i;
matlabbatch{1}.spm.util.defs.comp{2}.sn2def.bb = 2*bb_i;                                             
matlabbatch{1}.spm.util.defs.comp{3}.def = {[output_directory filesep 'y_wwmstructural3D.nii']};
matlabbatch{1}.spm.util.defs.out{1}.savedef.ofname = 'to_subj';
matlabbatch{1}.spm.util.defs.out{1}.savedef.savedir.saveusr = {output_directory};

spm_jobman('run',matlabbatch);



clear matlabbatch

matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.def = {[output_directory filesep  'y_to_subj.nii']};
matlabbatch{1}.spm.util.defs.comp{1}.inv.space = {[output_directory filesep  'mstructural3D.nii']};
matlabbatch{1}.spm.util.defs.out{1}.savedef.ofname = 'to_mni';
matlabbatch{1}.spm.util.defs.out{1}.savedef.savedir.saveusr = {output_directory};


spm_jobman('run',matlabbatch);



disp('cleaning up temporary files...');


copyfile([output_directory filesep 'wwwmstructural3D.nii'],[dd filesep ff '_mni' ext]);
copyfile([output_directory filesep 'y_to_mni.nii'],[dd filesep 'iy_' ff ext]);
copyfile([output_directory filesep 'y_to_subj.nii'],[dd filesep 'y_' ff ext]);



rmdir(output_directory,'s');

  