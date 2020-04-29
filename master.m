root = 'D:\Dropbox (Brain Modulation Lab)\Shared Lab Folders\CRCNS\MOVEMENT DATA';
leaddbs = 'C:\code\leaddbs';
wjn_toolbox = 'C:\code\wjn_toolbox';
spm12 = 'C:\code\spm12';
icn_connectomics = 'C:\code\icn_connectomics';
addpath(spm12)
addpath(genpath(leaddbs))
addpath(wjn_toolbox)


%% FIND ALL ELECTRODES FILES TO READ IN MNI COORDS
[files,folders] = wjn_subdir(fullfile(root,'*electrodes.tsv'));

%% CREATE SPHERICAL ROIS FROM ELECTRODE LOCATIONS FOR ALL SUBJECTS
for a =1:length(folders)
    T=tdfread(files{a});
    channels = cellstr(T.name);
    connectomics_dir = fullfile(folders{a}(1:end-4),'connectomics');
    mkdir(connectomics_dir)
    side = find(ismember(folders{a}(end-5),{'h','f'})); % right = 1; left = 2;
    n=0;
    rois={};
    for  b= 1:length(channels)
        if strcmp(channels{b}(1:4),'ECOG')
            n=n+1;
            mni = [-abs(T.x(b)) T.y(b) T.z(b)];
            rois{n}=wjn_spherical_roi(fullfile(connectomics_dir,['ROI_' channels{b} '.nii']),mni,2);
        elseif side == 1 && ismember(channels{b},{'STN_RIGHT_0','STN_RIGHT_1','STN_RIGHT_2'})
            n=n+1;
            mni = nanmean([-abs(T.x(b)) T.y(b) T.z(b);T.x(b+1),T.y(b+1),T.z(b+1)]);
             rois{n}=wjn_spherical_roi(fullfile(connectomics_dir,['ROI_' channels{b} '.nii']),mni,2);
        elseif side == 2 && ismember(channels{b},{'STN_LEFT_0','STN_LEFT_1','STN_LEFT_2'})
            n=n+1;
            mni = nanmean([-abs(T.x(b)) T.y(b) T.z(b);T.x(b+1),T.y(b+1),T.z(b+1)]);
             rois{n}=wjn_spherical_roi(fullfile(connectomics_dir,['ROI_' channels{b} '.nii']),mni,2);
        end
    end
    
end


