function results = run_STDOD(seq, res_path, bSaveImage, parameters)
% Set tracker parameters and run tracker
% Input  : seq[structure](sequence information)
% Output : results[structure](tracking results)

% Shiyong Lan, et al. 
% Robust Visual Object Tracking With Spatiotemporal Regularisation and Discriminative Occlusion Deformation" .


%% Set feature parameters
% HOG feature settings
hog_params.cell_size = 6;           
hog_params.feature_is_deep = false;

% CN feature settings
cn_params.tablename = 'CNnorm';
cn_params.useForGray = false;
cn_params.cell_size = 4;
cn_params.feature_is_deep = false;       

% IC feature settings
ic_params.tablename = 'intensityChannelNorm6';
ic_params.useForColor = false;
ic_params.cell_size = 4;
ic_params.feature_is_deep = false;

% CNN feature settings
dagnn_params.nn_name = 'imagenet-resnet-50-dag.mat'; 
dagnn_params.output_var = {'res4ex'};    
dagnn_params.feature_is_deep = true;
dagnn_params.augment.blur = 1;
dagnn_params.augment.rotation = 1;
dagnn_params.augment.flip = 1;

params.t_features = {
    struct('getFeature',@get_fhog,'fparams',hog_params),...
    struct('getFeature',@get_table_feature, 'fparams',cn_params),...
    struct('getFeature',@get_dagnn_layers_c1, 'fparams',dagnn_params),...
    struct('getFeature',@get_table_feature, 'fparams',ic_params),...
};

% Set [non-deep deep] parameters
params.learning_rate = [0.6 0.05];          % updating rate in each learning stage
params.channel_selection_rate = [0.9 0.075];% channel selection ratio
params.spatial_selection_rate = [0.1 0.9];  % spatial units selection ratio
params.output_sigma_factor = [1/16 1/4];	% desired label setting
params.lambda1 = 10;                        % lambda_1
params.lambda2 = 1;                         % lambda_2
params.lambda3 = [16 12];                   % lambda_3
params.stability_factor = [0 0];            % robustness testing parameter

% Image sample parameters
params.search_area_scale = [3.8 4.2];        % search region  
params.min_image_sample_size = [150^2 200^2];% minimal search region size   
params.max_image_sample_size = [200^2 250^2];% maximal search region size  

% Learning parameters
params.train_gap = 0;%1; %5                  % The number of intermediate frames with no training (0 corresponds to training every frame)
params.skip_after_frame = 10;%10;           % After which frame number the sparse update scheme should start (1 is directly)


% Detection parameters
params.refinement_iterations = 1;           % detection numbers
params.newton_iterations = 5;               % subgrid localisation numbers   

% Set scale parameters
params.number_of_scales = 7;                % scale pyramid size
params.scale_step = 1.01;                   % scale step ratio
params.beta_scale = 1;                    % for smooth scale update

% Set GPU 
params.use_gpu = true;                 
params.gpu_id = [];              

% Initialisation
params.vis_res = 1;%0;%                         % visualisation results
params.vis_details = 0;                     % visualisation details for debug
params.seq = seq; 
%for debug in condor  
params.debug_save = 0;                         
params.video_name =seq.name;
params.debug = 0;%1;  
% Run tracker
[results] = tracker_STDOD(params);
