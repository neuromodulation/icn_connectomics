addpath('C:\Users\ICN_admin\Documents\wjn_toolbox')
addpath(genpath('C:\Users\ICN_admin\Documents\leaddbs'))
addpath(genpath('C:\Users\ICN_admin\Documents\spm12'))

clear all, close all, clc
root = 'C:\Users\ICN_admin\Documents\Decoding_Toolbox\Data\Analysis';
leaddbs = 'C:\Users\ICN_admin\Documents\leaddbs';
wjn_toolbox = 'C:\Users\ICN_admin\Documents\wjn_toolbox';
spm12 = 'C:\Users\ICN_admin\Documents\spm1';
icn_connectomics = 'C:\Users\ICN_admin\Documents\icn_connectomics';
addpath(spm12)
addpath(genpath(leaddbs))
addpath(wjn_toolbox)
addpath(icn_connectomics)


%% CREATE SPHERICAL ROIS FROM ELECTRODE LOCATIONS FOR ALL SUBJECTS

csvfile='df_all_3_cohorts.csv';
T=readtable(csvfile);
connectomics_dir = 'C:\Users\ICN_admin\Documents\Decoding_Toolbox\Data\Analysis\connectomics_ROI';
mkdir(connectomics_dir)

for a =1:size(T,1)
    n=0;
    rois={};
    sub = T.subject(a);%['sub-' sprintf( '%03d', T.sub(a) )];
    %roiname = fullfile(connectomics_dir,[str(sub) '_ROI_'  T.ch_name{a} '.nii']);
    roiname = char(fullfile(connectomics_dir, strcat(T.cohort{a}, '_',sub, '_ROI_', T.ch_name{a}, '.nii')));
    if strcmp(T.ch_name{a}(1:4),'ECOG')
        n=n+1;
        mni = [-abs(T.x_coord(a)) T.y_coord(a) T.z_coord(a)];
        rois{n}=wjn_spherical_roi(roiname,mni,4);
    else
        n=n+1;
        mni = nanmean([-abs(T.x_coord(b)) T.y_coord(b) T.z_coord(b);T.x_coord(b+1),T.y_coord(b+1),T.z_coord(b+1)]);
        rois{n}=wjn_spherical_roi(roiname,mni,3);
    end
    
  
end