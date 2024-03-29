function [feature_map, img_samples] = extract_features_c1(image, pos, scales, features, gparams, extract_info)

% Sample image patches at given position and scales. Then extract features
% from these patches.
% Requires that cell size and image sample size is set for each feature.

if ~iscell(features)
    error('Wrong input');
end

if ~isfield(gparams, 'use_gpu')
    gparams.use_gpu = false;
end
if ~isfield(gparams, 'data_type')
    gparams.data_type = zeros(1, 'single');
end
if nargin < 6
    % Find used image sample size
    extract_info = get_feature_extract_info(features);
end

num_features = length(features);
num_scales = size(scales,2);
num_sizes = length(features);

% Extract image patches
img_samples = cell(num_sizes,1);
for sz_ind = 1:num_sizes %un-deep feature use scaled patch !!
    img_sample_sz = extract_info.img_sample_sz{sz_ind};
    img_input_sz = features{sz_ind}.img_input_sz;
    img_samples{sz_ind} = zeros(img_input_sz(1), img_input_sz(2), size(image,3), num_scales, 'uint8');
    for scale_ind = 1:num_scales
        %if(sz_ind ==3)
        %     tmpscale_patchsz= img_sample_sz*scales(features{sz_ind}.fparams.feature_is_deep+1,scale_ind)
        %      fprintf('deepfeature-==%d\n',features{sz_ind}.fparams.feature_is_deep);
        %end
        img_samples{sz_ind}(:,:,:,scale_ind) = sample_patch(image, pos, img_sample_sz*scales(features{sz_ind}.fparams.feature_is_deep+1,scale_ind), img_input_sz, gparams);
        %testszimgsamp= size(img_samples{sz_ind}(:,:,:,scale_ind))%204,210,259%for test
        %fprintf('\n-***sz_ind==%d****scale_ind=-=%d---features_fparams-feature_is_deep=%d,%d-imgsamplesz==%d,%d-\n',sz_ind,scale_ind,features{sz_ind}.fparams.feature_is_deep,img_samples{sz_ind}(:,:,:,scale_ind));
    end
    if sz_ind ==2 % compute the deep feature, only use one scale  %%add 2019-8-13
         num_scales =1;
    end
end

%	%deep feature not use scaled , only one scale use to location!!
%	%----------<<
%	    img_sample_sz = extract_info.img_sample_sz{3};
%	    img_input_sz = features{3}.img_input_sz;
%	    img_samples{3} = zeros(img_input_sz(1), img_input_sz(2), size(image,3), num_scales, 'uint8');
%	    scale_ind = round(num_scales/2); %1:num_scales select the orignal scale ==1,the middle of all scales
%	    img_samples{3}(:,:,:,1) = sample_patch(image, pos, img_sample_sz*scales(features{3}.fparams.feature_is_deep+1,scale_ind), %	    img_input_sz, gparams);
%	%--------->>


% Find the number of feature blocks and total dimensionality
num_feature_blocks = 0;
total_dim = 0;
for feat_ind = 1:num_features
    num_feature_blocks = num_feature_blocks + length(features{feat_ind}.fparams.nDim);
    total_dim = total_dim + sum(features{feat_ind}.fparams.nDim);
end

feature_map = cell(1, 1, num_feature_blocks);

% Extract feature maps for each feature in the list
ind = 1;
for feat_ind = 1:num_features
    feat = features{feat_ind};
    %fprintf("feat_ind=%d,feat.is_cell==%d\n",feat_ind,feat.is_cell);
    
    % do feature computation
    if feat.is_cell % for deep feature
        %num_blocks = length(feat.fparams.nDim)%;%1
        %tmpfeattype =extract_info.feature_is_deep(feat_ind) 
        %feat_ind%-------------3
        feature_map(ind:ind+num_blocks-1) = feat.getFeature(img_samples{feat_ind}, feat.fparams, gparams);%size(img_samples{feat_ind})---one pic
        %deepfeatsz = size(feature_map{ind})
    else
        num_blocks = 1;
        feature_map{ind} = feat.getFeature(img_samples{feat_ind}, feat.fparams, gparams);
        %handfeatsz = size(feature_map{ind})
    end
    
    ind = ind + num_blocks;
end
              
% Do feature normalization
if ~isempty(gparams.normalize_power) && gparams.normalize_power > 0
    if gparams.normalize_power == 2
        feature_map = cellfun(@(x) bsxfun(@times, x, ...
            sqrt((size(x,1)*size(x,2))^gparams.normalize_size * size(x,3)^gparams.normalize_dim ./ ...
            (sum(reshape(x, [], 1, 1, size(x,4)).^2, 1) + eps))), ...
            feature_map, 'uniformoutput', false);
    else
        feature_map = cellfun(@(x) bsxfun(@times, x, ...
            ((size(x,1)*size(x,2))^gparams.normalize_size * size(x,3)^gparams.normalize_dim ./ ...
            (sum(abs(reshape(x, [], 1, 1, size(x,4))).^gparams.normalize_power, 1) + eps)).^(1/gparams.normalize_power)), ...
            feature_map, 'uniformoutput', false);
    end
end
if gparams.square_root_normalization
    feature_map = cellfun(@(x) sign(x) .* sqrt(abs(x)), feature_map, 'uniformoutput', false);
end

end
