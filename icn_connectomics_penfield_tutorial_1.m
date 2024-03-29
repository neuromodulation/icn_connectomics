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

%% Tutorial 1: Export all stimulation points from a single map.
% Define the name of your analysis and the folder it should be stored in:
clear all, close all
options=[];
options.analysis_name = 'Tutorial_1-Elsas_Example';
options.analysis_dir = 'E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Analyses\';

% Define the csv files to be loaded:
options.csvfiles = fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas_Additional\Templates_and_Examples','example.csv');

% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
% Run the script
icn_connectomics_penfield(options)


%% Tutorial 2: Export all stimulation points from three or more maps.
clear all, close all
options=[];
options.analysis_name = 'Tutorial_2-Three_BRAVE_maps';
options.analysis_dir = 'E:\Analyses\';

% Define the csv files to be loaded:
options.csvfiles = {fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas\BRAVE_BRAIN_1963','BRAVE_BRAIN_1963_Figure26_Map25.csv'),...
    fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas\BRAVE_BRAIN_1963','BRAVE_BRAIN_1963_Figure18_Map17.csv'), ...
    fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas\BRAVE_BRAIN_1963','BRAVE_BRAIN_1963_Figure35_Map34.csv')};

% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
% Run the script
icn_connectomics_penfield(options)

%% Tutorial 3: Create filters for Motor vs. Sensory domains and subdomains based on Elsa's example file.
clear all, close all
options=[];
options.analysis_name = 'Tutorial_3-Filtering_example';
options.analysis_dir = 'E:\Analyses\';

% Define the csv files to be loaded:
options.csvfiles = fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas_Additional\Templates_and_Examples','example.csv');

% Define as many filters as you like. 

options.filters(1).name = 'Sensory_Arm';
options.filters(1).ArticleID.string = [];
options.filters(1).Domain.string = 'Sensory';
options.filters(1).Domain.exact = 1; % Sensory/Hallucination would not be found.
options.filters(1).Subdomain.string = 'Arm'; % accepts Legs/Arm
options.filters(1).Subdomain.exact = 0;
options.filters(1).Figure.string = [];
options.filters(1).Case.string = [];

options.filters(2).name = 'Motor_Arm';
options.filters(2).Domain.string = 'Motor';
options.filters(2).Domain.exact = 1;
options.filters(2).Subdomain.string = 'Arm';

% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
% Run the script
icn_connectomics_penfield(options)

%% Tutorial 4: Increase the stimulation radius.
% Define the name of your analysis and the folder it should be stored in:
clear all, close all
options.analysis_name = 'Tutorial_4-Increased_stimulation_radius';
options.analysis_dir = 'E:\Analyses\';

% Define the csv files to be loaded:
options.csvfiles = fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas\Templates_and_Examples','example.csv');

% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
options.stimulation_radius = 6;
% Run the script
icn_connectomics_penfield(options)

%% Tutorial 5: Read all csv files.
% Define the name of your analysis and the folder it should be stored in:
clear all, close all
options.analysis_name = 'Tutorial_5-Map_all_maps';
options.analysis_dir = 'E:\Analyses\';

% Define the csv files to be loaded:
options.csvfiles = wjn_subdir(fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas\','*.csv'));

% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
options.stimulation_radius = 3;
options.ignore_bad = 0;
options.ignore_list = {'E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas\BRAVE_BRAIN1963_Anna\BRAVE_BRAIN_1963_Figure13_Map12_Anna_final.csv'};

% Run the script
icn_connectomics_penfield(options)

%% Tutorial 6: Export all stimulation points from a single map.
% Define the name of your analysis and the folder it should be stored in:
clear all, close all
options=[];
options.analysis_name = 'Tutorial_6-Creating random selections';
options.analysis_dir = 'E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Analyses\';

% Define the csv files to be loaded:
options.csvfiles = fullfile('E:\OneDrive - Charit� - Universit�tsmedizin Berlin\Dokumente\PROJECT Penfield Atlas\Atlas_Additional\Templates_and_Examples','example.csv');

% Check overwrite to be able to delete and overwrite previous versions of the same analysis
options.overwrite = 1;
options.rand_n = 433; % Note that if the original collection is smaller than the number of randomized points, they will be oversampled. 
% Run the script
icn_connectomics_penfield(options)


