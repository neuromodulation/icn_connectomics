function icn_connectomics_penfield(options)




if ~isfield(options,'csvfiles')
    error('Please define options.csvfiles')
elseif ~iscell(options.csvfiles)
    options.csvfiles = {options.csvfiles};
end



if ~isfield(options,'analysis_dir')
    error('Please define options.analysis_dir')
else
    options.analysis_fdir = fullfile(options.analysis_dir,options.analysis_name);
    if exist(options.analysis_fdir,'dir') && (~isfield(options,'overwrite') || ~options.overwrite)
        error([options.analysis_fdir ' exists already. Choose a different path or set options.overwrite = 1.'])
    elseif exist(options.analysis_fdir,'dir') && isfield(options,'overwrite') && options.overwrite
        rmdir(options.analysis_fdir,'s')
    else
        mkdir(options.analysis_fdir)
    end
end

if ~isfield(options,'stimulation_radius')
    options.stimulation_radius = 3;
end

if ~isfield(options,'template_file')
    options.template_file = fullfile(spm('dir'),'canonical','single_subj_T1.nii');
end

if ~isfield(options,'ignore_bad')
    options.ignore_bad = 0;
end

%% Read the csv file into Table options.T
options.T=[];options.ignored_files=[];options.read_files=[];
for a = 1:length(options.csvfiles)
    
    try
        newT=[];
        
        newT = readtable(options.csvfiles{a},'TreatAsEmpty','na','delimiter',',');
        if ~iscell(newT.Comment)
            newT.Comment = cellstr(num2str(newT.Comment));
        end
        if ~iscell(newT.Case)
            newT.Case = cellstr(num2str(newT.Case));
        end
        if ~iscell(newT.ID)
            newT.ID = cellstr(num2str(newT.ID));
        end
        if ~iscell(newT.Figure)
            newT.Figure = cellstr(num2str(newT.Figure));
        end
        if ~isempty(newT)
            if a == 1
                options.T = newT;
            else
                options.T = [options.T;newT];
            end
            disp([num2str(size(newT,1)) ' stimulation points added from ' options.csvfiles{a}])
            options.read_files=[options.read_files;options.csvfiles(a)];
        end
    catch ME
        if options.ignore_bad
            warning(['Could not load ' options.csvfiles{a} '; The file is ignored.'])
            warning(ME.message)
            options.ignored_files=[options.ignored_files;options.csvfiles(a)];
        else
            warning(['Could not load ' options.csvfiles{a} '; The file is ignored.'])
            warning(ME.message)
            disp(newT)
            keyboard
          
        end
    end
end
disp(['DONE. ' num2str(size(options.T,1)) ' stimulation points loaded.'])


%% Filter

if ~isfield(options,'filters')
    warning('No filters defined.')
    options.filters(1).name = 'all';
end


for f = 1:length(options.filters)
    
    filter_fields = fieldnames(options.filters(f));
    options.filters(f).filter_index = [];n=0;
    for a = 1:length(filter_fields)
        if strcmp(options.filters(f).name,'all')
            options.filters(f).filter_index = 1:size(options.T,1);
        else
            if isfield(options.filters(f).(filter_fields{a}),'string') && ~isempty(options.filters(f).(filter_fields{a}).string)
                n=n+1;
                if isfield(options.filters(f).(filter_fields{a}),'exact') && options.filters(f).(filter_fields{a}).exact
                    current_filter_exact = 1;
                else
                    current_filter_exact = 0;
                end

                if n==1
                    options.filters(f).filter_index=ci(options.filters(f).(filter_fields{a}).string,options.T.(filter_fields{a}),current_filter_exact);
                else
                    options.filters(f).filter_index = intersect(ci(options.filters(f).(filter_fields{a}).string,options.T.(filter_fields{a}),current_filter_exact),options.filters(f).filter_index);
                end
            end
        end
    end
    
    
    %% Plot surface
    
    if ~isfield(options, 'plot_surface') || options.plot_surface
        figure('InvertHardcopy','off')
        p=wjn_plot_surface(fullfile(ea_getearoot,'templates\space\MNI_ICBM_2009b_NLIN_ASYM\cortex\CortexHiRes.mat'));
        p.FaceColor = 'w';
        hold on
        wjn_plot_colored_spheres([options.T.X(options.filters(f).filter_index) options.T.Y(options.filters(f).filter_index) options.T.Z(options.filters(f).filter_index)],1:length(options.filters(f).filter_index),options.stimulation_radius,colormap('jet'));
        light
        title(strrep({options.analysis_name,[options.filters(f).name ' N = ' num2str(numel(options.filters(f).filter_index))]},'_',' '),'color','w')
        if ~exist(fullfile(options.analysis_fdir,'figures'),'dir')
            mkdir(fullfile(options.analysis_fdir,'figures'))
        end
        savefig(fullfile(options.analysis_fdir,'figures',[options.analysis_name '_' options.filters(f).name '.fig']))
        myprint(fullfile(options.analysis_fdir,'figures',[options.analysis_name '_' options.filters(f).name ]))
        
    end
    if isempty(options.filters(f).filter_index)
        continue
    end
    
    %% Create seed volumes as nifti files
    
    if ~isfield(options, 'create_seed_volumes') || options.create_seed_volumes
        mkdir(fullfile(options.analysis_fdir,'niftis',options.filters(f).name))
        for a = 1:length(options.filters(f).filter_index)
            current_seed = options.T(options.filters(f).filter_index(a),:);
            current_seed_filename = ['seed_N_' num2str(a) '_' options.analysis_name '_' options.filters(f).name '_' strrep(strrep([current_seed.ArticleID{1},'_',current_seed.Figure{1},...
                ['_X' num2str(current_seed.X,3) '_Y' num2str(current_seed.Y,3) '_Z' num2str(current_seed.Z,3)]],'.','-'),' ','_'),'.nii'];
            current_seed_coords = [options.T.X(options.filters(f).filter_index(a)) options.T.Y(options.filters(f).filter_index(a)) options.T.Z(options.filters(f).filter_index(a))];
            options.filters(f).roi_files{a,1}=wjn_spherical_roi(fullfile(options.analysis_fdir,'niftis',options.filters(f).name,current_seed_filename),current_seed_coords,options.stimulation_radius,options.template_file);
            options.filters(f).mni(a,:) = current_seed_coords;
        end
    end
    options.filters(f).table = options.T(options.filters(f).filter_index,:);
    
    current_seed_filename = strrep(['seeds_N' num2str(a) '_' options.analysis_name '_' options.filters(f).name '.nii'],' ','_');
    wjn_nii_sum(options.filters(f).roi_files,fullfile(options.analysis_fdir,'niftis',strrep(['heatmap_N' num2str(a) '_' options.analysis_name '_' options.filters(f).name '.nii'],' ','_')));
    options.filters(f).master_seed = wjn_spherical_roi(fullfile(options.analysis_fdir,'niftis',current_seed_filename),options.filters(f).mni,options.stimulation_radius,options.template_file);
    writetable(options.filters(f).table,fullfile(options.analysis_fdir,[options.analysis_name '_' options.filters(f).name '.csv']))
end

save(fullfile(options.analysis_fdir,['options_' strrep(options.analysis_name,' ','_')]),'options')

