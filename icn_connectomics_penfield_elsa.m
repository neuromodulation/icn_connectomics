%% Mandatory code file system house keeping
clear all, close all, clc
options.leaddbs = 'C:\code\leaddbs';
options.icn_connectomics = 'C:\code\icn_connectomics';
options.wjn_toolbox = 'C:\code\wjn_toolbox';
options.spm12 = 'C:\code\spm12';
addpath(genpath(options.leaddbs))
addpath(options.icn_connectomics)
addpath(options.wjn_toolbox)
addpath(options.spm12)
%% Read all csv files and filter.
% Define the name of your analysis and the folder it should be stored in:
clear all, close all
options=[];
options.analysis_name = 'Motor_Speech';
options.analysis_dir = 'E:\PROJECT Penfield\Analyses';
% Define the csv files to be loaded:
options.csvfiles = wjn_subdir(fullfile('E:\PROJECT Penfield\Atlas_Elsa','*.csv'));
% Define as many filters as you like
options.filters(1).name = 'Motor_Speech';
options.filters(1).Domain.string = {'Motor'};
options.filters(1).Domain.exact = 1; 
options.filters(1).Subdomain.string = {'Head/Face/Jaw','Head/Face/Mouth'}; 
options.filters(1).Subdomain.exact = 0;  
% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
options.ignore_bad = 0;
options.stimulation_radius = 3;
% Run the script
icn_connectomics_penfield(options)