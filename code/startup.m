%% Setup global variables
ones(10)*ones(10);

%% Directories
global DIRS;

% Root directory for code
DIRS.ROOT = fileparts( mfilename('fullpath') );

% Root directory for data
DIRS.DATA_ROOT = fullfile(fileparts(DIRS.ROOT), 'data');

% Dirs to add to path
DIRS_TO_PATH = {'toplevel_func', ... 
                'point_desc', ...
                'tools', ...
                'utils', ...
                'plot', ...
                'thirdparty'
                };
             
cellfun(@(x)addpath(genpath(fullfile(DIRS.ROOT, x))), DIRS_TO_PATH);
clear DIRS_TO_PATH;

%% EIGS params
LB_PARAM = 'cot'; % 'neu', 'dir', 'cot', 'euc', 'geo'
MAX_NUM_EVECS  = 100;

% Naming conventions for data directories
NAMES.MESHES = 'meshes';
NAMES.SHAPES = 'shapes';
NAMES.EVECS =  ['evecs.' LB_PARAM];
NAMES.DESC = ['descriptors.' LB_PARAM];
NAMES.DICT = ['dict.' LB_PARAM];
NAMES.SUP_DICT = 'sup_dict';
NAMES.SEGM = 'segmentations';
NAMES.EVALUATION = 'experiments';

global DESC_TYPES;
DESC_TYPES.hks = 'HKS';
DESC_TYPES.sihks = 'SIHKS';
DESC_TYPES.gps = 'GPS';
DESC_TYPES.wks = 'WKS';     

% Training and validation set ratios
TRAININGSET_RATIO = 0.4;
VALID2TRAIN_RATIO = 0.25;

% Shape scaling for SHREC'14 datasets
SHAPE_SCALING.REAL = 53.7;
SHAPE_SCALING.SYNTHETIC = 138.3; 
