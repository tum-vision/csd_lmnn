%% Choose dataset and resolution
global CUR DIRS;

% Choose resolution
MESH_RESOLUTIONS = {'4500f', '10kf', '20kf', 'original'};
CUR.MESH_RESOL = [ 'resol_' MESH_RESOLUTIONS{3} ] ;

DATASETS_DIRS = {
                 'SHREC14_HUMAN/training/SYNTHETIC', ...% 1
                 'SHREC14_HUMAN/training/REAL', ... % 2
                 'SHREC14_HUMAN/SYNTHETIC', ... % 3
                 'SHREC14_HUMAN/REAL', ...        % 4
                 }';

% Choose dataset
CUR.DATASET_NUM = 4;
CUR.DATASET = DATASETS_DIRS{CUR.DATASET_NUM};

if ismember(CUR.DATASET_NUM, [1 3])  % Synthetic
    CUR.IS_SYNTHETIC = true;
else
    CUR.IS_SYNTHETIC = false;
end

if ismember(CUR.DATASET_NUM, [1 2])  % Training
    CUR.IS_TRAINING = true;
else
    CUR.IS_TRAINING = false;
end


if CUR.IS_SYNTHETIC
    CUR.SHAPE_SCALING = SHAPE_SCALING.SYNTHETIC;   
else
    CUR.SHAPE_SCALING = SHAPE_SCALING.REAL;
end


CUR.SAVE_DIR           = fullfile(DIRS.DATA_ROOT, CUR.DATASET, CUR.MESH_RESOL);
DIRS.MESHES            = fullfile(CUR.SAVE_DIR, NAMES.MESHES);
DIRS.SHAPES            = fullfile(CUR.SAVE_DIR, NAMES.SHAPES);
DIRS.EVECS             = fullfile(CUR.SAVE_DIR, ['evecs.' LB_PARAM]);
DIRS.DESC              = fullfile(CUR.SAVE_DIR, NAMES.DESC);
DIRS.DICT              = fullfile(CUR.SAVE_DIR, ['dict.' LB_PARAM]);
DIRS.EVALUATION        = fullfile(CUR.SAVE_DIR, NAMES.EVALUATION);


CUR.GROUNDTRUTH_FILE = get_files(fullfile(DIRS.DATA_ROOT, CUR.DATASET), '*.cla');    

if ~isempty(CUR.GROUNDTRUTH_FILE)
    [C, GROUNDTRUTH] = read_cla(CUR.GROUNDTRUTH_FILE);
else
    error('No groundtruth file found!');
end

