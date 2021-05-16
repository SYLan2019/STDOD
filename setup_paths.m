function setup_paths()
% Add involved folders into MATLAB path.

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

% Tracker implementation
addpath(genpath([pathstr '/tracker_imple/']));

% Utilities
addpath([pathstr '/tracker_utils/']);

% The feature extraction
addpath(genpath([pathstr '/tracker_featu/']));

% Matconvnet
addpath([pathstr '/tracker_exter/cpfromTFCR_matconvent/matconvnet/matlab/mex/']);%/home/ubuntu/lsytest/STDOD-bak_otb0933-0692/tracker_exter/cpfromTFCR_matconvent/matconvnet
addpath([pathstr '/tracker_exter/cpfromTFCR_matconvent/matconvnet/matlab']);
addpath([pathstr '/tracker_exter/cpfromTFCR_matconvent/matconvnet/matlab/simplenn']);
vl_setupnn;

% PDollar toolbox
addpath(genpath([pathstr '/tracker_exter/pdollar_toolbox/channels']));

% Mtimesx
addpath([pathstr '/tracker_exter/mtimesx/']);

% mexResize
addpath([pathstr '/tracker_exter/mexResize/']);

% Networks and tables
addpath([pathstr '/tracker_featu/offline_models/']);
