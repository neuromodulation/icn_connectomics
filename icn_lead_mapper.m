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
lead mapper