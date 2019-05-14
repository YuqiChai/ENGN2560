function param = globalParam(dataset)
% setup all the params

%% set up paths
addpath('/users/guest443/scratch/temp/ENGN2560/flow_utils');
addpath('/users/guest443/scratch/temp/ENGN2560/structured_edges');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/discreteFlow');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/bcd');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/parameters');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/edges');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/util');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/external/EpicFlow_v1.00');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/external/edges');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/external/flow-code-matlab');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/external/piotr_toolbox');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/build');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/flann-1.8.4-src');
addpath('/users/guest443/scratch/temp/ENGN2560/dFlow/outlier_rejection');

%addpath('/users/guest438/scratch/ENGN2560/ENGN2560/structured_edges/private');
% put piotr's toolbox path here
addpath(genpath('/users/guest443/scratch/temp/ENGN2560/bins/toolbox'));
% put root data folder here
addpath('/users/guest443/scratch/temp/ENGN2560');
rootPath = '/users/guest443/scratch/resPreprocess';

%% set up datasets
% we will mainly use three datasets:
% BSDS for benchmark edge detection
% Sintel for benchmark optical flow
% Video for learning
% each dataset is defined by a set of frame pairs
allDatasets = {'bsds', 'sintel','bird'};
% if we will sample the frames (or simply keep them all)
allSampleFrames = [0 0 1];
allScales = [1 1 0.5];
allFlowFlags = {'-sintel', '-sintel', '-sintel'};
allFileExt = {'.jpg', '.png', '.jpg'};

% set up dataset params
index = strcmp(dataset, allDatasets);
if sum(index)==0, param=[]; return; end
param.dataset = allDatasets{index};
param.flowFlag = allFlowFlags{index};
param.sampleFrames = allSampleFrames(index);
param.scale = allScales(index);
param.fileExt = allFileExt{index};

%% setup image / matching / edge / flow paths
param.rootPath = fullfile(rootPath, param.dataset);
param.imgPath = fullfile(rootPath, param.dataset, 'images');
param.matchPath = fullfile(rootPath, param.dataset, 'matches');
param.edgePath = fullfile(rootPath, param.dataset, 'edges');
param.flowPath = fullfile(rootPath, param.dataset, 'flows');
param.motEdgePath = fullfile(rootPath, param.dataset, 'motEdges');

%% number of samples used for training
param.numSamples = 1000;

%% counter and tmp file folder
param.iter = 0;
param.tmpFolder = '/users/guest443/scratch/temp/ENGN2560/tmp';

%% check dataset stats
param.edgeGT = 0;   param.flowGT = 0;
if exist(fullfile(param.edgePath, 'Groundtruth'), 'dir')
    param.edgeGT = 1;
end
if exist(fullfile(param.flowPath, 'Groundtruth'), 'dir')
    param.flowGT = 1;
end

%% binary for deepmatching and epicflow
param.dmBin = '/users/guest443/scratch/temp/ENGN2560/bins/deepmatching_1.2.2_c++/deepmatching-static';
param.efBin = '/users/guest443/scratch/temp/ENGN2560/bins/epicflow';

%% for parfor
param.numProc = 8;

