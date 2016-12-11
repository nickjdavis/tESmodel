function Slice = tESmodel_getImageData (gmfile)

GMvol = spm_vol(gmfile);
GMimg = spm_read_vols (GMvol);
Slice = rot90(squeeze(GMimg(:,150,:)));


% SAVE FOR LATER - SKULL IMAGE
%{
skfile = '.\data\c4sHive_03-0301-00003-000001-01_1.nii';
SKvol = spm_vol(skfile);
SKimg = spm_read_vols (SKvol);
Skull = rot90(squeeze(SKimg(:,150,:)));
%}