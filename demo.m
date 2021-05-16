%% In this work, we have based on and borrowed some codes from the GFSDCF tracker (https://github.com/XU-TIANYANG/GFS-DCF).
%% This demo script runs the STDOD tracker with deep features for "Face_ce" sequence.
%% Please run install.m first
close all;clear;clc;
setup_paths();

% Choose a sequence and load video information
base_path ='.';
%base_path ='/media/ubuntu/3333ab47-aee1-468f-87c5-ec39b552ab00/tmpdata/sunshipeng/lsycp_datasets/TC128_dataset/Temple-color-128';
%video = choose_video(base_path);
video = 'Girl2';

video_path = [base_path '/' video];
[seq, gt_boxes] = load_video(video_path,video);
seq.name =video;%%%add for condor debug

results = run_STDOD(seq);

% Evaluate performance
pd_boxes = results.res;
thresholdSetOverlap = 0: 0.05 : 1;
success_num_overlap = zeros(1, numel(thresholdSetOverlap));
if numel(gt_boxes(1,:))>4
    temp = zeros(size(gt_boxes,1),4);  
    for i = 1:size(gt_boxes,1)
        bb8 = round(gt_boxes(i,:));
        x1 = round(min(bb8(1:2:end)));
        x2 = round(max(bb8(1:2:end)));
        y1 = round(min(bb8(2:2:end)));
        y2 = round(max(bb8(2:2:end)));
        temp(i,:) = round([x1, y1, x2 - x1, y2 - y1]);
    end
    gt_boxes = temp;
end

thresholdSetPre = 0: 1 : 50;
success_num_pre = zeros(1, numel(thresholdSetPre));
res = calcRectInt(gt_boxes, pd_boxes);
p_gt = [gt_boxes(:,2),gt_boxes(:,1)]+([gt_boxes(:,4),gt_boxes(:,3)]-1)/2;
p_res = [pd_boxes(:,2),pd_boxes(:,1)]+([pd_boxes(:,4),pd_boxes(:,3)]-1)/2;
dis = sqrt(sum((p_gt-p_res).^2,2));
for t = 1: length(thresholdSetOverlap)
    success_num_overlap(1, t) = sum(res > thresholdSetOverlap(t));
end
for t = 1: length(thresholdSetPre)
    success_num_pre(1, t) = sum(dis <= thresholdSetPre(t));
end
Pre = success_num_pre(21) / size(gt_boxes, 1);
cur_AUC = mean(success_num_overlap) / size(gt_boxes, 1);
FPS_vid = results.fps;
display([video  '----> '  'Rank/Frames: ' num2str(results.rank_var) '/' num2str(size(gt_boxes, 1)) ', FPS: ' num2str(FPS_vid)   ', AUC: '   num2str(cur_AUC)  ', DP: '   num2str(Pre)]);
%gpuDevice([]);
