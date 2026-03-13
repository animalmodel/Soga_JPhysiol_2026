%Cat experiment first step
%set pass
% function path
clc
close all hidden;
%clearvars -except Ext_COMBdata COMBdata Easily_OEdata

%load path
addpath(genpath('D:\Cat article M2\For article analysis\Code\8-31 lumbar\function_for_0831Experiment'));
addpath(genpath('D:\Cat article M2\For article analysis\Code\8-31 lumbar\Experiment_sqript'));
addpath(genpath('D:\Cat article M2\For article analysis\Code\8-31 lumbar'));
addpath(genpath('D:\Cat article M2\For article analysis\Code\8-31 lumbar\function_by_trever'));


%{


addpath(genpath('E:\Cat_experiment_result\function_for_0831Experiment'));
addpath(genpath('E:\Cat_experiment_result\Experiment_sqript'));
addpath(genpath('E:\Cat_experiment_result\function_for_video'));
addpath(genpath('E:\Cat_experiment_result\function_by_trever'));
%}


%input video name
Neme_of_video_Ex3_main = '8_31_Ex3_main_ch1DLC_resnet50_Cat_831_CH1Jan7shuffle1_800000filtered.csv';

[fName,fnameORI{1,1}] = uigetfile('*Ext_COMBdata_step2.mat','Select a "Ext_COMBdata_step2.mat file" in data.');


%if you want to reload additional file you put path here
Fmat1 = [fnameORI{1,1},fName];
Parts = strsplit(Fmat1, filesep);
Fmat2=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs3/Easily_OEdata.mat'];
Fmat3=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs2/Wave_data_all.mat'];
Fmat4=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs2/Wave_data_main_channel.mat'];
%Fmat5=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs3/Analog_input_data.mat'];
FPAnew=[strjoin(Parts(1:end-2),filesep)];
PostureIDPath=[strjoin(Parts(1:end-5),filesep),filesep,'posture_data'];
Video_data_Path=[strjoin(Parts(1:end-5),filesep),filesep,'video_data'];

% load Ext_COMBdata
if exist('Ext_COMBdata_step2','var')==1
    disp('Ext_COMBdata_step2 exists. Did not load again. Clear this if you need to load a New data set.');
else
    disp('Load Ext_COMBdata');
    load(Fmat1); % it may take time due to large file size. 
end
FIEL=fieldnames(Ext_COMBdata_step2);
for i=1:length(FIEL)
    eval([FIEL{i},'=Ext_COMBdata_step2.',FIEL{i},';']);
end
fname_comb;FPATH;sampTsec_AP;CHt1;XCOORD;YCOORD;SpkID;SpkTime;SpkTime_RA;SpkCH;SOR2;
SpkTime = SpkTime_RA; %Use remove artifact data

% load Ext_OEdata easily 
if exist('Easily_OEdata','var')==1
    disp('Easily_OEdata exists. Did not load again. Clear this if you need to load a New data set.');
else
    disp('Load Easily_OEdata');
    load(Fmat2); % it may take time due to large file size. 
end
FIEL=fieldnames(Easily_OEdata);
for i=1:length(FIEL)
    eval([FIEL{i},'=Easily_OEdata.',FIEL{i},';']);
end
TimeKS;D_NIdata;D_AP_time;D_NI_timeNew;D_ME_timeNew;EventTIM;


%% load Wave data
both = 1;           %both 1 load only main channel, both2 load main and main+-20 channel

if both == 2
    if exist('Wave_data_all','var')==1
        disp('Wave_data_all exists. Did not load again. Clear this if you need to load a New data set.');
    else
        disp('Load Wave_data_all');
        load(Fmat3); % it may take t+-*ime due to large file size. 
    end
else
    disp('Only Load Wave_data_main_channel');
end

if exist('Wave_data_main_channel','var')==1
   disp('Wave_data_main_channel exists. Did not load again. Clear this if you need to load a New data set.');
else
   disp('Load Wave_data_main_channel');
   load(Fmat4); % it may take time due to large file size. 
end

% load analog data
%disp('Load analog_data');
%load(Fmat5); % it may take time due to large file size.

% load Position_ID_data
%read static posture position data
addpath(genpath(PostureIDPath));
Position_ID_data_table = readtable('static posture.csv');
Position_ID_data = table2cell(Position_ID_data_table);
% Define mapping
mapping = containers.Map({'P7', 'P8', 'P23', 'P10', 'P14', 'P13', 'P12', ...
                          'P11', 'P18', 'P17', 'P16', 'P15', 'P22', 'P21', ...
                          'P19', 'P20'}, ...
                         [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);

%Convert Participant column based on mapping
Position_ID = zeros(size(Position_ID_data));
for i = 1:size(Position_ID_data,2)
    Position_ID_Trial = cellfun(@(x) mapping(x), Position_ID_data(:,i));
    Position_ID(:,i) = Position_ID_Trial;
end

disp('Position data was completly lined')

%% losd video data
addpath(genpath(Video_data_Path));
fps = 29.970030;
length_competition = 10; %mm

%video name
filename_of_video_data_experiment3_main= 'Cat-2B-831_DLC_3D.csv';
filename_of_video_data_experiment3_hip= 'Cat-2Bhip-831_DLC_3D.csv';

[main_time_data,main_data_table,main_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_main,fps);
main_data_table_new = main_data_table*length_competition;
paw_main = main_data_table_new(:,1:3);
ankle_main = main_data_table_new(:,4:6);
knee_main = main_data_table_new(:,10:12);
hip_main = main_data_table_new(:,13:15);


[hip_time_data,hip_data_table,hip_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_hip,fps);
hip_data_table_new = hip_data_table*length_competition;
Hbone_hip_angle = hip_data_table_new(:,1:3);
hip_hip_angle = hip_data_table_new(:,4:6);
knee_hip_angle = hip_data_table_new(:,7:9);
ankle_hip_angle = hip_data_table_new(:,10:12);
paw_hip_angle = hip_data_table_new(:,13:15);
disp('Video data was completly loaded')

End_time = main_time_data(end)/60;

%% merge 2 plot
% 例: 各系から3点ずつ選択（同じ構造になる3点）

P_main = [ankle_main(1,:);
          ankle_main(20350,:);
          ankle_main(10000,:)];

P_hip = [ankle_hip_angle(1,:);
         ankle_hip_angle(20350,:);
         ankle_hip_angle(10000,:)];

% 中心化（重心を原点に）
centroid_main = mean(P_main);
centroid_hip = mean(P_hip);

P_main_centered = P_main - centroid_main;
P_hip_centered = P_hip - centroid_hip;

% 回転行列の計算（Kabsch）
H = P_hip_centered' * P_main_centered;
[U, ~, V] = svd(H);
R_align = V * U';

% 並進（重心も一致させる）
T = centroid_main' - R_align * centroid_hip';

% === これで R_align, T を使って全データを変換可能 ===
Hbone_hip_rot = (R_align * Hbone_hip_angle')' + T';
hip_hip_rot = (R_align * hip_hip_angle')' + T';
knee_hip_rot = (R_align * knee_hip_angle')' + T';
ankle_hip_rot = (R_align * ankle_hip_angle')' + T';
paw_hip_rot = (R_align * paw_hip_angle')' + T';

% convert to plane
origin = [hip_main(1,1), hip_main(1,2), hip_main(1,3)];
P1 = [ankle_main(1,1), ankle_main(1,2), ankle_main(1,3)];
P2 = [ankle_main(13700,1), ankle_main(13600,2), ankle_main(13600,3)];
P3 = [ankle_main(44000,1), ankle_main(44000,2), ankle_main(44000,3)];

% 平面法線ベクトル
v1 = P2 - P1;
v2 = P3 - P1;
normal_vec = cross(v1, v2);
normal_vec = normal_vec / norm(normal_vec);

% XZ平面の法線（Y軸）
target_normal = [0 1 0];

% 回転軸と角度
rot_axis = cross(normal_vec, target_normal);
axis_norm = norm(rot_axis);
angle = acos(dot(normal_vec, target_normal));

if axis_norm ~= 0
    rot_axis = rot_axis / axis_norm;
    K = [0 -rot_axis(3) rot_axis(2);
         rot_axis(3) 0 -rot_axis(1);
        -rot_axis(2) rot_axis(1) 0];
    R = eye(3) + sin(angle)*K + (1 - cos(angle))*(K^2);
else
    R = eye(3);
end
%変換行列
R_inv = [1 0 0;
     0 1 0;
     0 0 1];
%回転行列
rotation_angle = 0;
Ry = [cos(rotation_angle)  0  sin(rotation_angle);
      0          1      0;
     -sin(rotation_angle) 0  cos(rotation_angle)];

R_new = Ry*R_inv*R;



% 各点群に回転を適用
% 中心基準で平行移動（P1を原点に） for main angle
hip_centered   = hip_main   - origin;
knee_centered  = knee_main  - origin;
ankle_centered = ankle_main - origin;
paw_centered   = paw_main   - origin;

% hip angle 
Hbone_centered_hip   = Hbone_hip_rot   - origin;
hip_centered_hip   = hip_hip_rot   - origin;
knee_centered_hip  = knee_hip_rot  - origin;
ankle_centered_hip = ankle_hip_rot - origin;
paw_centered_hip   = paw_hip_rot   - origin;

% for main angle
hip_rotated   = (R_new * hip_centered')'   + origin;
knee_rotated  = (R_new * knee_centered')'  + origin;
ankle_rotated = (R_new * ankle_centered')' + origin;
paw_rotated   = (R_new * paw_centered')'   + origin;

% for hip angle
Hbone_ratated_hip = (R_new * Hbone_centered_hip')'   + origin;
hip_rotated_hip   = (R_new * hip_centered_hip')'   + origin;
knee_rotated_hip  = (R_new * knee_centered_hip')'  + origin;
ankle_rotated_hip = (R_new * ankle_centered_hip')' + origin;
paw_rotated_hip   = (R_new * paw_centered_hip')'   + origin;

% プロット
figure;
subplot(1,2,1);
% main
plot3(hip_main(:,1), hip_main(:,2), hip_main(:,3), 'go');
hold on;
plot3(knee_main(:,1), knee_main(:,2), knee_main(:,3), 'go');
plot3(ankle_main(:,1), ankle_main(:,2), ankle_main(:,3), 'go');
plot3(paw_main(:,1), paw_main(:,2), paw_main(:,3), 'go');
% hip（変換後）
plot3(hip_hip_rot(:,1), hip_hip_rot(:,2), hip_hip_rot(:,3), 'r.');
plot3(knee_hip_rot(:,1), knee_hip_rot(:,2), knee_hip_rot(:,3), 'r.');
plot3(ankle_hip_rot(:,1), ankle_hip_rot(:,2), ankle_hip_rot(:,3), 'r.');
plot3(paw_hip_rot(:,1), paw_hip_rot(:,2), paw_hip_rot(:,3), 'r.');
plot3(Hbone_hip_rot(:,1), Hbone_hip_rot(:,2), Hbone_hip_rot(:,3), 'b.');

title('Before transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on; view(3);
hold off;

% after convert
subplot(1,2,2);
plot3(hip_rotated(:,1), hip_rotated(:,2), hip_rotated(:,3), 'go');
hold on;
plot3(knee_rotated(:,1), knee_rotated(:,2), knee_rotated(:,3), 'go');
plot3(ankle_rotated(:,1), ankle_rotated(:,2), ankle_rotated(:,3), 'go');
plot3(paw_rotated(:,1), paw_rotated(:,2), paw_rotated(:,3), 'go');
% hip（変換後）
plot3(hip_rotated_hip(:,1), hip_rotated_hip(:,2), hip_rotated_hip(:,3), 'r.');
plot3(knee_rotated_hip(:,1), knee_rotated_hip(:,2), knee_rotated_hip(:,3), 'r.');
plot3(ankle_rotated_hip(:,1), ankle_rotated_hip(:,2), ankle_rotated_hip(:,3), 'r.');
plot3(paw_rotated_hip(:,1), paw_rotated_hip(:,2), paw_rotated_hip(:,3), 'r.');
plot3(Hbone_ratated_hip(:,1), Hbone_ratated_hip(:,2), Hbone_ratated_hip(:,3), 'b.');

title('After transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on; view(3);


Pos_main_data_label = ["Hbone","hip","knee","ankle","paw"];
Pos_main_data = {Hbone_ratated_hip,hip_rotated,knee_rotated,ankle_rotated,paw_rotated};


%% select MUA
Probe = 2; %1:ProbeA      2:ProbeB
if Probe == 1
    MUA_ID = 0;
elseif Probe == 2
    MUA_ID = [1523 1674 1679 1489 1622 1675]; %The spike what want to delete if you do not have mua please set 0
end
%ID 1523 1674 1679 MUA
%ID 1489 mix other wave
%ID 1622 mix other wave
%ID 1675 mix other wave
% delete mua
if length(MUA_ID) > 0
    disp('remove mua')
    SpkID_double = zeros(length(SpkID),1);
    %convert double
    for i = 1:length(SpkID)
    SpkID_double(i,1) =  SpkID{i,1}(1,1);
    end
    % SpkID_doubleの各要素がMUA_IDに含まれているかどうかを調べる
    is_member = ismember(SpkID_double, MUA_ID);
    % is_memberがtrue（1）である要素のインデックスを取得する
    indices = find(is_member);
    % delete MUA
    newSpkID = SpkID;
    newSpkID(indices) = [];
    newSpkCH = SpkCH;
    newSpkCH(indices) = [];
    newSpkTime = SpkTime;
    newSpkTime(indices) = [];
    newWavedata = Wave_data_main_channel;
    newWavedata(indices,:) = [];
else
    disp('not remove mua')
    newSpkID = SpkID;
    newSpkCH = SpkCH;
    newSpkTime = SpkTime;
    newWavedata = Wave_data_main_channel;
end



%% extract DI input
% select DI data
DI_related_control_and_separate_task = 3;          %DI3 red LED for control
DI_related_task = 4;         %DI4 green LED for task
% make DI new matrix
all_DI_input = zeros(length(D_NI_timeNew),2);
all_DI_input(:,1) = D_NI_timeNew;
all_DI_input(:,2) = D_NIdata{3};           %D_NIdata_ -1 = DI1, -3 DI3
% pick up DI data
%DI 3 static posture
[start_up_DI_related_control_and_separate_task, fall_DI_related_control_and_separate_task] = Target_DI_extract(all_DI_input, DI_related_control_and_separate_task);
%DI 4 dynamic posture
[start_up_DI_related_task,fall_DI_related_task] = Target_DI_extract(all_DI_input,DI_related_task);


% Separate each experiment
% make folder for result
%[fig_folder,fig_folder_tif,fig_folder_pdf,fig_folder_fig]=MakeFolder([FPAnew,filesep],'postanalysisfigs4');
step4savefolder = createNamedFolder(FPAnew, 'postanalysisfigs4');


%landmark for expriment2
experiment2_landmark = "Ex2";
%landmark for expriment3 no control (it could not position control when resting)
no_control_experiment3_landmark = "Ex3";
%landmark for expriment3 for analysis
experiment3_landmark = "Ex3 again";
%obtain each separate timing
[Ex1_Separate_point] = findNearestValue_experiment_separate(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task ,EventTIM, experiment2_landmark,1);   %if experiment1-2 set 1
[Ex3_no_control_Separate_point] = findNearestValue_experiment_separate(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task ,EventTIM, no_control_experiment3_landmark,1); %if experiment3 no control set 1
[Ex3_Separate_point] = findNearestValue_experiment_separate(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task ,EventTIM, experiment3_landmark,2);
Ex_starttime = 0;
Ex_endtime = fall_DI_related_control_and_separate_task(end,1);

%separate experiment
[EX1_control_DI,EX1_task_DI] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex_starttime,Ex1_Separate_point);
[EX2_control_DI,EX2_task_DI] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex1_Separate_point,Ex3_no_control_Separate_point);
[Ex3_no_control_control_DI,Ex3_no_control_task_DI] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex3_no_control_Separate_point,Ex3_Separate_point);
[EX3_control_DI,EX3_task_DI] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex3_Separate_point,Ex_endtime);


%Separate sech trial
Trial = 5;
[EX1_task_DI_Trial] = SepTrial(EX1_task_DI,Trial);
[EX2_task_DI_Trial] = SepTrial(EX2_task_DI,Trial);
[EX3_task_DI_Trial] = SepTrial(EX3_task_DI,Trial);
[EX3_noCont_task_DI_Trial] = SepTrial(Ex3_no_control_task_DI,Trial);



%% caluculate length

% ---- ビン幅と物理スケール設定 ----
bin_width = 4;                  % チャンネル数
channel_pitch_um = 10;          % 1チャンネルあたりの距離（μm）
bin_pitch_um = bin_width * channel_pitch_um;  % = 40μm

% ---- ビン数 ----
num_bins = 384 / bin_width;

% ---- 各ニューロンの属するビンを計算 ----
bin_indices = floor(newSpkCH / bin_width) + 1;

% ---- 各ビンに何個ニューロンが属するかをカウント ----
neuron_counts_per_bin = histcounts(bin_indices, 0.5:1:(num_bins + 0.5));

% ---- Y軸（深さμm）データ ----
Y_um = (1:num_bins) * bin_pitch_um;  % 1ビンごとに40μm

% ---- 横棒グラフを描画 ----
figure;
barh(Y_um, neuron_counts_per_bin, 'FaceColor', [0.2 0.6 0.8]);


xlim([0, max(neuron_counts_per_bin)]);

% ---- Y軸を0〜3840μmに制限し、深い方を下に ----
ylim([0 3840]);

% ---- 軸の見た目調整 ----
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
% ---- Y軸のメモリ（tick）に3840を追加 ----
yticks_manual = get(gca, 'YTick');  % 現在のtickを取得
if ~ismember(3840, yticks_manual)
    yticks([yticks_manual, 3840]);  % 3840を追加
end
grid on;

% 保存先のパス（必要に応じて変更）
output_folder = step4savefolder;  % Windowsなら 'C:\Users\YourName\Documents\figures' など

% フォルダが存在しなければ作成
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% 保存ファイル名とフルパス
filename = 'neuron_depth_distribution.tif';
full_path = fullfile(output_folder, filename);

% 図のサイズ調整
set(gcf, 'Units', 'inches', 'Position', [1, 1, 6, 8]);  % 幅6インチ×高さ8インチなど
set(gcf, 'Color', 'w');  % 背景を白に

% 解像度
dpi = 300;

% 保存処理
print(gcf, full_path, '-dtiff', ['-r' num2str(dpi)]);



%% set parameter
kernH=5; % kernel bandwidth 
% カラーマップのサイズを設定 (例: 256色)
nColors = 256;
% デフォルトの jet カラーマップを取得
cmap = jet(nColors);
% データの範囲を定義 (0から60)
dataRange = [0, 60];
% カスタムカラーマップの範囲を定義 (0から1に正規化)
customRange = linspace(0, 1, nColors);
% 特定の範囲 のサンプリングを密にする
customRange = [linspace(0, 0.5, 80), linspace(0.5, 0.75, 128), linspace(0.75, 1, 48)];
% 新しいカラーマップの作成
newCmap = interp1(linspace(0, 1, nColors), cmap, customRange);


%% Experiment 3
%plot psth make folder

% select 'main' or 'not_control' or 'both'
experiment3_select_trial = 'main';
%experiment3_select_trial = 'main';
%plot_Ex3_staticPSTH = 2;   % 1 plot psth 2 skip psth

if strcmp(experiment3_select_trial, 'main')
    experiment3_folder = createNamedFolder(step4savefolder, 'Experment3');
    experiment3_psth = createNamedFolder(experiment3_folder, 'Each posture PSTH');
    experiment3_control = createNamedFolder(experiment3_folder, 'Each control ');
    %Separate 5 trial using the number of DI
    numbertest = 1:1:length(Position_ID);
    EX3_task_DI_Trialnew = EX3_task_DI_Trial;
    for i = 1:length(EX3_task_DI_Trialnew)
        EX3_task_DI_Trialnew{i} = [EX3_task_DI_Trialnew{i}, Position_ID(:,i)];
    end

    %line up position data
    EX3_task_DI_Lineup_Trial = cell(size(EX3_task_DI_Trialnew));
    for i = 1:Trial
        EX3_task_DI_Lineup_Trial{i,1} = sortrows(EX3_task_DI_Trialnew{i,1}, 4);
    end
    % Separate each timing
    Ex3_Posture_cutting_time = [-20 20];
    Ex3_Control_cutting_time = [-10 70];
    % for control
    [Ex3_control_Count_spike_all,Ex3_control_spike_time_all,Ex3_control_Mean_firing_rate_all,Ex3_Control_each_main_wavedata] = Cutting_data_for_each_DI(newSpkTime,newWavedata,EX3_control_DI,Ex3_Control_cutting_time);
    % for posture
    [Ex3_Count_spike_all,Ex3_Task_spike_time_all,Ex3_Mean_firing_rate_all,Ex3_Pos_each_main_wavedata] = Cutting_data_for_each_DI(newSpkTime,newWavedata,EX3_task_DI_Lineup_Trial,Ex3_Posture_cutting_time);
    disp('select main')

elseif strcmp(experiment3_select_trial, 'not_control')
    %plot psth make folder
    experiment3_folder = createNamedFolder(step4savefolder, 'Experment3 not control');
    experiment3_psth = createNamedFolder(experiment3_folder, 'Each posture PSTH');
    %Separate 5 trial using the number of DI
    numbertest = 1:1:length(Position_ID);
    EX3N_task_DI_Trialnew = EX3_noCont_task_DI_Trial;
    for i = 1:length(EX3N_task_DI_Trialnew)
        EX3N_task_DI_Trialnew{i} = [EX3N_task_DI_Trialnew{i}, Position_ID(:,i)];
    end
    %line up position data
    EX3_task_DI_Lineup_Trial = cell(size(EX3N_task_DI_Trialnew));
    for i = 1:Trial
        EX3_task_DI_Lineup_Trial{i,1} = sortrows(EX3_noCont_task_DI_Trial{i,1},4);
    end

    % Separate each timing
    Ex3_Posture_cutting_time = [-20 20];
    %Static posture
    [Ex3_Count_spike_all,Ex3_Task_spike_time_all,Ex3_Mean_firing_rate_all,Ex3_Pos_each_main_wavedata] = Cutting_data_for_each_DI(newSpkTime,newWavedata,EX3_task_DI_Lineup_Trial,Ex3_Posture_cutting_time);
    disp('select no control')
elseif strcmp(experiment3_select_trial, 'both')
    experiment3_folder = createNamedFolder(step4savefolder, 'Experment3_10trial');
    experiment3_psth = createNamedFolder(experiment3_folder, 'Each posture PSTH');
    
    %Separate 10 trial using the number of DI
    numbertest = 1:1:length(Position_ID);
    EX3_10trial_task_DI_Trialnew = [EX3_noCont_task_DI_Trial;EX3_task_DI_Trial];
    Position_ID_10tri = [Position_ID,Position_ID];

    for i = 1:length(EX3_10trial_task_DI_Trialnew)
        EX3_10trial_task_DI_Trialnew{i} = [EX3_10trial_task_DI_Trialnew{i}, Position_ID_10tri(:,i)];
    end

    %line up position data
    EX3_task_DI_Lineup_Trial = cell(size(EX3_10trial_task_DI_Trialnew));
    for i = 1:length(EX3_10trial_task_DI_Trialnew)
        EX3_task_DI_Lineup_Trial{i,1} = sortrows(EX3_10trial_task_DI_Trialnew{i,1},4);
    end

    % Separate each timing
    Ex3_Posture_cutting_time = [-20 20];
    %Static posture
    [Ex3_Count_spike_all,Ex3_Task_spike_time_all,Ex3_Mean_firing_rate_all,Ex3_Pos_each_main_wavedata] = Cutting_data_for_each_DI(newSpkTime,newWavedata,EX3_task_DI_Lineup_Trial,Ex3_Posture_cutting_time);
    
    disp('select both')

else
    warning('Unrecognized trial type.');
end


%% check time data
EX3_control_DI;
EX3_task_DI_Trialnew;

All_pos_time_not_align = [EX3_task_DI_Trialnew{1,1}(:,:);EX3_task_DI_Trialnew{2,1}(:,:);EX3_task_DI_Trialnew{3,1}(:,:);EX3_task_DI_Trialnew{4,1}(:,:);EX3_task_DI_Trialnew{5,1}(:,:)];

EX3_control_DI_new = [EX3_control_DI,[0;0;0;0;0;0]];

All_time_not_align = [EX3_control_DI_new(1,:);EX3_task_DI_Trialnew{1,1}(:,:);EX3_control_DI_new(2,:);EX3_task_DI_Trialnew{2,1}(:,:);EX3_control_DI_new(3,:);EX3_task_DI_Trialnew{3,1}(:,:);EX3_control_DI_new(4,:);EX3_task_DI_Trialnew{4,1}(:,:);EX3_control_DI_new(5,:);EX3_task_DI_Trialnew{5,1}(:,:);EX3_control_DI_new(6,:)];

All_pos_time_not_align_only_robot_stop = All_pos_time_not_align(:,3);
Robot_stop_time_mean = mean(All_pos_time_not_align_only_robot_stop);
Robot_stop_time_std = std(All_pos_time_not_align_only_robot_stop);

% --- プロット ---
figure;
x = 1:length(All_pos_time_not_align_only_robot_stop);
y = All_pos_time_not_align_only_robot_stop;

plot(x, y, 'b'); % 元データ
hold on;

% --- 標準偏差の帯を追加（パッチ）---
x_fill = [x, fliplr(x)];
y_fill = [repmat(Robot_stop_time_mean + Robot_stop_time_std, size(x)), ...
          fliplr(repmat(Robot_stop_time_mean - Robot_stop_time_std, size(x)))];
fill(x_fill, y_fill, [0.7 0.7 0.7], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % 薄いグレー帯

% --- 平均値ライン ---
plot(x, repmat(Robot_stop_time_mean, size(x)), 'k', 'LineWidth', 2); % 黒の太線
% --- 平均値と標準偏差をテキスト表示 ---
x_text = x(end)*0.7;  % テキストを右寄りに配置（位置は調整可）
y_text = Robot_stop_time_mean + Robot_stop_time_std*1.2;

text(x_text, y_text, sprintf('Mean = %.2f', Robot_stop_time_mean), ...
    'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
text(x_text, y_text - Robot_stop_time_std*0.8, sprintf('SD = %.2f', Robot_stop_time_std), ...
    'Color', [0.4 0.4 0.4], 'FontSize', 12, 'FontWeight', 'bold');

% --- 仕上げ ---
xlabel('Task');
ylabel('Time');
title('Robot Stop Time (mean ± std)');
grid on;
hold off;

fontsize(gcf,20,"points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_folder, 'Robotstoptime.tif');
print(gcf, tifFileName, '-dtiff', '-r300');


%% calculate robot moving time

Robot_moving_time = All_time_not_align(2:length(All_time_not_align),1) - All_time_not_align(1:length(All_time_not_align)-1,2);
%Delete ecause of not series monement of robot
Robot_moving_time(Robot_moving_time > 10) = 0;
[max_time_robot_moving, max_idx_robot_moving] = max(Robot_moving_time);



%% Align video data
if strcmp(experiment3_select_trial, 'main')
    Ex3_main_time_data_align_offset = EX3_control_DI(1,2);

    Ex3_main_time_data_align = Ex3_main_time_data_align_offset + main_time_data;
    % define position
    
    each_pos_position_data = Cutting_pos_data(EX3_task_DI_Lineup_Trial,Ex3_main_time_data_align,Pos_main_data,[-5 20]);
    each_control_position_data = Cutting_pos_data(EX3_control_DI,Ex3_main_time_data_align,Pos_main_data,[5 55]);
else

end

%3D plot
figure;
colors = jet(16);
for i = 1:5
    for postutre_num = 1:16
    color = colors(postutre_num, :);
    %plot3(each_pos_position_data{1,i}{1,postutre_num}(1,:), each_pos_position_data{1,i}{1,postutre_num}(2,:), each_pos_position_data{1,i}{1,postutre_num}(3,:), 'o','Color', color);
    hold on;
    plot3(each_pos_position_data{1,i}{2,postutre_num}(1,:), each_pos_position_data{1,i}{2,postutre_num}(2,:), each_pos_position_data{1,i}{2,postutre_num}(3,:), 'o','Color', [0 0 0]);
    %plot3(each_pos_position_data{1,i}{3,postutre_num}(1,:), each_pos_position_data{1,i}{3,postutre_num}(2,:), each_pos_position_data{1,i}{3,postutre_num}(3,:), 'o','Color', color);
    plot3(each_pos_position_data{1,i}{4,postutre_num}(1,:), each_pos_position_data{1,i}{4,postutre_num}(2,:), each_pos_position_data{1,i}{4,postutre_num}(3,:), 'o','Color', color);
    %plot3(each_pos_position_data{1,i}{5,postutre_num}(1,:), each_pos_position_data{1,i}{5,postutre_num}(2,:), each_pos_position_data{1,i}{5,postutre_num}(3,:), 'o','Color', color);
    end
end
title('After transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on; view(3);



%% 

% ===============================
%  基本設定
% ===============================
trial_list = 1:5;
nPosture   = 16;

fontSizeAxis  = 18;
fontSizeTitle = 20;
fontSizeLabel = 18;

fig_w = 20; % cm
fig_h = 16; % cm

coord_list = {'X','Y'};   % ← X / Y

% ===============================
%  フォルダ作成
% ===============================
base_folder = fullfile(experiment3_folder, 'Motion_Speed_analysis');

ankle_X_folder = fullfile(base_folder, 'Ankle', 'X');
ankle_Y_folder = fullfile(base_folder, 'Ankle', 'Y');
paw_X_folder   = fullfile(base_folder, 'Paw',   'X');
paw_Y_folder   = fullfile(base_folder, 'Paw',   'Y');
coord_list = {'X','Y'};
folder_list = {ankle_X_folder, ankle_Y_folder, paw_X_folder, paw_Y_folder};
for i = 1:length(folder_list)
    if ~exist(folder_list{i},'dir')
        mkdir(folder_list{i});
    end
end

% ===============================
%  姿勢ループ
% ===============================
for posture_num = 1:nPosture

    % ===============================
    %  マーカー（Ankle / Paw）
    % ===============================
    for marker_idx = [4 5]

        if marker_idx == 4
            marker_name = 'Ankle';
        else
            marker_name = 'Paw';
        end

        % ===============================
        %  座標（X / Y）
        % ===============================
        for c = 1:length(coord_list)

            coord_name = coord_list{c};

            % ===== 保存フォルダ =====
            if strcmp(marker_name,'Ankle') && strcmp(coord_name,'X')
                save_folder = ankle_X_folder;
            elseif strcmp(marker_name,'Ankle') && strcmp(coord_name,'Y')
                save_folder = ankle_Y_folder;
            elseif strcmp(marker_name,'Paw') && strcmp(coord_name,'X')
                save_folder = paw_X_folder;
            else
                save_folder = paw_Y_folder;
            end

            % ===============================
            %  Y軸範囲の事前計算
            % ===============================
            all_data = [];

            for iTrial = trial_list
                pos = each_pos_position_data{1,iTrial}{marker_idx, posture_num};

                if strcmp(coord_name,'X')
                    data = pos(1,:);
                else
                    data = pos(3,:);
                end

                t = pos(4,:);

                [t, idx] = sort(t);
                data = data(idx);

                all_data = [all_data, data];

                validIdx = ~isnan(data) & ~isnan(t);
                if sum(validIdx) >= 2
                    data_interp = interp1(t(validIdx), data(validIdx), t, 'linear','extrap');
                    all_data = [all_data, data_interp];
                end
            end

            yMin = min(all_data, [], 'omitnan');
            yMax = max(all_data, [], 'omitnan');

            % ===============================
            %  Figure
            % ===============================
            figure('Units','centimeters','Position',[5 5 fig_w fig_h]);

            % ===============================
            % 上段：補間前
            % ===============================
            subplot(2,1,1); hold on; grid on;

            for iTrial = trial_list
                pos = each_pos_position_data{1,iTrial}{marker_idx, posture_num};

                if strcmp(coord_name,'X')
                    data = pos(1,:);
                else
                    data = pos(3,:);
                end

                t = pos(4,:);

                [t, idx] = sort(t);
                data = data(idx);

                plot(t, data, 'LineWidth', 1.5);
            end

            xline(0,'k--','LineWidth',1.2);
            ylabel(sprintf('%s position (mm)', coord_name),'FontSize',fontSizeLabel);
            title(sprintf('Posture %d – %s (%s, raw)', ...
                posture_num, marker_name, coord_name), ...
                'FontSize',fontSizeTitle);

            ylim([yMin yMax]);
            set(gca,'FontSize',fontSizeAxis,'LineWidth',1.5);

            % ===============================
            % 下段：補間後
            % ===============================
            subplot(2,1,2); hold on; grid on;

            for iTrial = trial_list
                pos = each_pos_position_data{1,iTrial}{marker_idx, posture_num};

                if strcmp(coord_name,'X')
                    data = pos(1,:);
                else
                    data = pos(3,:);
                end

                t = pos(4,:);

                [t, idx] = sort(t);
                data = data(idx);

                validIdx = ~isnan(data) & ~isnan(t);
                if sum(validIdx) >= 2
                    data_interp = interp1(t(validIdx), data(validIdx), t, 'linear','extrap');
                else
                    data_interp = nan(size(data));
                end

                plot(t, data_interp, 'LineWidth', 1.5);
            end

            xline(0,'k--','LineWidth',1.2);
            xlabel('Time (s)','FontSize',fontSizeLabel);
            ylabel(sprintf('%s position (mm)', coord_name),'FontSize',fontSizeLabel);
            title(sprintf('Posture %d – %s (%s, interpolated)', ...
                posture_num, marker_name, coord_name), ...
                'FontSize',fontSizeTitle);

            ylim([yMin yMax]);
            set(gca,'FontSize',fontSizeAxis,'LineWidth',1.5);

            % ===============================
            % 保存
            % ===============================
            png_name = sprintf('Posture_%02d_%s_%s.png', ...
                posture_num, marker_name, coord_name);

            print(gcf, fullfile(save_folder, png_name), '-dpng', '-r300');
            close(gcf);

        end
    end
end

%% 
trial_list = 1:5;
nPosture   = 16;

fontAxis  = 14;
fontTitle = 14;
fontLabel = 16;

fig_w = 30; % cm
fig_h = 24; % cm

coord_list = {'X','Y'};   % 座標
marker_list = [4 5];     % 4=Ankle, 5=Paw

% ===============================
%  ループ：Marker × Coord
% ===============================
for marker_idx = marker_list

    if marker_idx == 4
        marker_name = 'Ankle';
    else
        marker_name = 'Paw';
    end

    for c = 1:length(coord_list)

        coord_name = coord_list{c};

        % ===============================
        %  Y軸範囲（16姿勢すべて共通）
        % ===============================
        all_data = [];

        for posture_num = 1:nPosture
            for iTrial = trial_list
                pos = each_pos_position_data{1,iTrial}{marker_idx, posture_num};

                if strcmp(coord_name,'X')
                    data = pos(1,:);
                else
                    data = pos(3,:);
                end

                t = pos(4,:);
                [t, idx] = sort(t);
                data = data(idx);

                all_data = [all_data, data];
            end
        end

        yMin = min(all_data, [], 'omitnan');
        yMax = max(all_data, [], 'omitnan');

        % ===============================
        %  Figure
        % ===============================
        figure('Units','centimeters','Position',[3 3 fig_w fig_h]);
        tiledlayout(4,4,'TileSpacing','compact','Padding','compact');

        % ===============================
        %  姿勢ループ（4×4）
        % ===============================
        for posture_num = 1:nPosture

            nexttile; hold on; grid on;

            for iTrial = trial_list
                pos = each_pos_position_data{1,iTrial}{marker_idx, posture_num};

                if strcmp(coord_name,'X')
                    data = pos(1,:);
                else
                    data = pos(3,:);
                end

                t = pos(4,:);
                [t, idx] = sort(t);
                data = data(idx);

                plot(t, data, 'LineWidth', 1.2);
            end

            xline(0,'k--','LineWidth',1);

            ylim([yMin yMax]);
            title(sprintf('Pos %d', posture_num), 'FontSize', fontTitle);

            set(gca,'FontSize',fontAxis,'LineWidth',1.2);

            % 軸ラベルは左下だけ
            if posture_num == 13
                xlabel('Time (s)','FontSize',fontLabel);
                ylabel(sprintf('%s pos (mm)',coord_name),'FontSize',fontLabel);
            end
        end

        % ===============================
        %  全体タイトル
        % ===============================
        sgtitle(sprintf('%s – %s position (raw, NaN included)', ...
            marker_name, coord_name), ...
            'FontSize', 20, 'FontWeight','bold');

        % ===============================
        %  保存
        % ===============================
        save_folder = fullfile( ...
            experiment3_folder, ...
            'Motion_Position_Raw_4x4', ...
            marker_name, coord_name);

        if ~exist(save_folder,'dir')
            mkdir(save_folder);
        end

        png_name = sprintf('%s_%s_raw_4x4.png', marker_name, coord_name);
        print(gcf, fullfile(save_folder, png_name), '-dpng', '-r300');
        close(gcf);

    end
end



%% Speed
trial_list = 1:5;
nPosture   = 16;

% ===== 再サンプリング設定 =====
dt_rs = 0.03;                 % 50 ms
t_rs  = -5:dt_rs:20;           % ★必要に応じて変更★

% ===== 移動平均設定 =====
win = 5;
win_note = sprintf('movmean window = %d frames', win);

% ===== 保存フォルダ =====
speed_folder = fullfile(experiment3_folder, 'Motion_Speed_analysis');
ankle_folder = fullfile(speed_folder, 'Ankle_speed');
paw_folder   = fullfile(speed_folder, 'Paw_speed');

if ~exist(speed_folder,'dir'); mkdir(speed_folder); end
if ~exist(ankle_folder,'dir'); mkdir(ankle_folder); end
if ~exist(paw_folder,'dir');   mkdir(paw_folder);  end

% ===== 描画設定 =====
fontAxis  = 18;
fontLabel = 18;
fontTitle = 20;

fig_w = 22;
fig_h = 16;

% ===== 姿勢ループ =====
for posture_num = 1:nPosture
    for marker_idx = [4 5]   % 4=Ankle, 5=Paw

        if marker_idx == 4
            marker_name = 'Ankle';
            save_folder = ankle_folder;
        else
            marker_name = 'Paw';
            save_folder = paw_folder;
        end

        % trial × time の行列
        Vx_rs = nan(length(trial_list), length(t_rs));
        Vy_rs = nan(length(trial_list), length(t_rs));
        V_rs  = nan(length(trial_list), length(t_rs));

        % ===== Trial loop =====
        for k = 1:length(trial_list)
            i = trial_list(k);

            pos = each_pos_position_data{1,i}{marker_idx, posture_num};

            x = pos(1,:);
            y = pos(3,:);
            t = pos(4,:);

            [t, idx] = sort(t);
            x = x(idx);
            y = y(idx);

            validIdx = ~isnan(x) & ~isnan(y) & ~isnan(t);
            if sum(validIdx) < 2
                continue;
            end

            % 補間
            x_interp = interp1(t(validIdx), x(validIdx), t, 'linear','extrap');
            y_interp = interp1(t(validIdx), y(validIdx), t, 'linear','extrap');

            % 平滑化
            x_smooth = movmean(x_interp, win, 'omitnan');
            y_smooth = movmean(y_interp, win, 'omitnan');

            % 速度
            vx = diff(x_smooth) ./ diff(t);
            vy = diff(y_smooth) ./ diff(t);
            v  = sqrt(vx.^2 + vy.^2);

            t_v = t(1:end-1);

            % ===== 50 ms 再サンプリング =====
            Vx_rs(k,:) = interp1(t_v, abs(vx), t_rs, 'linear', NaN);
            Vy_rs(k,:) = interp1(t_v, abs(vy), t_rs, 'linear', NaN);
            V_rs(k,:)  = interp1(t_v, v,        t_rs, 'linear', NaN);
        end

        % ===== trial平均 =====
        Vx_mean = mean(Vx_rs, 1, 'omitnan');
        Vy_mean = mean(Vy_rs, 1, 'omitnan');
        V_mean  = mean(V_rs,  1, 'omitnan');

        % ===== 図 =====
        figure('Units','centimeters','Position',[5 5 fig_w fig_h]);
        hold on; grid on;

        plot(t_rs, Vx_mean, 'r', 'LineWidth',2);
        plot(t_rs, Vy_mean, 'b', 'LineWidth',2);
        plot(t_rs, V_mean,  'k', 'LineWidth',2.5);

        xline(0,'k--','LineWidth',1.2);

        xlabel('Time (s)','FontSize',fontLabel);
        ylabel('Speed (mm/s)','FontSize',fontLabel);
        title(sprintf('Posture %d – %s (50 ms binned, trial mean)', ...
            posture_num, marker_name), 'FontSize',fontTitle);

        legend({'|Vx|','|Vy|','|V|'}, 'Location','best');

        text(0.02,0.95, ...
            sprintf('%s\nbin = %.0f ms', win_note, dt_rs*1000), ...
            'Units','normalized', ...
            'FontSize',16, ...
            'FontWeight','bold', ...
            'VerticalAlignment','top');

        set(gca,'FontSize',fontAxis,'LineWidth',1.5);

        % ===== 保存 =====
        png_name = sprintf('Posture_%02d_%s_speed_50ms.png', ...
            posture_num, marker_name);
        print(gcf, fullfile(save_folder, png_name), '-dpng', '-r300');
        close(gcf);
    end
end



%% Figure 3A
trial_list = 1:5;
nPosture   = 16;

% ===== 再サンプリング設定 =====
dt_rs = 0.03;                 % 50 ms
t_rs  = -5:dt_rs:20;           % ★必要に応じて変更★

% ===== 移動平均設定 =====
win = 5;
win_moving = win*dt_rs*1000;

% ===== 保存フォルダ =====
speed_folder = fullfile(experiment3_folder, 'Motion_Speed_analysis');
main_fig_folder = fullfile(speed_folder, 'Main figure');

if ~exist(speed_folder,'dir'); mkdir(speed_folder); end
if ~exist(main_fig_folder,'dir'); mkdir(main_fig_folder); end

% ===== 描画設定 =====
fontAxis  = 10;
fontLabel = 10;
fontTitle = 10;

fig_w = 22;
fig_h = 16;

% ===== 姿勢ループ =====
target_pos_in_speed_figure = 1;

posture_num  =  target_pos_in_speed_figure;
save_folder = main_fig_folder;
 

% trial × time の行列
Vx_rs = nan(length(trial_list), length(t_rs));
Vy_rs = nan(length(trial_list), length(t_rs));
V_rs  = nan(length(trial_list), length(t_rs));

% ===== Trial loop =====
for k = 1:length(trial_list)
    i = trial_list(k);

    pos = each_pos_position_data{1,i}{4, posture_num};

    x = pos(1,:);
    y = pos(3,:);
    t = pos(4,:);

    [t, idx] = sort(t);
    x = x(idx);
    y = y(idx);

    validIdx = ~isnan(x) & ~isnan(y) & ~isnan(t);
    if sum(validIdx) < 2
        continue;
    end

    % 補間
    x_interp = interp1(t(validIdx), x(validIdx), t, 'linear','extrap');
    y_interp = interp1(t(validIdx), y(validIdx), t, 'linear','extrap');

    % 平滑化
    x_smooth = movmean(x_interp, win, 'omitnan');
    y_smooth = movmean(y_interp, win, 'omitnan');

    % 速度
    vx = diff(x_smooth) ./ diff(t);
    vy = diff(y_smooth) ./ diff(t);
    v  = sqrt(vx.^2 + vy.^2);

    t_v = t(1:end-1);
    % ===== 30 ms 再サンプリング =====
    Vx_rs(k,:) = interp1(t_v, abs(vx), t_rs, 'linear', NaN);
    Vy_rs(k,:) = interp1(t_v, abs(vy), t_rs, 'linear', NaN);
    V_rs(k,:)  = interp1(t_v, v,        t_rs, 'linear', NaN);
end

% ===== trial平均と標準偏差 =====
Vx_mean = mean(Vx_rs, 1, 'omitnan');
Vy_mean = mean(Vy_rs, 1, 'omitnan');
V_mean  = mean(V_rs,  1, 'omitnan');

V_std   = std(V_rs, 0, 1, 'omitnan');  % 標準偏差

% ===== 図 =====
figure('Units','centimeters','Position',[5 5 8 6.5]);
hold on; grid on;

% 標準偏差の影
validIdx = ~isnan(V_mean) & ~isnan(V_std);
X_fill = t_rs(validIdx);
Y_fill = [V_mean(validIdx)-V_std(validIdx), fliplr(V_mean(validIdx)+V_std(validIdx))];
fill([X_fill, fliplr(X_fill)], Y_fill, [0.3 0.3 0.3], 'FaceAlpha',0.3, 'EdgeColor','none');

% 平均値プロット
plot(t_rs, V_mean,  'k', 'LineWidth',2.5);

% x=0 と x=15 の濃いグレー点線
xline(0, 'Color',[0.1 0.1 0.1], 'LineStyle',':', 'LineWidth',1.2);
xline(15,'Color',[0.1 0.1 0.1], 'LineStyle',':', 'LineWidth',1.2);

% ===== 軸ラベル・タイトル =====
xlabel('Time [s]', 'FontSize', fontLabel, 'FontName', 'Arial', 'FontWeight', 'bold');
ylabel('Speed of ankle [mm/s]', 'FontSize', fontLabel, 'FontName', 'Arial', 'FontWeight', 'bold');
title(sprintf('Cat A Pos-%d', posture_num), 'FontSize', fontTitle, 'FontName', 'Arial', 'FontWeight', 'bold');

% ===== 軸目盛り設定 =====
xlim([-5 20]);
xticks([-5 0 5 10 15 20]);
yticks('auto');   % 必要に応じて手動も可

text(0.5,0.285, ...
            sprintf('bin = %.0f ms', dt_rs*1000), ...
            'Units','normalized', ...
            'FontSize',8, ...
            'FontWeight','bold', ...
            'FontName','Arial', ...
            'VerticalAlignment','top');

% ===== 軸の設定 =====
% 軸のフォント・太さ・目盛り方向
set(gca, 'FontSize', fontAxis, ...
         'FontName', 'Arial', ...
         'FontWeight', 'bold', ...
         'LineWidth', 1.5, ...
         'TickDir', 'out', ...    % 目盛りを外向き
         'XGrid', 'off', ...      % 横グリッド線 OFF
         'YGrid', 'off');         % 縦グリッド線 OFF

% ===== 保存 =====
emf_name = sprintf('Posture_%02d_speed_30ms.emf', posture_num);
print(gcf, fullfile(save_folder, emf_name), '-dmeta');  % EMFで保存
%close(gcf);





%% calculate speed
trial_list = 1:5;
nPosture   = 16;

% ===== 再サンプリング設定 =====
dt_rs = 0.03 ;               
t_rs  = -5:dt_rs:20;        

% ===== 移動平均設定 =====
win = 5;

% ===== 描画設定 =====
fontAxis  = 18;
fontLabel = 18;
fontTitle = 20;

fig_w = 22;
fig_h = 16;

marker_idx = 4;   % Ankleのみ

% 全trial・全姿勢を格納
V_all = [];

% ===============================
% 姿勢ループ
% ===============================
for posture_num = 1:nPosture

    % trial × time の行列
    V_rs  = nan(length(trial_list), length(t_rs));

    % ===== Trial loop =====
    for k = 1:length(trial_list)
        i = trial_list(k);

        pos = each_pos_position_data{1,i}{marker_idx, posture_num};

        x = pos(1,:);
        y = pos(3,:);
        t = pos(4,:);

        [t, idx] = sort(t);
        x = x(idx);
        y = y(idx);

        validIdx = ~isnan(x) & ~isnan(y) & ~isnan(t);
        if sum(validIdx) < 2
            continue;
        end

        % 補間
        x_interp = interp1(t(validIdx), x(validIdx), t, 'linear','extrap');
        y_interp = interp1(t(validIdx), y(validIdx), t, 'linear','extrap');

        % 平滑化
        x_smooth = movmean(x_interp, win, 'omitnan');
        y_smooth = movmean(y_interp, win, 'omitnan');

        % 速度
        vx = diff(x_smooth) ./ diff(t);
        vy = diff(y_smooth) ./ diff(t);
        v  = sqrt(vx.^2 + vy.^2);

        t_v = t(1:end-1);

        % 再サンプリング
        V_rs(k,:) = interp1(t_v, v, t_rs, 'linear', NaN);
    end

    % 全姿勢分を結合
    V_all = [V_all; V_rs];
end

% plot
V_mean = mean(V_all, 1, 'omitnan');
V_sd   = std(V_all,  0, 1, 'omitnan');

V_mean = V_mean(:)';
V_sd   = V_sd(:)';
t_rs   = t_rs(:)';

% ===============================
% baseline (5–10 s) から +3SD を計算
% ===============================
baseline_range = [5 10];

% baselineに該当する時間インデックス
base_idx = t_rs >= baseline_range(1) & t_rs <= baseline_range(2);

% baselineデータ（trial × time）
V_baseline = V_all(:, base_idx);

% baseline平均とSD（全trial・全baseline時間をまとめて計算）
baseline_mean = mean(V_baseline(:), 'omitnan');
baseline_sd   = std(V_baseline(:),  'omitnan');

% +2SD閾値
threshold_2sd = baseline_mean + 2 * baseline_sd;

% ===============================
% パラメータ
% ===============================
search_start = 14;     % 探索開始時刻
min_duration = 0.10;   % 100 ms

n_required = ceil(min_duration / dt_rs);   % 必要連続サンプル数

% ===============================
% 14秒以降の区間を取得
% ===============================
idx_after14 = find(t_rs >= search_start);
V_search = V_mean(idx_after14);

% thresholdを超えているかの論理配列
above_th = V_search > threshold_2sd;

% ===============================
% 連続超えの検出
% ===============================
onset_idx = NaN;

for i = 1:length(above_th) - n_required + 1
    if all(above_th(i : i+n_required-1))
        onset_idx = idx_after14(i);
        break
    end
end

% patch用にNaNのみ補間（時間軸は維持）
V_mean_patch = fillmissing(V_mean,'linear');
V_sd_patch   = fillmissing(V_sd,'linear');

figure('Units','centimeters','Position',[5 5 fig_w fig_h]);
hold on; grid on;

% SD帯（補間データ）
patch([t_rs fliplr(t_rs)], ...
      [V_mean_patch-V_sd_patch fliplr(V_mean_patch+V_sd_patch)], ...
      [0.6 0.6 0.6], ...
      'FaceAlpha',0.25, ...
      'EdgeColor','none');



% 平均線（元データ）
plot(t_rs, V_mean, 'k', 'LineWidth',3);

% 閾値ライン（赤破線）onset_time
yline(threshold_2sd, 'b--', 'LineWidth',2);

% 軸範囲取得
x_mid = mean(xlim);

% 青いラベルを中央に表示
text(x_mid, threshold_2sd, ...
    'Baseline +2SD', ...
    'Color','b', ...
    'FontSize',16, ...
    'FontWeight','bold', ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','bottom');


xline(0,'k--','LineWidth',1.2);

if ~isnan(onset_idx)
    onset_time = t_rs(onset_idx);

    xline(onset_time, 'r--', 'LineWidth',2);

    x_range = xlim;
    x_offset = 0.05 * diff(x_range);   % 横幅の5%分左にずらす
    text(onset_time - x_offset, max(V_mean), ...
    sprintf('Onset = %.2f s', onset_time), ...
    'Color','r', ...
    'FontSize',15, ...
    'FontWeight','bold', ...
    'HorizontalAlignment','right', ... % 文字を右寄せ
    'VerticalAlignment','top');
else
    disp('No sustained threshold crossing found.');
end


xlabel('Time (s)','FontSize',fontLabel,'FontWeight','bold');
ylabel('Speed (mm/s)','FontSize',fontLabel,'FontWeight','bold');
title('Ankle speed across all postures (mean ± SD)', ...
    'FontSize',fontTitle,'FontWeight','bold');

set(gca,'FontSize',fontAxis,'LineWidth',1.5,'FontWeight','bold');
set(gcf,'Color','w');

% ファイル名
file_base = fullfile(experiment3_static_folder, 'Ankle_speed_onset_CatA');

% PNG保存（高解像度）
print(gcf, [file_base '.png'], '-dpng', '-r300');

% PDF保存（ベクター形式）
print(gcf, [file_base '.pdf'], '-dpdf', '-painters');



%% calculate angle
static_posture_cuttime = [1 14];
only_static_posture_position = Cutting_pos_data(EX3_task_DI_Lineup_Trial,Ex3_main_time_data_align,Pos_main_data,static_posture_cuttime);


% collect all trial position data
Conmine_each_posture_matrix = cell(length(only_static_posture_position{1,1}),size(only_static_posture_position{1,1},1));
for position = 1:size(only_static_posture_position{1,1},1)
    for pos = 1:16
        for i = 1:5
            Conmine_each_posture_matrix_component = only_static_posture_position{1,i}{position,pos}(1:3,:);
            if i < 2
                Conmine_each_posture_matrix_component_new = Conmine_each_posture_matrix_component;
            else
                Conmine_each_posture_matrix_component_new = [Conmine_each_posture_matrix_component_new,Conmine_each_posture_matrix_component];
            end
        end
        Conmine_each_posture_matrix{pos,position} = Conmine_each_posture_matrix_component_new;
    end
end

%combine all posture for hip bone and hip joint
H_bone_all = [];
hip_all = [];
for i = 1:length(Conmine_each_posture_matrix)
    H_bone_each = Conmine_each_posture_matrix{i,1};
    hip_each = Conmine_each_posture_matrix{i,2};
    H_bone_all = [H_bone_all, H_bone_each];  
    hip_all = [hip_all, hip_each];  
end

% average all posture data
H_bone_mean = mean(H_bone_all, 2, 'omitnan')';  % 各行の平均（NaN除外）
hip_mean = mean(hip_all, 2, 'omitnan')';  % 各行の平均（NaN除外）

for i = 1:length(Conmine_each_posture_matrix)
    Knee_mean(i,:) = mean(Conmine_each_posture_matrix{i,3}, 2, 'omitnan')';
    Ankle_mean(i,:) = mean(Conmine_each_posture_matrix{i,4}, 2, 'omitnan')';
    Paw_mean(i,:) = mean(Conmine_each_posture_matrix{i,5}, 2, 'omitnan')';
end


% カラーマップ（16色）
colors = lines(16);  % または parula(16), hsv(16), jet(16) など

figure;
hold on;
grid on;
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Plot of Paw → Ankle → Knee (colored per row)');

for i = 1:16
    % 各点の座標（1×3ベクトル）
    paw = Paw_mean(i,:);
    ankle = Ankle_mean(i,:);
    knee = Knee_mean(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords = [ankle; knee; hip_mean;H_bone_mean];
    
    % プロット（色を行ごとに変える）
    plot3(coords(:,1), coords(:,2), coords(:,3), ':', 'Color', colors(i,:), ...
        'LineWidth', 2);
    plot3(Ankle_mean(9,1), Ankle_mean(9,2), Ankle_mean(9,3), 'o', 'Color', colors(9,:), ...
        'LineWidth', 2);
end

view(3);  % 3次元視点に切り替え


% calculate link length
vec_PawToAnkle = Ankle_mean - Paw_mean;   % 16×3
vec_AnkleToKnee = Knee_mean - Ankle_mean; % 16×3
vec_KneeToHip = Knee_mean - hip_mean;
vec_HipToHbone = H_bone_mean - hip_mean;

% ユークリッド距離（行ごとにノルム）
link1_length = sqrt(sum(vec_PawToAnkle.^2, 2));   % Paw→Ankle
link1_length_mean = mean(link1_length, 'omitnan');
link2_length = sqrt(sum(vec_AnkleToKnee.^2, 2));  % Ankle→Knee
link2_length_mean = mean(link2_length, 'omitnan');
link3_length = sqrt(sum(vec_KneeToHip.^2, 2));  % Hip→Knee
link3_length_mean = mean(link3_length, 'omitnan');
link4_length = sqrt(sum(vec_HipToHbone.^2, 2));  % Hip→Hipbone
link4_length_mean = mean(link4_length, 'omitnan');


link_compare_main = zeros(length(link1_length),4);
link_compare_main(:,1) = link1_length;
link_compare_main(:,2) = link2_length;
link_compare_main(:,3) = link3_length;
link_compare_main(:,4) = link4_length;
link_compare_main_mean = [link1_length_mean,link2_length_mean,link3_length_mean,link4_length_mean];

real_length = [94, 115,110, 24];

% calculate control length
H_bone_all_control = [];
hip_all_control = [];
knee_all_control = [];
ankle_all_control = [];
paw_all_control = [];

for i = 1:size(each_control_position_data,2)
    H_bone_each_control = each_control_position_data{1,i};
    hip_each_control = each_control_position_data{2,i};
    knee_each_control = each_control_position_data{3,i};
    ankle_each_control = each_control_position_data{4,i};
    paw_each_control = each_control_position_data{5,i};

    H_bone_all_control = [H_bone_all_control, H_bone_each_control];  
    hip_all_control = [hip_all_control, hip_each_control];  
    knee_all_control = [knee_all_control,knee_each_control];
    ankle_all_control = [ankle_all_control,ankle_each_control];
    paw_all_control = [paw_all_control,paw_each_control];
end
% average all posture data
H_bone_mean_conrol = mean(H_bone_all_control(1:3,:), 2, 'omitnan')';  % 各行の平均（NaN除外）
hip_mean_control = mean(hip_all_control(1:3,:), 2, 'omitnan')';  % 各行の平均（NaN除外）
knee_mean_control = mean(knee_all_control(1:3,:), 2, 'omitnan')';  % 各行の平均（NaN除外）
ankle_mean_control = mean(ankle_all_control(1:3,:), 2, 'omitnan')';  % 各行の平均（NaN除外）
paw_mean_control = mean(paw_all_control(1:3,:), 2, 'omitnan')';  % 各行の平均（NaN除外）

vec_PawToAnkle_control = ankle_mean_control - paw_mean_control;   % 16×3
vec_AnkleToKnee_control = knee_mean_control - ankle_mean_control; % 16×3
vec_KneeToHip_control = knee_mean_control - hip_mean_control;
vec_HipToHbone_control = H_bone_mean_conrol - hip_mean_control;

% ユークリッド距離（行ごとにノルム）
link1_length_control = sqrt(sum(vec_PawToAnkle_control.^2, 2));   % Paw→Ankle
link2_length_control = sqrt(sum(vec_AnkleToKnee_control.^2, 2));  % Ankle→Knee
link3_length_control = sqrt(sum(vec_KneeToHip_control.^2, 2));  % Hip→Knee
link4_length_control = sqrt(sum(vec_HipToHbone_control.^2, 2));  % Hip→Hipbone


link_compare_control = [link1_length_control,link2_length_control,link3_length_control,link4_length_control];



link_both = [link_compare_main;link_compare_main_mean;link_compare_control;real_length];

%% link_both は m x n 行列
col_mean = mean(link_both(1:16,:), 1, 'omitnan');  % 各列の平均（NaNを無視）
col_std  = std(link_both(1:16,:), 0, 1, 'omitnan'); % 各列の標準偏差（NaNを無視）

% 結果表示
disp('Column-wise mean:');
disp(col_mean);
disp('Column-wise standard deviation:');
disp(col_std);

%% estimate posture 9
Hip_point = hip_mean;
Knee_point = mean(Knee_mean, 'omitnan');
Ankle_point = Ankle_mean(9,:);
link1_model = link_compare_main_mean(1,3);
link2_model = link_compare_main_mean(1,2);


% ① 平面を求める
v1_estimate = Knee_point - Hip_point;
v2_estimate = Ankle_point - Hip_point;
normal_vec_estimate = cross(v1_estimate, v2_estimate);
normal_vec_estimate = normal_vec_estimate / norm(normal_vec_estimate);

% ② 球の交線（円）の中心と半径
d_estimate = norm(Ankle_point - Hip_point);
ex_estimate = (Ankle_point - Hip_point) / d_estimate;
x_estimate = (link1_model^2 - link2_model^2 + d_estimate^2) / (2 * d_estimate);
C_estimate = Hip_point + x_estimate * ex_estimate;
r_estimate = sqrt(link1_model^2 - x_estimate^2);

% 平面基底ベクトル
ey_estimate = cross(normal_vec_estimate, ex_estimate);
ey_estimate = ey_estimate / norm(ey_estimate);

% 交点候補
New_Knee_point1_estimate = C_estimate + r_estimate * ey_estimate;
New_Knee_point2_estimate = C_estimate - r_estimate * ey_estimate;

% ③ どちらが近いかで選択
dist1_estimate = norm(New_Knee_point1_estimate - Knee_point);
dist2_estimate = norm(New_Knee_point2_estimate - Knee_point);

if dist1_estimate < dist2_estimate
    New_Knee_point_estimate = New_Knee_point1_estimate;
else
    New_Knee_point_estimate = New_Knee_point2_estimate;
end

% ④ 結果表示
disp('推定されたKnee座標 (New_Knee_point_estimate):');
disp(New_Knee_point_estimate);
Knee_mean_new = Knee_mean;
Knee_mean_new(9,:) = New_Knee_point_estimate;

coords_all_pos = cell(16,1);
coords_all_pos_endpoint = zeros(16,3);
colors = lines(16);
figure;
hold on;
grid on;
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Plot of Paw → Ankle → Knee (colored per row)');
for i = 1:16
    % 各点の座標（1×3ベクトル）
    paw = Paw_mean(i,:);
    ankle = Ankle_mean(i,:);
    knee = Knee_mean_new(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords_all_each_pos = [ankle; knee; hip_mean;H_bone_mean];
    coords_all_pos{i,1} = coords_all_each_pos;
    coords_all_pos_endpoint(i,:) = ankle;
    % プロット（色を行ごとに変える）
    if i == 9
        plot3(coords_all_each_pos(:,1), coords_all_each_pos(:,2), coords_all_each_pos(:,3), 'o-', 'Color', [1 0 0.5], ...
        'LineWidth', 2);hold on;
    else
            plot3(coords_all_each_pos(:,1), coords_all_each_pos(:,2), coords_all_each_pos(:,3), ':', 'Color', colors(i,:), ...
        'LineWidth', 2);hold on;
    end
end

view(3);  % 3次元視点に切り替え
hold off;
figure;
for i = 1:16
    % 各点の座標（1×3ベクトル）
    paw = Paw_mean(i,:);
    ankle = Ankle_mean(i,:);
    knee = Knee_mean_new(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords_all_each_pos = [ankle; knee; hip_mean;H_bone_mean];
    % プロット（色を行ごとに変える）
    if i == 9
        plot(coords_all_each_pos(1,1),  coords_all_each_pos(1,3), 'o', 'Color', [1 0 0.5], ...
        'LineWidth', 2);hold on;
    else
            plot(coords_all_each_pos(1,1),  coords_all_each_pos(1,3), 'o', 'Color', colors(i,:), ...
        'LineWidth', 2);hold on;
    end
end


%% estimate all posture with actual link model
hip_knee_link_length_actual = 100;
knee_ankle_link_length_actual = 115;

Compensated_knee_joint_position = ...
    Knee_joint_position_Compensation(hip_mean, Knee_mean, Ankle_mean, ...
    hip_knee_link_length_actual, knee_ankle_link_length_actual);

% --- 誤差計算 ---
error_X = abs(Knee_mean(:,1) - Compensated_knee_joint_position(:,1));
error_Y = abs(Knee_mean(:,3) - Compensated_knee_joint_position(:,3));

% ユークリッド距離誤差
error_dist = sqrt(error_X.^2 + error_Y.^2);

% 姿勢番号
pos_idx = 1:16;

% ===== フォント設定 =====
title_fs = 16;
label_fs = 14;
tick_fs  = 12;
text_fs  = 14;

figure('Color','w');

% --- X誤差 ---
subplot(3,1,1);
bar(pos_idx, error_X, 'FaceColor', [0.6 0.6 0.6]);
hold on;

mean_X = mean(error_X, 'omitnan');
sd_X   = std(error_X, 'omitnan');

patch([0.5 16.5 16.5 0.5], ...
      [mean_X-sd_X mean_X-sd_X mean_X+sd_X mean_X+sd_X], ...
      'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');

plot([0.5 16.5], [mean_X mean_X], 'r', 'LineWidth', 3);

text(11, mean_X + sd_X*1.3, ...
    sprintf('Mean ± SD = %.2f ± %.2f mm', mean_X, sd_X), ...
    'Color','r','FontSize',text_fs,'FontWeight','bold');

ylabel('X error (mm)', ...
       'FontSize', label_fs, 'FontWeight','bold');

title('Knee position error by posture', ...
      'FontSize', title_fs, 'FontWeight','bold');

xticks(pos_idx);
xticklabels(compose('Pos%d',pos_idx));
set(gca, 'FontSize', tick_fs, 'LineWidth',1.2, 'FontWeight','bold');
grid on;


% --- Y誤差 ---
subplot(3,1,2);
bar(pos_idx, error_Y, 'FaceColor', [0.6 0.6 0.6]);
hold on;

mean_Y = mean(error_Y, 'omitnan');
sd_Y   = std(error_Y, 'omitnan');

patch([0.5 16.5 16.5 0.5], ...
      [mean_Y-sd_Y mean_Y-sd_Y mean_Y+sd_Y mean_Y+sd_Y], ...
      'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');

plot([0.5 16.5], [mean_Y mean_Y], 'r', 'LineWidth', 3);

text(11, mean_Y + sd_Y*1.3, ...
    sprintf('Mean ± SD = %.2f ± %.2f mm', mean_Y, sd_Y), ...
    'Color','r','FontSize',text_fs,'FontWeight','bold');

ylabel('Y error (mm)', ...
       'FontSize', label_fs, 'FontWeight','bold');

xticks(pos_idx);
xticklabels(compose('Pos%d',pos_idx));
set(gca, 'FontSize', tick_fs, 'LineWidth',1.2, 'FontWeight','bold');
grid on;


% --- 距離誤差 ---
subplot(3,1,3);
bar(pos_idx, error_dist, 'FaceColor', [0.6 0.6 0.6]);
hold on;

mean_D = mean(error_dist, 'omitnan');
sd_D   = std(error_dist, 'omitnan');

patch([0.5 16.5 16.5 0.5], ...
      [mean_D-sd_D mean_D-sd_D mean_D+sd_D mean_D+sd_D], ...
      'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');

plot([0.5 16.5], [mean_D mean_D], 'r', 'LineWidth', 3);

text(11, mean_D + sd_D*1.3, ...
    sprintf('Mean ± SD = %.2f ± %.2f mm', mean_D, sd_D), ...
    'Color','r','FontSize',text_fs,'FontWeight','bold');

ylabel('Distance error (mm)', ...
       'FontSize', label_fs, 'FontWeight','bold');

xlabel('Posture', ...
       'FontSize', label_fs, 'FontWeight','bold');

xticks(pos_idx);
xticklabels(compose('Pos%d',pos_idx));
set(gca, 'FontSize', tick_fs, 'LineWidth',1.2, 'FontWeight','bold');
grid on;

% 図サイズ

 % === Figureサイズ（A4正方）===
target_width  = 60;   % cm
target_height = 30;   % cm

set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);
 % === 保存 ===
baseName = fullfile(experiment3_folder, 'Compare_motion_data_and_actual_model_data_knee_jointposition');

print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
print(gcf, [baseName '.png'], '-dpng', '-r300');
%% estimate error exaluation
%{
Estimation_pos = 4;

Hip_point = hip_mean;
Knee_point = mean(Knee_mean, 'omitnan');
Ankle_point = Ankle_mean(Estimation_pos,:);
link1_model = link_compare_main_mean(1,3);
link2_model = link_compare_main_mean(1,2);


% ① 平面を求める
v1_estimate = Knee_point - Hip_point;
v2_estimate = Ankle_point - Hip_point;
normal_vec_estimate = cross(v1_estimate, v2_estimate);
normal_vec_estimate = normal_vec_estimate / norm(normal_vec_estimate);

% ② 球の交線（円）の中心と半径
d_estimate = norm(Ankle_point - Hip_point);
ex_estimate = (Ankle_point - Hip_point) / d_estimate;
x_estimate = (link1_model^2 - link2_model^2 + d_estimate^2) / (2 * d_estimate);
C_estimate = Hip_point + x_estimate * ex_estimate;
r_estimate = sqrt(link1_model^2 - x_estimate^2);

% 平面基底ベクトル
ey_estimate = cross(normal_vec_estimate, ex_estimate);
ey_estimate = ey_estimate / norm(ey_estimate);

% 交点候補
New_Knee_point1_estimate = C_estimate + r_estimate * ey_estimate;
New_Knee_point2_estimate = C_estimate - r_estimate * ey_estimate;

% ③ どちらが近いかで選択
dist1_estimate = norm(New_Knee_point1_estimate - Knee_point);
dist2_estimate = norm(New_Knee_point2_estimate - Knee_point);

if dist1_estimate < dist2_estimate
    New_Knee_point_estimate = New_Knee_point1_estimate;
else
    New_Knee_point_estimate = New_Knee_point2_estimate;
end

% ④ 結果表示
disp('推定されたKnee座標 (New_Knee_point_estimate):');
disp(New_Knee_point_estimate);
Knee_mean_new = Knee_mean;
Knee_mean_new(Estimation_pos,:) = New_Knee_point_estimate;

coords_all_pos = cell(16,1);
coords_all_pos_endpoint = zeros(16,3);
colors = lines(16);
figure;
hold on;
grid on;
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Plot of Paw → Ankle → Knee (colored per row)');
for i = 1:16
    % 各点の座標（1×3ベクトル）
    paw = Paw_mean(i,:);
    ankle = Ankle_mean(i,:);
    knee = Knee_mean(i,:);
    knee_model = Knee_mean_new(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords_all_each_pos = [ankle; knee; hip_mean;H_bone_mean];
    coords_all_each_pos_model = [ankle; knee_model; hip_mean;H_bone_mean];
    coords_all_pos{i,1} = coords_all_each_pos;
    coords_all_pos_endpoint(i,:) = ankle;
    % プロット（色を行ごとに変える）
    if i == Estimation_pos
        plot3(coords_all_each_pos_model(:,1), coords_all_each_pos_model(:,2), coords_all_each_pos_model(:,3), 'o-', 'Color', [1 0 0.5], ...
        'LineWidth', 2);hold on;
            plot3(coords_all_each_pos(:,1), coords_all_each_pos(:,2), coords_all_each_pos(:,3), ':', 'Color', colors(i,:), ...
        'LineWidth', 2);
    else
        
    end
end

view(3);  % 3次元視点に切り替え
hold off;
%
figure
for i = 1:16
    % 各点の座標（1×3ベクトル）
    paw = Paw_mean(i,:);
    ankle = Ankle_mean(i,:);
    knee = Knee_mean(i,:);
    knee_model = Knee_mean_new(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords_all_each_pos = [ankle; knee; hip_mean;H_bone_mean];
    coords_all_each_pos_model = [ankle; knee_model; hip_mean;H_bone_mean];
    coords_all_pos{i,1} = coords_all_each_pos;
    coords_all_pos_endpoint(i,:) = ankle;
    % プロット（色を行ごとに変える）
    if i == Estimation_pos
        plot(coords_all_each_pos_model(:,1),  coords_all_each_pos_model(:,3), 'o-', 'Color', [1 0 0.5], ...
        'LineWidth', 2);hold on;
            plot(coords_all_each_pos(:,1), coords_all_each_pos(:,3), ':', 'Color', colors(i,:), ...
        'LineWidth', 2);
    else
        
    end
end
%}
%% 
figure;
hold on;
grid on;
axis equal;
xlabel('X [mm]'); 
ylabel('Y [mm]');  % Z軸が縦軸になる
colors = lines(16);
for i = 1:16
    % 各点の座標
    paw = Paw_mean(i,:);
    ankle = Ankle_mean(i,:);
    knee = Knee_mean_new(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords = [ankle; knee; hip_mean; H_bone_mean];

    % プロット（X-Z平面に）
    plot(coords(:,1), coords(:,3), ':', 'Color', colors(i,:), 'LineWidth', 2);
    plot(coords(1,1), coords(1,3), 'o', ...
    'MarkerEdgeColor', colors(i,:), ...   % 外枠の色
    'MarkerFaceColor', colors(i,:), ...   % 塗りつぶしの色
    'MarkerSize', 8, ...                  % 点の大きさ
    'LineWidth', 2);                      % 枠線の太さ
end
xlim([-200 50])
ylim([215 425])
fontsize(gcf,20,"points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_folder, 'Recorded_posture_xy.tif');
%print(gcf, tifFileName, '-dtiff', '-r300');

hold off;


%% plot hindlimb xy
figure;
hold on;
grid on;
axis equal;
xlabel('X [mm]'); 
ylabel('Y [mm]');  
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);


for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Knee_mean_new(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    % 線
    plot(coords(:,1), coords(:,3), ':', 'Color', colors(i,:), 'LineWidth', 2);

    % 足首マーカー
    plot(coords(1,1), coords(1,3), 'o', ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip bone marker
    plot(Hbone(1,1), Hbone(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip marker
    plot(hip(1,1), hip(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

   
end

for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Knee_mean_new(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    if i == 6
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)-11, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    else
        % それ以外のPosは普通
        text(coords(1,1)-9, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end
 % それ以外のPosは普通
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% それ以外のPosは普通
text(hip(1,1)+6, hip(1,3)-3, 'Hip joint Position', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-80 150])
ylim([-220 20])
% --- 軸設定 --

set(gca, 'FontSize', 20, 'FontName', 'Arial', 'FontWeight', 'bold');
ax = gca;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
box off;

% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向き（内側なし）
ax.TickLength = [0.02 0.02];     % 主メモリと小メモリの長さ
ax.XMinorTick = 'on';            % X軸 小目盛ON
ax.YMinorTick = 'on';            % Y軸 小目盛ON
ax.LineWidth = 2;                % 軸線を太く

% === サイズを指定 (例: 12cm x 12cm) ===
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, 10, 10]);

% 保存 (高解像度)
pdfFileName = fullfile(experiment3_folder, ['Recorded_posture_xy_for' ...
    '_fig_Cat A.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');

%%  plot hindlimb xy compensation
figure;
hold on;
grid on;
axis equal;
xlabel('X [mm]'); 
ylabel('Y [mm]');  
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);


for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Compensated_knee_joint_position(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    % 線
    plot(coords(:,1), coords(:,3), ':', 'Color', colors(i,:), 'LineWidth', 2);

    % 足首マーカー
    plot(coords(1,1), coords(1,3), 'o', ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip bone marker
    plot(Hbone(1,1), Hbone(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip marker
    plot(hip(1,1), hip(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

   
end

for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Compensated_knee_joint_position(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    if i == 6
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)-11, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    else
        % それ以外のPosは普通
        text(coords(1,1)-9, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end
 % それ以外のPosは普通
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% それ以外のPosは普通
text(hip(1,1)+6, hip(1,3)-3, 'Hip joint Position', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-90 150])
ylim([-220 20])
% --- 軸設定 --

set(gca, 'FontSize', 20, 'FontName', 'Arial', 'FontWeight', 'bold');
ax = gca;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
box off;

% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向き（内側なし）
ax.TickLength = [0.02 0.02];     % 主メモリと小メモリの長さ
ax.XMinorTick = 'on';            % X軸 小目盛ON
ax.YMinorTick = 'on';            % Y軸 小目盛ON
ax.LineWidth = 2;                % 軸線を太く

% === サイズを指定 (例: 12cm x 12cm) ===
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, 10, 10]);

% 保存 (高解像度)
pdfFileName = fullfile(experiment3_folder, ['Recorded_posture_xy_for' ...
    '_fig_Cat A_compensation_position.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');
%% plot hindlimb xy for plot 4X4
figure;
hold on;
grid on;
axis equal;
xlabel('X [mm]'); 
ylabel('Y [mm]');  
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);

for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Knee_mean_new(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    % 足首マーカー
    plot(coords(1,1), coords(1,3), 'o', ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 14, ...
        'LineWidth', 2);

    % Hip bone marker
    plot(Hbone(1,1), Hbone(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip marker
    plot(hip(1,1), hip(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

   
end

for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Knee_mean_new(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];
    if i == 2
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 5
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-4, coords(1,3)-20, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 6
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-4, coords(1,3)-20, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 9
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-5, coords(1,3)+2, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 10
        text(coords(1,1)-9, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 11
        text(coords(1,1)-9, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 12
        text(coords(1,1)-9, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 13
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 14
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 15
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)-20, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 16
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    else
        % それ以外のPosは普通
        text(coords(1,1)-5.5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 30, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end

 % それ以外のPosは普通
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontWeight','bold','FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% それ以外のPosは普通
text(hip(1,1)+6, hip(1,3)-3, 'Hip joint Position', ...
            'FontWeight','bold','FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-80 150])
ylim([-220 20])
% --- 軸設定 --

set(gca, 'FontSize', 20, 'FontName', 'Arial', 'FontWeight', 'bold');
ax = gca;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
box off;

% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向き（内側なし）
ax.TickLength = [0.02 0.02];     % 主メモリと小メモリの長さ
ax.XMinorTick = 'on';            % X軸 小目盛ON
ax.YMinorTick = 'on';            % Y軸 小目盛ON
ax.LineWidth = 2;                % 軸線を太く

% === サイズを指定 (例: 12cm x 12cm) ===
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, 10, 10]);

% 保存 (高解像度)
pdfFileName = fullfile(experiment3_folder, ['Recorded_posture_xy_for' ...
    '_fig_plot_4_4_Cat A.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');

%% error evaluation
nPos = size(Knee_mean,1);

Knee_mean_new_model_motion_data = Knee_mean;      % 更新用
Knee_error_before = nan(nPos,1);
Knee_error_after  = nan(nPos,1);

for iPos = 1:nPos

    % ===== (1) 姿勢 i を除いた link モデル =====
    idx_use = setdiff(1:nPos, iPos);
    %pos-9 estimation model
    link1_model = link_compare_main_mean(1,3);
    link2_model = link_compare_main_mean(1,2);

    % ===== (2) 推定に使う点 =====
    Hip_point   = hip_mean;
    Knee_point  = Knee_mean(iPos,:);
    Ankle_point = Ankle_mean(iPos,:);

    % ===== (3) 平面推定 =====
    v1 = Knee_point - Hip_point;
    v2 = Ankle_point - Hip_point;
    normal_vec = cross(v1, v2);
    normal_vec = normal_vec / norm(normal_vec);

    % ===== (4) 球×球の交線 =====
    d = norm(Ankle_point - Hip_point);
    ex = (Ankle_point - Hip_point) / d;

    x = (link1_model^2 - link2_model^2 + d^2) / (2*d);
    C = Hip_point + x * ex;
    r = sqrt(max(link1_model^2 - x^2, 0)); % 数値安定性

    ey = cross(normal_vec, ex);
    ey = ey / norm(ey);

    Knee_cand1 = C + r * ey;
    Knee_cand2 = C - r * ey;

    % ===== (5) 近い方を選択 =====
    if norm(Knee_cand1 - Knee_point) < norm(Knee_cand2 - Knee_point)
        Knee_est = Knee_cand1;
    else
        Knee_est = Knee_cand2;
    end

    % ===== (6) 誤差評価 =====
    Knee_error_before(iPos) = norm(Knee_point - Knee_point); % =0（基準）
    Knee_error_after(iPos)  = norm(Knee_est - Knee_point);

    % ===== (7) 更新 =====
    Knee_mean_new_model_motion_data(iPos,:) = Knee_est;
end

figure; hold on; axis equal; grid on;
xlabel('X'); ylabel('Z');
title('Knee & Ankle position: Measured vs Estimated (X–Z plane)');

for i = 1:nPos
    % --- 実測 Knee ---
    plot(Knee_mean(i,1), Knee_mean(i,3), 'o', ...
        'Color', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 7); hold on;

    % Pos番号表示（少しずらす）
    text(Knee_mean(i,1) + 1, Knee_mean(i,3) + 1, ...
        sprintf('%d', i), ...
        'Color', colors(i,:), ...
        'FontSize', 9, ...
        'FontWeight', 'bold');

    % --- 推定 Knee ---
    plot(Knee_mean_new_model_motion_data(i,1), Knee_mean_new_model_motion_data(i,3), 'x', ...
        'Color', colors(i,:), ...
        'LineWidth', 2, ...
        'MarkerSize', 8);

    % --- 誤差ベクトル ---
    plot([Knee_mean(i,1), Knee_mean_new_model_motion_data(i,1)], ...
         [Knee_mean(i,3), Knee_mean_new_model_motion_data(i,3)], '-', ...
         'Color', colors(i,:), ...
         'LineWidth', 1);

    % --- 実測 Ankle ---
    plot(Ankle_mean(i,1), Ankle_mean(i,3), '^', ...
        'Color', colors(i,:), ...
        'MarkerFaceColor', 'w', ...
        'MarkerSize', 7, ...
        'LineWidth', 1.2);
end
%% 
% === 誤差の定義 ===
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);
err_xy   = Knee_mean_new_model_motion_data - Knee_mean;   % [Nx2]
err_x    = err_xy(:,1);
err_z    = err_xy(:,3);
err_norm = vecnorm([err_x,err_z], 2, 2);
hip_ankle_dist = vecnorm(Ankle_mean - hip_mean, 2, 2);
abs(hip_mean-Ankle_mean);

% NaN除外
valid_idx = ~isnan(err_x) & ~isnan(err_z);

figure;
tiledlayout(3,1, 'TileSpacing','compact');

% ===== 1段目：X方向誤差 =====
nexttile; hold on; grid on;
scatter(hip_ankle_dist(valid_idx), err_x(valid_idx), 60, colors(valid_idx,:), 'filled');

yline(mean(err_x(valid_idx),'omitnan'),'r--','LineWidth',4);
yline(mean(err_x(valid_idx),'omitnan') + std(err_x(valid_idx),'omitnan'),'r:', 'LineWidth', 2.5);
yline(mean(err_x(valid_idx),'omitnan') - std(err_x(valid_idx),'omitnan'),'r:' ,'LineWidth', 2.5);

xline(hip_ankle_dist(9),'b--','LineWidth',1.5);
for i = find(valid_idx)'
    text(hip_ankle_dist(i)+2, err_x(i), ...
        sprintf('%d', i), ...
        'FontSize', 20, ...
        'FontWeight', 'bold', ...
        'Color', colors(i,:));
end
txt = sprintf('mean ± SD = %.1f ± %.1f mm', mean(err_x(valid_idx),'omitnan'), std(err_x(valid_idx),'omitnan'));

text(0.02, 0.95, txt, ...
    'Units','normalized', ...
    'FontSize', 18, ...
    'FontWeight','bold', ...
    'Color','r', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','top');

ylim([-20 60])
ylabel('X error (mm)');
title('Knee estimation error (X direction)');

% ===== 2段目：Y方向誤差 =====
nexttile; hold on; grid on;
scatter(hip_ankle_dist(valid_idx), err_z(valid_idx), 60, colors(valid_idx,:), 'filled');
for i = find(valid_idx)'
    text(hip_ankle_dist(i)+2, err_z(i), ...
        sprintf('%d', i), ...
        'FontSize', 20, ...
        'FontWeight', 'bold', ...
        'Color', colors(i,:));
end
txt = sprintf('mean ± SD = %.1f ± %.1f mm', mean(err_z(valid_idx),'omitnan'), std(err_z(valid_idx),'omitnan'));

text(0.02, 0.95, txt, ...
    'Units','normalized', ...
    'FontSize', 18, ...
    'FontWeight','bold', ...
    'Color','r', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','top');
yline(mean(err_z(valid_idx),'omitnan'),'r--','LineWidth',4);
yline(mean(err_z(valid_idx),'omitnan') + std(err_z(valid_idx),'omitnan'),'r:', 'LineWidth', 2.5);
yline(mean(err_z(valid_idx),'omitnan') - std(err_z(valid_idx),'omitnan'),'r:', 'LineWidth', 2.5);
xline(hip_ankle_dist(9),'b--','LineWidth',1.5);

ylabel('Y error (mm)');
ylim([-20 60])
title('Knee estimation error (Y direction)');

% ===== 3段目：XY合成誤差 =====
nexttile; hold on; grid on;
scatter(hip_ankle_dist(valid_idx), err_norm(valid_idx), 60, colors(valid_idx,:), 'filled');

yline(mean(err_norm(valid_idx),'omitnan'),'r--','LineWidth',4);
yline(mean(err_norm(valid_idx),'omitnan') + std(err_norm(valid_idx),'omitnan'),'r:', 'LineWidth', 2.5);
yline(mean(err_norm(valid_idx),'omitnan') - std(err_norm(valid_idx),'omitnan'),'r:', 'LineWidth', 2.5);

xline(hip_ankle_dist(9),'b--','LineWidth',1.5);
ylim([0 60])
for i = find(valid_idx)'
    text(hip_ankle_dist(i)+2, err_norm(i), ...
        sprintf('%d', i), ...
        'FontSize', 20, ...
        'FontWeight', 'bold', ...
        'Color', colors(i,:));
end
txt = sprintf('mean ± SD = %.1f ± %.1f mm', mean(err_norm(valid_idx),'omitnan'), std(err_norm(valid_idx),'omitnan'));

text(0.02, 0.95, txt, ...
    'Units','normalized', ...
    'FontSize', 18, ...
    'FontWeight','bold', ...
    'Color','r', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','top');
xlabel('Hip–Ankle distance (mm)');
ylabel('Euclidean error (mm)');
title('Knee estimation error (XY magnitude)');

set(findall(gcf,'-property','FontSize'),'FontSize',16);
% === サイズを指定 (例: 12cm x 12cm) ===
target_width = 60;    % cm
target_height = 30;   % cm
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% 保存 (高解像度)
pngFileName = fullfile(experiment3_folder, ['Model_error_in_distance_from_ankle' ...
    '_fig_Cat A.png']);
print(gcf, pngFileName, '-dpng', '-r300');   % 300 dpi PNG

%% motion data in not good
% ===============================
%  Knee estimation error analysis
%  (exclude Pos 4, 8, 16 from statistics)
% ================================

close all;

% --- カラーマップ ---
fullJet = turbo(256);
idx = round(linspace(1,256,16));
colors = fullJet(idx,:);

% --- 誤差定義 ---
err_xy   = Knee_mean_new_model_motion_data - Knee_mean;   % [N x 3]
err_x    = err_xy(:,1);
err_z    = err_xy(:,3);
err_norm = vecnorm([err_x, err_z], 2, 2);

% --- NaN 除外 ---
valid_idx = ~isnan(err_x) & ~isnan(err_z);

% --- 統計から除外する姿勢 ---
exclude_pos = [4 8 16];
stat_idx = valid_idx;
stat_idx(exclude_pos) = false;

% --- 統計量（除外後） ---
mean_x = mean(err_x(stat_idx),'omitnan');
std_x  = std(err_x(stat_idx),'omitnan');

mean_z = mean(err_z(stat_idx),'omitnan');
std_z  = std(err_z(stat_idx),'omitnan');

mean_n = mean(err_norm(stat_idx),'omitnan');
model_potential_error_exc4_8_16 = mean_n;
std_n  = std(err_norm(stat_idx),'omitnan');

% ===============================
%  プロット
% ===============================

figure;
tiledlayout(3,1,'TileSpacing','compact');

% ===== X方向誤差 =====
nexttile; hold on; grid on;

scatter(hip_ankle_dist(valid_idx), err_x(valid_idx), ...
    70, colors(valid_idx,:), 'filled');

% 統計線（除外後）
yline(mean_x,'m--','LineWidth',4);
yline(mean_x + std_x,'m:','LineWidth',3);
yline(mean_x - std_x,'m:','LineWidth',3);

% Pos-9
xline(hip_ankle_dist(9),'k--','LineWidth',2);

% 姿勢番号
for i = find(valid_idx)'
    text(hip_ankle_dist(i)+2, err_x(i), sprintf('%d',i), ...
        'FontSize',18,'FontWeight','bold','Color',colors(i,:));
end

% 注釈
txt = sprintf('mean ± SD (excl. Pos 4,8,16) = %.1f ± %.1f mm', mean_x, std_x);
text(0.02,0.95,txt,'Units','normalized', ...
    'FontSize',18,'FontWeight','bold','Color','m', ...
    'VerticalAlignment','top');

ylim([-20 60])
ylabel('X error (mm)')
title('Knee estimation error (X direction)')

% ===== Y方向誤差 =====
nexttile; hold on; grid on;

scatter(hip_ankle_dist(valid_idx), err_z(valid_idx), ...
    70, colors(valid_idx,:), 'filled');

yline(mean_z,'m--','LineWidth',4);
yline(mean_z + std_z,'m:','LineWidth',3);
yline(mean_z - std_z,'m:','LineWidth',3);

xline(hip_ankle_dist(9),'k--','LineWidth',2);

for i = find(valid_idx)'
    text(hip_ankle_dist(i)+2, err_z(i), sprintf('%d',i), ...
        'FontSize',18,'FontWeight','bold','Color',colors(i,:));
end

txt = sprintf('mean ± SD (excl. Pos 4,8,16) = %.1f ± %.1f mm', mean_z, std_z);
text(0.02,0.95,txt,'Units','normalized', ...
    'FontSize',18,'FontWeight','bold','Color','m', ...
    'VerticalAlignment','top');

ylim([-20 60])
ylabel('Y error (mm)')
title('Knee estimation error (Y direction)')

% ===== XY 合成誤差 =====
nexttile; hold on; grid on;

scatter(hip_ankle_dist(valid_idx), err_norm(valid_idx), ...
    70, colors(valid_idx,:), 'filled');

yline(mean_n,'m--','LineWidth',4);
yline(mean_n + std_n,'m:','LineWidth',3);
yline(mean_n - std_n,'m:','LineWidth',3);

xline(hip_ankle_dist(9),'k--','LineWidth',2);

for i = find(valid_idx)'
    text(hip_ankle_dist(i)+2, err_norm(i), sprintf('%d',i), ...
        'FontSize',18,'FontWeight','bold','Color',colors(i,:));
end

txt = sprintf('mean ± SD (excl. Pos 4,8,16) = %.1f ± %.1f mm', mean_n, std_n);
text(0.02,0.95,txt,'Units','normalized', ...
    'FontSize',18,'FontWeight','bold','Color','m', ...
    'VerticalAlignment','top');

ylim([0 60])
xlabel('Hip–Ankle distance (mm)')
ylabel('Euclidean error (mm)')
title('Knee estimation error (XY magnitude)')

% ===== 図の体裁 =====
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gcf,'Units','centimeters','Position',[5 5 60 30]);

% 保存
pngFile = fullfile(experiment3_folder, ...
    'Knee_error_excluding_Pos4_8_16.png');
print(gcf, pngFile, '-dpng','-r300');




%% plot position model compare
fullJet = turbo(256);
idx = round(linspace(1,256,16));
colors = fullJet(idx,:);
offset = hip_mean;

figure;
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

nexttile;
hold on; grid on; axis equal;
title('Measured knee position');

xlabel('X [mm]');
ylabel('Y [mm]');
for i = 1:16
    offset = hip_mean;

    ankle = Ankle_mean(i,:) - offset;
    knee  = Knee_mean(i,:)  - offset;   % ← 実測
    hip   = hip_mean - offset;
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    plot(coords(:,1), coords(:,3), ':', ...
        'Color', colors(i,:), 'LineWidth', 2);

    plot(coords(1,1), coords(1,3), 'o', ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerSize', 8, 'LineWidth', 2);
    % === Pos ラベル ===
    text(coords(1,1)+6, coords(1,3)-3, ...
        sprintf('Pos-%d', i), ...
        'FontSize', 14, ...
        'FontWeight', 'bold', ...
        'Color', [0 0 0]);
end

nexttile;
hold on; grid on; axis equal;
title('Estimated knee position (2-link model)');
xlabel('X [mm]');
ylabel('Y [mm]');
for i = 1:16
    offset = hip_mean;

    ankle = Ankle_mean(i,:) - offset;
    knee  = Knee_mean_new_model_motion_data(i,:) - offset;   % ← 推定
    hip   = hip_mean - offset;
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    plot(coords(:,1), coords(:,3), ':', ...
        'Color', colors(i,:), 'LineWidth', 2);

    plot(coords(1,1), coords(1,3), 'o', ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerSize', 8, 'LineWidth', 2);
    % === Pos ラベル ===
    text(coords(1,1)+6, coords(1,3)-3, ...
        sprintf('Pos-%d', i), ...
        'FontSize', 14, ...
        'FontWeight', 'bold', ...
        'Color', [0 0 0]);
end
axs = findall(gcf,'Type','axes');
set(axs, ...
    'XLim',[-100 150], ...
    'YLim',[-220 20], ...
    'FontSize',20, ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'LineWidth',2);

pbaspect([1 1 1]);
for ax = axs'
    box(ax,'off');
end


% === サイズを指定 (例: 12cm x 12cm) ===
target_width = 40;    % cm
target_height = 20;   % cm
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% 保存 (高解像度)
pngFileName = fullfile(experiment3_folder, ['Recorded_posture_xy_model_and_actual_for' ...
    '_fig_Cat A.png']);
print(gcf, pngFileName, '-dpng', '-r300');   % 300 dpi PNG

%% 
figure; hold on; axis equal; grid on;
xlabel('X'); ylabel('Z');
title('Leg link projected onto X–Z plane (Measured vs Estimated)');

nPos = size(Knee_mean,1);
colors = lines(nPos);

for i = 1:nPos

    % ===== 実測リンク（XZ 平面）=====
    link_measured = [ ...
        Ankle_mean(i,[1 3]); ...
        Knee_mean(i,[1 3]); ...
        hip_mean([1 3]); ...
        H_bone_mean([1 3]) ...
    ];

    plot(link_measured(:,1), link_measured(:,2), '-', ...
        'Color', colors(i,:), ...
        'LineWidth', 1.8);

    % ===== 推定リンク（XZ 平面）=====
    link_estimated = [ ...
        Ankle_mean(i,[1 3]); ...
        Knee_mean_new(i,[1 3]); ...
        hip_mean([1 3]); ...
        H_bone_mean([1 3]) ...
    ];

    plot(link_estimated(:,1), link_estimated(:,2), '--', ...
        'Color', colors(i,:), ...
        'LineWidth', 1.8);
end





%% Static posture
%line up
Task_spike_time_all_Each_pos = cell(1,size(Ex3_Task_spike_time_all{1,1},2));
spike_time_each_collect_trial = cell(length(Ex3_Task_spike_time_all{1,1}),length(Ex3_Task_spike_time_all));
Mean_firing_rate_Each_pos = cell(1,size(Ex3_Task_spike_time_all{1,1},2));
Mean_firing_rate_collect_trial = zeros(length(Ex3_Task_spike_time_all{1,1}),length(Ex3_Task_spike_time_all));

for pos = 1:length(Task_spike_time_all_Each_pos)
    for tr = 1:length(Ex3_Task_spike_time_all)
        spike_time_each_collect_trial(:,tr) = Ex3_Task_spike_time_all{1,tr}(:,pos);
        Mean_firing_rate_collect_trial(:,tr) = Ex3_Mean_firing_rate_all{1,tr}(:,pos);
    end
    Task_spike_time_all_Each_pos{1,pos} = spike_time_each_collect_trial;
    Mean_firing_rate_Each_pos{1,pos} = Mean_firing_rate_collect_trial;
end

%lineup timing data
Ex3_DI_each_pos = cell(1,size(Ex3_Task_spike_time_all{1,1},2));
Ex3_each_DI = zeros(length(Ex3_Task_spike_time_all),3);

%line up pos 
for pos = 1:length(Ex3_DI_each_pos)
    for tr = 1:length(Ex3_Task_spike_time_all)
        Ex3_each_DI(tr,:) = EX3_task_DI_Lineup_Trial{tr,1}(pos,1:3);
    end
    Ex3_DI_each_pos{1,pos} = Ex3_each_DI;
end

%calucurate firingrate
%bin size for psth
bin_size_each = 0.05; % 50 ms bin size (adjust as needed)
start_time_each = Ex3_Posture_cutting_time(1); % Time before stimulus onset (in seconds)
end_time_each = Ex3_Posture_cutting_time(2);    % Time after stimulus onset (in seconds)
Ex3_time_window_each = start_time_each:bin_size_each:end_time_each;



[Ex3_static_firing_rate_for_psth,Ex3_static_max_fining_rate] = Firing_rate_calculate(newSpkTime,Task_spike_time_all_Each_pos,Ex3_time_window_each,bin_size_each);


%calucurate firingrate per 1 trial
%bin size for psth
bin_size_each = 0.05; % 50 ms bin size (adjust as needed)
start_time_each = Ex3_Posture_cutting_time(1); % Time before stimulus onset (in seconds)
end_time_each = Ex3_Posture_cutting_time(2);    % Time after stimulus onset (in seconds)
Ex3_time_window_each = start_time_each:bin_size_each:end_time_each;

Ex3_static_firing_rate_for_psth_each = Firing_rate_calculate_sep1(newSpkTime,Task_spike_time_all_Each_pos,Ex3_time_window_each,bin_size_each);



%% posture 17 control state
bin_size_each = 0.05; % 50 ms bin size (adjust as needed)
start_time_each_c = Ex3_Control_cutting_time(1); % Time before stimulus onset (in seconds)
end_time_each_c = Ex3_Control_cutting_time(2);    % Time after stimulus onset (in seconds)
Ex3_time_window_each_c = start_time_each_c:bin_size_each:end_time_each_c;
[Ex3_control_firing_rate_for_psth,Ex3_control_max_fining_rate] = Firing_rate_calculate(newSpkTime,Ex3_control_spike_time_all,Ex3_time_window_each_c,bin_size_each);


Ex3_control_firing_rate_smoothed_data = smoothing_firing_rate_by_gaussian_kern_reg(Ex3_control_firing_rate_for_psth,kernH);

plot_Ex3_controlPSTH = 2;
close all hidden
experiment3_control = createNamedFolder(experiment3_psth, 'Control_Posture_17');
if plot_Ex3_controlPSTH == 1
        for neuron = 1:length(newSpkTime)
            figure;
            for task = 1:length(EX3_control_DI)
                scatter(subplot(2,1,1),Ex3_control_spike_time_all{neuron,task},task,'.','MarkeredgeColor','k');hold on;
                scatter(subplot(2,1,1),0,task,'.','MarkeredgeColor','r','SizeData', 200);hold on;
                scatter(subplot(2,1,1),EX3_control_DI(task,3),task,'.','MarkeredgeColor','b','SizeData', 200);hold on;
            end
            xlim([-5 65])
            ylim([0 length(EX3_control_DI)+1])
            xlabel('Time (s)');
            ylabel('Trial');
            %psth
            b = bar(subplot(2,1,2), Ex3_time_window_each_c(1:end-1), Ex3_control_firing_rate_for_psth(neuron,:),'hist');
            b.FaceColor = 'cyan'; % 棒グラフの色をシアンに設定
            b.FaceAlpha = 0.8; % 棒グラフの透明度を設定（0.5で50%透明）
            hold on;
            p = plot(subplot(2,1,2), Ex3_time_window_each_c(1:end-1), Ex3_control_firing_rate_smoothed_data(neuron,:) , 'Color', 'r', 'LineWidth', 4); % 赤色、太さ2
            hold off;
            xlim([-5 65])
            ylim([0 110])
            xlabel('Time (s)');
            ylabel('Firing Rate [Hz]');
            sgtitle(gcf, ['Control(Posture 17) Neuron ' num2str(neuron)  ' ' num2str(newSpkCH(neuron)) 'channel']);
            fontsize(gcf,20,"points");
            set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
            tifFileName = fullfile(experiment3_control, ['Control_Posture_17_Neuron Neuron_' num2str(neuron) '.tif']);
            print(gcf, tifFileName, '-dtiff', '-r300'); 
        end
        close all hidden
else
    disp('not make PSTH')
end
%% for each FR

    figure;
    colormap(newCmap)
    imagesc(Ex3_time_window_each_c(1:end-1),length(newSpkTime):-1:1,Ex3_control_firing_rate_for_psth);
    caxis([0 110]);
    xlim([-5 65])
    ylim([0.5 length(newSpkTime)+0.5])
    xlabel('Time (s)');
    ylabel('Single Unit');
    % Y軸のラベルを反転
    yticks(1:length(newSpkTime)); % 元のY軸の位置を設定
    yticklabels(fliplr(1:length(newSpkTime))); % ラベルを逆順に設定
    colorbar;
    title('Firing rate Control(Posture 17)');
    fontsize(gcf,20,"points")
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_control, ['Control_Posture_17_Neuron_Firing_Rate' '.tif']);
    print(gcf, tifFileName, '-dtiff', '-r300'); 
    close all hidden;


%% plot psth 
% make name
Postures_name = strings(1, length(Task_spike_time_all_Each_pos));  % 文字列配列を作成
for i = 1:length(Postures_name)
    Postures_name(i) = "Pos-" + string(i);  % 'Posture'に数字を付けて文字列を作成
end
 


Ex3_static_firing_rate_smoothed_data = smoothing_firing_rate_by_gaussian_kern_reg(Ex3_static_firing_rate_for_psth,kernH);

plot_Ex3_staticPSTH = 2;
close all hidden

if plot_Ex3_staticPSTH == 1
    for pos = 1:length(Postures_name)
        experiment3_pos = createNamedFolder(experiment3_psth, Postures_name(1,pos));
        for neuron = 1:length(newSpkTime)
            figure;
            for task = 1:length(Ex3_DI_each_pos{1,1})
                scatter(subplot(2,1,1),Task_spike_time_all_Each_pos{1,pos}{neuron,task},task,'.','MarkeredgeColor','k');hold on;
                scatter(subplot(2,1,1),0,task,'.','MarkeredgeColor','r','SizeData', 200);hold on;
                scatter(subplot(2,1,1),Ex3_DI_each_pos{1,pos}(task,3),task,'.','MarkeredgeColor','b','SizeData', 200);hold on;
            end
            xlim([-5 20])
            ylim([0 length(Ex3_DI_each_pos{1,1})+1])
            xlabel('Time (s)');
            ylabel('Trial');
            %psth
            b = bar(subplot(2,1,2), Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_for_psth{1,pos}(neuron,:),'hist');
            b.FaceColor = 'cyan'; % 棒グラフの色をシアンに設定
            b.FaceAlpha = 0.8; % 棒グラフの透明度を設定（0.5で50%透明）
            hold on;
            p = plot(subplot(2,1,2), Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_smoothed_data{1,pos}(neuron,:) , 'Color', 'r', 'LineWidth', 4); % 赤色、太さ2
            hold off;
            xlim([-5 20])
            ylim([0 110])
            xlabel('Time (s)');
            ylabel('Firing Rate [Hz]');
            sgtitle(gcf, [char(Postures_name(1,pos))  ' Neuron ' num2str(neuron)  ' ' num2str(newSpkCH(neuron)) 'channel']);
            fontsize(gcf,20,"points");
            set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
            tifFileName = fullfile(experiment3_pos, [char(Postures_name(1,pos))  ' Neuron ' num2str(neuron) '.tif']);
            print(gcf, tifFileName, '-dtiff', '-r300'); 
        end
        close all hidden
    end
else
    disp('not make PSTH')
end


%% plot representative neuron firing rate 

neuron = 21;
Neuron_21_for_fig_folder = createNamedFolder(experiment3_psth, 'neiron 21 for fig new');

for pos = 1:length(Postures_name)
figure;
% --- 棒グラフ ---
b = bar(Ex3_time_window_each(1:end-1), ...
        Ex3_static_firing_rate_for_psth{1,pos}(neuron,:), ...
        'BarWidth', 1);  % hist ではなく BarWidth 指定

b.FaceColor = [0.6 0.6 0.6];   % グレー塗り
b.EdgeColor = [0.6 0.6 0.6];   % 枠線もグレー
hold on;                

% --- 軸設定 ---
xlim([-5 20]);
ylim([0 120]);


% --- ラスタープロット ---
for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
   scatter(Task_spike_time_all_Each_pos{1,pos}{neuron,task}, ...
           120 - 5*5 + task*5, ...
           '.', 'MarkerEdgeColor','k'); 
   hold on;
end


% --- X軸 ---
xticks([-5 0 5 10 15 20]);      
xticklabels({'-5','0','5','10','15','20'});  

% --- グレー線 ---
xline(0, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 4);
xline(15, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 4);

% --- タイトル ---
title(['Pos-' num2str(pos)], 'FontWeight','bold', 'FontSize', 45, 'FontName', 'Arial','Color',colors_rechange(pos,:));


% --- 軸設定 ---
ax = gca;
ax.FontSize = 32;          
ax.FontWeight = 'bold';  % 必要なら太字
ax.FontName = 'Arial';     % ★ フォントをArialに設定 ★
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.XMinorTick = 'on';            % X軸の小目盛をON
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 3;                % 軸線を太く（見やすさアップ）
box off;
% === Figureサイズ ===
target_width = 20;    % cm
target_height = 15;   % cm
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);


% === PDF出力用 ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];
fig.PaperPosition = [0 0 target_width target_height];
pngFileName = fullfile(Neuron_21_for_fig_folder, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_neuron21_pos1_for_explanation' '.png']);
%pngFileName = fullfile(Firing_rate_folder_for_fig, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_withcolorbar' '.png']);
print(gcf, pngFileName, '-dpng', '-r300');   % 300 dpi PNG


hold off;
end


close all hidden
% plot representative neuron firing rate 

neuron = 15;
Neuron_15_for_fig_folder = createNamedFolder(experiment3_psth, 'neiron 15 for fig new');

for pos = 1:length(Postures_name)
figure;
% --- 棒グラフ ---
b = bar(Ex3_time_window_each(1:end-1), ...
        Ex3_static_firing_rate_for_psth{1,pos}(neuron,:), ...
        'BarWidth', 1);  % hist ではなく BarWidth 指定

b.FaceColor = [0.6 0.6 0.6];   % グレー塗り
b.EdgeColor = [0.6 0.6 0.6];   % 枠線もグレー
hold on;                

% --- 軸設定 ---
xlim([-5 20]);
ylim([0 200]);


% --- ラスタープロット ---
for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
   scatter(Task_spike_time_all_Each_pos{1,pos}{neuron,task}, ...
           200 - 5*5 + task*5, ...
           '.', 'MarkerEdgeColor','k'); 
   hold on;
end


% --- X軸 ---
xticks([-5 0 5 10 15 20]);      
xticklabels({'-5','0','5','10','15','20'});  

% --- グレー線 ---
xline(0, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 4);
xline(15, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 4);

% --- タイトル ---
title(['Pos-' num2str(pos)], 'FontWeight','bold', 'FontSize', 45, 'FontName', 'Arial','Color',colors_rechange(pos,:));


% --- 軸設定 ---
ax = gca;
ax.FontSize = 32;          
ax.FontWeight = 'bold';  % 必要なら太字
ax.FontName = 'Arial';     % ★ フォントをArialに設定 ★
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.XMinorTick = 'on';            % X軸の小目盛をON
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 3;                % 軸線を太く（見やすさアップ）
box off;
% === Figureサイズ ===
target_width = 20;    % cm
target_height = 15;   % cm
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);


% === PDF出力用 ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];
fig.PaperPosition = [0 0 target_width target_height];
pngFileName = fullfile(Neuron_15_for_fig_folder, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_neuron15_pos1_for_explanation' '.png']);
%pngFileName = fullfile(Firing_rate_folder_for_fig, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_withcolorbar' '.png']);
print(gcf, pngFileName, '-dpng', '-r300');   % 300 dpi PNG


hold off;
end

close all hidden

%% 
Posture_PSTH = cell(length(Postures_name),1);
experiment3_each_pos_psth = createNamedFolder(experiment3_psth,'each_pos_psth_fig');
plot_Ex3_staticPSTH = 1;
if plot_Ex3_staticPSTH == 1
    for neuron = 28:28
        %1:length(newSpkTime)
    figure;
    % --- サブプロット作成 ---
    for i = 1:length(Postures_name)
        Posture_PSTH{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);
        hold(Posture_PSTH{i}, 'on');  % 明示的にhold on
    end
        for pos = 1:length(Postures_name)
            %
            % --- 棒グラフ ---
            b = bar(Posture_PSTH{pos}, Ex3_time_window_each(1:end-1), firing_rate_for_psth_rechange{pos,1}(neuron,:), 'hist');
            b.FaceColor = [0.6 0.6 0.6];   % グレー塗り
            b.EdgeColor = [0.6 0.6 0.6];   % 枠線もグレー
  
            
            % --- PSTH線プロット ---
            %p = plot(Posture_PSTH{pos}, Ex3_time_window_each(1:end-1), firing_rate_for_psth_smoothed_rechange{pos,1}(neuron,:) , 'Color', 'r', 'LineWidth', 3);
            
            % --- 軸設定 ---
            xlim(Posture_PSTH{pos}, [-5 20]);
            ylim(Posture_PSTH{pos}, [0 100]);
            
            
            for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
                scatter(Posture_PSTH{pos},Task_spike_time_all_Each_pos_rechange{pos,1}{neuron,task},100-5*5+task*5,'.','MarkeredgeColor','k');hold on;
            end
            
            
            % --- 縦線追加 ---
            xline(Posture_PSTH{pos}, 0, ':', 'LineWidth', 4, 'Color', [0.25 0.25 0.25]);  
            xline(Posture_PSTH{pos}, 15, ':', 'LineWidth', 4, 'Color', [0.25 0.25 0.25]);
            % --- 軸フォント設定
            set(Posture_PSTH{pos}, 'FontSize', 25, ...
                           'FontWeight', 'bold', ...
                           'FontName', 'Arial');
        end
     %ここで全サブプロットにX軸目盛を一括適用！
        allAxes = findall(gcf, 'type', 'axes', '-not', 'Tag', 'Colorbar');
        for ax = allAxes'
            xticks(ax, [-5 0 5 10 15 20]);
            xticklabels(ax, {'-5','0','5','10','15','20'});
            % --- 軸設定 ---       
            % === メモリ設定 ===
            ax.TickDir = 'out';              % メモリを外向きに
            ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
            ax.XMinorTick = 'on';            % X軸の小目盛をON
            ax.YMinorTick = 'on';            % Y軸の小目盛をON
            ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
            box off; 
        end
        for pos = 1:length(Postures_name)
             title(Posture_PSTH{pos},[char(Postures_name_rechange{pos})], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 40, 'Color',colors_rechange(pos,:))
        end
     
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % --- PDF出力用設定 ---
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [20 20]);         % 用紙サイズ（例：20×20 cm）
    set(gcf, 'PaperPosition', [0 0 20 20]); % 図の配置位置とサイズ

    
     % === Figureサイズ ===
     % === FigureのサイズをA4幅に縮小 ===
    target_width = 80;     % cm （A4幅に収める）
    target_height = 50;     % 縦は適度に調整（横幅に合わせて縮小）

    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

    % --- ファイル名設定 ---
    pdfFileName = fullfile(experiment3_each_pos_psth, ['Neuron_' num2str(neuron) '.pdf']);
    print(fig, pdfFileName, '-dpdf');

    close all hidden
    end
else
    disp('not make PSTH');
end



%% make FR
%for each FR
for pos = 1:length(Postures_name)
    figure;
    colormap(newCmap)
    experiment3_pos = createNamedFolder(experiment3_psth, Postures_name(1,pos));
    imagesc(Ex3_time_window_each(1:end-1),length(newSpkTime):-1:1,Ex3_static_firing_rate_for_psth{1,pos});
    caxis([0 110]);
    xlim([-5 20])
    ylim([0.5 length(newSpkTime)+0.5])
    xlabel('Time (s)');
    ylabel('Single Unit');
    % Y軸のラベルを反転
    yticks(1:length(newSpkTime)); % 元のY軸の位置を設定
    yticklabels(fliplr(1:length(newSpkTime))); % ラベルを逆順に設定
    colorbar;
    title(['Firing rate ' + Postures_name(pos)]);
    fontsize(gcf,20,"points")
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_pos, [char(Postures_name(1,pos)) '_Firing_Rate' '.tif']);
    print(gcf, tifFileName, '-dtiff', '-r300'); 
    close all hidden;
end

%% plot firing rate for fig
Firing_rate_folder_for_fig = createNamedFolder(experiment3_psth, 'Firing rate for fig');
nColors = 256;
cmap = jet(nColors);

% データ範囲
dataMin = 0;
dataMax = 180;

% カスタム変換: データ値 -> colormap index (0〜1)
% ここで 80 が 0.75 (オレンジ) に来るように調整
mapFunc = @(val) (val/50) * 0.75 .* (val<=50) + ...
                 (0.75 + (val-50)/(dataMax-50)*0.25) .* (val>50);

% サンプリング
nPoints = 256;
customRange = mapFunc(linspace(dataMin, dataMax, nPoints));

% 新しいカラーマップ
newmyCmap = interp1(linspace(0,1,nColors), cmap, customRange);

%% === 描画 ===
for pos = 1:length(Postures_name)
figure;
colormap(newmyCmap);
imagesc(Ex3_time_window_each(1:end-1), length(newSpkTime):-1:1, Ex3_static_firing_rate_for_psth{1,pos});
caxis([0 180]);   
%colorbar;
xlim([-5 20])
ylim([0.5 length(newSpkTime)+0.5])

yticks([13 33 53]); 
yticklabels(fliplr({'20 ','40 ','60 '}));

% --- X軸 ---
xticks([0 15]);      % 目盛りの位置を指定
xticklabels({'0','15'});  % 表示ラベル
hold on;
% --- グレー線 ---
xline(0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
xline(15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);




% --- 軸の設定 ---
ax = gca;
ax.FontSize = 45;          % 軸のフォントサイズ
%ax.FontWeight = 'bold';    % 軸ラベル・目盛を太字に

% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.XMinorTick = 'on';            % X軸の小目盛をON
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
box off;

% --- タイトルを太字かつ80ポイントに ---
title(['Pos-' num2str(pos)], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 60);

% === FigureサイズをA4幅に縮小 ===
target_width = 19;    % cm
target_height = 20;   % cm
set(gca, 'FontName', 'Arial','FontWeight','bold')
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% Create textarrow
%{
annotation(gcf,'textarrow',[0.095447870778267 0.129221732745961],...
    [0.337517433751742 0.337517433751741],'LineWidth',5,'HeadStyle','plain');
%}
% Create arrow
annotation(gcf,'textbox',...
    [0.902808653741913 0.246624825662482 0.0957229174768547 0.133268509242345],...
    'String','▶',...
    'FontSize',45,...
    'FitBoxToText','off',...
    'EdgeColor','none');
% Create SQUAREmean firing rate
annotation(gcf,'textbox',...
    [0.898209985315699 0.473960948396095 0.0900425844346533 0.112970711297058],...
    'String','■',...
    'FontSize',45,...
    'FitBoxToText','off',...
    'EdgeColor','none');
% Create triangle
annotation(gcf,'textbox',...
    [0.896741556534501 0.62295676495675 0.0900425844346534 0.0864714086471238],...
    'String','●',...
    'FontSize',45,...
    'FitBoxToText','off',...
    'EdgeColor','none');

% === PDF出力用 ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];
fig.PaperPosition = [0 0 target_width target_height];
pngFileName = fullfile(Firing_rate_folder_for_fig, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig' '.png']);
%pngFileName = fullfile(Firing_rate_folder_for_fig, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_withcolorbar' '.png']);
print(gcf, pngFileName, '-dpng', '-r300');   % 300 dpi PNG
end
%}

%% plot firing rate for fig
Firing_rate_folder_for_fig = createNamedFolder(experiment3_psth, 'Firing rate for fig');
nColors = 256;
cmap = jet(nColors);

% データ範囲
dataMin = 0;
dataMax = 180;

% カスタム変換: データ値 -> colormap index (0〜1)
% ここで 80 が 0.75 (オレンジ) に来るように調整
mapFunc = @(val) (val/50) * 0.75 .* (val<=50) + ...
                 (0.75 + (val-50)/(dataMax-50)*0.25) .* (val>50);

% サンプリング
nPoints = 256;
customRange = mapFunc(linspace(dataMin, dataMax, nPoints));

% 新しいカラーマップ
newmyCmap = interp1(linspace(0,1,nColors), cmap, customRange);

%% === 描画 ===
for pos = 1:length(Postures_name)
figure;
colormap(newmyCmap);
imagesc(Ex3_time_window_each(1:end-1), length(newSpkTime):-1:1, Ex3_static_firing_rate_for_psth{1,pos});
caxis([0 180]);   
%colorbar;
xlim([-5 20])
ylim([0.5 length(newSpkTime)+0.5])


hold on;
% --- グレー線 ---
xline(0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
xline(15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);




% --- 軸の設定 ---
ax = gca;
ax.FontSize = 40;          % 軸のフォントサイズ
%ax.FontWeight = 'bold';    % 軸ラベル・目盛を太字に


% === 主目盛 ===
yticks([13 33 53]); 
yticklabels(fliplr({'20 ','40 ','60 '}));

% --- X軸 ---
xticks([0 15]);      % 目盛りの位置を指定
xticklabels({'0','15'});  % 表示ラベル
% === ラベルを水平に ===
ax.XTickLabelRotation = 0;                    % ラベルを回転させない（水平）

% === 小目盛（線のみ） ===
ax.YMinorTick = 'on';          
ax.YAxis.MinorTickValues = ([3 8 18 23 28 38 43 48 58 63 68]);
ax.XAxis.MinorTickValues = ([-5 5 10 20]);
ax.YMinorGrid = 'off';

% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.XMinorTick = 'on';            % X軸の小目盛をON
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 3;                % 軸線を太く（見やすさアップ）
box off;

% --- タイトルを太字かつ80ポイントに ---
title(['Pos-' num2str(pos)], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 50,'Color',colors_rechange(pos,:));

% === FigureサイズをA4幅に縮小 ===
target_width = 19;    % cm
target_height = 20;   % cm
set(gca, 'FontName', 'Arial','FontWeight','bold')
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用 ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];
fig.PaperPosition = [0 0 target_width target_height];
pngFileName = fullfile(Firing_rate_folder_for_fig, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_explain' '.png']);
%pngFileName = fullfile(Firing_rate_folder_for_fig, [char(Postures_name(1,pos)) '_Firing_Rate_for_fig_withcolorbar' '.png']);
print(gcf, pngFileName, '-dpng', '-r300');   % 300 dpi PNG
end
%}




%% figure 3 BC 
neuron = 21;
Neuron_21_for_fig_folder = createNamedFolder(experiment3_psth, 'main figure for article neuron 21');

pos = 1;

% 8分割タイル
% color map setting
nColors = 256;
baseMap = viridis(nColors);

dataMax   = 180;
threshold = 50;

t = threshold / dataMax;

v = linspace(0,1,nColors);

customRange = zeros(size(v));

% --- 0–50Hz に85%割り当て ---
customRange(v <= t) = ...
    (v(v<=t)/t) * 0.85;

% --- 50–180Hz は非線形でなだらかに ---
gamma_high = 1.5;  % 1より大きいと終端集中を防ぐ

vh = (v(v>t)-t) / (1-t);
customRange(v > t) = ...
    0.85 + (vh.^gamma_high) * 0.15;

newCmap = interp1(linspace(0,1,nColors), baseMap, customRange);

figure('Units','centimeters','Position',[5 5 14 6.5]);

% --- 左図（ax1）: 幅4/8=0.5 ---
ax1 = axes('Position',[0.1 0.1 0.4 0.8]);  % [左 下 幅 高さ]
hold(ax1,'on');
% バー＋ラスター描画
b = bar(ax1, Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_for_psth{1,pos}(neuron,:), 'BarWidth',1);
b.FaceColor = [0.6 0.6 0.6]; b.EdgeColor = [0.6 0.6 0.6];
for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
    spk = Task_spike_time_all_Each_pos{1,pos}{neuron,task};
    y = (120 - 5*5 + task*5) * ones(size(spk));
    plot(ax1, spk, y, 'k.', 'MarkerSize',3);
end
xlim(ax1,[-5 20]); ylim(ax1,[0 120]);
ax1.FontSize = 10; ax1.FontWeight = 'bold'; ax1.FontName = 'Arial';
ax1.TickDir = 'out'; ax1.LineWidth = 1.5; box(ax1,'off');
ax1.Layer = 'top';   % ← これを追加
xline(ax1,0, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.5);
xline(ax1,15, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.5);
title(ax1,['Cat A Pos-' num2str(pos)], 'FontWeight','bold','FontSize',10,'FontName','Arial');

% --- Raster plot for five trials (n=5) ---
text(0.225, 0.835, ...          % 左上付近
    'Raster plot for five trials (n=5)', ...
    'Units', 'normalized', ...
    'FontSize', 8, ...
    'FontWeight', 'bold', ...
    'FontName', 'Arial', ...
    'VerticalAlignment', 'top', ...
    'HorizontalAlignment', 'left');

% --- Bin = 50 ms ---
text(0.6, 0.425, ...          % 上から少し下にずらす
    'bin = 50 ms', ...
    'Units', 'normalized', ...
    'FontSize', 8, ...
    'FontWeight', 'bold', ...
    'FontName', 'Arial', ...
    'VerticalAlignment', 'top', ...
    'HorizontalAlignment', 'left');

% --- 右図（ax2）: 幅3/8=0.375, 右詰め、間に空白1/8 ---
ax2 = axes('Position',[0.625 0.1 0.375 0.8]);  % 左端 = 0.5+0.125
imagesc(ax2, Ex3_time_window_each(1:end-1), 1:length(newSpkTime), Ex3_static_firing_rate_for_psth{1,pos});
caxis(ax2,[0 180]); 
colormap(ax2,newCmap);
% --- Y軸を反転 ---
set(ax2, 'YDir', 'normal');  % 上が大きく、下が小さく

xlim(ax2,[-5 20]); ylim(ax2,[0.5 length(newSpkTime)+0.5]);
ax2.FontSize = 10; ax2.FontWeight = 'bold'; ax2.FontName = 'Arial';
ax2.TickDir = 'out'; ax2.LineWidth = 1.5; box(ax2,'off');
yticks(ax2,[20 40 60]); 
xticks(ax2,[-5 0 5 10 15 20]);
yticklabels(ax2,{'20','40','60'});
ax2.XMinorTick = 'off'; ax2.YMinorTick = 'on';
xline(ax2,0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5);
xline(ax2,15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5);
title(ax2,['Cat A Pos-' num2str(pos)], 'FontWeight','bold','FontSize',10,'FontName','Arial');

% --- カラーバー ---
cb = colorbar(ax2);
cb.Ticks = [0 50 100 150 180];     % 目盛りを指定
cb.FontSize = 10; cb.FontWeight = 'bold'; cb.FontName = 'Arial';
cb.Label.String = 'Firing rate [Hz]';  % 必要に応じてラベルを追加
cb.Label.FontSize = 10; cb.Label.FontWeight = 'bold'; cb.Label.FontName = 'Arial';

% --- 保存 (EMF) ---
saveNameEMF = fullfile(Neuron_21_for_fig_folder, ...
    [char(Postures_name(1,pos)) '_Neuron21_BarRaster_and_Heatmap.emf']);
print(gcf, saveNameEMF, '-dmeta');  % EMF形式で保存

%% all firing rate
%line change for firing rate for heatmap time
Ex3_static_firing_rate_for_psth;
% 1×16のセル配列を4×4に変換
firing_rate_for_psth_rechange = reshape(Ex3_static_firing_rate_for_psth, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
firing_rate_for_psth_rechange = firing_rate_for_psth_rechange';
% 縦に並べて16×1のセル配列に変換
firing_rate_for_psth_rechange = reshape(firing_rate_for_psth_rechange, [length(Postures_name), 1]);

%line up smoothed data
Ex3_static_firing_rate_smoothed_data_rechange = reshape(Ex3_static_firing_rate_smoothed_data, [length(Postures_name)/4, length(Postures_name)/4]);
Ex3_static_firing_rate_smoothed_data_rechange = Ex3_static_firing_rate_smoothed_data_rechange';
firing_rate_for_psth_smoothed_rechange = reshape(Ex3_static_firing_rate_smoothed_data_rechange, [length(Postures_name), 1]);

%line up time data
Ex3_DI_each_pos_rechange  = reshape(Ex3_DI_each_pos, [length(Postures_name)/4, length(Postures_name)/4]);
Ex3_DI_each_pos_rechange = Ex3_DI_each_pos_rechange';
DI_each_pos_rechange = reshape(Ex3_DI_each_pos_rechange, [length(Postures_name), 1]);

%line up spike timing data
Task_spike_time_all_Each_pos_rechange  = reshape(Task_spike_time_all_Each_pos, [length(Postures_name)/4, length(Postures_name)/4]);
Task_spike_time_all_Each_pos_rechange = Task_spike_time_all_Each_pos_rechange';
Task_spike_time_all_Each_pos_rechange = reshape(Task_spike_time_all_Each_pos_rechange, [length(Postures_name), 1]);

%line up posture name
Postures_name;
Postures_name_rechange = reshape(Postures_name, [length(Postures_name)/4, length(Postures_name)/4]);
Postures_name_rechange = Postures_name_rechange';
Postures_name_rechange = reshape(Postures_name_rechange,[length(Postures_name), 1]);

% --- colorsの並び替え ---
n = length(Postures_name);  % 例: 16
side = sqrt(n);             % 例: 4
% --- colorsを行単位で再配置 ---
idx_color = reshape(1:n, [side, side]);  % 4x4 のインデックスマトリクス
idx_color = idx_color';                        % 転置して縦横を入れ替える
idx_color = idx_color(:);                      % 再び縦ベクトル化（並び替えインデックス）
colors_rechange = colors(idx_color, :);  % 行単位で並び替え


%% 
figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
experiment3_firingrate_heatmap = createNamedFolder(experiment3_folder, 'experiment3_firingrate_heatmap');

for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(newmyCmap);  
    Heat_map = imagesc(Posture_heatmap_time{pos},Ex3_time_window_each(1:end-1),length(newSpkTime):-1,firing_rate_for_psth_rechange{pos,1});
    caxis([0 180]);
    xline(Posture_heatmap_time{pos},0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
    xline(Posture_heatmap_time{pos},15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
  
    % --- 軸フォント設定
            set(Posture_heatmap_time{pos}, 'FontSize', 25, ...
                           'FontWeight', 'bold', ...
                           'FontName', 'Arial');
end
allAxes = findall(gcf, 'type', 'axes', '-not', 'Tag', 'Colorbar');
        for ax = allAxes'
            % === 主目盛 ===
            yticks(ax,[20 40 60]); 
            yticklabels(ax,{'20','40','60'});
            % === ラベルを水平に ===
            ax.XTickLabelRotation = 0;                    % ラベルを回転させない（水平）
            % === 小目盛（線のみ） ===
            ax.YMinorTick = 'on';          
            %ax.YAxis.MinorTickValues = ([3 8 18 23 28 38 43 48 58 63 68]);
            ax.YAxis.MinorTickValues = ([5 10 15 25 30 35 45 50 55 65 70]);
            ax.YMinorGrid = 'off';
            xticks(ax, [0 15]);
            xticklabels(ax, {'0','15'});
            ax.XAxis.MinorTickValues = ([-5 5 10 20]);
            % --- 軸設定 ---       
            % === メモリ設定 ===
            ax.TickDir = 'out';              % メモリを外向きに
            ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
            ax.XMinorTick = 'on';            % X軸の小目盛をON
            ax.YMinorTick = 'on';            % Y軸の小目盛をON
            ax.LineWidth = 2.5;                % 軸線を太く（見やすさアップ）
            ax.YRuler.TickLabelGapOffset = -6;  % 負の値で数字を軸線に近づける
            box on; 
        end
for pos = 1:length(Postures_name)
    title(Posture_heatmap_time{pos},[char(Postures_name_rechange{pos})], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 30, 'Color',colors_rechange(pos,:))
        
    %title(Posture_heatmap_time{pos}, ['Pos-' num2str(pos)], 'FontSize', 30, 'FontWeight', 'bold','Color',colors_rechange(pos,:));
end

cellfun(@(x) caxis(x,[0 180]),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_firingrate_heatmap, ['All_Posture_labeld'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden

%% plot all firing rate for fig---------------------------------------------------------------------------
experiment3_firingrate_heatmap = createNamedFolder(experiment3_folder, 'experiment3_firingrate_heatmap');
figure;

for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
for pos = 1:length(Postures_name)
    % ヒートマップ描画
    colormap(newmyCmap);
    imagesc(Posture_heatmap_time{pos}, Ex3_time_window_each(1:end-1), length(newSpkTime):-1, firing_rate_for_psth_rechange{pos,1});
    caxis([0 180]);
    xline(Posture_heatmap_time{pos},0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
    xline(Posture_heatmap_time{pos},15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
  
    % --- 軸フォント設定
            set(Posture_heatmap_time{pos}, 'FontSize', 25, ...
                           'FontWeight', 'bold', ...
                           'FontName', 'Arial');
end
allAxes = findall(gcf, 'type', 'axes', '-not', 'Tag', 'Colorbar');
        for ax = allAxes'
            % === 主目盛 ===
            yticks(ax,[20 40 60]); 
            yticklabels(ax,{'20','40','60'});
            % === ラベルを水平に ===
            ax.XTickLabelRotation = 0;                    % ラベルを回転させない（水平）
            % === 小目盛（線のみ） ===
            ax.YMinorTick = 'on';          
            %ax.YAxis.MinorTickValues = ([3 8 18 23 28 38 43 48 58 63 68]);
            ax.YAxis.MinorTickValues = ([5 10 15 25 30 35 45 50 55 65 70]);
            ax.YMinorGrid = 'off';
            xticks(ax, [0 15]);
            xticklabels(ax, {'0','15'});
            ax.XAxis.MinorTickValues = ([-5 5 10 20]);
            % --- 軸設定 ---       
            % === メモリ設定 ===
            ax.TickDir = 'out';              % メモリを外向きに
            ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
            ax.XMinorTick = 'on';            % X軸の小目盛をON
            ax.YMinorTick = 'on';            % Y軸の小目盛をON
            ax.LineWidth = 2.5;                % 軸線を太く（見やすさアップ）
            ax.YRuler.TickLabelGapOffset = -6;  % 負の値で数字を軸線に近づける
            box on; 
        end
 for pos = 1:length(Postures_name)
     title(Posture_heatmap_time{pos},[char(Postures_name_rechange{pos})], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 30, 'Color',colors_rechange(pos,:))
        
     %title(Posture_heatmap_time{pos}, ['Pos-' num2str(pos)], 'FontSize', 30, 'FontWeight', 'bold','Color',colors_rechange(pos,:));
 end
for pos = 1:length(Postures_name)
    ax = Posture_heatmap_time{pos};

    % 位置をデータ座標で指定
    text(ax, 21.25, 21, '▶', ...
        'Color', 'k', ...           % 黒色（必要に応じて変更）
        'FontSize', 20, ...         % サイズ
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
   text(ax, 21.25, 41, '■', ...
        'Color', 'k', ...           % 黒色（必要に応じて変更）
        'FontSize', 20, ...         % サイズ
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
   text(ax, 21.25, 53, '●', ...
        'Color', 'k', ...           % 黒色（必要に応じて変更）
        'FontSize', 20, ...         % サイズ
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
cellfun(@(x) caxis(x,[0 180]),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.93, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整

% === カラーバー目盛とラベル設定 ===
colorbarHandle.Ticks = [0 50 100 150 180];                % 目盛の位置
colorbarHandle.TickLabels = {'0','50','100','150','180'}; % 表示ラベル（省略可）

 % --- PDF出力用設定 ---
 % === FigureのサイズをA4幅に縮小 ===
 target_width = 40;     % cm （A4幅に収める）
 target_height = 50;     % 縦は適度に調整（横幅に合わせて縮小）
 set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

 % === PDF出力用にPaperSizeを合わせる ===
 fig = gcf;
 fig.PaperUnits = 'centimeters';
 fig.PaperSize = [target_width target_height];      % 幅 × 高さ
 fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

 % --- ファイル名設定 ---
 pdfFileName = fullfile(experiment3_firingrate_heatmap, ['Firing_rate_heat_map_for_fig.pdf']);
 print(fig, pdfFileName, '-dpdf');
% --- PNG出力（高解像度）---
pngFileName = fullfile(experiment3_firingrate_heatmap, 'Firing_rate_heat_map_for_fig.png');
print(fig, pngFileName, '-dpng', '-r600');   % 600dpiの高解像度PNG
%----------------------------------------------------------------------------

%% plot all firing rate for fig master thesis---------------------------------------------------------------------------
experiment3_firingrate_heatmap = createNamedFolder(experiment3_folder, 'experiment3_firingrate_heatmap');

figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
for pos = 1:length(Postures_name)
    % ヒートマップ描画
    colormap(newmyCmap);
    imagesc(Posture_heatmap_time{pos}, Ex3_time_window_each(1:end-1), length(newSpkTime):-1, firing_rate_for_psth_rechange{pos,1});
    caxis([0 180]);
    xline(Posture_heatmap_time{pos},0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
    xline(Posture_heatmap_time{pos},15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
  
    % --- 軸フォント設定
            set(Posture_heatmap_time{pos}, 'FontSize', 25, ...
                           'FontWeight', 'bold', ...
                           'FontName', 'Arial');
end
allAxes = findall(gcf, 'type', 'axes', '-not', 'Tag', 'Colorbar');
        for ax = allAxes'
            % === 主目盛 ===
            yticks(ax,[20 40 60]); 
            yticklabels(ax,{'20','40','60'});
            %yticks(ax,[5 10 15 20 25]); 
            %yticklabels(ax,{'5','10','15','20','25'});
            % === ラベルを水平に ===
            ax.XTickLabelRotation = 0;                    % ラベルを回転させない（水平）
            % === 小目盛（線のみ） ===
            ax.YMinorTick = 'on';          
            %ax.YAxis.MinorTickValues = ([3 8 18 23 28 38 43 48 58 63 68]);
            %ax.YAxis.MinorTickValues = ([5 10 15 25 30 35 45 50 55 65 70]);
            ax.YAxis.MinorTickValues = ([5 10 15 25 30 35 45 50 55 65 70]);
            ax.YMinorGrid = 'off';
            xticks(ax, [0 15]);
            xticklabels(ax, {'0','15'});
            ax.XAxis.MinorTickValues = ([-5 5 10 20]);
            % --- 軸設定 ---       
            % === メモリ設定 ===
            ax.TickDir = 'out';              % メモリを外向きに
            ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
            ax.XMinorTick = 'on';            % X軸の小目盛をON
            ax.YMinorTick = 'on';            % Y軸の小目盛をON
            ax.LineWidth = 2.5;                % 軸線を太く（見やすさアップ）
            ax.YRuler.TickLabelGapOffset = -6;  % 負の値で数字を軸線に近づける
            box on; 
        end
 for pos = 1:length(Postures_name)
     title(Posture_heatmap_time{pos},[char(Postures_name_rechange{pos})], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 30, 'Color',colors_rechange(pos,:))
        
     %title(Posture_heatmap_time{pos}, ['Pos-' num2str(pos)], 'FontSize', 30, 'FontWeight', 'bold','Color',colors_rechange(pos,:));
 end
cellfun(@(x) caxis(x,[0 180]),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.93, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整

% === カラーバー目盛とラベル設定 ===
colorbarHandle.Ticks = [0 50 100 150 180];                % 目盛の位置
colorbarHandle.TickLabels = {'0','50','100','150','180'}; % 表示ラベル（省略可）

 % --- PDF出力用設定 ---
 % === FigureのサイズをA4幅に縮小 ===
 target_width = 40;     % cm （A4幅に収める）
 target_height = 50;     % 縦は適度に調整（横幅に合わせて縮小）
 set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

 % === PDF出力用にPaperSizeを合わせる ===
 fig = gcf;
 fig.PaperUnits = 'centimeters';
 fig.PaperSize = [target_width target_height];      % 幅 × 高さ
 fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

 % --- ファイル名設定 ---
 pdfFileName = fullfile(experiment3_firingrate_heatmap, ['Firing_rate_heat_map_for_fig_master_thesis.pdf']);
 print(fig, pdfFileName, '-dpdf');
% --- PNG出力（高解像度）---
pngFileName = fullfile(experiment3_firingrate_heatmap, 'Firing_rate_heat_map_for_fig_master_thesis..png');
print(fig, pngFileName, '-dpng', '-r600');   % 600dpiの高解像度PNG
%% plot psth all

Posture_PSTH = cell(length(Postures_name),1);
experiment3_each_pos_psth = createNamedFolder(experiment3_psth,'each_pos_psth');
plot_Ex3_staticPSTH = 2;
if plot_Ex3_staticPSTH == 1
    for neuron = 1:length(newSpkTime)
    figure;
    % --- サブプロット作成 ---
    for i = 1:length(Postures_name)
        Posture_PSTH{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);
        hold(Posture_PSTH{i}, 'on');  % 明示的にhold on
    end
        for pos = 1:length(Postures_name)
            %
            % --- 棒グラフ ---
            b = bar(Posture_PSTH{pos}, Ex3_time_window_each(1:end-1), firing_rate_for_psth_rechange{pos,1}(neuron,:), 'hist');
            b.FaceColor = [0.6 0.6 0.6];   % グレー塗り
            b.EdgeColor = [0.6 0.6 0.6];   % 枠線もグレー
  
            
            % --- PSTH線プロット ---
            p = plot(Posture_PSTH{pos}, Ex3_time_window_each(1:end-1), firing_rate_for_psth_smoothed_rechange{pos,1}(neuron,:) , 'Color', 'r', 'LineWidth', 3);
            
            % --- 軸設定 ---
            xlim(Posture_PSTH{pos}, [-5 20]);
            ylim(Posture_PSTH{pos}, [0 140]);
            
            % --- タイトル（サブプロットごと） ---
            title(Posture_PSTH{pos}, [char(Postures_name_rechange{pos})]);
            
            
            for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
                scatter(Posture_PSTH{pos},Task_spike_time_all_Each_pos_rechange{pos,1}{neuron,task},140-5*5+task*5,'.','MarkeredgeColor','k');hold on;
            end
            
            
            % --- 縦線追加 ---
            xline(Posture_PSTH{pos}, 0, ':', 'LineWidth', 4, 'Color', [0.25 0.25 0.25]);  
            xline(Posture_PSTH{pos}, 15, ':', 'LineWidth', 4, 'Color', [0.25 0.25 0.25]);
            % --- 軸フォント設定（←ここが重要）---
            set(Posture_PSTH{pos}, 'FontSize', 20, ...
                           'FontWeight', 'bold', ...
                           'FontName', 'Arial');
        end
     %ここで全サブプロットにX軸目盛を一括適用！
        allAxes = findall(gcf, 'type', 'axes', '-not', 'Tag', 'Colorbar');
        for ax = allAxes'
            xticks(ax, [-5 0 5 10 15 20]);
            xticklabels(ax, {'-5','0','5','10','15','20'});
           
        end
        for pos = 1:length(Postures_name)
             title(Posture_PSTH{pos},['Pos-' num2str(pos)], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 30)
        end
    %fontsize(gca,30,"points");
    % --- 図全体タイトル ---
    sgtitle(gcf, ['Neuron ' num2str(neuron) ' ' num2str(newSpkCH(neuron)) 'channel PSTH across postures'],'FontSize', 30);
     % --- 全体のX軸/Y軸ラベル ---
    han = axes(gcf, 'visible', 'off');
    
    han.XLabel.Visible = 'on';
    han.YLabel.Visible = 'on';
    xlabel(han, 'Time [s]', 'FontSize', 40, 'FontWeight','bold','FontName', 'Arial','Units', 'normalized', 'Position', [0.5, -0.08, 0]);
    ylabel(han, 'Firing rate [Hz]', 'FontSize', 40,'FontWeight','bold','FontName', 'Arial', 'Units', 'normalized', 'Position', [-0.08, 0.5, 0]);
    
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % --- PDF出力用設定 ---
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [20 20]);         % 用紙サイズ（例：20×20 cm）
    set(gcf, 'PaperPosition', [0 0 20 20]); % 図の配置位置とサイズ

    
     % === Figureサイズ ===
     % === FigureのサイズをA4幅に縮小 ===
    target_width = 80;     % cm （A4幅に収める）
    target_height = 50;     % 縦は適度に調整（横幅に合わせて縮小）

    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

    % --- ファイル名設定 ---
    pdfFileName = fullfile(experiment3_each_pos_psth, ['Neuron_' num2str(neuron) '.pdf']);
    print(fig, pdfFileName, '-dpdf');

    close all hidden
    end
else
    disp('not make PSTH');
end

%% plot psth all for fig-------------------------------------------------------------------------------

Posture_PSTH = cell(length(Postures_name),1);
experiment3_each_pos_psth = createNamedFolder(experiment3_psth,'each_pos_psth_fig');
plot_Ex3_staticPSTH = 2;
if plot_Ex3_staticPSTH == 1
    for neuron = 21:21
        %1:length(newSpkTime)
    figure;
    % --- サブプロット作成 ---
    for i = 1:length(Postures_name)
        Posture_PSTH{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);
        hold(Posture_PSTH{i}, 'on');  % 明示的にhold on
    end
        for pos = 1:length(Postures_name)
            %
            % --- 棒グラフ ---
            b = bar(Posture_PSTH{pos}, Ex3_time_window_each(1:end-1), firing_rate_for_psth_rechange{pos,1}(neuron,:), 'hist');
            b.FaceColor = [0.6 0.6 0.6];   % グレー塗り
            b.EdgeColor = [0.6 0.6 0.6];   % 枠線もグレー
  
            
            % --- PSTH線プロット ---
            %p = plot(Posture_PSTH{pos}, Ex3_time_window_each(1:end-1), firing_rate_for_psth_smoothed_rechange{pos,1}(neuron,:) , 'Color', 'r', 'LineWidth', 3);
            
            % --- 軸設定 ---
            xlim(Posture_PSTH{pos}, [-5 20]);
            ylim(Posture_PSTH{pos}, [0 120]);
            
            
            for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
                scatter(Posture_PSTH{pos},Task_spike_time_all_Each_pos_rechange{pos,1}{neuron,task},120-5*5+task*5,'.','MarkeredgeColor','k');hold on;
            end
            
            
            % --- 縦線追加 ---
            xline(Posture_PSTH{pos}, 0, ':', 'LineWidth', 4, 'Color', [0.25 0.25 0.25]);  
            xline(Posture_PSTH{pos}, 15, ':', 'LineWidth', 4, 'Color', [0.25 0.25 0.25]);
            % --- 軸フォント設定
            set(Posture_PSTH{pos}, 'FontSize', 25, ...
                           'FontWeight', 'bold', ...
                           'FontName', 'Arial');
        end
     %ここで全サブプロットにX軸目盛を一括適用！
        allAxes = findall(gcf, 'type', 'axes', '-not', 'Tag', 'Colorbar');
        for ax = allAxes'
            xticks(ax, [-5 0 5 10 15 20]);
            xticklabels(ax, {'-5','0','5','10','15','20'});
            % --- 軸設定 ---       
            % === メモリ設定 ===
            ax.TickDir = 'out';              % メモリを外向きに
            ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
            ax.XMinorTick = 'on';            % X軸の小目盛をON
            ax.YMinorTick = 'on';            % Y軸の小目盛をON
            ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
            box off; 
        end
        for pos = 1:length(Postures_name)
             title(Posture_PSTH{pos},[char(Postures_name_rechange{pos})], 'FontWeight','bold','FontName', 'Arial', 'FontSize', 40, 'Color',colors_rechange(pos,:))
        end
     
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % --- PDF出力用設定 ---
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', [20 20]);         % 用紙サイズ（例：20×20 cm）
    set(gcf, 'PaperPosition', [0 0 20 20]); % 図の配置位置とサイズ

    
     % === Figureサイズ ===
     % === FigureのサイズをA4幅に縮小 ===
    target_width = 80;     % cm （A4幅に収める）
    target_height = 50;     % 縦は適度に調整（横幅に合わせて縮小）

    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

    % --- ファイル名設定 ---
    pdfFileName = fullfile(experiment3_each_pos_psth, ['Neuron_' num2str(neuron) '.pdf']);
    print(fig, pdfFileName, '-dpdf');

    close all hidden
    end
else
    disp('not make PSTH');
end





%% Zscore
figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time_zscore{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end

firing_rate_for_psth_rechange_zscore = cell(length(firing_rate_for_psth_rechange),1);
for zsc = 1:length(firing_rate_for_psth_rechange)
    firing_rate_for_psth_rechange_zscore{zsc,1} = zscore(firing_rate_for_psth_rechange{zsc,1}, [], 2);
end


for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(jet);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Posture_heatmap_time_zscore{pos},Ex3_time_window_each(1:end-1),length(newSpkTime):-1,firing_rate_for_psth_rechange_zscore{pos,1});
    caxis([0 110]);
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_heatmap_time_zscore(pos));
end


cellfun(@(x) caxis(x,[-4 4]),Posture_heatmap_time_zscore(1:16));
cellfun(@(x) xlabel(x,'Time (s)'),Posture_heatmap_time_zscore(1:16));
cellfun(@(x) ylabel(x,'Single-unit'),Posture_heatmap_time_zscore(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time_zscore(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time_zscore(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_firingrate_heatmap, ['All_Posture_normalized'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');


%% separate dynamic phase and static phase
% extract non firedneuron  remove non fired neuron

experiment3_sepstatic_dynamic_folder = createNamedFolder(experiment3_folder, 'Separate Static and Dynamic');
% セル配列を行列に変換
[Ex3_Count_spike_all,Ex3_Task_spike_time_all,Ex3_Mean_firing_rate_all,Ex3_Pos_each_main_wavedata] = Cutting_data_for_each_DI(newSpkTime,newWavedata,EX3_task_DI_Lineup_Trial,Ex3_Posture_cutting_time);
    
[Ex3_Count_spike_all,Ex3_Task_spike_time_all,Ex3_Mean_firing_rate_all_5s_10s,Ex3_Pos_each_main_wavedata] = Cutting_data_for_each_DI_5_10s(newSpkTime,newWavedata,EX3_task_DI_Lineup_Trial,Ex3_Posture_cutting_time);
    
MFR_pos_matrix = zeros(length(Ex3_Mean_firing_rate_all_5s_10s{1,1}),size(Ex3_Mean_firing_rate_all_5s_10s{1,1},2));
MFR_pos_component = zeros(length(Ex3_Mean_firing_rate_all_5s_10s{1,1}),length(Ex3_Mean_firing_rate_all_5s_10s));

for i = 1:size(Ex3_Mean_firing_rate_all_5s_10s{1,1},2)
    for ii = 1:length(Ex3_Mean_firing_rate_all_5s_10s)
        MFR_pos_component(:,ii) = Ex3_Mean_firing_rate_all_5s_10s{1,ii}(:,i);
    end
    MFR_pos_matrix(:,i) = mean(MFR_pos_component,2);
end

% 各列で全ての要素が0であるかをチェック
zeroIndices = all(MFR_pos_matrix == 0, 1);
% 結果のインデックス
Non_fired_neuron_in_Ex3 = find(zeroIndices);
% average
bace_line = mean(MFR_pos_matrix,2);

SD = 1;
%% rectify baced on bace line


for pos = 1:length(Ex3_static_firing_rate_for_psth_each)
    Ex3_static_firing_rate_pos = Ex3_static_firing_rate_for_psth_each(:,pos);
    for trial = 1:size(Ex3_static_firing_rate_for_psth_each,1)
        Ex3_static_firing_rate_tri = Ex3_static_firing_rate_pos{trial,1};
        for neuron = 1:length(newSpkTime)
            Ex3_static_firing_rate_each_rect_neu(neuron,:) = abs(Ex3_static_firing_rate_tri(neuron,:) - bace_line(neuron,1));
        end
        Ex3_static_firing_rate_each_rect_tri{trial,1} = Ex3_static_firing_rate_each_rect_neu;
    end
    Ex3_static_firing_rate_each_rect(:,pos) = Ex3_static_firing_rate_each_rect_tri;
end


plot_for_ex3_rect = 1;
if plot_for_ex3_rect == 1
    posture = 1;
    neuron1 = 15;
    neuron2 = 25;
    figure;
    Fig_title_name = ["Trial 1 Neuron 15", "Trial 2 Neuron 15", "Trial 1 Neuron 15 rectified", "Trial 2 Neuron 15 rectified", "Trial 1 Neuron 25", "Trial 2 Neuron 25", "Trial 1 Neuron 25 rectified", "Trial 2 Neuron 25 rectified","Trial 2"];
    for i = 1:8
        Ex3_sep_explain_fig{i} = subplot(2,4,i);
    end
    plot(Ex3_sep_explain_fig{1},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_for_psth_each{1,1}(neuron1,:));
    plot(Ex3_sep_explain_fig{2},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_for_psth_each{2,1}(neuron1,:));
    plot(Ex3_sep_explain_fig{3},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_each_rect{1,1}(neuron1,:));
    plot(Ex3_sep_explain_fig{4},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_each_rect{2,1}(neuron1,:));
    plot(Ex3_sep_explain_fig{5},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_for_psth_each{1,1}(neuron2,:));
    plot(Ex3_sep_explain_fig{6},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_for_psth_each{2,1}(neuron2,:));
    plot(Ex3_sep_explain_fig{7},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_each_rect{1,1}(neuron2,:));
    plot(Ex3_sep_explain_fig{8},Ex3_time_window_each(1:end-1), Ex3_static_firing_rate_each_rect{2,1}(neuron2,:));
    for pos = 1:8
        cellfun(@(x) title(x, Fig_title_name(pos)),Ex3_sep_explain_fig(pos));
    end
    cellfun(@(x) xlabel(x,'Time [s]'),Ex3_sep_explain_fig(1:8));
    cellfun(@(x) ylabel(x,'Firing rate [Hz]'),Ex3_sep_explain_fig(1:8));
    cellfun(@(x) xlim(x,[-5 20]),Ex3_sep_explain_fig(1:8));
    cellfun(@(x) ylim(x,[-10 140]),Ex3_sep_explain_fig(1:8));
    cellfun(@(x) line(x,[-5, 20], [bace_line(neuron1,1), bace_line(neuron1,1)], 'Color',[0 1 0], 'LineStyle', '-', 'LineWidth', 5),Ex3_sep_explain_fig(1:2));
    cellfun(@(x) line(x,[-5, 20], [0, 0], 'Color',[0 1 0], 'LineStyle', '-', 'LineWidth', 5),Ex3_sep_explain_fig(3:4));
    cellfun(@(x) line(x,[-5, 20], [bace_line(neuron2,1), bace_line(neuron2,1)], 'Color',[0 1 0], 'LineStyle', '-', 'LineWidth', 5),Ex3_sep_explain_fig(5:6));
    cellfun(@(x) line(x,[-5, 20], [0, 0], 'Color',[0 1 0], 'LineStyle', '-', 'LineWidth', 5),Ex3_sep_explain_fig(7:8));
    fontsize(gcf,20,"points")
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_sepstatic_dynamic_folder, [' Posture_1_rectified'  '.tif']);
    print(gcf, tifFileName, '-dtiff', '-r300');

else
    disp('not plot')
end


% 各セル要素の指定行を削除
for i = 1:numel(Ex3_static_firing_rate_each_rect)
    currentMatrix = Ex3_static_firing_rate_each_rect{i}; % セル内の28×800行列を取得
    currentMatrix(Non_fired_neuron_in_Ex3,:) = []; % 指定行を削除
    Ex3_static_firing_rate_each_rect{i} = currentMatrix; % セル配列に戻す
end



% セル配列全体の加算平均を求める
numElements = numel(Ex3_static_firing_rate_each_rect); % セル要素数



for i = 1:numel(Ex3_static_firing_rate_each_rect)
    if i == 1
        allMatrix = Ex3_static_firing_rate_each_rect{i};
    else
        allMatrix = [allMatrix;Ex3_static_firing_rate_each_rect{i}]; % 各セル要素を加算
    end
end
Sum_Ex3_static_firing_rate_each_rect = mean(allMatrix,1);
Sum_bace_line = mean(allMatrix,'all');

%sd in mean value
Std_Ex3_static_firing_rate_each_rect = std(Sum_Ex3_static_firing_rate_each_rect,0,2);
Std_Ex3_plus = SD*Std_Ex3_static_firing_rate_each_rect+Sum_bace_line;
Std_Ex3_minus = -SD*Std_Ex3_static_firing_rate_each_rect+Sum_bace_line;

%%pick up columun extract start and end
timewindow_0to15 = Ex3_time_window_each(find(Ex3_time_window_each >= 0 & Ex3_time_window_each <= 15));
timewindow_10to15 = Ex3_time_window_each(find(Ex3_time_window_each >= 10 & Ex3_time_window_each <= 15));
Sum_Ex3_static_firing_rate_rect_0to15 = Sum_Ex3_static_firing_rate_each_rect(find(Ex3_time_window_each >= 0 & Ex3_time_window_each <= 15));
Sum_Ex3_static_firing_rate_rect_10to15 = Sum_Ex3_static_firing_rate_each_rect(find(Ex3_time_window_each >= 10 & Ex3_time_window_each <= 15));
str_sep_dynamic_static_SD = timewindow_0to15(find(Sum_Ex3_static_firing_rate_rect_0to15 < Std_Ex3_plus, 1));
end_sep_dynamic_static_SD = timewindow_10to15(find(Sum_Ex3_static_firing_rate_rect_10to15 > Std_Ex3_plus, 1)-1);


fig = figure;
p = plot(Ex3_time_window_each(1:end-1), Sum_Ex3_static_firing_rate_each_rect, 'Color', 'r', 'LineWidth', 2); % 赤色、太さ2

% ベースラインの水平線（緑）
line([-5, 20], [Sum_bace_line, Sum_bace_line], 'Color',[0 1 0], 'LineStyle', '-', 'LineWidth', 5);

% SD範囲の塗りつぶし（シアン）
sd_rectangle_x = [-20 20 20 -20];
sd_rectangle_y = [Std_Ex3_minus Std_Ex3_minus Std_Ex3_plus Std_Ex3_plus]; % minus minus plus plus
patch(sd_rectangle_x, sd_rectangle_y, 'cyan', 'FaceAlpha', 0.3);

% 縦線
xline(0, '-k', 'LineWidth', 2);
xline(str_sep_dynamic_static_SD, 'LineStyle', '-', 'Color', [0 1 0.75], 'LineWidth', 4); 
text(str_sep_dynamic_static_SD,20, ['Static phase start = ' num2str(str_sep_dynamic_static_SD)], ...
    'FontSize', 14, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top','Color', [0 1 0.75]);

xline(end_sep_dynamic_static_SD, 'LineStyle', '-', 'Color', [1 0.75 0], 'LineWidth', 4); 
text(end_sep_dynamic_static_SD,20, ['Static phase end = ' num2str(end_sep_dynamic_static_SD)], ...
    'FontSize', 14, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top','Color', [1 0.75 0]);

xlim([-5 20]);
ylim([0 25]);
xlabel('Time (s)');
ylabel('Activity from bace line');

fontsize(gcf, 30, "points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

tifFileName = fullfile(experiment3_sepstatic_dynamic_folder, 'wave_sd.tif');
print(fig, tifFileName, '-dtiff', '-r300');



%% Separate static and dynamic by differential
Sum_Ex3_static_firing_rate_each_rect_min5to20 = Sum_Ex3_static_firing_rate_each_rect(find(Ex3_time_window_each >= -5 & Ex3_time_window_each<20));
Ex3_time_window_each_min5to20 = Ex3_time_window_each(find(Ex3_time_window_each >= -5 & Ex3_time_window_each<20));
tilt_cal_bin = 9;
[LI2, LI, xtm, dxtm] = findSigAboveThreshErode(Sum_Ex3_static_firing_rate_each_rect_min5to20, 0.95, 0.95, tilt_cal_bin);
tvect_LI = (Ex3_time_window_each>-5); 

% 結果をプロット
figure;

% 元の信号
subplot(2,1,1);
plot(Ex3_time_window_each_min5to20, Sum_Ex3_static_firing_rate_each_rect_min5to20, 'k');
title('Original Signal');
xlabel('Time');
ylabel('Firing Rate');
xline(0, '--k', 'LineWidth', 1.5);  % X=0 に黒の破線を追加

% 時間微分的変化（変化率）
subplot(2,1,2);
plot(Ex3_time_window_each_min5to20, dxtm, 'b'); hold on;
plot(Ex3_time_window_each_min5to20(find(LI)), dxtm(LI), 'r.');
title(['Temporal Derivative (d/dt) tilt cal bin = ' num2str(tilt_cal_bin)]);
xlabel('Time');
ylabel('Derivative');
xline(0, '--k', 'LineWidth', 1.5);  % X=0 に黒の破線を追加

% LI の変化点（0→1または1→0）を検出
LI_diff = diff([0; LI(:); 0]);  % パディングしてエッジ検出
change_indices = find(LI_diff ~= 0);  % 変化があるインデックス（開始・終了含む）

% 2番目・3番目の変化点の時間を取得（存在する場合のみ）

if numel(change_indices) >= 3
    second_change_idx = change_indices(2);
    second_time = Ex3_time_window_each_min5to20(second_change_idx);
    
    third_change_idx = change_indices(3);
    third_time = Ex3_time_window_each_min5to20(third_change_idx);

    % 時刻を文字列に変換（小数2桁）
    second_time_str = sprintf('Static start %.2f', second_time);
    third_time_str = sprintf('Static end %.2f', third_time);

    % 1つ目のプロットに縦線とテキスト追加
    subplot(2,1,1);
    hold on;
    xline(second_time, '--g', 'LineWidth', 1.5);
    xline(third_time, '--b', 'LineWidth', 1.5);
    
    % Y軸の最大値を取得して、テキスト位置を調整
    ylims1 = ylim;
    text(second_time + 0.2, ylims1(2)*0.9, second_time_str, 'Color', 'g', 'FontSize', 10);
    text(third_time + 0.2, ylims1(2)*0.8, third_time_str, 'Color', 'b', 'FontSize', 10);

    % 2つ目のプロットに縦線とテキスト追加
    subplot(2,1,2);
    hold on;
    xline(second_time, '--g', 'LineWidth', 1.5);
    xline(third_time, '--b', 'LineWidth', 1.5);

    ylims2 = ylim;
    text(second_time + 0.2, ylims2(2)*0.9, second_time_str, 'Color', 'g', 'FontSize', 10);
    text(third_time + 0.2, ylims2(2)*0.8, third_time_str, 'Color', 'b', 'FontSize', 10);
end
sgtitle('Signal Change Detection Results');
fontsize(gcf, 30, "points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

tifFileName = fullfile(experiment3_sepstatic_dynamic_folder, ['Separate_differential'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
%% 
experiment3_static_folder = createNamedFolder(experiment3_folder, 'Static_phase');
experiment3_static_SD_folder = createNamedFolder(experiment3_static_folder, 'SD');
experiment3_static_differential_folder = createNamedFolder(experiment3_static_folder, 'Differential');
experiment3_static_defined_folder = createNamedFolder(experiment3_static_folder, 'Defined');
%select

%static_calculation = 'Defined';
static_calculation = 'Differential';
%static_calculation = 'Defined';
%
if strcmp(static_calculation, 'SD')
    experiment3_static_folder_select = experiment3_static_SD_folder;
    str_sep_dynamic_static = str_sep_dynamic_static_SD;
    end_sep_dynamic_static = end_sep_dynamic_static_SD;
elseif strcmp(static_calculation, 'Differential')
    experiment3_static_folder_select = experiment3_static_differential_folder;
    str_sep_dynamic_static = second_time;
    end_sep_dynamic_static = third_time;
elseif strcmp(static_calculation, 'Defined')
    % 区間（秒）
    str_sep_dynamic_static = 5;
    end_sep_dynamic_static = onset_time;

    % フォルダ名用の文字列
    start_str = strrep(num2str(str_sep_dynamic_static), '.', 'p');
    end_str   = strrep(num2str(end_sep_dynamic_static),   '.', 'p');

    defined_subfolder_name = [start_str, '-', end_str, 's'];

    % ★ Defined フォルダの中に作成
    experiment3_static_folder_select = ...
        createNamedFolder(experiment3_static_defined_folder, ...
                          defined_subfolder_name);
else
    disp('select static calculation')
end

bin_size_each_Ex3_sep = 0.05; % 50 ms bin size (adjust as needed)
start_time_each_Ex3_sep = str_sep_dynamic_static; % Time before stimulus onset (in seconds)
end_time_each_Ex3_sep = end_sep_dynamic_static;    % Time after stimulus onset (in seconds)
time_window_each_Ex3_sep = start_time_each_Ex3_sep:bin_size_each_Ex3_sep:end_time_each_Ex3_sep;

%[Ex3_Control_firing_rate_for_psth,max_fining_rate_Ex3_control] = Firing_rate_calculate(newSpkTime,Ex3_control_spike_time_all,time_window_each_Ex3Control,bin_size_each_Ex3Control);

[Ex3_firing_rate_sep,MFR_sep] = Firing_rate_calculate_sep_and_MFR(newSpkTime,Task_spike_time_all_Each_pos,time_window_each_Ex3_sep,bin_size_each_Ex3_sep);



%% spike count for cross correlation

bin_size_each_Ex3_for_crosss = 0.001; % 1 ms bin size (adjust as needed)
start_time_each_Ex3_sep = str_sep_dynamic_static; % Time before stimulus onset (in seconds)
end_time_each_Ex3_sep = end_sep_dynamic_static;    % Time after stimulus onset (in seconds)
time_window_each_Ex3_for_cross = start_time_each_Ex3_sep:bin_size_each_Ex3_for_crosss:end_time_each_Ex3_sep;

spike_count_for_psth = Firing_rate_calculate_sep_and_Spike_count(newSpkTime,Task_spike_time_all_Each_pos,time_window_each_Ex3_for_cross);


%% calculate angle
model_error_type = 4;
pos_number = 1:1:16;

%angle_definition = 'relative_normalized_centering';


angle_definition = 'relative_normalized_centering_knee_compensation';

%angle_definition =  'relative_normalized_centering_model_error_evaluation';
% relative, diff_from_standard,abs_by_horizontal
angle_folder =createNamedFolder(experiment3_static_folder_select, 'Angle_compare');
% 
if strcmp(angle_definition, 'relative')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new),pos_number'];
    vec_hipknee = hip_mean - Knee_mean_new;
    standard_vec_hip_knee = Knee_mean_new - vec_hipknee;
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean),pos_number'];
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new),compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)];
    hip_joint_lim = [25 90];
    knee_joint_lim = [35 125];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
elseif strcmp(angle_definition, 'relative_normalized')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new),pos_number'];
    vec_hipknee = hip_mean - Knee_mean_new;
    standard_vec_hip_knee = Knee_mean_new - vec_hipknee;
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean),pos_number'];
    hip_joint_lim = [-1 1];
    knee_joint_lim = [-1 1];
    %original angle information
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new),compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)];
    % normalized hip and knee angle -1 to 1
    hip_joint_angle_ori_normalized = 2 * (hip_joint_angle_ori(:,1) - min(hip_joint_angle_ori(:,1))) / (max(hip_joint_angle_ori(:,1)) - min(hip_joint_angle_ori(:,1))) - 1;
    knee_joint_angle_ori_normalized = 2 * (knee_joint_angle_ori(:,1) - min(knee_joint_angle_ori(:,1))) / (max(knee_joint_angle_ori(:,1)) - min(knee_joint_angle_ori(:,1))) - 1;
    hip_joint_angle_ori = [hip_joint_angle_ori_normalized,hip_joint_angle_ori(:,2)];
    knee_joint_angle_ori = [knee_joint_angle_ori_normalized,knee_joint_angle_ori(:,2)];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
    %centering
    hip_joint_angle_ori_centering = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new)-mean(compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new)),pos_number'];
    knee_joint_angle_ori_centering = [compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)-mean(compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)),pos_number'];
    hip_joint_angle_ori_normalized_centering = 2 * (hip_joint_angle_ori_centering(:,1) - min(hip_joint_angle_ori_centering(:,1))) / (max(hip_joint_angle_ori_centering(:,1)) - min(hip_joint_angle_ori_centering(:,1))) - 1;
    knee_joint_angle_ori_normalized_centering = 2 * (knee_joint_angle_ori_centering(:,1) - min(knee_joint_angle_ori_centering(:,1))) / (max(knee_joint_angle_ori_centering(:,1)) - min(knee_joint_angle_ori_centering(:,1))) - 1;
    hip_joint_angle_ori_centering = [hip_joint_angle_ori_normalized_centering,hip_joint_angle_ori_centering(:,2)];
    knee_joint_angle_ori_centering = [knee_joint_angle_ori_normalized_centering,knee_joint_angle_ori_centering(:,2)];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
elseif strcmp(angle_definition, 'relative_normalized_centering')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    vec_hipknee = hip_mean - Knee_mean_new;
    standard_vec_hip_knee = Knee_mean_new - vec_hipknee;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new)-mean(compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new)),pos_number'];
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)-mean(compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)),pos_number'];
    hip_joint_lim = [-1 1];
    knee_joint_lim = [-1 1];
    %original angle information
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new),compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)];
    % normalized hip and knee angle -1 to 1
    hip_joint_angle_ori_normalized = 2 * (hip_joint_angle_ori(:,1) - min(hip_joint_angle_ori(:,1))) / (max(hip_joint_angle_ori(:,1)) - min(hip_joint_angle_ori(:,1))) - 1;
    knee_joint_angle_ori_normalized = 2 * (knee_joint_angle_ori(:,1) - min(knee_joint_angle_ori(:,1))) / (max(knee_joint_angle_ori(:,1)) - min(knee_joint_angle_ori(:,1))) - 1;
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
    hip_joint_angle_ori = [hip_joint_angle_ori_normalized,hip_joint_angle_ori(:,2)];
    knee_joint_angle_ori = [knee_joint_angle_ori_normalized,knee_joint_angle_ori(:,2)];
elseif strcmp(angle_definition, 'relative_normalized_centering_model_error_evaluation')
    angle_model_error_evaluationfolder =createNamedFolder(angle_folder,  angle_definition);
    if model_error_type == 1
        Knee_mean_model_error = Knee_mean_new;
        Knee_mean_model_error(9,1) = Knee_mean_new(9,1)+model_potential_error_exc4_8_16;
        Knee_mean_model_error(9,3) = Knee_mean_new(9,3);
        Erra_label_folder_name = 'Xplus';
        angle_related_folder =createNamedFolder(angle_model_error_evaluationfolder,  Erra_label_folder_name);
    elseif model_error_type == 2
        Knee_mean_model_error = Knee_mean_new;
        Knee_mean_model_error(9,1) = Knee_mean_new(9,1)-model_potential_error_exc4_8_16;
        Knee_mean_model_error(9,3) = Knee_mean_new(9,3);
        Erra_label_folder_name = 'Xminus';
        angle_related_folder =createNamedFolder(angle_model_error_evaluationfolder,  Erra_label_folder_name);
    elseif model_error_type == 3
        Knee_mean_model_error = Knee_mean_new;
        Knee_mean_model_error(9,1) = Knee_mean_new(9,1);
        Knee_mean_model_error(9,3) = Knee_mean_new(9,3)+model_potential_error_exc4_8_16;
        Erra_label_folder_name = 'Yplus';
        angle_related_folder =createNamedFolder(angle_model_error_evaluationfolder,  Erra_label_folder_name);
    elseif model_error_type == 4
        Knee_mean_model_error = Knee_mean_new;
        Knee_mean_model_error(9,1) = Knee_mean_new(9,1);
        Knee_mean_model_error(9,3) = Knee_mean_new(9,3)-model_potential_error_exc4_8_16;
        Erra_label_folder_name = 'Yminus';
        angle_related_folder =createNamedFolder(angle_model_error_evaluationfolder,  Erra_label_folder_name);
    end 
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    vec_hipknee = hip_mean - Knee_mean_model_error;
    standard_vec_hip_knee = Knee_mean_model_error - vec_hipknee;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_model_error)-mean(compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new)),pos_number'];
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean_model_error, Ankle_mean)-mean(compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)),pos_number'];
    hip_joint_lim = [-1 1];
    knee_joint_lim = [-1 1];
    %original angle information
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_model_error),compute_joint_angle(standard_vec_hip_knee, Knee_mean_new, Ankle_mean)];
    % normalized hip and knee angle -1 to 1
    hip_joint_angle_ori_normalized = 2 * (hip_joint_angle_ori(:,1) - min(hip_joint_angle_ori(:,1))) / (max(hip_joint_angle_ori(:,1)) - min(hip_joint_angle_ori(:,1))) - 1;
    knee_joint_angle_ori_normalized = 2 * (knee_joint_angle_ori(:,1) - min(knee_joint_angle_ori(:,1))) / (max(knee_joint_angle_ori(:,1)) - min(knee_joint_angle_ori(:,1))) - 1;
    hip_joint_angle_ori = [hip_joint_angle_ori_normalized,hip_joint_angle_ori(:,2)];
    knee_joint_angle_ori = [knee_joint_angle_ori_normalized,knee_joint_angle_ori(:,2)];

elseif strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    vec_hipknee = hip_mean - Compensated_knee_joint_position;
    standard_vec_hip_knee = Compensated_knee_joint_position - vec_hipknee;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Compensated_knee_joint_position)-mean(compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Compensated_knee_joint_position)),pos_number'];
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Compensated_knee_joint_position, Ankle_mean)-mean(compute_joint_angle(standard_vec_hip_knee, Compensated_knee_joint_position, Ankle_mean)),pos_number'];
    hip_joint_lim = [-1 1];
    knee_joint_lim = [-1 1];
    %original angle information
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Compensated_knee_joint_position),compute_joint_angle(standard_vec_hip_knee, Compensated_knee_joint_position, Ankle_mean)];
    % normalized hip and knee angle -1 to 1
    hip_joint_angle_ori_normalized = 2 * (hip_joint_angle_ori(:,1) - min(hip_joint_angle_ori(:,1))) / (max(hip_joint_angle_ori(:,1)) - min(hip_joint_angle_ori(:,1))) - 1;
    knee_joint_angle_ori_normalized = 2 * (knee_joint_angle_ori(:,1) - min(knee_joint_angle_ori(:,1))) / (max(knee_joint_angle_ori(:,1)) - min(knee_joint_angle_ori(:,1))) - 1;
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
    hip_joint_angle_ori = [hip_joint_angle_ori_normalized,hip_joint_angle_ori(:,2)];
    knee_joint_angle_ori = [knee_joint_angle_ori_normalized,knee_joint_angle_ori(:,2)];

elseif strcmp(angle_definition, 'diff_from_standard')
    hip_joint_angle = compute_joint_angle(H_bone_mean, hip_mean, Knee_mean_new);
    knee_joint_angle = compute_joint_angle(hip_mean, Knee_mean_new, Ankle_mean);
    hip_joint_angle_stardard = compute_joint_angle(H_bone_mean, hip_mean, knee_mean_control);
    knee_joint_angle_stardard = compute_joint_angle(hip_mean, knee_mean_control, ankle_mean_control);
    hip_joint_angle_ori = [hip_joint_angle-hip_joint_angle_stardard,pos_number'];
    knee_joint_angle_ori = [knee_joint_angle-knee_joint_angle_stardard,pos_number'];
    hip_joint_lim = [-50 15];
    knee_joint_lim = [-85 5];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);

elseif strcmp(angle_definition, 'abs_by_horizontal') 
    abs_angle_standard = hip_mean + [-50, 0, 0];
    abs_angle_standard_vec = abs_angle_standard - hip_mean;
    abs_angle_standard_end_point   = Knee_mean_new + abs_angle_standard_vec;
    hip_joint_angle = compute_joint_angle(abs_angle_standard, hip_mean, Knee_mean_new);
    knee_joint_angle = compute_joint_angle(abs_angle_standard_end_point, Ankle_mean, Knee_mean_new);
    idx_abs_knee = Knee_mean_new(:,3) < Ankle_mean(:,3);
    knee_joint_angle(idx_abs_knee)  = -abs(knee_joint_angle(idx_abs_knee));
    knee_joint_angle(~idx_abs_knee) =  abs(knee_joint_angle(~idx_abs_knee)); 
    hip_joint_angle_ori = [hip_joint_angle,pos_number'];
    knee_joint_angle_ori = [knee_joint_angle,pos_number'];
    hip_joint_lim = [30 105];
    knee_joint_lim = [-10 25];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);

else 
    hip_joint_angle = compute_joint_angle(H_bone_mean, hip_mean, Knee_mean_new);
    knee_joint_angle = compute_joint_angle(hip_mean, Knee_mean_new, Ankle_mean);
    hip_joint_angle_ori = [hip_joint_angle,pos_number'];
    knee_joint_angle_ori = [knee_joint_angle,pos_number'];
    hip_joint_lim = [95 155];
    knee_joint_lim = [55 145];
    angle_related_folder =createNamedFolder(angle_folder,  'normal');
end


%% ROM analysis
%hip joint ROM
hip_joint_angle_gonios = compute_joint_angle(H_bone_mean, hip_mean, Knee_mean_new);
knee_joint_angle_gonios = compute_joint_angle(hip_mean, Knee_mean_new, Ankle_mean);
gonios_hip_and_knee = [hip_joint_angle_gonios,knee_joint_angle_gonios];
Hip_max_of_ginios_rad_by_article = 164;
Hip_min_of_ginios_rad_by_article = 32;
hip_flexion_max_by_article = 180-Hip_min_of_ginios_rad_by_article;
hip_extension_max_by_article = 180-Hip_max_of_ginios_rad_by_article;
Hip_range_prrcentage = (max(hip_joint_angle_gonios)-min(hip_joint_angle_gonios))/(Hip_max_of_ginios_rad_by_article-Hip_min_of_ginios_rad_by_article);
Hip_range_of_ginios_by_article = Hip_max_of_ginios_rad_by_article-Hip_min_of_ginios_rad_by_article;

%Knee joint ROM
Knee_max_of_ginios_rad_by_article = 166;
Knee_min_of_ginios_rad_by_article = 22;
knee_flexion_max_by_article = 180-Knee_min_of_ginios_rad_by_article;
knee_extension_max_by_article = 180-Knee_max_of_ginios_rad_by_article;
Knee_range_of_ginios_by_article = Knee_max_of_ginios_rad_by_article-Knee_min_of_ginios_rad_by_article;
Knee_range_prrcentage = (max(knee_joint_angle_gonios)-min(knee_joint_angle_gonios))/(Knee_max_of_ginios_rad_by_article-Knee_min_of_ginios_rad_by_article);


%% データの取得（1列目: X, 2列目: Y）----------------------------------------------------
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);

% 点数（＝16と仮定）
nPoints = length(X);

% カラーマップ（jetの16色）
fullJet = turbo(256);
idx = round(linspace(1,256,16));
colors = fullJet(idx,:);
cmap = colors;

figure;
hold on;

for i = 1:nPoints
    % マーカーサイズをさらに大きく（例: 150）
    scatter(X(i), Y(i), 200, cmap(i,:), 'filled');

    % ラベルをY方向に少し上にずらして表示
    text(X(i), Y(i) + 2.5, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
end

xlabel('Hip joint angle [degree]', 'FontSize', 12);
ylabel('Knee joint angle [degree]', 'FontSize', 12);



ax = gca;  % 現在の軸を取得
ax.FontSize = 20;       % 目盛りの文字サイズを大きく
ax.FontWeight = 'bold'; % 目盛りの文字を太字に

axis equal;
grid on;
xlim([20 100])
ylim([40 130])
if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    xlim([20 120])
    ylim([50 140])
end

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
if strcmp(angle_definition, 'relative_normalized_centering_model_error_evaluation')
      tifFileName = fullfile(angle_related_folder, 'Recorded_angle.tif');
elseif strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    tifFileName = fullfile(angle_related_folder, 'Recorded_angle.tif');
else
    tifFileName = fullfile(experiment3_folder, 'Recorded_angle.tif');
end
print(gcf, tifFileName, '-dtiff', '-r300');

 % === Figureサイズ（A4正方）===
target_width  = 30;   % cm
target_height = 30;   % cm

set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);
 % === 保存 ===
if strcmp(angle_definition, 'relative_normalized_centering_model_error_evaluation')
    baseName = fullfile(angle_related_folder, 'Recorded_angle_CatA');
elseif strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    baseName = fullfile(angle_related_folder, 'Recorded_angle_knee_position_compemsation_CatA');
else
    baseName = fullfile(experiment3_folder, 'Recorded_angle_CatA');
end
    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');


%%  plot hindlimb xy compensation with ideal ROM
figure;
hold on;
grid on;
axis equal;
xlabel('X [mm]'); 
ylabel('Y [mm]');  
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);


for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Compensated_knee_joint_position(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    % 線
    plot(coords(:,1), coords(:,3), ':', 'Color', colors(i,:), 'LineWidth', 2);

    % 足首マーカー
    plot(coords(1,1), coords(1,3), 'o', ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip bone marker
    plot(Hbone(1,1), Hbone(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

    % Hip marker
    plot(hip(1,1), hip(1,3), 'o', ...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor', [0 0 0], ...
        'MarkerSize', 8, ...
        'LineWidth', 2);

   
end


% ===== 2-link ROM workspace =====

% hipを原点にする
v = H_bone_mean - hip_mean;

vx = v(1);
vz = v(3);   % あなたは X-Z 平面

theta0 = atan2(vz, vx);   % 現在の基準直線の角度
theta0 = theta0 - pi;
theta0_deg = rad2deg(theta0);
disp(theta0_deg)


% ---- リンク長（既にある変数を使う） ----
L1 = hip_knee_link_length_actual;
L2 = knee_ankle_link_length_actual;

% ---- 角度範囲（degree → rad）----
hip_min  = deg2rad(hip_extension_max_by_article);
hip_max  = deg2rad(hip_flexion_max_by_article);

knee_min = deg2rad(knee_extension_max_by_article);
knee_max = deg2rad(knee_flexion_max_by_article);

% ---- 角度グリッド ----
nGrid = 200;
hip_range  = linspace(hip_min, hip_max, nGrid);
knee_range = linspace(knee_min, knee_max, nGrid);

[HIP, KNEE] = meshgrid(hip_range, knee_range);

% ---- 足首位置計算 ----
X = L1*cos(-HIP+theta0) + L2*cos(-HIP + KNEE+theta0);
Y = L1*sin(-HIP+theta0) + L2*sin(-HIP + KNEE+theta0);

% ---- 原点をhip基準に合わせる ----
% あなたの図は (x,z) を使っているので z方向をYに対応
X = X;
Z = Y;

% ===== Correct workspace boundary (Angle-boundary method) =====

nCurve = 400;

hip_vec  = linspace(hip_min, hip_max, nCurve);
knee_vec = linspace(knee_min, knee_max, nCurve);

% ---- 1) hip = hip_min ----
HIP1  = hip_min * ones(size(knee_vec));
KNEE1 = knee_vec;

X1 = L1*cos(-HIP1+theta0) + L2*cos(-HIP1 + KNEE1 + theta0);
Y1 = L1*sin(-HIP1+theta0) + L2*sin(-HIP1 + KNEE1 + theta0);


% ---- 2) knee = knee_max ----
HIP2  = hip_vec;
KNEE2 = knee_max * ones(size(hip_vec));

X2 = L1*cos(-HIP2+theta0) + L2*cos(-HIP2 + KNEE2 + theta0);
Y2 = L1*sin(-HIP2+theta0) + L2*sin(-HIP2 + KNEE2 + theta0);

% ---- 3) hip = hip_max ----
HIP3  = hip_max * ones(size(knee_vec));
KNEE3 = fliplr(knee_vec);

X3 = L1*cos(-HIP3+theta0) + L2*cos(-HIP3 + KNEE3 + theta0);
Y3 = L1*sin(-HIP3+theta0) + L2*sin(-HIP3 + KNEE3 + theta0);

% ---- 4) knee = knee_min ----
HIP4  = fliplr(hip_vec);
KNEE4 = knee_min * ones(size(hip_vec));

X4 = L1*cos(-HIP4+theta0) + L2*cos(-HIP4 + KNEE4 + theta0);
Y4 = L1*sin(-HIP4+theta0) + L2*sin(-HIP4 + KNEE4 + theta0);

% ---- 全境界を連結 ----
Xb = [X1 X2 X3 X4];
Yb = [Y1 Y2 Y3 Y4];

% ---- パッチ描画 ----
patch(Xb, Yb, [0.8 0.8 0.8], ...
    'EdgeColor','none', ...
    'FaceAlpha',0.4);

%{
% ===== 4 corner link postures =====

corner_angles = [
    hip_min  knee_min;
    hip_min  knee_max;
    hip_max  knee_min;
    hip_max  knee_max
];

for i = 1:4
    
    th1 = corner_angles(i,1);
    th2 = corner_angles(i,2);
    
    % ---- 関節位置（workspace式と完全一致）----
    hip_pt   = [0; 0];
    
    knee_pt  = [L1*cos(-th1+theta0); 
                L1*sin(-th1+theta0)];
    
    ankle_pt = [L1*cos(-th1+theta0) + L2*cos(-th1+th2+theta0); ...
                L1*sin(-th1+theta0) + L2*sin(-th1+th2+theta0)];
    

    % ---- プロット ----
    plot([hip_pt(1) knee_pt(1)], ...
         [hip_pt(2) knee_pt(2)], ...
         'k', 'LineWidth', 2);
     
    plot([knee_pt(1) ankle_pt(1)], ...
         [knee_pt(2) ankle_pt(2)], ...
         'k', 'LineWidth', 2);
     
    plot(hip_pt(1), hip_pt(2), 'ko', 'MarkerFaceColor','k');
    plot(knee_pt(1), knee_pt(2), 'ko', 'MarkerFaceColor','k');
    plot(ankle_pt(1), ankle_pt(2), 'ko', 'MarkerFaceColor','k');
end
%}




for i = 1:16
    offset = hip_mean;  

    paw   = Paw_mean(i,:)   - offset;
    ankle = Ankle_mean(i,:) - offset;
    knee  = Compensated_knee_joint_position(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];

    if i == 6
        % Pos6だけ座標を少し下げる
        text(coords(1,1)-9, coords(1,3)-11, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 10, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    else
        % それ以外のPosは普通
        text(coords(1,1)-9, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 10, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end
 % それ以外のPosは普通
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% それ以外のPosは普通
text(hip(1,1)+6, hip(1,3)-3, 'Hip joint Position', ...
            'FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-220 150])
ylim([-220 30])
% --- 軸設定 --

set(gca, 'FontSize', 20, 'FontName', 'Arial', 'FontWeight', 'bold');
ax = gca;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
box off;

% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向き（内側なし）
ax.TickLength = [0.02 0.02];     % 主メモリと小メモリの長さ
ax.XMinorTick = 'on';            % X軸 小目盛ON
ax.YMinorTick = 'on';            % Y軸 小目盛ON
ax.LineWidth = 2;                % 軸線を太く

% === サイズを指定 (例: 12cm x 12cm) ===
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, 10, 10]);

% 保存 (高解像度)
pdfFileName = fullfile(experiment3_folder, ['Recorded_posture_xy_for' ...
    '_fig_Cat A_compensation_position_with_ROM.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');

%% compare hip joint angle and knee joint angle

hip_knee_joint_angle_original_definition_motion_data = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean_new),compute_joint_angle(Knee_mean_new - (hip_mean - Knee_mean_new), Knee_mean_new, Ankle_mean)];
hip_knee_joint_angle_original_definition_compensated_data = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Compensated_knee_joint_position),compute_joint_angle(Compensated_knee_joint_position - (hip_mean - Compensated_knee_joint_position), Compensated_knee_joint_position, Ankle_mean)];


% 角度差
angle_diff = hip_knee_joint_angle_original_definition_compensated_data ...
           - hip_knee_joint_angle_original_definition_motion_data;

% 絶対値差
abs_angle_diff = abs(angle_diff);
abs_angle_diff(9,:) = NaN;

% 姿勢番号
pos_idx = 1:size(abs_angle_diff,1);

% ===== フォント設定 =====
title_fs = 16;
label_fs = 14;
tick_fs  = 12;
text_fs  = 14;

figure('Color','w');

% --- Hip angle ---
subplot(2,1,1);
bar(pos_idx, abs_angle_diff(:,1), 'FaceColor', [0.6 0.6 0.6]);
hold on;

mean_hip = mean(abs_angle_diff(:,1), 'omitnan');
sd_hip   = std(abs_angle_diff(:,1), 'omitnan');

% SDパッチ
patch([0.5 max(pos_idx)+0.5 max(pos_idx)+0.5 0.5], ...
      [mean_hip-sd_hip mean_hip-sd_hip mean_hip+sd_hip mean_hip+sd_hip], ...
      'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');

% 平均線
plot([0.5 max(pos_idx)+0.5], [mean_hip mean_hip], ...
     'r', 'LineWidth', 3);

% テキスト
text(max(pos_idx)*0.65, mean_hip + sd_hip*1.3, ...
    sprintf('Mean ± SD = %.2f ± %.2f°', mean_hip, sd_hip), ...
    'Color','r','FontSize',text_fs,'FontWeight','bold');

ylabel('Hip angle error (deg)', ...
       'FontSize', label_fs, 'FontWeight','bold');

title('Absolute joint angle difference after compensation', ...
      'FontSize', title_fs, 'FontWeight','bold');

xticks(pos_idx);
xticklabels(compose('Pos%d',pos_idx));
set(gca, 'FontSize', tick_fs, 'LineWidth',1.2, 'FontWeight','bold');
grid on;


% --- Knee angle ---
subplot(2,1,2);
bar(pos_idx, abs_angle_diff(:,2), 'FaceColor', [0.6 0.6 0.6]);
hold on;

mean_knee = mean(abs_angle_diff(:,2), 'omitnan');
sd_knee   = std(abs_angle_diff(:,2), 'omitnan');

patch([0.5 max(pos_idx)+0.5 max(pos_idx)+0.5 0.5], ...
      [mean_knee-sd_knee mean_knee-sd_knee mean_knee+sd_knee mean_knee+sd_knee], ...
      'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');

plot([0.5 max(pos_idx)+0.5], [mean_knee mean_knee], ...
     'r', 'LineWidth', 3);

text(max(pos_idx)*0.65, mean_knee + sd_knee*1.3, ...
    sprintf('Mean ± SD = %.2f ± %.2f°', mean_knee, sd_knee), ...
    'Color','r','FontSize',text_fs,'FontWeight','bold');

ylabel('Knee angle error (deg)', ...
       'FontSize', label_fs, 'FontWeight','bold');

xlabel('Posture', ...
       'FontSize', label_fs, 'FontWeight','bold');

xticks(pos_idx);
xticklabels(compose('Pos%d',pos_idx));
set(gca, 'FontSize', tick_fs, 'LineWidth',1.2, 'FontWeight','bold');
grid on;

% 図サイズ調整
print(gcf, tifFileName, '-dtiff', '-r300');

 % === Figureサイズ（A4正方）===
target_width  = 60;   % cm
target_height = 30;   % cm

set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);
 % === 保存 ===
baseName = fullfile(experiment3_folder, 'Compare_motion_data_and_actual_model_data');

print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
print(gcf, [baseName '.png'], '-dpng', '-r300');



%% calculate 2 joint parameter
% calculate link length
vec_HipToAnkle = hip_mean - Ankle_mean;

% ユークリッド距離（行ごとにノルム）
link_HipToAnkle = sqrt(sum(vec_HipToAnkle.^2, 2));   % Ankle Hip
Leg_length = [link_HipToAnkle,pos_number'];

orientation_standard = hip_mean + [50, 0, 0];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];
orientation_lim = [25 105];


figure;
hold on;
grid on;
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Plot of Paw → Ankle → Knee (colored per row)');
for i = 1:16
    % 各点の座標（1×3ベクトル）
    ankle = Ankle_mean(i,:);
    
    % 3点を結ぶ線分の座標行列（3×3）
    coords = [ankle; hip_mean;orientation_standard];
    
    % プロット（色を行ごとに変える）
    if i == 9
        plot3(coords(:,1), coords(:,2), coords(:,3), 'o-', 'Color', [1 0 0.5], ...
        'LineWidth', 2);hold on;
    else
            plot3(coords(:,1), coords(:,2), coords(:,3), ':', 'Color', colors(i,:), ...
        'LineWidth', 2);hold on;
    end
end

view(3);  % 3次元視点に切り替え
hold off;
sort_hip_ankle_ori = sortrows(Theta_hip_to_ankle_ori, 1);

%% plot all orientation and length

% 点数（＝16と仮定）
nPoints = length(X);

% カラーマップ（jetの16色）
cmap = colors;

figure;
hold on;

for i = 1:nPoints
    % マーカーサイズをさらに大きく（例: 150）
    scatter(Theta_hip_to_ankle_ori(i), Leg_length(i), 200, cmap(i,:), 'filled');

    % ラベルをY方向に少し上にずらして表示
    text(Theta_hip_to_ankle_ori(i), Leg_length(i) + 4, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
end

xlabel('Orientation [degree]', 'FontSize', 12);
ylabel('length [mm]', 'FontSize', 12);

ax = gca;  % 現在の軸を取得
ax.FontSize = 20;       % 目盛りの文字サイズを大きく
ax.FontWeight = 'bold'; % 目盛りの文字を太字に

grid on;
xlim([20 110])
ylim([70 200])

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_folder, 'Recorded_angle_orientation_and_length.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

% === Figureサイズ（A4正方）===
target_width  = 30;   % cm
target_height = 30;   % cm

set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);

    % === 保存 ===
    baseName = fullfile(experiment3_folder, 'Recorded_angle_orientation_and_length_CatA');

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');


%% line up for fig
MFR_sep_pos = cell(1,length(newSpkTime));
MFR_sep_tri_pos = zeros(size(MFR_sep{1,1},2),length(MFR_sep));

for n = 1:length(newSpkTime)
    for i = 1:length(MFR_sep_tri_pos)
        MFR_sep_tri_pos(:,i) = (MFR_sep{1,i}(n,:))';
    end
    MFR_sep_pos{1,n} = MFR_sep_tri_pos;
end

%% zscore
Firing_rate_sep_tri_pos_zscore = cell(size(Ex3_firing_rate_sep));
Ex3_firing_rate_sep_each_trial = cell(size(Ex3_firing_rate_sep,1),1);
Firing_rate_sep_zscore_each_trial = cell(size(Firing_rate_sep_tri_pos_zscore,1),1);
for tr = 1:size(Ex3_firing_rate_sep,1)
    for i = 1:length(Ex3_firing_rate_sep)
        if i ==1
            Ex3_firing_rate_sep_each = Ex3_firing_rate_sep{tr,i};
        else
            Ex3_firing_rate_sep_each = [Ex3_firing_rate_sep_each,Ex3_firing_rate_sep{tr,i}];
        end
    end
    Ex3_firing_rate_sep_each_trial{tr} = Ex3_firing_rate_sep_each;
    Ex3_firing_rate_sep_each_zscore = zscore(Ex3_firing_rate_sep_each,0,2);
    Firing_rate_sep_zscore_each_trial{tr} = Ex3_firing_rate_sep_each_zscore;

    for ii = 1:length(Ex3_firing_rate_sep)
        Firing_rate_sep_tri_pos_zscore{tr,ii} = Ex3_firing_rate_sep_each_zscore(:,(length(time_window_each_Ex3_sep)-1)*(ii-1)+1:ii*(length(time_window_each_Ex3_sep)-1));
    end
end

MFR_sep_zscore = cell(size(Firing_rate_sep_tri_pos_zscore));
for col = 1:length(Firing_rate_sep_tri_pos_zscore)
    for low = 1:size(Firing_rate_sep_tri_pos_zscore,1)
        MFR_sep_zscore{low,col} = mean(Firing_rate_sep_tri_pos_zscore{low,col},2);
    end
end

%line up for fig
MFR_sep_zscore_pos = cell(1,length(newSpkTime));
for n = 1:length(newSpkTime)
    for pos = 1:length(MFR_sep_tri_pos)
        for trial = 1:size(MFR_sep_zscore,1)
            MFR_sep_zscore_pos{1,n}(trial,pos) = MFR_sep_zscore{trial,pos}(n,1);
        end
    end
end

MFR_sep_zscore_average_trial = zeros(length(Ex3_firing_rate_sep), length(newSpkTime));
for k = 1:length(newSpkTime)
    MFR_sep_zscore_average_trial(:,k) = mean(MFR_sep_zscore_pos{1,k}, 1);  % 各ニューロンに対応
end





%% plot mean firing rate




% =========================
% 基本情報
% =========================
% =========================
% 保存フォルダ
% =========================
save_base_folder = fullfile(experiment3_static_folder_select, 'Mean_firing_rate');
if ~exist(save_base_folder,'dir')
    mkdir(save_base_folder);
end

% =========================
% カラーマップ設定
% =========================
nColors = 256;
cmap = jet(nColors);

dataMin = 0;
dataMax = 110;

mapFunc = @(val) (val/50) * 0.75 .* (val<=50) + ...
                 (0.75 + (val-50)/(dataMax-50)*0.25) .* (val>50);

customRange = mapFunc(linspace(dataMin, dataMax, nColors));
newmyCmap_mean_firing_rate = interp1(linspace(0,1,nColors), cmap, customRange);

% =========================
% Neuron × Posture 行列
% =========================
nNeuron  = length(MFR_sep_pos);  % 72
nPosture = 16;

FR_mat = nan(nNeuron, nPosture);

for neuron_idx = 1:nNeuron
    fr_trial_pos = MFR_sep_pos{1, neuron_idx}; % 5×16
    FR_mat(neuron_idx,:) = mean(fr_trial_pos, 1, 'omitnan');
end

% =========================
% プロット
% =========================
figure;
set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);  % ← 全画面

imagesc(FR_mat);
axis tight;

colormap(newmyCmap_mean_firing_rate);
cb = colorbar;
cb.FontSize  = 16;
cb.FontWeight = 'bold';

% =========================
% 軸・文字設定（全部太字）
% =========================
xlabel('Posture','FontSize',20,'FontWeight','bold');
ylabel('Neuron','FontSize',20,'FontWeight','bold');

set(gca,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('Pos%d',x),1:nPosture,'UniformOutput',false),...
    'FontSize',18,...
    'FontWeight','bold',...
    'LineWidth',2,...
    'YDir','normal');

title('Mean firing rate (5 trials average)', ...
    'FontSize',22,'FontWeight','bold');

% =========================
% 保存
% =========================
save_name = fullfile(save_base_folder, 'Mean_firing_rate_allNeurons.png');
print(gcf, save_name, '-dpng', '-r300');
%% line up X axia
% =========================
% Neuron × Posture 行列作成
% =========================
nNeuron  = length(MFR_sep_pos);  % 72
nPosture = 16;

FR_mat = nan(nNeuron, nPosture);

for neuron_idx = 1:nNeuron
    fr_trial_pos = MFR_sep_pos{1, neuron_idx};  % 5×16
    FR_mat(neuron_idx,:) = mean(fr_trial_pos, 1, 'omitnan');
end

% =========================
% 姿勢の並び替え（Ankle X：左が小、右が大）
% =========================
Ankle_Xaxis = Ankle_mean(:,1) - offset(1,1);   % 16×1

[~, sortIdx] = sort(Ankle_Xaxis, 'ascend');    % ← 左が小

FR_mat_sorted = FR_mat(:, sortIdx);

FR = FR_mat_sorted;   % 72 × 16

%sort index
nNeuron = size(FR,1);
group_mean = zeros(nNeuron,4);

% 4姿勢ごとの平均
for g = 1:4
    idx = (g-1)*4 + (1:4);
    group_mean(:,g) = mean(FR(:,idx), 2, 'omitnan');
end

x = (1:4)';   % グループ番号
slope = zeros(nNeuron,1);

for i = 1:nNeuron
    p = polyfit(x, group_mean(i,:)', 1);
    slope(i) = p(1);
end


% 勾配順に並び替え
[~, idx] = sort(slope, 'descend');
FR_sorted = FR(idx,:);




% =========================
% プロット
% =========================
figure;
set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);  % 全画面

imagesc(FR_sorted);
axis tight;

colormap(newmyCmap_mean_firing_rate);

cb = colorbar;
cb.FontSize   = 18;
cb.FontWeight = 'bold';
cb.Label.FontSize = 18;
cb.Label.FontWeight = 'bold';

% =========================
% 軸・文字設定（全部太字）
% =========================
xlabel('Recording Position (sorted by X axis of ankle joint position)','FontSize',22,'FontWeight','bold');
ylabel('Single neuron (sorted by slope of mean firing rate)','FontSize',22,'FontWeight','bold');

ax = gca;
set(ax,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('Pos-%d',x), sortIdx, 'UniformOutput', false),...
    'YTick',[],...                 % ← 縦軸メモリ削除
    'FontSize',18,...
    'FontWeight','bold',...
    'LineWidth',2,...
    'YDir','normal',...
    'TickDir','out',...            % ← 目盛りを外向きに
    'Box','off');                  % ← 上右の枠を消す


% =========================
% 保存
% =========================
save_name = fullfile(save_base_folder, ...
    'Mean_firing_rate_allNeurons_sortedBy_AnkleX.png');

print(gcf, save_name, '-dpng', '-r300');

%% line up Y axia
% =========================
% Neuron × Posture 行列作成
% =========================
nNeuron  = length(MFR_sep_pos);  % 72
nPosture = 16;

FR_mat = nan(nNeuron, nPosture);

for neuron_idx = 1:nNeuron
    fr_trial_pos = MFR_sep_pos{1, neuron_idx};  % 5×16
    FR_mat(neuron_idx,:) = mean(fr_trial_pos, 1, 'omitnan');
end

% =========================
% 姿勢の並び替え（Ankle X：左が小、右が大）
% =========================
Ankle_Yaxis = Ankle_mean(:,3) - offset(1,3);   % 16×1

[~, sortIdx] = sort(Ankle_Yaxis, 'descend');    % ← 左が小

FR_mat_sorted = FR_mat(:, sortIdx);


%sort index

FR = FR_mat_sorted;   % 72 × 16

nNeuron = size(FR,1);
group_mean = zeros(nNeuron,4);

% 4姿勢ごとの平均
for g = 1:4
    idx = (g-1)*4 + (1:4);
    group_mean(:,g) = mean(FR(:,idx), 2, 'omitnan');
end

x = (1:4)';   % グループ番号
slope = zeros(nNeuron,1);

for i = 1:nNeuron
    p = polyfit(x, group_mean(i,:)', 1);
    slope(i) = p(1);
end


% 勾配順に並び替え
[~, idx] = sort(slope, 'ascend');
FR_sorted = FR(idx,:);


% =========================
% プロット
% =========================
figure;
set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);  % 全画面

imagesc(FR_sorted);
axis tight;

colormap(newmyCmap_mean_firing_rate);

cb = colorbar;
cb.FontSize   = 18;
cb.FontWeight = 'bold';
cb.Label.FontSize = 18;
cb.Label.FontWeight = 'bold';

% =========================
% 軸・文字設定（全部太字）
% =========================
xlabel('Recording Position (sorted by Y axis of ankle joint position)','FontSize',22,'FontWeight','bold');
ylabel('Single neuron (sorted by slope of mean firing rate)','FontSize',22,'FontWeight','bold');

ax = gca;
set(ax,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('Pos-%d',x), sortIdx, 'UniformOutput', false),...
    'YTick',[],...                 % ← 縦軸メモリ削除
    'FontSize',18,...
    'FontWeight','bold',...
    'LineWidth',2,...
    'YDir','normal',...
    'TickDir','out',...            % ← 目盛りを外向きに
    'Box','off');                  % ← 上右の枠を消す


% =========================
% 保存
% =========================
save_name = fullfile(save_base_folder, ...
    'Mean_firing_rate_allNeurons_sortedBy_AnkleY.png');

print(gcf, save_name, '-dpng', '-r300');


%% Plot mean firing rate for all neuron

% =========================
% 保存フォルダ指定
% =========================
save_base_folder = fullfile(experiment3_folder, 'FR_Map_Ankle');
if ~exist(save_base_folder,'dir')
    mkdir(save_base_folder);
end

% --- 座標 ---
Ankle_Xaxis = Ankle_mean(:,1) - offset(1,1);   
Ankle_Yaxis = Ankle_mean(:,3) - offset(1,3);

for neuron_idx = 1:72

    figure('Units','centimeters','Position',[5 5 18 16]);
    hold on;
    axis equal;

    xlabel('X [mm]','FontWeight','bold'); 
    ylabel('Y [mm]','FontWeight','bold');  

    xlim([-50 150])
    ylim([-200 -20])

    % =========================
    % データ
    % =========================
    firing_rate_mean = mean(MFR_sep_pos{1, neuron_idx}, 1);

    % ===== カラースケール =====
    max_val = max(firing_rate_mean, [], 'all');
    if max_val > 100
        ylim_fig = [0 120];
    elseif max_val > 80
        ylim_fig = [0 100];
    elseif max_val > 40
        ylim_fig = [0 80];
    elseif max_val > 20
        ylim_fig = [0 40];
    elseif max_val > 5
        ylim_fig = [0 20];
    elseif max_val > 1
        ylim_fig = [0 5];
    else
        ylim_fig = [0 1];
    end

    % =========================
    % プロット
    % =========================
    scatter(Ankle_Xaxis, Ankle_Yaxis, 80, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');
    colormap(jet);
    caxis(ylim_fig);
    colorbar('eastoutside');

    title(sprintf('Neuron %d  (CH %d)', ...
        neuron_idx, newSpkCH(neuron_idx)), ...
        'FontWeight','bold');

    % =========================
    % 姿勢ラベル
    % =========================
    for j = 1:length(Ankle_Xaxis)
        if j == 3
            text(Ankle_Xaxis(j), Ankle_Yaxis(j) + 6, ...
            ['Pos', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'Color','black');
        else
        text(Ankle_Xaxis(j), Ankle_Yaxis(j) - 5, ...
            ['Pos', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'Color','black');
        end

    
    end

    % 軸設定
    set(gca,'FontWeight','bold','LineWidth',1.5)

    % =========================
    % 保存（PNG）
    % =========================
    png_name = sprintf('Neuron_%02d_Ankle_FRmap.png', neuron_idx);
    print(gcf, fullfile(save_base_folder, png_name), '-dpng', '-r300');
    close(gcf)

end




%% Figure 4
% =========================
% 保存フォルダ指定
% =========================
save_base_folder = fullfile(experiment3_folder, 'FR_Map_Ankle');
if ~exist(save_base_folder,'dir')
    mkdir(save_base_folder);
end

% You need to MatPlotLib "Perceptually Uniform" Colormaps tool box
% --- 座標 ---
Ankle_Xaxis = Ankle_mean(:,1) - offset(1,1);   
Ankle_Yaxis = Ankle_mean(:,3) - offset(1,3);

% =========================
% 指定ニューロン
% =========================
neuron_pair = [53 21];   % ←ここに表示したい2つを指定


figure('Units','centimeters','Position',[5 5 17 8.5]);

tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
for k = 1:2
    
    neuron_idx = neuron_pair(k);
    
    nexttile
    hold on;
    axis equal;

   
    % ===== 軸ラベル =====
    xlabel('X [mm]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8); 
    
    ylabel('Y [mm]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8);  

    xlim([-50 150])
    ylim([-200 -20])
    xticks(-50:50:150);
    yticks(-200:50:-20);

    % =========================
    % データ
    % =========================
    firing_rate_mean = mean(MFR_sep_pos{1, neuron_idx}, 1);

    % ===== カラースケール =====
    max_val = max(firing_rate_mean, [], 'all');
    if max_val > 100
        ylim_fig = [0 120];
    elseif max_val > 80
        ylim_fig = [0 100];
    elseif max_val > 60
        ylim_fig = [0 80];
    elseif max_val > 40
        ylim_fig = [0 60];
    elseif max_val > 20
        ylim_fig = [0 40];
    elseif max_val > 5
        ylim_fig = [0 20];
    elseif max_val > 1
        ylim_fig = [0 5];
    else
        ylim_fig = [0 1];
    end

    % =========================
    % プロット
    % =========================
    scatter(Ankle_Xaxis, Ankle_Yaxis, 20, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');

    colormap(viridis);
    caxis(ylim_fig);
  
    % ===== カラーバー =====
    cb = colorbar;
    set(cb, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8)
    % ===== タイトル =====
    title(sprintf('Cat A Neuron #%d', neuron_idx), ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8);
    
    % =========================
    % 姿勢ラベル
    % =========================
    for j = 1:length(Ankle_Xaxis)
        if j == 3
            text(Ankle_Xaxis(j)+4, Ankle_Yaxis(j) + 7, ...
                ['Pos-', num2str(j)], ...
                'FontWeight','bold', ...
                'FontSize', 6, ...
                'HorizontalAlignment','center', ...
                'FontName','Arial');
        else
            text(Ankle_Xaxis(j)+4, Ankle_Yaxis(j) - 6, ...
                ['Pos-', num2str(j)], ...
                'FontWeight','bold', ...
                'FontSize', 6, ...
                'HorizontalAlignment','center', ...
                'FontName','Arial');
        end
    end

    % ===== 軸目盛り =====
    set(gca, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8, ...
        'LineWidth',1.5)

end

print(gcf, fullfile(save_base_folder, ...
    'FR_Map_CatA_neuron21_53.emf'), ...
    '-dmeta', '-r600');


%% Figure 5
% =========================
% 基本設定
% =========================

% =========================
% color map setting
nColors = 256;
baseMap = viridis(nColors);

dataMax   = 110;
threshold = 50;

t = threshold / dataMax;

v = linspace(0,1,nColors);

customRange = zeros(size(v));

% --- 0–50Hz に85%割り当て ---
customRange(v <= t) = ...
    (v(v<=t)/t) * 0.85;

% --- 50–110Hz は非線形でなだらかに ---
gamma_high = 1.5;  % 1より大きいと終端集中を防ぐ

vh = (v(v>t)-t) / (1-t);
customRange(v > t) = ...
    0.85 + (vh.^gamma_high) * 0.15;

newCmap = interp1(linspace(0,1,nColors), baseMap, customRange);

% initial setting
nNeuron  = length(MFR_sep_pos);   % 72
nPosture = 16;

FR_mat = nan(nNeuron, nPosture);

for neuron_idx = 1:nNeuron
    fr_trial_pos = MFR_sep_pos{1, neuron_idx};  % 5×16
    FR_mat(neuron_idx,:) = mean(fr_trial_pos, 1, 'omitnan');
end

% ==========================================================
% Figure作成（横並び）
% ==========================================================
figure('Units','centimeters','Position',[5 5 17 15]);
set(gcf,'DefaultAxesFontName','Arial');
set(gcf,'DefaultTextFontName','Arial');
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

% =========================================================
% ① X-axis で並び替え（左）
% =========================================================
Ankle_Xaxis = Ankle_mean(:,1) - offset(1,1);
[~, sortIdx_X] = sort(Ankle_Xaxis,'ascend');

FR_X = FR_mat(:, sortIdx_X);

% ---- 勾配計算 ----
group_mean = zeros(nNeuron,4);
for g = 1:4
    idx = (g-1)*4 + (1:4);
    group_mean(:,g) = mean(FR_X(:,idx), 2, 'omitnan');
end

x = (1:4)';
slope = zeros(nNeuron,1);
for i = 1:nNeuron
    p = polyfit(x, group_mean(i,:)', 1);
    slope(i) = p(1);
end

[~, idx_sort] = sort(slope,'descend');
FR_X_sorted = FR_X(idx_sort,:);

% ---- プロット ----
nexttile;
imagesc(FR_X_sorted);
axis tight;
colormap(newCmap)
caxis([dataMin dataMax])
xlabel('Recording Position (Sorted by X axis)','FontSize',10,'FontWeight','bold');
ylabel('Single neuron','FontSize',10,'FontWeight','bold');

set(gca,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('%d',x), sortIdx_X, 'UniformOutput', false),...
    'XTickLabelRotation',0,...
    'YTick',[],...
    'FontWeight','bold',...
    'LineWidth',1.5,...
    'YDir','normal',...
    'TickDir','out',...
    'Box','off');


% =========================================================
% ② Y-axis で並び替え（右）
% =========================================================
Ankle_Yaxis = Ankle_mean(:,3) - offset(1,3);
[~, sortIdx_Y] = sort(Ankle_Yaxis,'ascend');

FR_Y = FR_mat(:, sortIdx_Y);

% ---- 勾配計算 ----
group_mean = zeros(nNeuron,4);
for g = 1:4
    idx = (g-1)*4 + (1:4);
    group_mean(:,g) = mean(FR_Y(:,idx), 2, 'omitnan');
end

slope = zeros(nNeuron,1);
for i = 1:nNeuron
    p = polyfit(x, group_mean(i,:)', 1);
    slope(i) = p(1);
end

[~, idx_sort] = sort(slope,'descend');
FR_Y_sorted = FR_Y(idx_sort,:);

% ---- プロット ----
nexttile;
imagesc(FR_Y_sorted);
axis tight;
colormap(newCmap)
caxis([dataMin dataMax])


cb2 = colorbar;
cb2.FontSize = 8;
cb2.FontWeight = 'bold';

xlabel('Recording Position (Sorted by Y-axis)','FontSize',10,'FontWeight','bold');

set(gca,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('%d',x), sortIdx_Y, 'UniformOutput', false),...
    'XTickLabelRotation',0,...
    'YTick',[],...
    'FontWeight','bold',...
    'LineWidth',1.5,...
    'YDir','normal',...
    'TickDir','out',...
    'Box','off');


% =========================================================
% 保存
% =========================================================
save_name = fullfile(save_base_folder, ...
    'Mean_firing_rate_allNeurons_sortedBy_AnkleXY.png');

save_name = fullfile(save_base_folder, ...
    'Mean_firing_rate_allNeurons_sortedBy_AnkleXY.emf');

print(gcf, save_name, '-dmeta', '-r600');



%% 1-way analysis of variance
% データをベクトル化（80×1）
Anova_1_way_p = zeros(length(newSpkCH),1);
All_multcompare_results = cell(length(newSpkCH),1);  % 各ニューロンの multcompare 結果
All_anova_stats = cell(length(newSpkCH),1);          % 各ニューロンの stats 構造体（state）

for i = 1:length(newSpkCH)
    data_vector = MFR_sep_pos{1,i}(:);  % 5×16 = 80個の平均発火頻度

    % 条件ラベル（16条件 × 各5トライアル）
    group_labels = repmat(1:16, 5, 1);
    group_labels = group_labels(:);

    % 一元配置分散分析（ANOVA）
    [p, ~, stats] = anova1(data_vector, group_labels, 'off');
    Anova_1_way_p(i,1) = p;

    % 多重比較と保存
    All_anova_stats{i} = stats;  % stats 構造体を保存
    All_multcompare_results{i} = multcompare(stats, 'display', 'off');  % 表示せずに保存
end
Significant_neuron_by_anova = find(Anova_1_way_p < 0.05);
Num_of_significant_neuron = length(Significant_neuron_by_anova);
disp(Num_of_significant_neuron)
%% lineup for pleferd neuron
experiment3_polor_plot_end_point_f = createNamedFolder(experiment3_static_folder_select, 'End_point');
experiment3_polor_plot_folder = createNamedFolder(experiment3_polor_plot_end_point_f, 'Polor_plot');

%line up matrix end point
Line_up_matrix_polar =[1 2 4 8 16 15 13 9];
large_posture_num = numel(Line_up_matrix_polar);

[MFR_sep_lineup_endP,MFR_sep_lineup_mean_endP,MFR_sep_lineup_z_endP,MFR_sep_lineup_z_mean_endP] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,Line_up_matrix_polar);

% line up
hip_joint_angle_sort = sortrows(hip_joint_angle_ori, 1);
knee_joint_angle_sort = sortrows(knee_joint_angle_ori, 1);
[MFR_sep_lineup_hip,MFR_sep_lineup_mean_hip,MFR_sep_lineup_z_hip,MFR_sep_lineup_z_mean_hip] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,hip_joint_angle_sort(:,2)');
[MFR_sep_lineup_knee,MFR_sep_lineup_mean_knee,MFR_sep_lineup_z_knee,MFR_sep_lineup_z_mean_knee] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,knee_joint_angle_sort(:,2)');

leg_orientation_sort = sortrows(Theta_hip_to_ankle_ori, 1);
leg_length_sort = sortrows(Leg_length, 1);
[MFR_sep_lineup_leg_orientation,MFR_sep_lineup_mean_leg_orientation,MFR_sep_lineup_z_leg_orientation,MFR_sep_lineup_z_mean_leg_orientation] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,leg_orientation_sort(:,2)');
[MFR_sep_lineup_leg_length,MFR_sep_lineup_mean_leg_length,MFR_sep_lineup_z_leg_length,MFR_sep_lineup_z_mean_leg_length] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,leg_length_sort(:,2)');


%% plot angle related 
num_neurons = length(newSpkCH);  % 72
neurons_per_fig = 12;            % 12個ずつ表示
num_figs = ceil(num_neurons / neurons_per_fig);  % 6ページ


%{
for ThR = 1:1
threshold_R = 0.4*ThR;
for thp = 1:3
if thp == 1
p_thresh = 0.05;
elseif thp == 2 
p_thresh = 0.01;
else
p_thresh = 0.001;
end
%}
threshold_R = 0.4;
p_thresh = 0.001;

threshold_folder_name = sprintf('threshold_R_%02d_p_%03d', round(threshold_R*10), round(p_thresh*100));

threshold_folder = createNamedFolder(angle_related_folder, threshold_folder_name);

knee_angle_related_folder = createNamedFolder(threshold_folder, 'Knee_angle');
hip_angle_related_folder = createNamedFolder(threshold_folder, 'Hip_angle');
hip_angle_z = createNamedFolder(hip_angle_related_folder, 'normalizd_by_Z');
knee_angle_z = createNamedFolder(knee_angle_related_folder, 'normalizd_by_Z');
leg_orientation_related_folder = createNamedFolder(threshold_folder, 'Leg_orientation');
leg_length_related_folder = createNamedFolder(threshold_folder, 'Leg_length');
hip_and_knee_PCAfolder = createNamedFolder(threshold_folder, 'Hip_and_Knee_angle');
hip_and_knee_folder_cross = createNamedFolder(hip_and_knee_PCAfolder, 'cross');
hip_and_knee_folder_cross_centering = createNamedFolder(hip_and_knee_PCAfolder, 'cross_mean');
hip_and_knee_folder_plus = createNamedFolder(hip_and_knee_PCAfolder, 'plus');

leg_length_orientation_related_folder = createNamedFolder(threshold_folder, 'Leg_length_and_orientation');
leg_length_orientation_related_folder_cross = createNamedFolder(leg_length_orientation_related_folder, 'cross');
leg_length_orientation_related_folder_plus = createNamedFolder(leg_length_orientation_related_folder, 'plus');
Fig_name_leg_orientation = 'Leg orientation firingrate not normalized';
Fig_name_leg_length = 'Leg length firingrate not normalized';
Fig_name_knee_and_hip_plus = 'Knee angle and Hip angle plus firingrate not normalized';
Fig_name_knee_and_hip_cross = 'Knee angle and Hip angle interaction firingrate not normalized';
Fig_name_knee_and_hip_cross_centering = 'Knee angle and Hip angle interaction centering firingrate not normalized';
Fig_name_leg_and_orientation_length_cross = 'Leg length and orientation cross firingrate not normalized';
Fig_name_leg_and_orientation_length_plus = 'Leg length and orientation plus firingrate not normalized';

% recurrent model

nNeurons = length(newSpkCH);
Rsq_single_hip = zeros(nNeurons, 1);    % 単関節モデルのR²
Rsq_single_knee = zeros(nNeurons, 1);
Rsq_orientation = zeros(nNeurons, 1);
Rsq_length = zeros(nNeurons, 1);

p_joint_hip = zeros(nNeurons, 1);          % 股関節のp値
p_joint_knee = zeros(nNeurons, 1);          % 膝関節のp値
p_orientation = zeros(nNeurons, 1);
p_length = zeros(nNeurons, 1);

cofficient_hip = zeros(nNeurons, 2); 
cofficient_knee = zeros(nNeurons, 2); 
cofficient_orientation = zeros(nNeurons, 2); 
cofficient_length = zeros(nNeurons, 2); 

%plus kee and angle
Rsq_multi_hip_knee_inter_plus = zeros(nNeurons, 1);
p_multi_hip_knee_inter_plus = zeros(nNeurons, 2);  % 各係数のp値（intercept除く）
cofficient_multi_hip_knee_inter_plus = zeros(nNeurons, 3); 

%cross knee and angle
Rsq_multi_hip_knee_inter_cross = zeros(nNeurons, 1);
p_multi_hip_knee_inter_cross = zeros(nNeurons, 3);  % 各係数のp値（intercept除く）
cofficient_multi_hip_knee_inter_cross = zeros(nNeurons, 4); 

Rsq_multi_hip_knee_inter_cross_centering = zeros(nNeurons, 1);
p_multi_hip_knee_inter_cross_centering = zeros(nNeurons, 3);  % 各係数のp値（intercept除く）
cofficient_multi_hip_knee_inter_cross_centering = zeros(nNeurons, 4); 

%plus orientation and length
Rsq_multi_ori_len_inter_plus = zeros(nNeurons, 1);
p_multi_ori_len_inter_plus = zeros(nNeurons, 2);  % 各係数のp値（intercept除く）
cofficient_multi_ori_len_inter_plus = zeros(nNeurons, 3); % [intercept, ori, len, ori*len]

%cross orientation and length
Rsq_multi_ori_len_inter_cross = zeros(nNeurons, 1);
p_multi_ori_len_inter_cross = zeros(nNeurons, 3);  % 各係数のp値（intercept除く）
cofficient_multi_ori_len_inter_cross = zeros(nNeurons, 4); % [intercept, ori, len, ori*len]

for i = 1:nNeurons
    rates_mat = MFR_sep_pos{i}';  % 5×16
    firing_vec = [];
    hip_joint_angle_sort_for_analyze = [];
    knee_joint_angle_sort_for_analyze = [];
    orientation_sort_for_analyze = [];
    length_sort_for_analyze = [];
    %hip_joint_angle_ori_centering_analyze = [];
    %knee_joint_angle_ori_centering_analyze = [];

    for trial = 1:size(rates_mat,2)
        firing_vec = [firing_vec; rates_mat(:,trial)];
        hip_joint_angle_sort_for_analyze = [hip_joint_angle_sort_for_analyze; hip_joint_angle_ori(:,1)];
        knee_joint_angle_sort_for_analyze = [knee_joint_angle_sort_for_analyze; knee_joint_angle_ori(:,1)];
        orientation_sort_for_analyze = [orientation_sort_for_analyze; Theta_hip_to_ankle_ori(:,1)];
        length_sort_for_analyze = [length_sort_for_analyze; Leg_length(:,1)];
        %hip_joint_angle_ori_centering_analyze = [hip_joint_angle_ori_centering_analyze;hip_joint_angle_ori_centering(:,1)];
        %knee_joint_angle_ori_centering_analyze = [knee_joint_angle_ori_centering_analyze;knee_joint_angle_ori_centering(:,1)];
    end

    % 単回帰（股関節のみ）
    mdl1 = fitlm(hip_joint_angle_sort_for_analyze, firing_vec);
    Rsq_single_hip(i) = mdl1.Rsquared.Adjusted;
    p_joint_hip(i) = mdl1.Coefficients.pValue(2);  % 係数のp値
    cofficient_hip(i,1) = mdl1.Coefficients.Estimate(1);
    cofficient_hip(i,2) = mdl1.Coefficients.Estimate(2); 
    Only_Hip_SSE(i,1) = sum(mdl1.Residuals.Raw.^2);

    % 単回帰（膝関節のみ）
    mdl2 = fitlm(knee_joint_angle_sort_for_analyze, firing_vec);
    Rsq_single_knee(i) = mdl2.Rsquared.Adjusted;
    p_joint_knee(i) = mdl2.Coefficients.pValue(2);
    cofficient_knee(i,1) = mdl2.Coefficients.Estimate(1);
    cofficient_knee(i,2) = mdl2.Coefficients.Estimate(2); 
    Only_Knee_SSE(i,1) = sum(mdl2.Residuals.Raw.^2);

    % 単回帰（orientation）
    mdl3 = fitlm(orientation_sort_for_analyze, firing_vec);
    Rsq_orientation(i) = mdl3.Rsquared.Adjusted;
    p_orientation(i) = mdl3.Coefficients.pValue(2);
    cofficient_orientation(i,1) = mdl3.Coefficients.Estimate(1);
    cofficient_orientation(i,2) = mdl3.Coefficients.Estimate(2);

    % 単回帰（lengtrh）
    mdl4 = fitlm(length_sort_for_analyze, firing_vec);
    Rsq_length(i) = mdl4.Rsquared.Adjusted;
    p_length(i) = mdl4.Coefficients.pValue(2);
    cofficient_length(i,1) = mdl4.Coefficients.Estimate(1);
    cofficient_length(i,2) = mdl4.Coefficients.Estimate(2);


    % 交互作用項を含めない 説明変数行列 hip angle and knee model plus
    hip_plus = hip_joint_angle_sort_for_analyze - mean(hip_joint_angle_sort_for_analyze);
    knee_plus = knee_joint_angle_sort_for_analyze - mean(knee_joint_angle_sort_for_analyze);
    X_inter_angle_plus = [hip_plus, knee_plus];
    mdl_inter_angle_plus = fitlm(X_inter_angle_plus, firing_vec);
    Rsq_multi_hip_knee_inter_plus(i) = mdl_inter_angle_plus.Rsquared.Adjusted;
    p_multi_hip_knee_inter_plus(i, :) = mdl_inter_angle_plus.Coefficients.pValue(2:3)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_hip_knee_inter_plus(i, :) = mdl_inter_angle_plus.Coefficients.Estimate';  % [intercept, ori, len, ori*len]
    Only_Hip_plus_Knee_SSE(i,1) = sum(mdl_inter_angle_plus.Residuals.Raw.^2);

     % 交互作用項を含めた説明変数行列 hip angle and knee model cross
    hip_cross = hip_joint_angle_sort_for_analyze;
    knee_cross = knee_joint_angle_sort_for_analyze;
    interaction_angle_cross = hip_cross .* knee_cross;
    X_inter_angle = [hip_cross, knee_cross, interaction_angle_cross];
    mdl_inter_angle_cross = fitlm(X_inter_angle, firing_vec);
    Rsq_multi_hip_knee_inter_cross(i) = mdl_inter_angle_cross.Rsquared.Adjusted;
    p_multi_hip_knee_inter_cross(i, :) = mdl_inter_angle_cross.Coefficients.pValue(2:4)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_hip_knee_inter_cross(i, :) = mdl_inter_angle_cross.Coefficients.Estimate';  % [intercept, ori, len, ori*len]
    p_value_multi_hip_knee_inter_cross(i,1) = mdl_inter_angle_cross.ModelFitVsNullModel.Pvalue;
    Fullmodel_SSE(i,1) = sum(mdl_inter_angle_cross.Residuals.Raw.^2);

     %hip angle and knee model cross hip&knee poralitry aligned by 0 not use
     %centering
    hip_cross_centering = hip_joint_angle_sort_for_analyze-mean(hip_joint_angle_sort_for_analyze);
    knee_cross_centering = knee_joint_angle_sort_for_analyze-mean(knee_joint_angle_sort_for_analyze);
    interaction_angle_cross_centering = hip_cross_centering .* knee_cross_centering;
    X_inter_angle = [hip_cross_centering, knee_cross_centering, interaction_angle_cross_centering];
    mdl_inter_angle_cross_centering = fitlm(X_inter_angle, firing_vec);
    Rsq_multi_hip_knee_inter_cross_centering(i) = mdl_inter_angle_cross_centering.Rsquared.Adjusted;
    p_multi_hip_knee_inter_cross_centering(i, :) = mdl_inter_angle_cross_centering.Coefficients.pValue(2:4)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_hip_knee_inter_cross_centering(i, :) = mdl_inter_angle_cross_centering.Coefficients.Estimate';  % [intercept, ori, len, ori*len]
    p_value_multi_hip_knee_inter_cross_centering(i,1) = mdl_inter_angle_cross_centering.ModelFitVsNullModel.Pvalue;

    % 交互作用項を含めnai 説明変数行列 2 hennsuu
    ori = orientation_sort_for_analyze;
    len = length_sort_for_analyze;
    X_inter_ori_len_plus = [ori, len];
    mdl_inter_ori_len_plus = fitlm(X_inter_ori_len_plus, firing_vec);
    Rsq_multi_ori_len_inter_plus(i) = mdl_inter_ori_len_plus.Rsquared.Adjusted;
    p_multi_ori_len_inter_plus(i, :) = mdl_inter_ori_len_plus.Coefficients.pValue(2:3)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_ori_len_inter_plus(i, :) = mdl_inter_ori_len_plus.Coefficients.Estimate';  % [intercept, ori, len, ori*len]
    p_value_whole_multi_ori_len_inter_plus(i, 1)  = mdl_inter_ori_len_plus.ModelFitVsNullModel.Pvalue;

     % 交互作用項を含めた説明変数行列 orientation angle and length model cross
    ori = orientation_sort_for_analyze;
    len = length_sort_for_analyze;
    interaction = ori .* len;
    X_inter = [ori, len, interaction];
    mdl_inter = fitlm(X_inter, firing_vec);
    Rsq_multi_ori_len_inter_cross(i) = mdl_inter.Rsquared.Adjusted;
    p_multi_ori_len_inter_cross(i, :) = mdl_inter.Coefficients.pValue(2:4)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_ori_len_inter_cross(i, :) = mdl_inter.Coefficients.Estimate';  % [intercept, ori, len, ori*len]
    p_value_whole_multi_ori_len_inter_cross(i, 1)  = mdl_inter.ModelFitVsNullModel.Pvalue;

    %regression model Quadratic interaction model
    hip_cross  = hip_joint_angle_sort_for_analyze;
    knee_cross = knee_joint_angle_sort_for_analyze;
    % ---- 交互作用 ----
    interaction_angle_cross = hip_cross .* knee_cross;
    % ---- 2乗項 ----
    hip_sq  = hip_cross.^2;
    knee_sq = knee_cross.^2;
    % ---- 説明変数行列 ----
    X_inter_angle = [hip_cross, ...
                 knee_cross, ...
                 interaction_angle_cross, ...
                 hip_sq, ...
                 knee_sq];
    % ---- 回帰 ----
    mdl_quad_inter_angle_cross = fitlm(X_inter_angle, firing_vec);
    % ---- 指標取得 ----
    Rsq_multi_mdl_quad_inter_angle_cross(i) = mdl_quad_inter_angle_cross.Rsquared.Adjusted;
    % p値（intercept除く）
    p_multi_mdl_quad_inter_angle_cross(i, :) = mdl_quad_inter_angle_cross.Coefficients.pValue(2:6)';
    % 係数（intercept含む）
    cofficient_multi_mdl_quad_inter_angle_cross(i, :) = mdl_quad_inter_angle_cross.Coefficients.Estimate';
    p_value_multi_mdl_quad_inter_angle_cross(i,1) = mdl_quad_inter_angle_cross.ModelFitVsNullModel.Pvalue;
    Fullmodel_SSE_mdl_quad_inter_angle_cross(i,1) = sum(mdl_quad_inter_angle_cross.Residuals.Raw.^2);


    %regression model f value kentei
    %full model centering
    First_element = ones(length(hip_cross_centering),1);
    centering_element_Hip_Knee_inter = [First_element hip_cross_centering knee_cross_centering hip_cross_centering.*knee_cross_centering];
    [b,~,r,~,stats] = regress(firing_vec,centering_element_Hip_Knee_inter);
    R_square_regress_center(i,1) = stats(1);
    P_regress_center(i,1) = stats(3);
end




% 結果の確認例（有意なものだけを抽出）
Rsq_good_hip = find(Rsq_single_hip > threshold_R & p_joint_hip < p_thresh);
Rsq_good_knee = find(Rsq_single_knee > threshold_R & p_joint_knee < p_thresh);
Rsq_good_orientation = find(Rsq_orientation > threshold_R & p_orientation < p_thresh);
Rsq_good_length = find(Rsq_length > threshold_R & p_length < p_thresh);


Rsq_good_multi_angle = find(Rsq_multi_hip_knee_inter_plus > threshold_R);
Rsq_good_multi = find(Rsq_multi_ori_len_inter_plus > threshold_R);

%%
Rsq_good_multi_angle_cross = find(Rsq_multi_hip_knee_inter_cross_centering>threshold_R);

P_and_Rsq_good_multi_angle_cross = Rsq_good_multi_angle_cross(find(p_value_multi_hip_knee_inter_cross_centering(Rsq_good_multi_angle_cross)<0.001));


%% calculate paticular R^2
% case of the hip

for neu = 1:length(newSpkTime)
    particular_p(neu,1) = (Only_Knee_SSE(neu)-Fullmodel_SSE(neu))/Only_Knee_SSE(neu);
    diff_num_coef = mdl_inter_angle_cross.NumEstimatedCoefficients - mdl2.NumEstimatedCoefficients;
    full_num_coef = mdl_inter_angle_cross.NumEstimatedCoefficients;
    num_of_sample = mdl_inter_angle_cross.NumObservations;
    Fval(neu,1) = ((Only_Knee_SSE(neu)-Fullmodel_SSE(neu))/diff_num_coef)/(Fullmodel_SSE(neu)/(num_of_sample-full_num_coef));
    pval_by_partR_for_Hip(neu,1) = 1- fcdf(Fval(neu,1),diff_num_coef,num_of_sample-full_num_coef);
end
% case of the Knee
for neu = 1:length(newSpkTime)
    particular_p(neu,1) = (Only_Hip_SSE(neu)-Fullmodel_SSE(neu))/Only_Hip_SSE(neu);
    diff_num_coef = mdl_inter_angle_cross.NumEstimatedCoefficients - mdl1.NumEstimatedCoefficients;
    full_num_coef = mdl_inter_angle_cross.NumEstimatedCoefficients;
    num_of_sample = mdl_inter_angle_cross.NumObservations;
    Fval(neu,1) = ((Only_Hip_SSE(neu)-Fullmodel_SSE(neu))/diff_num_coef)/(Fullmodel_SSE(neu)/(num_of_sample-full_num_coef));
    pval_by_partR_for_Knee(neu,1) = 1- fcdf(Fval(neu,1),diff_num_coef,num_of_sample-full_num_coef);
end
% case of the interaction
for neu = 1:length(newSpkTime)
    particular_p(neu,1) = (Only_Hip_plus_Knee_SSE(neu)-Fullmodel_SSE(neu))/Only_Hip_plus_Knee_SSE(neu);
    diff_num_coef = mdl_inter_angle_cross.NumEstimatedCoefficients - mdl_inter_angle_plus.NumEstimatedCoefficients;
    full_num_coef = mdl_inter_angle_cross.NumEstimatedCoefficients;
    num_of_sample = mdl_inter_angle_cross.NumObservations;
    Fval(neu,1) = ((Only_Hip_plus_Knee_SSE(neu)-Fullmodel_SSE(neu))/diff_num_coef)/(Fullmodel_SSE(neu)/(num_of_sample-full_num_coef));
    pval_by_partR_for_interaction(neu,1) = 1- fcdf(Fval(neu,1),diff_num_coef,num_of_sample-full_num_coef);
end

% all neuron Pval
All_neuron_pval_by_particular_R = [pval_by_partR_for_Hip,pval_by_partR_for_Knee,pval_by_partR_for_interaction];
GoodR_separatable_neuron = [P_and_Rsq_good_multi_angle_cross,All_neuron_pval_by_particular_R(P_and_Rsq_good_multi_angle_cross,:)];
%% 
Rsq_good_multi_cross = find(Rsq_multi_ori_len_inter_cross>threshold_R);


% soukann kaiseki between two link
x = hip_joint_angle_ori(:,1);
y = knee_joint_angle_ori(:,1);

% 相関係数と P値
[R, P] = corrcoef(x, y);
R_value = R(1,2);
P_value = P(1,2);

% 散布図の描画
figure;
scatter(x, y, 40, 'filled');
xlabel('Hip joint angle');
ylabel('Knee joint angle');
title('Correlation between Hip and Knee Angles');

% 相関係数と P 値の注釈を図中に追加
txt = sprintf('R = %.2f, p = %.2f', R_value, P_value);
text(mean(x), mean(y), txt, 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', 'w');

grid on;
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_folder, 'Hip_and_Knee_coff.tif');
print(gcf, tifFileName, '-dtiff', '-r300');
%close hidden;

%% cross particular R^2
Rsq_good_multi_angle_cross = length(find(Rsq_multi_hip_knee_inter_cross>threshold_R));
 
hip_and_knee_folder_cross_particular_p = createNamedFolder(hip_and_knee_PCAfolder, 'cross_particular_p');
Fig_name_knee_and_hip_cross_particular_p  = 'Knee angle and Hip angle interaction particular p';


Plot_angle_MFR_multiple_regression_hip_knee_cross_particular_R(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_particular_p, hip_and_knee_folder_cross_particular_p, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R,p_value_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)
%{

hip_and_knee_folder_cross_particular_p_for_fig = createNamedFolder(hip_and_knee_folder_cross_particular_p, 'for_fig');
Plot_angle_MFR_regression_hip_knee_cross_particular_R_for_fig(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_particular_p, hip_and_knee_folder_cross_particular_p_for_fig, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R,p_value_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)


%% 
hip_and_knee_folder_cross_particular_p_for_fig = createNamedFolder(hip_and_knee_folder_cross_particular_p, 'for_master_thesis');
Plot_angle_MFR_regression_hip_knee_cross_particular_R_for_M2(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_particular_p, hip_and_knee_folder_cross_particular_p_for_fig, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R,p_value_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)
%}

%% plot in main neuron
responsible_neuron = [53, 21, 24];
%responsible_neuron = [15, 28, 24];
% 格子点作成のための範囲
hip_range = linspace(min(hip_joint_angle_ori(:,1)), max(hip_joint_angle_ori(:,1)), 30);
knee_range = linspace(min(knee_joint_angle_ori(:,1)), max(knee_joint_angle_ori(:,1)), 30);
[Hip_coff, Knee_coff] = meshgrid(hip_range, knee_range);

figure;
for num_n = 1:length(responsible_neuron)
    subplot(1, 3, num_n);
    hold on;

    % Z軸データ（発火率）
    z = mean(MFR_sep_pos{responsible_neuron(num_n)}, 1)';  

    % 最大値の取得
    max_val = max(z, [], 'all');
    % Z軸範囲の設定
    if max_val > 100
         zlim_fig = [0 150];
    elseif max_val > 80
         zlim_fig = [0 100];
    elseif max_val > 40
        zlim_fig = [0 80];
    elseif max_val > 20
        zlim_fig = [0 40];
    elseif max_val > 5
        zlim_fig = [0 20];
    else
        zlim_fig = [0 5];
    end
    zlim(zlim_fig);

    % --- 実データのプロット（黒い点） ---
    scatter3(hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), z, ...
             20, 'k', 'filled');

    % --- モデル平面の計算 ---
    beta = cofficient_multi_hip_knee_inter_cross(responsible_neuron(num_n),:);
    beta_representative(num_n,:) = beta(1,:);
    F_model = beta(1) + beta(2)*Hip_coff + beta(3)*Knee_coff + beta(4)*(Hip_coff .* Knee_coff);

    % --- モデル面の描画（薄いグレー） ---
    surf(Hip_coff, Knee_coff, F_model, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.3, ...
         'FaceColor', [0.7 0.7 0.7]);  % 薄いグレー

    % タイトル
    title(['SubA Neuron ' num2str(responsible_neuron(num_n))]);

    %xlabel('Normalized hip joint angle');
    %ylabel('Normalized knee joint angle');
    view(135, 35);
    grid on;
end

% === FigureのサイズをA4幅に縮小 ===
target_width = 18;     % cm （A4幅に収める）
target_height = 6;     % 縦は適度に調整（横幅に合わせて縮小）

set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(hip_and_knee_folder_cross_particular_p, ...
    'Regression_model_representative_neuron_subB_A4width.pdf');
print(fig, pdfFileName, '-dpdf');




%% Figure 6
% 2D color map with fixed color limits

responsible_neuron = [53, 21, 24];

% 格子点作成
hip_range  = linspace(min(hip_joint_angle_ori(:,1)), max(hip_joint_angle_ori(:,1)), 20);
knee_range = linspace(min(knee_joint_angle_ori(:,1)), max(knee_joint_angle_ori(:,1)), 20);
[Hip_coff, Knee_coff] = meshgrid(hip_range, knee_range);

figure('Units','centimeters','Position',[5 5 8.5 18],'Color','w');
tiledlayout(3,1,'TileSpacing','compact','Padding','compact');
for num_n = 1:length(responsible_neuron)
    nexttile;
    hold on;

    % モデル平面
    beta = cofficient_multi_hip_knee_inter_cross(responsible_neuron(num_n),:);
    F_model = beta(1) + beta(2)*Hip_coff + beta(3)*Knee_coff + beta(4)*(Hip_coff .* Knee_coff);

    % --- Z軸データ（発火率） ---
    z = mean(MFR_sep_pos{responsible_neuron(num_n)}, 1)';  

    % カラーマップ範囲設定（caxis）
    % 最大値取得
    max_val = max(z, [], 'all');

    % カラーマップの上限を決定
    if max_val > 100
        clim = [0 150];
    elseif max_val > 10
        clim = [0 ceil(max_val/20)*20];   % 10刻み
    elseif max_val > 5
        clim = [0 ceil(max_val/5)*5];     % 5刻み
    else
        clim = [0 ceil(max_val)];         % 1刻み
    end
    % モデル面描画（pcolor）
    h = pcolor(Hip_coff, Knee_coff, F_model);
    set(h, 'EdgeColor', 'none');
    colormap(viridis);
    caxis(clim);   % カラーマップ範囲固定
    c = colorbar;
    c.FontName   = 'Arial';
    c.FontWeight = 'bold';
    c.FontSize   = 15;

    % 実測値の散布図（色=発火率, 枠線=グレー）
    scatter(hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), 80, z, ...
            'filled', 'MarkerEdgeColor', [0.6 0.6 0.6], 'LineWidth', 1.5);

    title(['CatA Neuron #' num2str(responsible_neuron(num_n))], ...
          'FontName','Arial','FontWeight','bold','FontSize',15);

    % 軸設定
    axis([-1.1 1.1 -1.1 1.1]);
    axis square;
    xticks([-1 -0.5 0 0.5 1]);
    yticks([-1 -0.5 0 0.5 1]);
    grid on;

    ax = gca;
    ax.FontName   = 'Arial';
    ax.FontWeight = 'bold';
    ax.FontSize   = 15;
    ax.LineWidth  = 1.5;
    ax.TickDir    = 'out';
    ax.Box        = 'off';
    ax.XTickLabelRotation = 0;  % ここで傾きを 0 に固定
    % 軸ラベルを normalized 単位に変更
    ax.XLabel.Units = 'normalized';
    ax.YLabel.Units = 'normalized';

    % 微小にずらす（0.01程度でも見た目は微調整）
    ax.XLabel.Position(2) = ax.XLabel.Position(2) + 0.15;  % 下に少し移動
    ax.YLabel.Position(1) = ax.YLabel.Position(1) + 0.35;  % 左に少し移動
    

end

% --- EMF保存（17×8 cm） ---
fig = gcf;
set(fig, 'Units', 'centimeters');
set(fig, 'Position', [5 5 8.5 23]);   % 幅17cm, 高さ8cm

emfFileName = fullfile(hip_and_knee_folder_cross_particular_p, ...
    'Regression_model_representative_neuron_Cat_A4width_2D_vertical.emf');

print(fig, emfFileName, '-dmeta', '-r600');


%% 



% Figureサイズ調整（A4横）
target_width = 40; 
target_height = 15; 
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% PDF保存
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];
fig.PaperPosition = [0 0 target_width target_height];
pdfFileName = fullfile(hip_and_knee_folder_cross_particular_p, ...
    'Regression_model_representative_neuron_Cat_A4width_2D.pdf');
print(fig, pdfFileName, '-dpdf');


%% plot 3D
neurons_per_fig = 12;
label_cell_angle = {'Hip Angle [deg]', 'Knee Angle [deg]'};
label_cell_multi = {'Orientation [deg]', 'Length [deg]'};
both_angle_scotter_folder = createNamedFolder(angle_related_folder, 'Scottter_both_parameter');


% plot 3D hip and knee
both_angle_foldername = 'Hip_and_knee_angle';
plotBothJointAngleScatter(hip_knee_joint_angle_orignal(:,1), hip_knee_joint_angle_orignal(:,2), MFR_sep_pos, newSpkCH, neurons_per_fig, both_angle_scotter_folder, label_cell_angle,both_angle_foldername);


%% ヒートマップ表示 particular p

All_neuron_pval_by_particular_R;
hip_and_knee_folder_cross_particular_p;
Rsq_multi_hip_knee_inter_cross;
p_value_multi_hip_knee_inter_cross;
cofficient_multi_hip_knee_inter_cross;


% 3列分のマトリクス作成（1:Hip, 2:Knee, 3:Interaction ）
heatmap_data = zeros(nNeurons, 7);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_multi_hip_knee_inter_cross(i)) > threshold_R &&  p_value_multi_hip_knee_inter_cross(i) < p_thresh
        if All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,3) = 3;  % 赤
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,4) = 4;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,5) = 5;
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,6) = 6;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) > p_thresh
            if abs(cofficient_multi_hip_knee_inter_cross(i,2)) < abs(cofficient_multi_hip_knee_inter_cross(i,3))
                heatmap_data(i,7) = 2;
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2))>abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
                heatmap_data(i,7) = 1;
            end
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh && All_neuron_pval_by_particular_R(i,1) < p_thresh
            heatmap_data(i,1) = 1;
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh &&  All_neuron_pval_by_particular_R(i,2) < p_thresh
            heatmap_data(i,2) = 2;
        end
    end
end

% --- カラーマップ: -1=青, 0=白, 1=赤, 2=緑 ---
cmap = [
    1 1 1;   % no modulation
    0 0 1;   % only hip
    0 1 0;   %only knee 
    0.6 0.3 0;   % 3 parameter p < 0.05
    1 0 0; %only cross
    1 0.5 0; % hip and cross
    1 0.4 0.7; % knee and cross
    1 0.75 0.8; %only hip and knee
];

figure;
imagesc(heatmap_data);
colormap(cmap);
caxis([0 7]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:7);
xticklabels({'Hip', 'Knee', 'Hip & Knee & int' ,'int','Hip & int','Knee & int','Hip & Knee'});
ax.Layer = 'top';
ax.LineWidth = 1.5;

% 標準グリッド無効化
ax.XGrid = 'off';
ax.YGrid = 'off';

% --- 手動グリッド線（Y方向：1.5, 2.5, 3.5, ...） ---

hold on;

% 対象列のインデックスと名前

col_labels = {'Hip', 'Knee', 'Hip & Knee & int' ,'int','Hip & int','Knee & int','Hip & Knee'};
col_indices = [1, 2, 3,4,5,6,7];  % heatmap_dataの対応列
text_y = 0.5;  % 上に少し表示するためのY位置

for col = 1:length(col_indices)
        idx = col_indices(col);
    
        % 閾値を満たすデータ数をカウント（絶対値が 1, 2, 3 などで判定）
        count_significant = sum(heatmap_data(:,idx) ~= 0);  % 0以外（有意）な数
        % 軸上にテキストで表示
        text(col, text_y, sprintf('%d/%d', count_significant, nNeurons), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 20, ...
        'FontWeight', 'bold', ...
        'Color', 'k');
end



y_lines = 1.5:1:nNeurons - 0.5;
for y = y_lines
    line([0.5, 10.5], [y, y], 'Color', [0.7 0.7 0.7], 'LineStyle', '-', 'LineWidth', 1);  % 横線
end

% --- 必要ならX方向も同様に描画 ---
x_lines = 1.5:1:10 - 0.5;
for x = x_lines
    line([x, x], [0.5, nNeurons + 0.5], 'Color', [0.7 0.7 0.7], 'LineStyle', '-', 'LineWidth', 1);  % 縦線
end

% カラーバーとタイトル
colorbar('Ticks',[0 1 2 3 4 5 6 7], ...
         'TickLabels', {'None', ['Hip P > ' num2str(p_thresh)],['Knee P > ' num2str(p_thresh)], ['All P  > ' num2str(p_thresh)], ['Int P  > ' num2str(p_thresh)], ['Hip & Int P  > ' num2str(p_thresh)],['Knee & Int P  > ' num2str(p_thresh)],['Hip & Knee P  > ' num2str(p_thresh)]}, 'FontSize', 18);
title(['Correlation Significance Heatmap'],['Threshold R^2 > ' num2str(threshold_R) ' and p < ' num2str(p_thresh)],'FontSize', 18);
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存
tifFileName = fullfile(hip_and_knee_folder_cross_particular_p, ...
    'Fitting_evaluation_only_i_model_centering.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%% ヒートマップ表示 particular p only 3

All_neuron_pval_by_particular_R;
hip_and_knee_folder_cross_particular_p;
Rsq_multi_hip_knee_inter_cross;
p_value_multi_hip_knee_inter_cross;
cofficient_multi_hip_knee_inter_cross;

% 3列分のマトリクス作成（1:Hip, 2:Knee, 3:Interaction ）
heatmap_data_particular_R_3 = zeros(nNeurons, 3);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_multi_hip_knee_inter_cross(i)) > threshold_R &&  p_value_multi_hip_knee_inter_cross(i) < p_thresh
        if All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;  % 赤
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) > p_thresh
            if abs(cofficient_multi_hip_knee_inter_cross(i,2)) < abs(cofficient_multi_hip_knee_inter_cross(i,3))
                heatmap_data_particular_R_3(i,2) = 2;
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2)) >abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
                heatmap_data_particular_R_3(i,1) = 1;
            end
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh && All_neuron_pval_by_particular_R(i,1) < p_thresh
            heatmap_data_particular_R_3(i,1) = 1;
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh &&  All_neuron_pval_by_particular_R(i,2) < p_thresh
            heatmap_data_particular_R_3(i,2) = 2;
        end
    end
end

% --- カラーマップ: -1=青, 0=白, 1=赤, 2=緑 ---
cmap = [
    1 1 1;   % no modulation
    0 0 1;   % only hip
    0 1 0;   %only knee 
    1 0 0;   % 3 parameter p < 0.05
];

figure;
imagesc(heatmap_data_particular_R_3);
colormap(cmap);
caxis([0 3]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:7);
xticklabels({'Hip', 'Knee', 'Hip & Knee'});
ax.Layer = 'top';
ax.LineWidth = 1.5;

% 標準グリッド無効化
ax.XGrid = 'off';
ax.YGrid = 'off';

% --- 手動グリッド線（Y方向：1.5, 2.5, 3.5, ...） ---

hold on;

% 対象列のインデックスと名前

col_labels = {'Hip', 'Knee','Hip & Knee'};
col_indices = [1, 2, 3];  % heatmap_dataの対応列
text_y = 0.5;  % 上に少し表示するためのY位置




y_lines = 1.5:1:nNeurons - 0.5;
for y = y_lines
    line([0.5, 10.5], [y, y], 'Color', [0.7 0.7 0.7], 'LineStyle', '-', 'LineWidth', 1);  % 横線
end

% --- 必要ならX方向も同様に描画 ---
x_lines = 1.5:1:10 - 0.5;
for x = x_lines
    line([x, x], [0.5, nNeurons + 0.5], 'Color', [0.7 0.7 0.7], 'LineStyle', '-', 'LineWidth', 1);  % 縦線
end

% カラーバーとタイトル
colorbar('Ticks',[0 1 2 3 4 5 6 7], ...
         'TickLabels', {'None', ['Hip P > ' num2str(p_thresh)],['Knee P > ' num2str(p_thresh)], ['All P  > ' num2str(p_thresh)]}, 'FontSize', 18);
title(['Correlation Significance Heatmap'],['Threshold R^2 > ' num2str(threshold_R) ' and p < ' num2str(p_thresh)],'FontSize', 18);
set(gcf, 'Units', 'inches', 'Position', [1, 1, 6, 8]);  % 幅6インチ×高さ8インチなど

% 保存
tifFileName = fullfile(hip_and_knee_folder_cross_particular_p, ...
    'Fitting_evaluation_only_i_model_centering_only3.tif');
print(gcf, tifFileName, '-dtiff', '-r300');




%% caluculate length

% ---- ビン幅と物理スケール設定 ----
bin_width = 4;                  % チャンネル数
channel_pitch_um = 10;          % 1チャンネルあたりの距離（μm）
bin_pitch_um = bin_width * channel_pitch_um;  % = 40μm

% ---- ビン数 ----
num_bins = 384 / bin_width;
Hip_neuron_spk_ch = [];
Knee_neuron_spk_ch = [];
Hip_and_knee_neuron_spk_ch = [];

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_multi_hip_knee_inter_cross(i)) > threshold_R &&  p_value_multi_hip_knee_inter_cross(i) < p_thresh
        if All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            Hip_and_knee_neuron_spk_ch = [Hip_and_knee_neuron_spk_ch; newSpkCH(i,1)];  
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            Hip_and_knee_neuron_spk_ch = [Hip_and_knee_neuron_spk_ch; newSpkCH(i,1)];  
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            Hip_and_knee_neuron_spk_ch = [Hip_and_knee_neuron_spk_ch; newSpkCH(i,1)];  
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            Hip_and_knee_neuron_spk_ch = [Hip_and_knee_neuron_spk_ch; newSpkCH(i,1)];  
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) > p_thresh
            if cofficient_multi_hip_knee_inter_cross(i,2) < cofficient_multi_hip_knee_inter_cross(i,3)
                Knee_neuron_spk_ch = [Knee_neuron_spk_ch; newSpkCH(i,1)];  
            elseif cofficient_multi_hip_knee_inter_cross(i,2)>cofficient_multi_hip_knee_inter_cross(i,3)
                Hip_neuron_spk_ch = [Hip_neuron_spk_ch; newSpkCH(i,1)];  
            end
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh && All_neuron_pval_by_particular_R(i,1) < p_thresh
            Hip_neuron_spk_ch = [Hip_neuron_spk_ch; newSpkCH(i,1)]; 
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh &&  All_neuron_pval_by_particular_R(i,2) < p_thresh
            Knee_neuron_spk_ch = [Knee_neuron_spk_ch; newSpkCH(i,1)]; 
        end
    end
end

%

% for Hip
% ---- 各ニューロンの属するビンを計算 ----
Hip_bin_indices = floor(Hip_neuron_spk_ch / bin_width) + 1;
Knee_bin_indices = floor(Knee_neuron_spk_ch / bin_width) + 1;
Hip_and_Knee_bin_indices = floor(Hip_and_knee_neuron_spk_ch / bin_width) + 1;
% ---- 各ビンに何個ニューロンが属するかをカウント ----
Hip_joint_neuron_counts_per_bin = histcounts(Hip_bin_indices, 0.5:1:(num_bins + 0.5));
Knee_joint_neuron_counts_per_bin = histcounts(Knee_bin_indices, 0.5:1:(num_bins + 0.5));
Hip_and_Knee_joint_neuron_counts_per_bin = histcounts(Hip_and_Knee_bin_indices, 0.5:1:(num_bins + 0.5));


% ---- Y軸（深さμm）データ ----
Y_um = (1:num_bins) * bin_pitch_um;  % 1ビンごとに40μm

% 各行 = ビン, 各列 = カテゴリ（Hip, Knee, Hip&Knee）
stack_data = [Hip_joint_neuron_counts_per_bin(:), ...
              Knee_joint_neuron_counts_per_bin(:), ...
              Hip_and_Knee_joint_neuron_counts_per_bin(:)];

% --- 横積み棒グラフ ---
figure;
b = barh(Y_um, stack_data, 'stacked');

% --- 色設定（Hip=赤, Knee=青, 両方=緑 など）
b(1).FaceColor = [0 0 1];     % Hip
b(2).FaceColor = [0.0 0.5 0.0];     % Knee
b(3).FaceColor = [1 0 0];   % Hip & Knee

% --- 軸や表示調整 ---
ylim([0 3840]);
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Neuron Count');
ylabel('Depth (μm)');
grid on;

% --- 保存処理 ---
filename = 'neuron_depth_distribution_stacked.tif';
full_path = fullfile(hip_and_knee_folder_cross_particular_p, filename);
set(gcf, 'Units', 'inches', 'Position', [1, 1, 6, 8], 'Color', 'w');
print(gcf, full_path, '-dtiff', '-r300');


%% calculat slope for joint related neuron----------------------------------------------------------------------------
angle_sensitivity_folder_cross_particular_p = createNamedFolder(hip_and_knee_folder_cross_particular_p, 'angle_sensitivity');
angle_sensitivity_folder_cross_particular_p_neuron = createNamedFolder(angle_sensitivity_folder_cross_particular_p, 'Each_neuron');
coef = cofficient_multi_hip_knee_inter_cross;
hip  = hip_joint_angle_ori(:,1);
knee = knee_joint_angle_ori(:,1);

nNeuron  = size(coef,1);
nPosture = length(hip);

% ニューロンタイプ
neuron_type_only_joint = ...
    heatmap_data_particular_R_3(:,1) + ...
    heatmap_data_particular_R_3(:,2) + ...
    heatmap_data_particular_R_3(:,3);

% カラーマップ
cmap_joint = [
    0.6 0.6 0.6;   % 0 → gray
    0   0   1;     % 1 → blue
    0   0.5   0;     % 2 → green
    1   0   0;     % 3 → red
];



% ===== ニューロンごとの図 =====
for i = 1:nNeuron

    type_i = neuron_type_only_joint(i);

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    figure('Color','w'); hold on;
    axis equal;
    box on;

    vec_all = [];

    for p = 1:nPosture
        H = hip(p);
        K = knee(p);

        % 局所勾配
        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;

        mag = norm([s_hip, s_knee]);
        if mag == 0
            continue
        end

        % 単位ベクトル
        u_hip  = s_hip  / mag;
        u_knee = s_knee / mag;

        vec_all(end+1,:) = [u_hip, u_knee];

        % ---- 記録点 ----
        plot(H, K, 'ko', 'MarkerFaceColor','k', 'MarkerSize',4);

        % ---- 中心を記録点にした矢印 ----
        scale = 0.4;  % 矢印の長さ調整
        dx = u_hip  * scale;
        dy = u_knee * scale;

        % 中心配置
        x0 = H - dx/2;
        y0 = K - dy/2;

        quiver(x0, y0, dx, dy, 0, ...
            'LineWidth',2, ...
            'Color', cmap_joint(type_i+1,:), ...
            'MaxHeadSize',2);
    end

    % =========================
    % 平均ベクトル（太矢印） ← ここでスキップ判定
    % =========================
    if ~isempty(vec_all)  % vec_allが空でなければ描画
        mean_vec = mean(vec_all,1);
        mean_mag = norm(mean_vec);

        if mean_mag > 0
            mean_vec = mean_vec / mean_mag;  % 単位化

            H_mean = mean(hip);
            K_mean = mean(knee);

            scale_mean = 0.6;  % 太矢印の長さ
            dx = mean_vec(1) * scale_mean;
            dy = mean_vec(2) * scale_mean;

            x0 = H_mean - dx/2;
            y0 = K_mean - dy/2;

            quiver(x0, y0, dx, dy, 0, ...
                'LineWidth',3, ...
                'Color','k', ...
                'MaxHeadSize',2);
        end
    end

    % 軸・文字体裁
    xlabel('Hip (normalized)', 'FontSize',16, 'FontWeight','bold');
    ylabel('Knee (normalized)', 'FontSize',16, 'FontWeight','bold');
    title(['Neuron ' num2str(i) ' direction field'], ...
          'FontSize',18, 'FontWeight','bold');

    ax = gca;
    ax.FontSize   = 14;
    ax.FontWeight = 'bold';
    ax.LineWidth  = 1.5;
    ax.TickDir    = 'out';
    ax.Box        = 'off';
    ax.XAxisLocation = 'bottom';
    ax.YAxisLocation = 'left';
    grid on;

    % ===== PNG保存 =====
    fname = fullfile(angle_sensitivity_folder_cross_particular_p_neuron, ...
                     ['Neuron_' num2str(i,'%03d') '_UnitVectorField.png']);
    exportgraphics(gcf, fname, 'Resolution',300);

    close;  % 図を閉じる
end


%% arrow plot

figure('Color','w'); hold on;
axis equal;
box on;

% 矢印の色：1=Hip, 2=Knee, 3=Both
cmap_joint = [
    0   0   1;   % 1 only Hip
    0   0.5   0;   % 2 only Knee
    1   0   0;   % 3 both
];

center = [0, 0];   % 原点から矢印を出す
arrow_length = 1;  % 矢印の長さを統一

for i = 1:nNeuron

    type_i = neuron_type_only_joint(i);

    % 1,2,3以外はスキップ
    if ~ismember(type_i, [1,2,3])
        continue
    end

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    vec_all = [];

    for p = 1:nPosture
        H = hip(p);
        K = knee(p);

        % 局所勾配
        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;

        mag = norm([s_hip, s_knee]);
        if mag == 0
            continue
        end

        % 単位ベクトル化（方向だけ）
        u_hip  = s_hip  / mag;
        u_knee = s_knee / mag;

        vec_all(end+1,:) = [u_hip, u_knee];
    end

    % 平均ベクトルを描画
    if ~isempty(vec_all)
        mean_vec = mean(vec_all,1);
        mean_mag = norm(mean_vec);

        if mean_mag > 0
            mean_vec = mean_vec / mean_mag;  % 方向だけにする

            dx = mean_vec(1) * arrow_length;
            dy = mean_vec(2) * arrow_length;

            quiver(center(1), center(2), dx, dy, 0, ...
                'LineWidth',2, ...
                'Color', cmap_joint(type_i,:), ...
                'MaxHeadSize',0.5);
        end
    end
end

% 軸・文字体裁
xlabel('Hip sensitivity', 'FontSize',16, 'FontWeight','bold');
ylabel('Knee sensitivity', 'FontSize',16, 'FontWeight','bold');

ax = gca;
ax.FontSize   = 14;
ax.FontWeight = 'bold';
ax.LineWidth  = 1.5;
ax.TickDir    = 'out';
ax.Box        = 'off';
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';
grid on;
axis([-1.2 1.2 -1.2 1.2]);  % 原点中心で表示


if ~exist(angle_sensitivity_folder_cross_particular_p, 'dir')
    mkdir(angle_sensitivity_folder_cross_particular_p);
end
% ===== PNG保存 =====
fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_arrow_CatA.png');
exportgraphics(gcf, fname, 'Resolution',300);

%close;  % 図を閉じる

%% scatter plot
nNeuron = length(coef(:,1));
Hip_dir  = zeros(nNeuron,1);
Knee_dir = zeros(nNeuron,1);
type_i_all = zeros(nNeuron,1);

for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);
    % 1,2,3以外はスキップ
    if ~ismember(type_i, [1,2,3])
        continue
    end

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    vec_all = zeros(nPosture,2);
    for p = 1:nPosture
        H = hip(p);
        K = knee(p);

        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;

        vec_all(p,:) = [s_hip, s_knee];
    end

    mean_vec = mean(vec_all,1);      % 全姿勢で平均
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;   % 単位化
    else
        mean_vec = [0 0];
    end

    Hip_dir(i)  = mean_vec(1);
    Knee_dir(i)= mean_vec(2);
    type_i_all(i) = type_i;
end

% ---- 散布図作成 ----
figure('Color','w'); hold on;

cmap_joint = [0 0 1;   % 1=青
              0 0.5 0;   % 2=緑
              1 0 0];  % 3=赤

scatter_handles = gobjects(3,1);  % 凡例用ハンドル

for t = 1:3
    idx = type_i_all == t;
    scatter_handles(t) = scatter(Hip_dir(idx), Knee_dir(idx), 50, cmap_joint(t,:), 'filled');
end


for t = 1:3
    idx = type_i_all == t;
    scatter(Hip_dir(idx), Knee_dir(idx), 100, cmap_joint(t,:), 'filled');
end

xlim([-1.05 1.05])
ylim([-1.05 1.05])
xlabel('Hip sensitivity', 'FontSize',16,'FontWeight','bold');
ylabel('Knee sensitivity', 'FontSize',16,'FontWeight','bold');
axis equal; grid on;
box on;

ax = gca;
ax.FontSize   = 14;
ax.FontWeight = 'bold';
ax.LineWidth  = 1.5;
ax.TickDir    = 'out';
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

% ---- 軸目盛り非表示 ----
ax.XTick = [];
ax.YTick = [];

% ===== PNG保存 =====
fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_scatter_CatA.png');
exportgraphics(gcf, fname, 'Resolution',300);

close;  % 図を閉じる



%% scatter only phase 1
nNeuron = length(coef(:,1));
Hip_dir  = zeros(nNeuron,1);
Knee_dir = zeros(nNeuron,1);
type_i_all = zeros(nNeuron,1);

for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);
    % 1,2,3以外はスキップ
    if ~ismember(type_i, [1,2,3])
        continue
    end

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    vec_all = zeros(nPosture,2);
    for p = 1:nPosture
        H = hip(p);
        K = knee(p);
        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;
        vec_all(p,:) = [s_hip, s_knee];
    end

    mean_vec = mean(vec_all,1);      % 全姿勢で平均
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;   % 単位化
    else
        mean_vec = [0 0];
    end

    % 第一象限に揃える
    Hip_dir(i)  = abs(mean_vec(1));
    Knee_dir(i)= abs(mean_vec(2));
    type_i_all(i) = type_i;
end

% ---- 散布図作成 ----
figure('Color','w'); hold on;

cmap_joint = [0 0 1;   % 1=青 -> Hip
              0 0.5 0;   % 2=緑 -> Knee
              1 0 0];  % 3=赤 -> Hip and Knee

scatter_handles = gobjects(3,1);  % 凡例用ハンドル

% ===== 2値だけで交互オフセット =====
% ---- 極座標 ----
r = sqrt(Hip_dir.^2 + Knee_dir.^2);
theta = atan2(Knee_dir, Hip_dir);

% θでソート
[theta_sorted, order] = sort(theta);

r_plot = r;

% 3値スケール
scale_values = [0.95, 1.00, 1.05];

for k = 1:length(order)

    idx = order(k);

    % 1,2,3,1,2,3,... の周期
    scale_idx = mod(k-1, 3) + 1;

    r_plot(idx) = r(idx) * scale_values(scale_idx);

end

% ---- 戻す ----
Hip_plot  = r_plot .* cos(theta);
Knee_plot = r_plot .* sin(theta);


for t = 1:3
    idx = type_i_all == t;
    scatter_handles(t) = scatter(Hip_plot(idx), Knee_plot(idx), ...
                                 50, cmap_joint(t,:), 'filled');
end


xlim([0 1.25])
ylim([0 1.25])
xlabel('Hip sensitivity', 'FontSize',16,'FontWeight','bold');
ylabel('Knee sensitivity', 'FontSize',16,'FontWeight','bold');
axis equal; grid on;
box on;

ax = gca;
ax.FontSize   = 14;
ax.FontWeight = 'bold';
ax.LineWidth  = 1.5;
ax.TickDir    = 'out';
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

% ---- 軸目盛り非表示 ----
ax.XTick = [];
ax.YTick = [];

% ---- 凡例追加 ----
legend(scatter_handles, {'Hip','Knee','Hip and Knee'}, ...
       'Location','southwest', 'FontSize',12);


% ===== PNG保存 =====
fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_scatter_only_phase1_CatA.png');
exportgraphics(gcf, fname, 'Resolution',300);

%close;  % 図を閉じる



%% scatter only phase 1 magnitude
nNeuron = length(coef(:,1));
Hip_dir  = zeros(nNeuron,1);
Knee_dir = zeros(nNeuron,1);
type_i_all = zeros(nNeuron,1);


for neuron_idx = 1:nNeuron
    fr_trial_pos = MFR_sep_pos{1, neuron_idx};  % 5×16
    FR_mat(neuron_idx,:) = mean(fr_trial_pos, 1, 'omitnan');
end
range_row = max(FR_mat, [], 2) - min(FR_mat, [], 2);
std_row   = std(FR_mat, 0, 2);


for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);
    % 1,2,3以外はスキップ
    if ~ismember(type_i, [1,2,3])
        continue
    end

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    vec_all = zeros(nPosture,2);
    for p = 1:nPosture
        H = hip(p);
        K = knee(p);

        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;

        vec_all(p,:) = [s_hip, s_knee];
    end

    mean_vec = mean(vec_all,1);      % 全姿勢で平均
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;   % 単位化
    else
        mean_vec = [0 0];
    end

    % 第一象限に揃える
    Hip_dir(i)  = abs(mean_vec(1));
    Knee_dir(i)= abs(mean_vec(2));
    type_i_all(i) = type_i;
end

% ---- 散布図作成 ----
figure('Color','w'); hold on;

cmap_joint = [0 0 1;   % 1=青 -> Hip
              0 0.5 0;   % 2=緑 -> Knee
              1 0 0];  % 3=赤 -> Hip and Knee

scatter_handles = gobjects(3,1);  % 凡例用ハンドル

% ===== 2値だけで交互オフセット =====
% ---- 極座標 ----
r = sqrt(Hip_dir.^2 + Knee_dir.^2);
theta = atan2(Knee_dir, Hip_dir);

% θでソート
[theta_sorted, order] = sort(theta);

r_plot = r;

% 3値スケール
scale_values = [0.95, 1.00, 1.05];

for k = 1:length(order)

    idx = order(k);

    % 1,2,3,1,2,3,... の周期
    scale_idx = mod(k-1, 3) + 1;

    r_plot(idx) = r(idx) * scale_values(scale_idx);

end

% ---- 戻す ----
Hip_plot  = r_plot .* cos(theta);
Knee_plot = r_plot .* sin(theta);


% ===== 全体で正規化（type別にしない） =====
rmin = min(range_row);
rmax = max(range_row);

if rmax > rmin
    range_norm = (range_row - rmin) / (rmax - rmin);
else
    range_norm = zeros(size(range_row));
end

% ===== カラーマップ作成（最大値に合わせる） =====
nColor = 256;

% 淡い色 → 濃い色 へ
cmap_blue  = [linspace(0.85,0,nColor)', ...
              linspace(0.90,0,nColor)', ...
              linspace(1.00,0.6,nColor)'];

cmap_green = [linspace(0.85,0,nColor)', ...
              linspace(1.00,0.5,nColor)', ...
              linspace(0.85,0,nColor)'];

cmap_red   = [linspace(1.00,0.6,nColor)', ...
              linspace(0.85,0,nColor)', ...
              linspace(0.85,0,nColor)'];

scatter_handles = gobjects(3,1);

for t = 1:3
    
    idx = find(type_i_all == t);
    if isempty(idx)
        continue
    end
    
    % 全体正規化値をカラーマップindexへ変換
    color_idx = round(range_norm(idx) * (nColor-1)) + 1;
    
    colors = zeros(length(idx),3);
    
    switch t
        case 1
            colors = cmap_blue(color_idx,:);
        case 2
            colors = cmap_green(color_idx,:);
        case 3
            colors = cmap_red(color_idx,:);
    end
    
    scatter_handles(t) = scatter(Hip_plot(idx), ...
                                 Knee_plot(idx), ...
                                 50, colors, 'filled');
    main_ax = gca;   % ← メイン軸を保存
end

xlim([0 1.25])
ylim([0 1.25])
xlabel('Hip sensitivity', 'FontSize',16,'FontWeight','bold');
ylabel('Knee sensitivity', 'FontSize',16,'FontWeight','bold');
axis equal; grid on;
box on;

ax = gca;
ax.FontSize   = 14;
ax.FontWeight = 'bold';
ax.LineWidth  = 1.5;
ax.TickDir    = 'out';
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

% ---- 軸目盛り非表示 ----
ax.XTick = [];
ax.YTick = [];

% ===== 3つのカラーバーを追加 =====

% 共通スケール
caxis([rmin rmax])

% ----- 1: Hip (青) -----
ax1 = axes('Position',[0.88 0.65 0.02 0.25], ...
           'Visible','off');
colormap(ax1, cmap_blue)
caxis(ax1, [rmin rmax])
cb1 = colorbar(ax1, 'Position',[0.90 0.65 0.02 0.25]);
cb1.Label.String = 'Range (Hip)';
cb1.FontSize = 10;

% ----- 2: Knee (緑) -----
ax2 = axes('Position',[0.88 0.35 0.02 0.25], ...
           'Visible','off');
colormap(ax2, cmap_green)
caxis(ax2, [rmin rmax])
cb2 = colorbar(ax2, 'Position',[0.90 0.35 0.02 0.25]);
cb2.Label.String = 'Range (Knee)';
cb2.FontSize = 10;

% ----- 3: Hip & Knee (赤) -----
ax3 = axes('Position',[0.88 0.05 0.02 0.25], ...
           'Visible','off');
colormap(ax3, cmap_red)
caxis(ax3, [rmin rmax])
cb3 = colorbar(ax3, 'Position',[0.90 0.05 0.02 0.25]);
cb3.Label.String = 'Range (Hip & Knee)';
cb3.FontSize = 10;




% ===== PNG保存 =====
set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [5 5 20 20]);


fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_scatter_only_phase1_CatA_magnitude.png');
exportgraphics(gcf, fname, 'Resolution',300);

%close;  % 図を閉じる



%% scatter only phase 1
nNeuron = length(coef(:,1));
Hip_dir  = zeros(nNeuron,1);
Knee_dir = zeros(nNeuron,1);
type_i_all = zeros(nNeuron,1);

for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);
    % 1,2,3以外はスキップ
    if ~ismember(type_i, [1,2,3])
        continue
    end

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    vec_all = zeros(nPosture,2);
    for p = 1:nPosture
        H = hip(p);
        K = knee(p);

        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;

        vec_all(p,:) = [s_hip, s_knee];
    end

    mean_vec = mean(vec_all,1);      % 全姿勢で平均
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;   % 単位化
    else
        mean_vec = [0 0];
    end

    % 第一象限に揃える
    Hip_dir(i)  = abs(mean_vec(1));
    Knee_dir(i)= abs(mean_vec(2));
    type_i_all(i) = type_i;
end

% ---- 散布図作成 ----
figure('Color','w'); hold on;

cmap_joint = [0 0 1;   % 1=青 -> Hip
              0 0.5 0;   % 2=緑 -> Knee
              1 0 0];  % 3=赤 -> Hip and Knee

scatter_handles = gobjects(3,1);  % 凡例用ハンドル

% ===== 2値だけで交互オフセット =====
% ---- 極座標 ----
r = sqrt(Hip_dir.^2 + Knee_dir.^2);
theta = atan2(Knee_dir, Hip_dir);

% θでソート
[theta_sorted, order] = sort(theta);

r_plot = r;

% 3値スケール
scale_values = [0.95, 1.00, 1.05];

for k = 1:length(order)

    idx = order(k);

    % 1,2,3,1,2,3,... の周期
    scale_idx = mod(k-1, 3) + 1;

    r_plot(idx) = r(idx) * scale_values(scale_idx);

end

% ---- 戻す ----
Hip_plot  = r_plot .* cos(theta);
Knee_plot = r_plot .* sin(theta);


for t = 1:3
    idx = type_i_all == t;
    scatter_handles(t) = scatter(Hip_plot(idx), Knee_plot(idx), ...
                                 50, cmap_joint(t,:), 'filled');
end


xlim([0 1.25])
ylim([0 1.25])
xlabel('Hip sensitivity', 'FontSize',16,'FontWeight','bold');
ylabel('Knee sensitivity', 'FontSize',16,'FontWeight','bold');
axis equal; grid on;
box on;

ax = gca;
ax.FontSize   = 14;
ax.FontWeight = 'bold';
ax.LineWidth  = 1.5;
ax.TickDir    = 'out';
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

% ---- 軸目盛り非表示 ----
ax.XTick = [];
ax.YTick = [];

% ---- 凡例追加 ----
legend(scatter_handles, {'Hip','Knee','Hip and Knee'}, ...
       'Location','southwest', 'FontSize',12);


% ===== PNG保存 =====
fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_scatter_only_phase1_CatA.png');
exportgraphics(gcf, fname, 'Resolution',300);

%close;  % 図を閉じる
%% scatter only phase 1 magnitude black and white
nNeuron = length(coef(:,1));
Hip_dir  = zeros(nNeuron,1);
Knee_dir = zeros(nNeuron,1);
type_i_all = zeros(nNeuron,1);


for neuron_idx = 1:nNeuron
    fr_trial_pos = MFR_sep_pos{1, neuron_idx};  % 5×16
    FR_mat(neuron_idx,:) = mean(fr_trial_pos, 1, 'omitnan');
end
range_row = max(FR_mat, [], 2) - min(FR_mat, [], 2);
std_row   = std(FR_mat, 0, 2);


for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);
    % 1,2,3以外はスキップ
    if ~ismember(type_i, [1,2,3])
        continue
    end

    beta_hip  = coef(i,2);
    beta_knee = coef(i,3);
    beta_int  = coef(i,4);

    vec_all = zeros(nPosture,2);
    for p = 1:nPosture
        H = hip(p);
        K = knee(p);

        s_hip  = beta_hip  + beta_int * K;
        s_knee = beta_knee + beta_int * H;

        vec_all(p,:) = [s_hip, s_knee];
    end

    mean_vec = mean(vec_all,1);      % 全姿勢で平均
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;   % 単位化
    else
        mean_vec = [0 0];
    end

    % 第一象限に揃える
    Hip_dir(i)  = abs(mean_vec(1));
    Knee_dir(i)= abs(mean_vec(2));
    type_i_all(i) = type_i;
end

% ---- 散布図作成 ----
figure('Color','w'); hold on;

cmap_joint = [0 0 1;   % 1=青 -> Hip
              0 0.5 0;   % 2=緑 -> Knee
              1 0 0];  % 3=赤 -> Hip and Knee

scatter_handles = gobjects(3,1);  % 凡例用ハンドル

% ===== 2値だけで交互オフセット =====
% ---- 極座標 ----
r = sqrt(Hip_dir.^2 + Knee_dir.^2);
theta = atan2(Knee_dir, Hip_dir);

% θでソート
[theta_sorted, order] = sort(theta);

r_plot = r;

% 3値スケール
scale_values = [0.95, 1.00, 1.05];

for k = 1:length(order)

    idx = order(k);

    % 1,2,3,1,2,3,... の周期
    scale_idx = mod(k-1, 3) + 1;

    r_plot(idx) = r(idx) * scale_values(scale_idx);

end

% ---- 戻す ----
Hip_plot  = r_plot .* cos(theta);
Knee_plot = r_plot .* sin(theta);


% ===== 全体で正規化（type別にしない） =====
% ===== 全体で正規化 =====
rmin = min(range_row);
rmax = max(range_row);

if rmax > rmin
    range_norm = (range_row - rmin) / (rmax - rmin);
else
    range_norm = zeros(size(range_row));
end

% ===== 白黒カラーマップ =====
nColor = 256;
cmap_gray = flipud(gray(nColor));   % ← ここに置く


scatter_handles = gobjects(3,1);


for t = 1:3
    
    idx = find(type_i_all == t);
    if isempty(idx)
        continue
    end
    
    scatter_handles(t) = scatter(Hip_plot(idx), ...
                                 Knee_plot(idx), ...
                                 50, ...
                                 range_row(idx), ...   % ← 数値を渡す
                                 'filled');
end


xlim([0 1.25])
ylim([0 1.25])
xlabel('Hip sensitivity', 'FontSize',16,'FontWeight','bold');
ylabel('Knee sensitivity', 'FontSize',16,'FontWeight','bold');
axis equal; grid on;
box on;

ax = gca;
ax.FontSize   = 14;
ax.FontWeight = 'bold';
ax.LineWidth  = 1.5;
ax.TickDir    = 'out';
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left'; 

% ---- 軸目盛り非表示 ----
ax.XTick = [];
ax.YTick = [];

% ===== 3つのカラーバーを追加 =====
colormap(cmap_gray)
caxis([rmin rmax])
cb = colorbar;
cb.Label.String = 'Range';
cb.FontSize = 12;





% ===== PNG保存 =====
set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [5 5 20 20]);


fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_scatter_only_phase1_CatA_magnitude_BW.png');
exportgraphics(gcf, fname, 'Resolution',300);

%close;  % 図を閉じる



%% Figure 7
% ===== Figure設定 =====
figure('Units','centimeters','Position',[5 5 16 8],'Color','w');
t = tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

set(groot,'defaultAxesFontName','Arial');
set(groot,'defaultTextFontName','Arial');

% ===== 共通準備 =====

% type別個数
n1 = sum(type_i_all==1);
n2 = sum(type_i_all==2);
n3 = sum(type_i_all==3);

% 色定義
color_hip   = [0.0 0.0 1.0];
color_knee  = [0.0 0.7 0.7];
color_both  = [0.8 0.0 0.8];

% =========================
% ===== 1タイル目：方向のみ =====
% =========================
nexttile; hold on;

idx1 = type_i_all==1;
idx2 = type_i_all==2;
idx3 = type_i_all==3;

h1 = scatter(Hip_plot(idx1),Knee_plot(idx1),25,'o', ...
             'MarkerFaceColor',color_hip,'MarkerEdgeColor','k');

h2 = scatter(Hip_plot(idx2),Knee_plot(idx2),25,'s', ...
             'MarkerFaceColor',color_knee,'MarkerEdgeColor','k');

h3 = scatter(Hip_plot(idx3),Knee_plot(idx3),25,'^', ...
             'MarkerFaceColor',color_both,'MarkerEdgeColor','k');
xlim([0 1.25])
ylim([0 1.25])

axis square
box on
grid on
set(gca,'XTick',[],'YTick',[])

xlabel('Hip sensitivity','FontWeight','bold')
ylabel('Knee sensitivity','FontWeight','bold')

set(gca,'FontName','Arial','FontSize',11,'LineWidth',1.2)

legend([h1 h2 h3], ...
    {sprintf('Hip (n=%d)',n1), ...
     sprintf('Knee (n=%d)',n2), ...
     sprintf('Hip & Knee (n=%d)',n3)}, ...
     'Location','southwest','FontSize',6,'FontWeight','bold');
title('Cat A','FontName','Arial','FontWeight','bold','FontSize',12)

% =========================
% ===== 2タイル目：白黒Magnitude =====
% =========================
ax2 = nexttile; 
hold on;


% 正規化
rmin = min(range_row);
rmax = max(range_row);

colormap(flipud(gray))
caxis([rmin rmax])

h1 = scatter(ax2,Hip_plot(idx1),Knee_plot(idx1),25,range_row(idx1), ...
             'o','filled');
h2 = scatter(ax2,Hip_plot(idx2),Knee_plot(idx2),25,range_row(idx2), ...
             's','filled');
h3 = scatter(ax2,Hip_plot(idx3),Knee_plot(idx3),25,range_row(idx3), ...
             '^','filled');
axis square

xlim([0 1.25])
ylim([0 1.25])

box on
grid on
set(gca,'XTick',[],'YTick',[])

xlabel('Hip sensitivity','FontWeight','bold')
ylabel('Knee sensitivity','FontWeight','bold')

set(gca,'FontName','Arial','FontSize',11,'LineWidth',1.2,'FontWeight','bold')

title('Cat A','FontName','Arial','FontWeight','bold','FontSize',12)

cb = colorbar;
cb.Layout.Tile = 'east';

% ===== EMF保存 =====
set(gcf,'Renderer','painters');   % ベクター形式

fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
    'Hip_Knee_direction_and_magnitude_CatA.emf');

exportgraphics(gcf,fname,'Resolution',600);

%% 

cofficient_multi_hip_knee_inter_cross;
hip_joint_angle_ori(:,1);
knee_joint_angle_ori(:,1);
neuron_type_only_joint = heatmap_data_particular_R_3(:,1)+heatmap_data_particular_R_3(:,2)+heatmap_data_particular_R_3(:,3);

for i = 1:length(cofficient_multi_hip_knee_inter_plus)
    a = cofficient_multi_hip_knee_inter_plus(i,2);
    b = cofficient_multi_hip_knee_inter_plus(i,3);

    slope_vec(i,:)      = [a, b];
    unit_slope_vec(i,:) = [a, b] / norm([a, b]);
    slope_mag(i)        = norm([a, b]);

end

%
neuron_type_only_joint = heatmap_data_particular_R_3(:,1)+heatmap_data_particular_R_3(:,2)+heatmap_data_particular_R_3(:,3);
cmap_joint = [
    0.6 0.6 0.6;   % 0 no modulation
    0   0   1;     % 1 only hip
    0   0.5   0;     % 2 only knee
    1   0   0;     % 3 all / strong
];
%


nNeuron = length(newSpkTime);


figure('Color','w'); hold on
axis equal
box on

for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);

    beta_hip  = cofficient_multi_hip_knee_inter_plus(i,2);
    beta_knee = cofficient_multi_hip_knee_inter_plus(i,3);

    quiver(0, 0, beta_hip, beta_knee, 0, ...
        'LineWidth',1.5, ...
        'Color', cmap_joint(type_i+1,:));
end

xlabel('Hip sensitivity (\beta_{hip})');
ylabel('Knee sensitivity (\beta_{knee})');
title('Joint sensitivity vectors (magnitude + direction)');
grid on

% ---- 保存 ----
fname = fullfile(hip_and_knee_folder_plus, 'JointSensitivity_VectorMagnitude.png');
exportgraphics(gcf, fname, 'Resolution', 300);


figure('Color','w'); hold on
axis equal
box on

for i = 1:nNeuron
    type_i = neuron_type_only_joint(i);

    a = cofficient_multi_hip_knee_inter_plus(i,2);
    b = cofficient_multi_hip_knee_inter_plus(i,3);

    mag = norm([a b]);
    if mag == 0
        continue
    end

    quiver(0, 0, a/mag, b/mag, 0, ...
        'LineWidth',1.5, ...
        'Color', cmap_joint(type_i+1,:));
end

xlabel('Hip direction');
ylabel('Knee direction');
title('Preferred joint direction (unit vectors)');
grid on

% ---- 保存 ----
fname = fullfile(hip_and_knee_folder_plus, 'JointSensitivity_UnitVector.png');
exportgraphics(gcf, fname, 'Resolution', 300);




%% Preprocessing for PCA
Ex3_firing_rate_sep_each_trial;

Ex3_firing_rate_sep;


time_window_each_Ex3_sep;
Firing_rate_sep_zscore_each_trial;
MFR_sep_zscore_average_trial;
Firing_rate_sep_tri_pos_zscore;

% not normalized
for tr = 1:5
figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end

%line change for firing rate for heatmap time
static_phase_firing_rate_for_psth = Ex3_firing_rate_sep(tr,:);
% 1×16のセル配列を4×4に変換
static_phase_firing_rate_for_psth_notnormalized_rechange = reshape(static_phase_firing_rate_for_psth, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
static_phase_firing_rate_for_psth_notnormalized_rechange = static_phase_firing_rate_for_psth_notnormalized_rechange';
% 縦に並べて16×1のセル配列に変換
static_phase_firing_rate_for_psth_notnormalized_rechange = reshape(static_phase_firing_rate_for_psth_notnormalized_rechange, [length(Postures_name), 1]);

%line up posture name
Postures_name;
Postures_name_rechange = reshape(Postures_name, [length(Postures_name)/4, length(Postures_name)/4]);
Postures_name_rechange = Postures_name_rechange';
Postures_name_rechange = reshape(Postures_name_rechange,[length(Postures_name), 1]);


if strcmp(angle_definition, 'relative_normalized_centering_model_error_evaluation')
    experiment3_static_folder_select = angle_related_folder;
elseif strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    experiment3_static_folder_select = angle_related_folder;
else

end
experiment3_firingrate_heatmap_pca = createNamedFolder(experiment3_static_folder_select, 'PCA');
Preprocessing_for_pca = createNamedFolder(experiment3_firingrate_heatmap_pca, 'Preprocessing');
PCA_original_rowdata_folder = createNamedFolder(Preprocessing_for_pca, 'Not_normalized');

for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Posture_heatmap_time{pos},time_window_each_Ex3_sep(1:end-1),length(newSpkTime):-1,static_phase_firing_rate_for_psth_notnormalized_rechange{pos,1});
    caxis([0 140]);
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_heatmap_time(pos));
end


cellfun(@(x) caxis(x,[0 140]),Posture_heatmap_time(1:16));
cellfun(@(x) xlabel(x,'Time (s)'),Posture_heatmap_time(1:16));
cellfun(@(x) ylabel(x,'Single-unit'),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[min(time_window_each_Ex3_sep) max(time_window_each_Ex3_sep)]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,10,"points")
sgtitle(['Trial ' num2str(tr) ' not normalized' ],'FontSize', 18, 'FontWeight', 'bold');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_original_rowdata_folder, ['All_Posture_not_normalized_trial' num2str(tr) '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden
end

%% single endpoint specific analysis
% check contract analysis
MFR_sep_pos;
experiment3_multcomparefolder = createNamedFolder(experiment3_static_folder_select, 'Multcompare');
Multcompare_p_map_all_neuron = cell(length(newSpkCH),1);
for neuron =1:length(newSpkCH)
%neuron = 4;
data = MFR_sep_pos{1,neuron};  % 5*16 × 1 ベクトル
% -------------------------------------------
% 多重比較の結果をカラーマップに表示
% 0.05 以下 = 緑, それ以外 = 青
% 各セルに p値を表示
% -------------------------------------------

% ---- 1. ANOVAと多重比較 ----
[p, tbl, stats] = anova1(data, [], 'off');
results = multcompare(stats, 'CType', 'tukey-kramer');

nPosture = size(data,2);
pMat = nan(nPosture);  % NxN行列（NaNで初期化）

for i = 1:size(results,1)
    g1 = results(i,1);
    g2 = results(i,2);
    pval = results(i,6);
    pMat(g1,g2) = pval;
    pMat(g2,g1) = pval; % 対称にする
end

% ---- 2. 閾値で2値化（0.05以下=1, それ以外=0）
binaryMat = nan(size(pMat));
binaryMat(pMat <= 0.05) = 1;  % 有意
binaryMat(pMat > 0.05)  = 0;  % 非有意
Multcompare_p_map_all_neuron{neuron,1} =  binaryMat;
%{
% ---- 3. カラーマップ設定 ----
figure;
imagesc(binaryMat);
colormap([0 0 1; 0 1 0]);   % 0=青, 1=緑
caxis([0 1]);               % カラースケールを固定
colorbar('Ticks',[0 1],'TickLabels',{'ns','p<0.05'});
axis equal tight;
xticks(1:nPosture); yticks(1:nPosture);
xlabel('Posture'); ylabel('Posture');
title(sprintf('Multcompare neuron %d', neuron));

% ---- 4. 各セルに p値を表示 ----
for i = 1:nPosture
    for j = 1:nPosture
        if ~isnan(pMat(i,j))
            if pMat(i,j) <= 0.05
                txtColor = 'k'; % 有意なら黒字
            else
                txtColor = 'w'; % 非有意なら白字
            end
            text(j,i, sprintf('%.3f', pMat(i,j)), ...
                'HorizontalAlignment','center', ...
                'FontSize',8, 'Color',txtColor);
        end
    end
end
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(experiment3_multcomparefolder, sprintf('Multcompare_neuron_%d.tif', neuron));
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden
%}
end

%% plot representative neuron to show caluculation method
bar_plot_representative_neuron = 15;
numPosture = 16; 
%calucurate mean and sd
MFR_representative_neuron_5trial = MFR_sep_pos{1,bar_plot_representative_neuron};
Multcompare_p_map_representative_neuron = Multcompare_p_map_all_neuron{bar_plot_representative_neuron,1};
% ---- 平均とSDを計算 ----
mu_representative_neuron  = mean(MFR_representative_neuron_5trial, 1, "omitnan");  
sd_representative_neuron  = std(MFR_representative_neuron_5trial, 0, 1, "omitnan"); 

figure; hold on;
b = bar(1:numPosture, mu_representative_neuron, 'FaceColor','flat'); 
er = errorbar(1:numPosture, mu_representative_neuron, sd_representative_neuron, 'k.', 'LineWidth',1.2);

b.CData = [0.6 0.6 0.6];
ylim([0 max(mu_representative_neuron+sd_representative_neuron)*1.1]); % 線を描きやすいように余裕

xlabel('Recording position');
ylabel('Mean firing rate [Hz]');
title(['Neuron #' num2str(bar_plot_representative_neuron)]);
box off;
fontsize(gcf, 15, "points");

ax = gca;
ax.XTick = 1:numPosture;                % 1〜16 の位置に目盛り
ax.XTickLabel = string(1:numPosture);   % 表示ラベルを 1〜16 にする
% --- 軸設定 ---       
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
box off; 
fontsize(gcf, 15, "points");

% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
set(gca,  'FontName', 'Arial', 'FontWeight', 'bold');
set(gca, 'XTickLabelRotation',0)
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(experiment3_multcomparefolder, ...
    'Plot mean firing rate bar neuron 15 Cat A.pdf');
print(fig, pdfFileName, '-dpdf');

%% plot representative multicompare
figure;
imagesc(Multcompare_p_map_representative_neuron);
colormap([1 1 1; 0 0 0]);
caxis([0 1]);
axis equal tight;

nPosture = size(Multcompare_p_map_representative_neuron,1);

xticks(1:nPosture);
yticks(1:nPosture);
xlabel('Recording position');
ylabel('Recording position');

xlim([0.5 numPosture+0.5]); 
ylim([0.5 numPosture+0.5]); 
title(['Neuron #' num2str(bar_plot_representative_neuron)]);

ax = gca;

% --- すべてのグリッドを OFF ---
ax.XGrid = 'off';
ax.YGrid = 'off';
ax.XMinorGrid = 'off';
ax.YMinorGrid = 'off';
hold on;

% --- セル境界をすべて実線で描く ---
for k = 0.5 : 1 : nPosture+0.5
    % 横線
    plot([0.5 nPosture+0.5], [k k], 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
    % 縦線
    plot([k k], [0.5 nPosture+0.5], 'Color', [0.7 0.7 0.7], 'LineWidth', 1);
end
% --- 軸設定 ---       
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
box off; 


hold off;
% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
set(gca,  'FontName', 'Arial', 'FontWeight', 'bold');
set(gca, 'XTickLabelRotation',0)
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(experiment3_multcomparefolder, ...
    'Multicompare neuron 15 Cat A.pdf');
print(fig, pdfFileName, '-dpdf');

%% plot representative results for malticompare 
% 各姿勢の有意差の回数
 counts = sum(Multcompare_p_map_representative_neuron==1,1);
% 正規化（設計どおり numPosture-1 で割る）
if max(counts) > 0
    normalized_counts = counts / (numPosture-1);
else
    normalized_counts = counts;
end
% ---- 平均と3SDを計算 ----
mu  = mean(normalized_counts, "omitnan");
sd  = std(normalized_counts, 0, "omitnan");
thresh = mu + 3*sd;
% ---- 判定 ----
cond_overThresh = (normalized_counts > thresh) & (normalized_counts > 0.5);
cond_over05 = (normalized_counts > 0.5);
countStrong = sum(cond_overThresh);
countOver05 = sum(cond_over05);
% ---- 色設定 (デフォルト灰色) ----
barColors = repmat([0.6 0.6 0.6], numPosture, 1);
% ★ 追加：閾値超えた部分だけ赤に変更
barColors(cond_overThresh, :) = repmat([1 0 0], sum(cond_overThresh), 1);
% ---- プロット ----
b = bar(1:numPosture, normalized_counts, 'FaceColor','flat'); hold on;
b.CData = barColors;
% 閾値ラインを描画
plot([0, numPosture+1], [thresh, thresh], '--r', 'LineWidth', 1.2);
xticks(1:nPosture);
xlim([0.5 numPosture+0.5]); 
ylim([0 1]);
xlabel('Recording position');
ylabel('Numbar of significant');
fontsize(gcf, 15, "points");
ax = gca;
% --- 軸設定 ---       
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
box off; 


hold off;
% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
set(gca,  'FontName', 'Arial', 'FontWeight', 'bold');
set(gca, 'XTickLabelRotation',0)
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(experiment3_multcomparefolder, ...
    'Multicompare significant count neuron 15 Cat A.pdf');
print(fig, pdfFileName, '-dpdf');



%% 
% 前提: Multcompare_p_map_all_neuron が存在
Multcompare_p_map_all_neuron;
numNeurons = numel(Multcompare_p_map_all_neuron);   % = 72
numPosture = 16;                  
plotsPerPage = 12;                
rows = 3; 
cols = 4;
experiment3_bar_folder = createNamedFolder(experiment3_multcomparefolder, 'Number_of_Significant_Neurons');

% 出力用行列（Flag(4/0), ConditionID(1..16 or 0)）
StrongNeuronMatrix = zeros(numNeurons,2);

for nBlock = 1:ceil(numNeurons/plotsPerPage)
    fig = figure;
    tiledlayout(rows, cols, "TileSpacing","compact","Padding","compact");

    neuronRange = (nBlock-1)*plotsPerPage + 1 : min(nBlock*plotsPerPage, numNeurons);

    for i = 1:numel(neuronRange)
        n = neuronRange(i);

        binMat = Multcompare_p_map_all_neuron{n};
        if isempty(binMat)
            nexttile; axis off;
            continue;
        end

        % 各姿勢の有意差の回数
        counts = sum(binMat==1,1);

        % 正規化（設計どおり numPosture-1 で割る）
        if max(counts) > 0
            normalized_counts = counts / (numPosture-1);
        else
            normalized_counts = counts;
        end

        % ---- 平均と3SDを計算 ----
        mu  = mean(normalized_counts, "omitnan");
        sd  = std(normalized_counts, 0, "omitnan");
        thresh = mu + 3*sd;

        % ---- 判定 ----
        cond_overThresh = (normalized_counts > thresh) & (normalized_counts > 0.5);
        cond_over05 = (normalized_counts > 0.5);

        countStrong = sum(cond_overThresh);
        countOver05 = sum(cond_over05);

        % ---- 色設定 (デフォルト灰色) ----
        barColors = repmat([0.6 0.6 0.6], numPosture, 1);

        % 条件を満たす場合は1列目に4を、2列目に条件番号を入れる
        if (countStrong == 1) && (countOver05 == 1)
            % 赤条件：3SD超え & 0.5超え & それが唯一
            idxCond = find(cond_overThresh, 1, 'first');
            barColors(idxCond,:) = [1 0 0];

            % 保存（要求どおり）
            StrongNeuronMatrix(n,1) = 4;
            StrongNeuronMatrix(n,2) = idxCond;
        else
            % 条件を満たさない場合は (0,0) のまま
            StrongNeuronMatrix(n,1) = 0;
            StrongNeuronMatrix(n,2) = 0;
        end

        % ---- プロット ----
        nexttile;
        b = bar(1:numPosture, normalized_counts, 'FaceColor','flat'); hold on;
        b.CData = barColors;
        % 閾値ラインを描画
        plot(1:numPosture, repmat(thresh,1,numPosture), '--r', 'LineWidth', 1.2);

        ylim([0 1]);
        xlabel('Posture'); ylabel('Norm count');
        if StrongNeuronMatrix(n,1) == 4
            title(sprintf('Neuron %d  <-- strong at cond %d', n, StrongNeuronMatrix(n,2)));
        else
            title(sprintf('Neuron %d', n));
        end
        set(gca,'FontSize',10);
    end

    sgtitle(sprintf('Number of Significant Neurons %d–%d', neuronRange(1), neuronRange(end)), 'FontSize',14);
    set(fig, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % 保存 (TIFF)
    tifFileName = fullfile(experiment3_bar_folder, sprintf('Significant_neuron_all_page_%d.tif', nBlock));
    print(fig, tifFileName, '-dtiff', '-r300');

    % 図を閉じる（現在の図のみ）
    close(fig);
end

% 結果の確認（表示・ファイル出力）
disp('StrongNeuronMatrix (Flag(4/0), ConditionID):');
disp(StrongNeuronMatrix);

%% Figure 8
%single endpoint neuron
% =========================
% 保存フォルダ指定
% =========================

%StrongNeuronMatrix
particular_R_angle_related_neuron;


save_base_folder = fullfile(experiment3_folder, 'FR_Map_joint_angle');
if ~exist(save_base_folder,'dir')
    mkdir(save_base_folder);
end

% You need to MatPlotLib "Perceptually Uniform" Colormaps tool box
% --- 座標 ---
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);
% =========================
% 指定ニューロン
% =========================
neuron_pair = [51 20 15 1];   % ←ここに表示したい4つを指定




figure('Units','centimeters','Position',[5 5 17 16]);
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

for k = 1:4
    neuron_idx = neuron_pair(k);
    nexttile
    hold on;
    axis equal;

   
    % ===== 軸ラベル =====
    if k == 3   % 2行1列目のみラベル表示
    
        xlabel('Hip joint angle [degree]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8); 
    
        ylabel('Knee joint angle [degree]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8);  

    else
        xlabel('')
        ylabel('')
    end  

    xlim([20 120])
    ylim([40 140])
    xticks(20:20:120);
    yticks(40:20:140);

    % =========================
    % データ
    % =========================
    firing_rate_mean = mean(MFR_sep_pos{1, neuron_idx}, 1);

    % ===== カラースケール =====
    max_val = max(firing_rate_mean, [], 'all');
    if max_val > 100
        ylim_fig = [0 120];
    elseif max_val > 80
        ylim_fig = [0 100];
    elseif max_val > 60
        ylim_fig = [0 80];
    elseif max_val > 40
        ylim_fig = [0 60];
    elseif max_val > 20
        ylim_fig = [0 40];
    elseif max_val > 10
        ylim_fig = [0 20];
    elseif max_val > 5
        ylim_fig = [0 10];
    elseif max_val > 1
        ylim_fig = [0 5];
    else
        ylim_fig = [0 1];
    end

    % =========================
    % プロット
    % =========================
    scatter(X, Y, 20, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');

    colormap(viridis);
    caxis(ylim_fig);
  
    % ===== カラーバー =====
    cb = colorbar;
    set(cb, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8)
    
    % ===== タイトル =====
    title(sprintf('Cat A Neuron #%d', neuron_idx), ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8);
    
    % =========================
    % 姿勢ラベル
    % =========================
    
    target_pos = StrongNeuronMatrix(neuron_idx,2);  % 強く反応したポジション

    for j = 1:length(X)

    % ===== 色設定 =====
    if j == target_pos
        txtColor = [1.0 0.6 0.0];   % オレンジ
    else
        txtColor = 'k';             % 黒
    end

    % ===== 位置微調整 =====
    if j == 3
        text(X(j)+1, Y(j)+4, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 6, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    else
        text(X(j)+1, Y(j)-3, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 6, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    end
    end
    % ===== 軸目盛り =====
    set(gca, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8, ...,
        'TickDir','out')   % ← 追加
end

print(gcf, fullfile(save_base_folder, ...
    'FR_Map_CatA_single_endpoint_neuron.emf'), ...
    '-dmeta', '-r600');


%% Figure 3S
%single endpoint neuron
% =========================
% 保存フォルダ指定
% =========================

%StrongNeuronMatrix

save_base_folder = fullfile(experiment3_folder, 'FR_Map_joint_angle');
if ~exist(save_base_folder,'dir')
    mkdir(save_base_folder);
end

% You need to MatPlotLib "Perceptually Uniform" Colormaps tool box
% --- 座標 ---
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);
% =========================
% 指定ニューロン
% =========================

threshold_R = 0.4;
p_thresh = 0.001;

% set parameter

% 3列分のマトリクス作成（1:Hip, 2:Knee, 3:Interaction ）
heatmap_data_particular_R_3 = zeros(nNeurons, 3);
StrongNeuronMatrix;


% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_multi_hip_knee_inter_cross(i)) > threshold_R &&  p_value_multi_hip_knee_inter_cross(i) < p_thresh
        if All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;  % 赤
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) > p_thresh
            if abs(cofficient_multi_hip_knee_inter_cross(i,2)) < abs(cofficient_multi_hip_knee_inter_cross(i,3))
                heatmap_data_particular_R_3(i,2) = 2;
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2)) > abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
                heatmap_data_particular_R_3(i,1) = 1;
            end
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh && All_neuron_pval_by_particular_R(i,1) < p_thresh
            heatmap_data_particular_R_3(i,1) = 1;
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh &&  All_neuron_pval_by_particular_R(i,2) < p_thresh
            heatmap_data_particular_R_3(i,2) = 2;
        end
    end
end


particular_R_angle_related_neuron = heatmap_data_particular_R_3(:,1)+heatmap_data_particular_R_3(:,2)+heatmap_data_particular_R_3(:,3);
idx_1_specific_neuron = (StrongNeuronMatrix(:,1) == 4) & (particular_R_angle_related_neuron == 0);
neunum_1_specific_neuron = find(idx_1_specific_neuron == 1);
neunum_1_specific_neuron_pos = StrongNeuronMatrix(neunum_1_specific_neuron,2);
particular_R_angle_related_neuron(idx_1_specific_neuron) = 4;
StrongNeuronMatrix;



neuron_pair = [51 20 15 1];   % ←ここに表示したい4つを指定
% ① 値が4のインデックス取得
idx_4 = find(particular_R_angle_related_neuron == 4);
% ② neuron_pair を除外
idx_4_excluded = setdiff(idx_4, neuron_pair);
Specific_pos_index_FigureS3 = StrongNeuronMatrix(idx_4_excluded,2);



figure('Units','centimeters','Position',[5 5 17 17]);
tiledlayout(3,3,'TileSpacing','compact','Padding','compact');

for k = 1:length(Specific_pos_index_FigureS3)
    neuron_idx = idx_4_excluded(k);
    nexttile
    hold on;
    axis equal;

   
    % ===== 軸ラベル =====
    if k == 7   % 2行1列目のみラベル表示
    
        xlabel('Hip joint angle [degree]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',6); 
    
        ylabel('Knee joint angle [degree]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',6);  

    else
        xlabel('')
        ylabel('')
    end  

    xlim([20 120])
    ylim([40 140])
    xticks(20:20:120);
    yticks(40:20:140);

    % =========================
    % データ
    % =========================
    firing_rate_mean = mean(MFR_sep_pos{1, neuron_idx}, 1);

    % ===== カラースケール =====
    max_val = max(firing_rate_mean, [], 'all');
    if max_val > 100
        ylim_fig = [0 120];
    elseif max_val > 80
        ylim_fig = [0 100];
    elseif max_val > 60
        ylim_fig = [0 80];
    elseif max_val > 40
        ylim_fig = [0 60];
    elseif max_val > 20
        ylim_fig = [0 40];
    elseif max_val > 10
        ylim_fig = [0 20];
    elseif max_val > 5
        ylim_fig = [0 10];
    elseif max_val > 1
        ylim_fig = [0 5];
    else
        ylim_fig = [0 1];
    end

    % =========================
    % プロット
    % =========================
    scatter(X, Y, 20, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');

    colormap(viridis);
    caxis(ylim_fig);
  
    % ===== カラーバー =====
    cb = colorbar;
    range_max = ylim_fig(2);

    if range_max >= 100
        tick_step = 20;
    elseif range_max >= 20
        tick_step = 10;
    elseif range_max >= 10
        tick_step = 2;
    elseif range_max >= 5
        tick_step = 1;
    elseif range_max >= 1
        tick_step = 0.2;
    else
        tick_step = 0.1;
    end
    cb.Ticks = 0:tick_step:range_max;
    set(cb, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',6)
    
    % ===== タイトル =====
    title(sprintf('Cat A Neuron #%d', neuron_idx), ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8);
    
    % =========================
    % 姿勢ラベル
    % =========================
    
    target_pos = Specific_pos_index_FigureS3(k);  % 強く反応したポジション

    for j = 1:length(X)

    % ===== 色設定 =====
    if j == target_pos
        txtColor = [1.0 0.6 0.0];   % オレンジ
    else
        txtColor = 'k';             % 黒
    end

    % ===== 位置微調整 =====
    if j == 3
        text(X(j)+3, Y(j)+5, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 4, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    elseif j == 9
        text(X(j)+2, Y(j)+5, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 4, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    else
        text(X(j)+2, Y(j)-4.5, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 4, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    end
    end
    % ===== 軸目盛り =====
    set(gca, ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',6, ...
    'LineWidth',1.5, ...
    'TickDir','out')   % ← 追加
end

print(gcf, fullfile(save_base_folder, ...
    'FR_Map_CatA_single_endpoint_neuron_FigureS3.emf'), ...
    '-dmeta', '-r600');

%% 
%{
% plot bar
numPosture = 16;                  
plotsPerPage = 12;                
rows = 3; 
cols = 4;
experiment3_bar_MFR_folder = createNamedFolder(experiment3_static_folder_select, 'Bar_MFR');

heatmap_data_particular_R_3;
joint_modulated_neuron_particular_R_3 = heatmap_data_particular_R_3(:,1)+heatmap_data_particular_R_3(:,2)+heatmap_data_particular_R_3(:,3);
SD_value = 3;
% ±SDを超えるニューロンの記録用
singleOutlierNeurons = [];  % ニューロン番号を格納
singleOutlierConditions = []; % どの姿勢かを格納
MFR_mean_all = nan(numNeurons, numPosture);

for nBlock = 1:ceil(numNeurons/plotsPerPage)
    fig = figure;
    tiledlayout(rows, cols, "TileSpacing","compact","Padding","compact");

    neuronRange = (nBlock-1)*plotsPerPage + 1 : min(nBlock*plotsPerPage, numNeurons);

    for i = 1:numel(neuronRange)
        n = neuronRange(i);

        data_MFR = MFR_sep_pos{1,n};   % 各条件ごとの発火率（試行×条件）

        % ---- 平均とSDを計算 ----
        mu  = mean(data_MFR, 1, "omitnan");  
        sd  = std(data_MFR, 0, 1, "omitnan"); 

        % ★ 平均発火率を保存 ★
        MFR_mean_all(n,:) = mu;

        % ---- 全16条件にわたる基準値 ----
        grandMean = mean(mu, "omitnan");              
        grandSD   = std(mu, 0, "omitnan");            
        upperLine = grandMean + SD_value*grandSD;
        lowerLine = grandMean - SD_value*grandSD;
        % ---- ±SD を超えている要素を探索 ----
        outlierMask = (mu > upperLine) | (mu < lowerLine);

        % joint_modulated_neuron_particular_R_3(n) ~= 0 のときだけ記録
        if sum(outlierMask) == 1 && joint_modulated_neuron_particular_R_3(n) == 0
            % 条件を満たすニューロン
            singleOutlierNeurons(end+1) = n;
            singleOutlierConditions(end+1) = find(outlierMask);
        end

        % ---- プロット ----
        nexttile;

        % 棒ごとの色を決定
        colors = repmat([0.6 0.6 0.6], numPosture, 1);  % デフォルトはグレー
        colors(mu > upperLine, :) = repmat([1 0 0], sum(mu > upperLine), 1);  % 赤
        colors(mu < lowerLine, :) = repmat([0 0 1], sum(mu < lowerLine), 1);  % 青

        b = bar(1:numPosture, mu, 'FaceColor','flat'); hold on;
        b.CData = colors;  % 各棒の色を適用

        % エラーバー追加
        if ~all(isnan(mu))
            errorbar(1:numPosture, mu, sd, 'k', 'LineStyle','none', 'LineWidth',1);

            ymax = max([mu+sd upperLine], [], 'omitnan');
            if ~isempty(ymax) && ~isnan(ymax) && ymax > 0
                ylim([0 ymax*1.2]);
            end
        else
            ylim([0 1]);  
        end

        % ---- 全体平均 ±2SD を追加 ----
        yline(grandMean, '-r', 'LineWidth',1.5);
        yline(upperLine, '--m', 'LineWidth',1.2);
        yline(lowerLine, '--m', 'LineWidth',1.2);
        
        xlabel('Posture'); ylabel('Firing rate');

        % === タイトルの色を条件で変更 ===
        labelVal = joint_modulated_neuron_particular_R_3(n); % そのニューロンのラベル値
        switch labelVal
            case 1
                titleColor = [0 0 1]; % 青
            case 2
                titleColor = [0 0.6 0]; % 緑
            case 3
                titleColor = [1 0 0]; % 赤
            otherwise
                titleColor = [0 0 0]; % 黒（デフォルト）
        end

        title(sprintf('Neuron %d', n), 'Color', titleColor);
        set(gca,'FontSize',10);
    end
    %{
    sgtitle(sprintf('Neurons %d–%d', neuronRange(1), neuronRange(end)), 'FontSize',14);
    set(fig, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % 保存 (TIFF)
    tifFileName = fullfile(experiment3_static_folder_select, ...
        sprintf('Bar_MFR_SD_page_%d.tif', nBlock));
    print(fig, tifFileName, '-dtiff', '-r300');
    %}

    close(fig);  % ページごとに閉じる
end

%
single_pos_modulated_neuron = zeros(length(newSpkTime),1);
single_pos_modulated_neuron(singleOutlierNeurons',1) = 4;
edges = 0.5:1:16.5;  % ビンの境界（1～16を数える）
counts = histcounts(singleOutlierConditions, edges);
%}

% --------------------
threshold_R = 0.4;
p_thresh = 0.001;

% set parameter
%Excluding_joint_relted_neuron_for_endpoint_neuron = 'No';
Excluding_joint_relted_neuron_for_endpoint_neuron = 'Yes';

% 小数点を含まない文字列に変換
threshold_R_str = strrep(sprintf('%.2f', threshold_R), '.', '');  % "0.40" → "040"
p_thresh_str    = strrep(sprintf('%.3f', p_thresh), '.', '');     % "0.001" → "0001"

% 3列分のマトリクス作成（1:Hip, 2:Knee, 3:Interaction ）
heatmap_data_particular_R_3 = zeros(nNeurons, 3);
StrongNeuronMatrix;


% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_multi_hip_knee_inter_cross(i)) > threshold_R &&  p_value_multi_hip_knee_inter_cross(i) < p_thresh
        if All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;  % 赤
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data_particular_R_3(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) > p_thresh
            if abs(cofficient_multi_hip_knee_inter_cross(i,2)) < abs(cofficient_multi_hip_knee_inter_cross(i,3))
                heatmap_data_particular_R_3(i,2) = 2;
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2)) > abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
                heatmap_data_particular_R_3(i,1) = 1;
            end
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh && All_neuron_pval_by_particular_R(i,1) < p_thresh
            heatmap_data_particular_R_3(i,1) = 1;
        elseif All_neuron_pval_by_particular_R(i,3) > p_thresh &&  All_neuron_pval_by_particular_R(i,2) < p_thresh
            heatmap_data_particular_R_3(i,2) = 2;
        end
    end
end


particular_R_angle_related_neuron = heatmap_data_particular_R_3(:,1)+heatmap_data_particular_R_3(:,2)+heatmap_data_particular_R_3(:,3);
StrongNeuronMatrix;

if strcmp(Excluding_joint_relted_neuron_for_endpoint_neuron, 'Yes')
    idx_1_specific_neuron = (StrongNeuronMatrix(:,1) == 4) & (particular_R_angle_related_neuron == 0);
    neunum_1_specific_neuron = find(idx_1_specific_neuron == 1);
    neunum_1_specific_neuron_pos = StrongNeuronMatrix(neunum_1_specific_neuron,2);
    particular_R_angle_related_neuron(idx_1_specific_neuron) = 4;

    %set color for Pie chart

    % === カラー定義 ===
    colorMap = [ ...
    0.6 0.6 0.6;  % 0 → 灰
    0 0 1.0;  % 1 → 青
    0 0.5 0;  % 2 → 緑
    1.0 0.2 0.2;  % 3 → 赤
    1.0 0.6 0.0]; % 4 → オレンジ

    desired_order = [2 1 3 4 0];  % 好きな順番
    include_specifc_parameter = 'Excluding joint relted neuron for endpoint neuron';

elseif strcmp(Excluding_joint_relted_neuron_for_endpoint_neuron, 'No')
    idx_1_specific_neuron = (StrongNeuronMatrix(:,1) == 4) & (particular_R_angle_related_neuron == 0);
    particular_R_angle_related_neuron(idx_1_specific_neuron) = 4;
    %For specific and hip joint neuron
    idx_1_specific_and_hip_neuron = (StrongNeuronMatrix(:,1) == 4) & (particular_R_angle_related_neuron == 1);
    particular_R_angle_related_neuron(idx_1_specific_and_hip_neuron) = 5;
    %For specific and knee joint neuron
    idx_1_specific_and_knee_neuron = (StrongNeuronMatrix(:,1) == 4) & (particular_R_angle_related_neuron == 2);
    particular_R_angle_related_neuron(idx_1_specific_and_knee_neuron) = 6;
    %For specific and dual joint neuron
    idx_1_specific_and_hip_and_knee_neuron = (StrongNeuronMatrix(:,1) == 4) & (particular_R_angle_related_neuron == 3);
    particular_R_angle_related_neuron(idx_1_specific_and_hip_and_knee_neuron) = 7;
    neunum_1_specific_neuron = find( ...
    idx_1_specific_neuron | ...
    idx_1_specific_and_hip_neuron | ...
    idx_1_specific_and_knee_neuron | ...
    idx_1_specific_and_hip_and_knee_neuron );
    %extract position detectied by specific modulation
    neunum_1_specific_neuron_pos = StrongNeuronMatrix(neunum_1_specific_neuron,2);

    % === カラー定義 ===
    colorMap = [ ...
    0.6 0.6 0.6;  % 0 → 灰
    0 0 1.0;  % 1 → 青
    0 0.5 0;  % 2 → 緑
    1.0 0.2 0.2;  % 3 → 赤
    1.0 0.6 0.0; % 4 → オレンジ
    0.8 0.9 1.0; % 5 → usui ao
    0.8 0.5 0.8; % 6→ usui midori
    1.0 0.8 0.9; % 7→ usui orenge
    ];

    desired_order = [2 1 3 6 5 7 4 0];  % 好きな順番
    include_specifc_parameter = 'Including joint relted neuron for endpoint neuron';
else

end


% plot multicompare pattern
% --- データ ---
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);

% 点数（＝姿勢数）
nPoints = length(X);

% --- 出現回数をカウント ---
counts = histcounts(neunum_1_specific_neuron_pos, 1:nPoints+1);

figure; hold on;

for i = 1:nPoints

    % --- マーカーサイズ：カウントに応じて変更 ---
    if counts(i) > 0
        markerSize = 400 * (1 + 1*(counts(i)-1));
        scatter(X(i), Y(i), markerSize, colors(i,:), 'filled');
    else
        markerSize = 100;
        scatter(X(i), Y(i), markerSize, ...
            'MarkerEdgeColor', colors(i,:), ...
            'MarkerFaceColor', 'none', ...  % 塗りつぶし無し
            'LineWidth', 2);
    end

    % --- ラベル：カウント 1 以上のみ数字を表示 ---
    if counts(i) > 0
        labelText = sprintf('Pos%d (%d/%d)', i, counts(i),length(neunum_1_specific_neuron_pos));
        Shift_value_in_fig  = 4;
    else
        labelText = sprintf('Pos%d', i);
        Shift_value_in_fig  = 2;
    end
    if i == 2
       text(X(i), Y(i) + 5, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
    elseif i == 4
       text(X(i)+2, Y(i) + Shift_value_in_fig, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
    elseif i == 14
       text(X(i)+2, Y(i) + 3, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
   else
    % ラベルをY方向に少し上にずらして表示
    text(X(i), Y(i) + Shift_value_in_fig, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
    end
end


xlabel('Hip joint angle [degree]', 'FontSize', 12);
ylabel('Knee joint angle [degree]', 'FontSize', 12);


axis equal;
xlim([20 100])
ylim([40 130])
if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    xlim([20 120])
    ylim([50 140])
end

ax = gca;

% ===== フォント設定 =====
ax.FontWeight = 'bold';
ax.FontSize   = 20;
ax.FontName   = 'Arial';
ax.XTickLabelRotation = 0;

% ===== 主目盛り（10刻み）=====
ax.XTick = 20:10:100;
ax.YTick = 40:10:130;

% ===== 補助目盛り（5刻み）=====
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';

ax.XAxis.MinorTickValues = 20:5:100;
ax.YAxis.MinorTickValues = 40:5:130;

% ===== 軸スタイル =====
ax.TickDir   = 'out';          % メモリを外向き
ax.TickLength = [0.02 0.01];   % [主 小]
ax.LineWidth = 2;

box off
grid on
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_multcomparefolder, 'Recorded_angle_and_specific_neuron_CatA.tif');
print(gcf, tifFileName, '-dtiff', '-r300');
 % === Figureサイズ（A4正方）===
target_width  = 30;   % cm
target_height = 30;   % cm

set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);

    % === 保存 ===
    baseName = fullfile(experiment3_multcomparefolder, ...
        'Recorded_angle_and_specific_neuron_CatA');

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');




%% zscore PCA pre processing-----------------------------------------------------------------------------------------------------------------
for tr = 1:5
figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end

%line change for firing rate for heatmap time
static_phase_firing_rate_for_psth_zscore = Firing_rate_sep_tri_pos_zscore(tr,:);
% 1×16のセル配列を4×4に変換
static_phase_firing_rate_for_psth_zscore_rechange = reshape(static_phase_firing_rate_for_psth_zscore, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
static_phase_firing_rate_for_psth_zscore_rechange = static_phase_firing_rate_for_psth_zscore_rechange';
% 縦に並べて16×1のセル配列に変換
static_phase_firing_rate_for_psth_zscore_rechange = reshape(static_phase_firing_rate_for_psth_zscore_rechange, [length(Postures_name), 1]);

%line up posture name
Postures_name;
Postures_name_rechange = reshape(Postures_name, [length(Postures_name)/4, length(Postures_name)/4]);
Postures_name_rechange = Postures_name_rechange';
Postures_name_rechange = reshape(Postures_name_rechange,[length(Postures_name), 1]);

PCA_original_zscore_folder = createNamedFolder(Preprocessing_for_pca, 'Zscore');

for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Posture_heatmap_time{pos},time_window_each_Ex3_sep(1:end-1),length(newSpkTime):-1,static_phase_firing_rate_for_psth_zscore_rechange{pos,1});
    caxis([-2 2]);
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_heatmap_time(pos));
end


cellfun(@(x) caxis(x,[-2 2]),Posture_heatmap_time(1:16));
cellfun(@(x) xlabel(x,'Time (s)'),Posture_heatmap_time(1:16));
cellfun(@(x) ylabel(x,'Single-unit'),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[min(time_window_each_Ex3_sep) max(time_window_each_Ex3_sep)]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,10,"points")
sgtitle(['Trial ' num2str(tr) ' normalized by Zscore' ],'FontSize', 18, 'FontWeight', 'bold');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_original_zscore_folder, ['All_Posture_zscore_trial' num2str(tr) '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden
end

% not normalized
figure;
for i = 1:5
    Trial_heatmap_time{i} = subplot(5,1,i);hold on;
end


for tr = 1:5
    %plot firing rate
    axes(Trial_heatmap_time{tr});  % <- この行を追加
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Trial_heatmap_time{tr},1:1:length(Ex3_firing_rate_sep_each_trial{1,1}),length(newSpkTime):-1,Ex3_firing_rate_sep_each_trial{tr,1});
    caxis([0 140]);
     title(['Trial ' num2str(tr) ]);
end
x_lines = length(time_window_each_Ex3_sep)-1:length(time_window_each_Ex3_sep)-1:length(Ex3_firing_rate_sep_each_trial{1,1});
for tr = 1:5
    axes(Trial_heatmap_time{tr});  % 対象のsubplotをアクティブに
    for x = x_lines
        xline(x, 'Color', [0 0 0], 'LineWidth', 1.2, 'LineStyle', '-');
    end
end
% --- X軸ラベルを Pos1, Pos2, ... にする ---
segment_length = length(time_window_each_Ex3_sep) - 1;  % 1姿勢分のフレーム数
num_segments = floor(length(Firing_rate_sep_zscore_each_trial{1,1}) / segment_length);
xtick_vals = segment_length/2 + segment_length * (0:(num_segments - 1));  % 中心位置
xtick_labels = arrayfun(@(x) ['Pos' num2str(x)], 1:num_segments, 'UniformOutput', false);

for tr = 1:5
    set(Trial_heatmap_time{tr}, 'XTick', xtick_vals, 'XTickLabel', xtick_labels);
end


cellfun(@(x) caxis(x,[0 140]),Trial_heatmap_time(1:5));
cellfun(@(x) ylabel(x,'Single-unit'),Trial_heatmap_time(1:5));
cellfun(@(x) xlim(x,[1 length(Firing_rate_sep_zscore_each_trial{1,1})]),Trial_heatmap_time(1:5));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Trial_heatmap_time(1:5));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,10,"points")
sgtitle(['Trial ' num2str(tr) ' normalized by Zscore' ],'FontSize', 18, 'FontWeight', 'bold');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_original_rowdata_folder, ['All_Posture_all_trial.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden
% normalized Z score
figure;
for i = 1:5
    Trial_heatmap_time{i} = subplot(5,1,i);hold on;
end


for tr = 1:5
    %plot firing rate
    axes(Trial_heatmap_time{tr});  % <- この行を追加
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Trial_heatmap_time{tr},1:1:length(Firing_rate_sep_zscore_each_trial{1,1}),length(newSpkTime):-1,Firing_rate_sep_zscore_each_trial{tr,1});
    caxis([-2 2]);
     title(['Trial ' num2str(tr) ]);
end
x_lines = length(time_window_each_Ex3_sep)-1:length(time_window_each_Ex3_sep)-1:length(Firing_rate_sep_zscore_each_trial{1,1});
for tr = 1:5
    axes(Trial_heatmap_time{tr});  % 対象のsubplotをアクティブに
    for x = x_lines
        xline(x, 'Color', [0 0 0], 'LineWidth', 1.2, 'LineStyle', '-');
    end
end
% --- X軸ラベルを Pos1, Pos2, ... にする ---
segment_length = length(time_window_each_Ex3_sep) - 1;  % 1姿勢分のフレーム数
num_segments = floor(length(Firing_rate_sep_zscore_each_trial{1,1}) / segment_length);
xtick_vals = segment_length/2 + segment_length * (0:(num_segments - 1));  % 中心位置
xtick_labels = arrayfun(@(x) ['Pos' num2str(x)], 1:num_segments, 'UniformOutput', false);

for tr = 1:5
    set(Trial_heatmap_time{tr}, 'XTick', xtick_vals, 'XTickLabel', xtick_labels);
end


cellfun(@(x) caxis(x,[-2 2]),Trial_heatmap_time(1:5));
cellfun(@(x) ylabel(x,'Single-unit'),Trial_heatmap_time(1:5));
cellfun(@(x) xlim(x,[1 length(Firing_rate_sep_zscore_each_trial{1,1})]),Trial_heatmap_time(1:5));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Trial_heatmap_time(1:5));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,10,"points")
sgtitle(['Trial ' num2str(tr) ' normalized by Zscore' ],'FontSize', 18, 'FontWeight', 'bold');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_original_zscore_folder, ['All_Posture_zscore_all_trial.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden
 
%% カラーマップを用意
num_neurons = size(MFR_sep_zscore_average_trial, 2);  % 例: 72ニューロン
cmap = jet(num_neurons);

figure; hold on;

% 各ニューロンのZスコアを点線・色付きで表示
for neuron = 1:num_neurons
    plot(1:16, MFR_sep_zscore_average_trial(:,neuron), ...
        '--', 'Color', cmap(neuron,:), 'LineWidth', 1);
end

% 平均Zスコアを黒線で太く表示
mean_zscore = mean(MFR_sep_zscore_average_trial, 2);
plot(1:16, mean_zscore, 'k-', 'LineWidth', 3);

% 軸ラベル
xlabel('Posture');
ylabel('Z-score (Mean Firing Rate)');
title('Z-scored Mean Firing Rate per Posture across Neurons');

% 軸とカラーバー設定
colormap(cmap);
caxis([1 num_neurons]);
cb = colorbar;
cb.Ticks = linspace(1, num_neurons, 10);  % 表示間引き（任意）
cb.Label.String = 'Neuron Number';

% グラフィック設定
xlim([1 16]);
grid on;
set(gca, 'FontSize', 12);
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_original_zscore_folder, ['Mean_Zscore_and_Posture.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');


%% PCA
% 各点に番号を表示（1〜16）
Firing_rate_sep_tri_pos_zscore;
% M: 16姿勢 × 72ニューロンの平均発火率行列
MFR_sep_zscore_average_trial = zeros(16, length(newSpkCH));

% 除外したいニューロン番号（インデックス）
exclude_idx = [];

if isempty(exclude_idx)
    folder_name = 'PCA';  % 除外なしの時のフォルダ名
else
    exclude_str = sprintf('%d_', exclude_idx);
    exclude_str = exclude_str(1:end-1);  % 最後の'_'を削除
    folder_name = ['PCA_Remove_' exclude_str];
end

% フォルダ作成
PCA_folder = experiment3_firingrate_heatmap_pca;

% 使用するニューロンのインデックスを計算
include_idx = setdiff(1:length(newSpkCH), exclude_idx);

% Mを構築
MFR_sep_zscore_average_trial = zeros(16, length(include_idx));
for k = 1:length(include_idx)
    i = include_idx(k);
    MFR_sep_zscore_average_trial(:,k) = mean(MFR_sep_zscore_pos{1,i}, 1);  % 各ニューロンに対応
end

PCA_martix = MFR_sep_zscore_average_trial;

[coeff, score, latent, tsquared, explained,mu] = pca(PCA_martix);

% プロット対象PCの組み合わせ
pc_pairs = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];

% 16色のカラーマップを作成
colors = jet(16);  % 16x3のRGB行列

figure;
bar(explained, 'FaceColor', [0.2 0.6 0.8]);
xlabel('Principal Component');
ylabel('Explained Variance (%)');
title('Explained Variance by Principal Components');
ylim([0, max(explained)*1.2]);  % 上に余白を作る

% 棒グラフの上に数値を表示
textPositionsY = explained + max(explained)*0.02;  % 少し上にずらす
for i = 1:length(explained)
    text(i, textPositionsY(i), sprintf('%.1f%%', explained(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 10);
end

fontsize(gcf, 20, "points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_folder,'explained_variance_bar.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

% サブプロットで総当たり描画
figure;
for i = 1:size(pc_pairs, 1)
    pc_x = pc_pairs(i, 1);
    pc_y = pc_pairs(i, 2);

    subplot(2, 3, i);
    scatter(score(:, pc_x), score(:, pc_y), 80, 'filled');
    xlabel(['PC' num2str(pc_x) ' (' num2str(explained(pc_x), '%.1f') '%)']);
    ylabel(['PC' num2str(pc_y) ' (' num2str(explained(pc_y), '%.1f') '%)']);
    title(['PC' num2str(pc_x) ' vs PC' num2str(pc_y)]);
    grid on;
    axis equal;
    hold on;

    % 16姿勢ごとにラベルの色を変える
    
    colors = jet(16);
    for j = 1:16
        text(score(j, pc_x), score(j, pc_y), num2str(j), ...
            'FontSize', 10, 'FontWeight', 'bold', ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
            'Color', 'w', 'BackgroundColor', colors(j,:), 'Margin', 1);
    end
    
    
end

% 除去ニューロン情報をタイトルの1行目に追加
if ~isempty(exclude_idx)
    removed_str = sprintf('%d, ', exclude_idx);
    removed_str = removed_str(1:end-2);  % 最後のカンマ削除
    sgtitle({['\color{blue}Removed neuron(s): ', removed_str]; ...
             '神経活動のPCA総当たりプロット'}, ...
             'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'tex');
else
    sgtitle('神経活動のPCA総当たりプロット', ...
            'FontSize', 18, 'FontWeight', 'bold');
end
fontsize(gcf, 20, "points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(PCA_folder,'PCA_normalized.tif');
print(gcf, tifFileName, '-dtiff', '-r300');


%% 3D plot
figure;
fullJet = turbo(256);
idx = round(linspace(1,256,16));
colors = fullJet(idx,:);

% 3D散布図
scatter3(score(:,1), score(:,2), score(:,3), ...
    100, colors(1:16,:), 'filled');
grid on;
axis equal;
xlabel(['PC1 (' num2str(explained(1), '%.1f') '%)']);
ylabel(['PC2 (' num2str(explained(2), '%.1f') '%)']);
zlabel(['PC3 (' num2str(explained(3), '%.1f') '%)']);
view(45, 25);  % 見やすい角度に調整

% ラベルを各点に表示
hold on;
%
for j = 1:16
    text(score(j,1), score(j,2), score(j,3), num2str(j), ...
        'FontSize', 10, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'Color', 'w', 'BackgroundColor', colors(j,:), ...
        'Margin', 1);
end


% 除去ニューロンの情報をタイトルに表示（オプション）
if ~isempty(exclude_idx)
    removed_str = sprintf('%d, ', exclude_idx);
    removed_str = removed_str(1:end-2);  % 最後のカンマ削除
    title({['Removed neuron(s): ' removed_str], '3D PCA Plot'}, ...
          'FontSize', 16, 'FontWeight', 'bold');
end

fontsize(gcf, 14, "points");
set(gcf, 'Units', 'normalized', 'Position', [0.2, 0.2, 0.6, 0.6]);
tifFileName3D = fullfile(PCA_folder, 'PCA_3D_PC123.tif');
print(gcf, tifFileName3D, '-dtiff', '-r300');

%% 
figure;
fullJet = turbo(256);
idx = round(linspace(1,256,16));
colors = fullJet(idx,:);

% =========================
% 3D散布図
% =========================
scatter3(score(:,1), score(:,2), score(:,3), ...
    120, colors(1:16,:), 'filled');
grid on;
axis equal;

xlabel(['PC1 (' num2str(explained(1), '%.1f') '%)'], ...
    'FontSize',18,'FontWeight','bold','FontName','Arial');
ylabel(['PC2 (' num2str(explained(2), '%.1f') '%)'], ...
    'FontSize',18,'FontWeight','bold','FontName','Arial');
zlabel(['PC3 (' num2str(explained(3), '%.1f') '%)'], ...
    'FontSize',18,'FontWeight','bold','FontName','Arial');

view(45, 25);

% =========================
% 軸設定（太字・太線）
% =========================
ax = gca;
ax.FontSize   = 16;
ax.FontWeight = 'bold';
ax.FontName   = 'Arial';
ax.LineWidth  = 2;        % 軸の太さ
ax.TickDir    = 'out';

% =========================
% 丸い数字ラベル
% =========================
hold on;
for j = 1:16
    text(score(j,1), score(j,2), score(j,3), [' ' num2str(j) ' '], ...
        'FontSize',12, ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'Color','w', ...
        'BackgroundColor',colors(j,:), ...
        'Margin',4, ...              % 余白を増やす
        'EdgeColor','none', ...
        'Clipping','off');
end

% =========================
% タイトル
% =========================
if ~isempty(exclude_idx)
    removed_str = sprintf('%d, ', exclude_idx);
    removed_str = removed_str(1:end-2);
    title({['Removed neuron(s): ' removed_str], '3D PCA Plot'}, ...
        'FontSize',18,'FontWeight','bold','FontName','Arial');
end

% =========================
% Figureサイズ
% =========================
set(gcf, 'Units', 'normalized', 'Position', [0.2, 0.2, 0.6, 0.6]);

% 保存
tifFileName3D = fullfile(PCA_folder, 'PCA_3D_PC123.tif');
print(gcf, tifFileName3D, '-dtiff', '-r300');


%% Figure 9
figure;
fullJet = turbo(256);
idx = round(linspace(1,256,16));
colors = fullJet(idx,:);
% =========================
% 表示アングル設定（ここを変更すればOK）
% =========================


% ankle X axis
Ankle_Xaxis = Ankle_mean(:,1) - offset(1,1);
[~, sortIdx_X] = sort(Ankle_Xaxis,'ascend');
% ankle Y axis
Ankle_Yaxis = Ankle_mean(:,3) - offset(1,3);
[~, sortIdx_Y] = sort(Ankle_Yaxis,'ascend');

% =========================
% 3D散布図
% =========================
scatter3(score(:,1), score(:,2), score(:,3), ...
    120, colors(1:16,:), 'filled');
grid on;
axis equal;

xlabel(['PC1 (' num2str(explained(1), '%.1f') '%)'], ...
    'FontSize',18,'FontWeight','bold','FontName','Arial');
ylabel(['PC2 (' num2str(explained(2), '%.1f') '%)'], ...
    'FontSize',18,'FontWeight','bold','FontName','Arial');
zlabel(['PC3 (' num2str(explained(3), '%.1f') '%)'], ...
    'FontSize',18,'FontWeight','bold','FontName','Arial');

view(45, 25);

% =========================
% 軸設定（太字・太線）
% =========================
ax = gca;
ax.FontSize   = 16;
ax.FontWeight = 'bold';
ax.FontName   = 'Arial';
ax.LineWidth  = 2;        % 軸の太さ
ax.TickDir    = 'out';

% =========================
% 丸い数字ラベル
% =========================
hold on;
for j = 1:16
    text(score(j,1), score(j,2), score(j,3), [' ' num2str(j) ' '], ...
        'FontSize',12, ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'Color','w', ...
        'BackgroundColor',colors(j,:), ...
        'Margin',4, ...              % 余白を増やす
        'EdgeColor','none', ...
        'Clipping','off');
end

% =========================
% タイトル
% =========================
if ~isempty(exclude_idx)
    removed_str = sprintf('%d, ', exclude_idx);
    removed_str = removed_str(1:end-2);
    title({['Removed neuron(s): ' removed_str], '3D PCA Plot'}, ...
        'FontSize',18,'FontWeight','bold','FontName','Arial');
end

% =========================
% Figureサイズ
% =========================
set(gcf, 'Units', 'normalized', 'Position', [0.2, 0.2, 0.6, 0.6]);

% 保存
tifFileName3D = fullfile(PCA_folder, 'PCA_3D_PC123.tif');
print(gcf, tifFileName3D, '-dtiff', '-r300');


%% Figure 9: PCA 3D Scatter Plot (Refined for Reviewer)
% ========================================================
% 姿勢グループの定義（ソート順に基づいて4つずつ割り当て）
% ========================================================
az_angle = 45;   % 水平回転
el_angle = 20;   % ← 低くする（5〜15がおすすめ）

X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);

% hip joint
Ankle_Xaxis = Ankle_mean(:,1) - offset(1,1);
[~, sortIdx_X] = sort(X,'ascend');
% knee joint
Ankle_Yaxis = Ankle_mean(:,3) - offset(1,3);
[~, sortIdx_Y] = sort(Y,'ascend');



% 16姿勢を2グループ（8点×2種類）に分ける
base_groups_2 = [repmat(1,1,8), repmat(2,1,8)]; 

% (A) 足首 X軸のソート順に基づく2グループ分け
group_logic_X = zeros(1, 16);
group_logic_X(sortIdx_X) = base_groups_2;

% (B) 足首 Y軸のソート順に基づく2グループ分け
group_logic_Y = zeros(1, 16);
group_logic_Y(sortIdx_Y) = base_groups_2;



% 【重要】ここで変数名を統一して格納します
groups_to_plot = {group_logic_X, group_logic_Y};

% ========================================================
% フィギュア設定 (17cm x 10cm)
% ========================================================
fig = figure('Units', 'centimeters', 'Position', [2, 2, 17, 10]); 
tlo = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% 共通設定
marker_styles = {'o', '^'}; % ● と ▲
% パネルタイトルを物理的な意味に合わせて修正
panel_labels = {'Cat A', 'Cat A'};

% カラーマップ (Cividis)
try
    colors = cividis(16);
catch
    colors = [linspace(0, 0.9, 16)', linspace(0.1, 0.8, 16)', linspace(0.3, 0.5, 16)'];
end

% ========================================================
% 各パネルの描画
% ========================================================
for i = 1:2
    nexttile; 
    hold on;
    
    current_group = groups_to_plot{i};
    
    for j = 1:16
        m_idx = current_group(j);
        
        scatter3(score(j,1), score(j,2), score(j,3), 50, ...
            'Marker', marker_styles{m_idx}, ...
            'MarkerFaceColor', colors(j,:), ...
            'MarkerEdgeColor', [0.1 0.1 0.1], ...
            'LineWidth', 0.8);
         if j == 12
            text(score(j,1)-1, score(j,2), score(j,3)+0.2, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         elseif j == 11
             text(score(j,1)-2.3, score(j,2), score(j,3)-0.5, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
        elseif j == 14
             text(score(j,1)-2, score(j,2), score(j,3)-0.5, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         elseif j == 16
             text(score(j,1)-1.5, score(j,2), score(j,3)-0.05, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         elseif j == 3 
             text(score(j,1)-0.2, score(j,2)+0.1, score(j,3), ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
            
         elseif j == 1 || j == 4 || j==6 || j== 8 || j == 2 || j == 7 
            text(score(j,1), score(j,2)+0.1, score(j,3), ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         else
             text(score(j,1)-0.2, score(j,2)-0.5, score(j,3)-0.2, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');

         end
    end
    
    % 軸設定
    grid on; box on; axis tight;
    ax = gca;
    ax.FontSize = 10;
    ax.FontWeight = 'bold';
    ax.TickDir = 'out';
    ax.LineWidth = 1.2;
    ax.XAxis.Label.Rotation = -30;  % 数値調整
    ax.YAxis.Label.Rotation = 30;
    ax.FontName = 'Arial';   % ← 追加
    
    if i == 1
        xlabel(['PC1 (' num2str(explained(1), '%.1f') '%)'], ...
        'FontSize', 10, 'FontName','Arial');

        ylabel(['PC2 (' num2str(explained(2), '%.1f') '%)'], ...
        'FontSize', 10, 'FontName','Arial');

        zlabel(['PC3 (' num2str(explained(3), '%.1f') '%)'], ...
        'FontSize', 10, 'FontName','Arial');
   
    else

    end
            title(panel_labels{i}, 'FontSize', 12, 'FontName', 'Arial');
    
    % ★ ここを変更（角度を変数化）
    view(az_angle, el_angle);
    
    % =====================================================
    % 左パネルのみにカラーマップを追加
    % =====================================================
    if i == 2
        colormap(gca, colors);   % 左軸だけに適用
        cb = colorbar;
        cb.FontSize = 9;
        cb.LineWidth = 1;
        
        % カラースケールを1–16に固定
        % ★ 1〜16をすべて表示
        cb.Ticks = 1:16;
        cb.TickLabels = 1:16;
        caxis([1 16]);
    end
end

% ========================================================
% 保存設定 (600dpi, EMF)
% ========================================================
export_path = fullfile(PCA_folder, 'Figure9_PCA_AnkleSideBySide.emf');
set(fig, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 17 10]);
print(fig, export_path, '-dmeta', '-r600');

%% 
% カラーマップを用意
num_neurons = size(MFR_sep_zscore_average_trial, 2);
cmap = jet(num_neurons);  % カラーマップ

figure;

% 上段：Zスコアの平均プロット
subplot(2,1,1); hold on;
for neuron = 1:num_neurons
    plot(1:16, MFR_sep_zscore_average_trial(:,neuron), '--', ...
        'Color', cmap(neuron,:), 'LineWidth', 1);
end
plot(1:16, mean(MFR_sep_zscore_average_trial, 2), 'k-', 'LineWidth', 3);  % 黒線で平均

xlim([1 16]);
xlabel('Posture');
ylabel('Z-score');
title('Z-scored Mean Firing Rate per Posture');
grid on;
% カラーバーとスタイル
colormap(cmap);

% 下段：PCAスコア（例: PC1）
subplot(2,1,2); hold on;
cmapPC = jet(4);
for PC = 1:4
    plot(1:16, score(:,PC), '-', ...
        'Color', cmapPC(PC,:), 'LineWidth', 1.5, ...
        'DisplayName', ['PC' num2str(PC)]);
end
xlabel('Posture');
ylabel('PC Score');
title('PC1–PC3 Scores across Postures');
legend show;
grid on;

xlim([1 16]);
xlabel('Posture');
ylabel('PCA Score');
title('PCA Score per Posture (e.g. PC1)');
grid on;


sgtitle('Z-score and PCA Score per Posture', 'FontSize', 16);
set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.6 0.8]);
tifFileName3D = fullfile(PCA_folder, 'PCA_score_PC1234.tif');
print(gcf, tifFileName3D, '-dtiff', '-r300');

%% polar plot 
% データ中心化と極座標変換


% データ中心化と極座標変換
coords_all_pos_endpoint = Ankle_mean;
coords_all_pos_endpoint_xz = [Ankle_mean(:,1),Ankle_mean(:,3)];



endpoint_x_center = mean(coords_all_pos_endpoint(:,1));
endpoint_z_center = mean(coords_all_pos_endpoint(:,3));
coords_all_pos_endpoint_xz_centered = [coords_all_pos_endpoint_xz(:,1)-endpoint_x_center, ...
                                       coords_all_pos_endpoint_xz(:,2)-endpoint_z_center];

x = coords_all_pos_endpoint_xz_centered(:,1);
z = coords_all_pos_endpoint_xz_centered(:,2);
r = sqrt(x.^2 + z.^2);
theta_rad = atan2(z, x);  % -π〜π
theta_deg = rad2deg(theta_rad);
theta_deg(theta_deg < 0) = theta_deg(theta_deg < 0) + 360;  % 0〜360度

%% 中心化された x-z 座標を使用
endpoint_x_center = mean(coords_all_pos_endpoint(:,1));
endpoint_z_center = mean(coords_all_pos_endpoint(:,3));
coords_all_pos_endpoint_xz_centered = [coords_all_pos_endpoint_xz(:,1)-endpoint_x_center, ...
                                       coords_all_pos_endpoint_xz(:,2)-endpoint_z_center];

x = coords_all_pos_endpoint_xz_centered(:,1);
z = coords_all_pos_endpoint_xz_centered(:,2);
r = sqrt(x.^2 + z.^2);
theta_rad = atan2(z, x);
theta_deg = rad2deg(theta_rad);
theta_deg(theta_deg < 0) = theta_deg(theta_deg < 0) + 360;

% 極座標プロット
figure;
pax = polaraxes;
hold(pax, 'on');

% 極座標プロットで点と線を表示
polarplot(pax, deg2rad(theta_deg), r, 'o-', 'LineWidth', 2);

% 各点の上にラベル（Pos1〜16）を描画
hold on;

% 姿勢ラベルを追加
for i = 1:length(theta_rad)
    % 半径をスコアより少し外側に
    r_label = r(i) + 0.05 * range(r);
    text(theta_rad(i), r_label, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 10, 'FontWeight', 'bold');
end

title('Polar Plot of 16 Postures');

% 保存
output_folder = 'PCA_folder';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
saveas(gcf, fullfile(output_folder, 'polar_plot_with_labels.tif'));




%% 
% PCスコアと角度の取得
PC = 1;
values = score(:, PC);         % スコア（16個）
theta_deg = theta_deg(:);      % 念のため列ベクトルにしておく
theta_rad = deg2rad(theta_deg);% ラジアンに変換

% ① θとscoreをソート
[theta_sorted, sort_idx] = sort(theta_rad);
score_sorted = score(:, PC);
%score_sorted = ones(16,1);
score_sorted = score_sorted(sort_idx);

% ② 始点を最後に追加（θもscoreも）
theta_closed = [theta_sorted; theta_sorted(1)];
score_closed = [score_sorted; score_sorted(1)];


% 
% データ（theta, score）を用意（ラジアン & score: -3〜5を含む）
theta = theta_closed;  % ラジアン [0, 2pi]
r = score_closed;      % スコア -3〜5 など

% 極座標軸をカスタムで作成
pax = polaraxes;
polarplot(pax, theta, r, '-o', 'LineWidth', 2);

% r軸の制限を手動で設定（ここがポイント）
pax.RLim = [-3 5];  % 半径の範囲（見た目）

% r軸のメモリラベル調整（任意）
pax.RTick = -3:1:5;

% タイトルなど
title('Polar Plot with Radius from -3 to 5');

%% 
% PCスコアと角度の取得
theta_deg = theta_deg(:);                    % 念のため列ベクトル
theta_rad = deg2rad(theta_deg);              % ラジアンに変換
[theta_sorted, sort_idx] = sort(theta_rad);  % 角度でソート

% 元のPosラベル作成（未ソート）
pos_labels_all = arrayfun(@(n) sprintf('Pos%d', n), 1:16, 'UniformOutput', false);

% ソートされた順に並び替え
pos_labels_sorted = pos_labels_all(sort_idx);

% 色リスト（3PC分）
color_list = lines(3);

% 極座標軸を作成
figure;
pax = polaraxes;
hold(pax, 'on');

% PC1〜PC3 を順にプロット
for PC = 1:3
    values = score(:, PC);                  % スコア（16個）
    values_sorted = values(sort_idx);       % 角度順に並べ替え

    % 始点を最後に追加して閉じる
    theta_closed = [theta_sorted; theta_sorted(1)];
    score_closed = [values_sorted; values_sorted(1)];

    % 極座標プロット
    polarplot(pax, theta_closed, score_closed, '-o', ...
        'LineWidth', 2, 'Color', color_list(PC,:));
end

% r軸設定
pax.RLim = [-3 5];
pax.RTick = -3:1:5;

% タイトル
title('Polar Plot of PC1 to PC3');

% PC1 にラベル（Pos1〜Pos16）を追加
pos_labels = arrayfun(@(n) sprintf('Pos%d', n), 1:16, 'UniformOutput', false);
r1 = score(sort_idx, 1);        % PC1 のスコア
theta1 = theta_sorted;          % PC1 のθ

for i = 1:16
    r_offset = r1(i) + 0.2 * sign(r1(i));  
    text(pax, theta1(i), r_offset, pos_labels_sorted{i}, ...
        'HorizontalAlignment', 'center', 'FontSize', 10);
end


%% 
% 角度の並び替え（ラジアン、0〜2pi）
[theta_deg_sorted, sort_idx_deg] = sort(theta_deg);
theta = deg2rad(theta_deg_sorted');

% Posラベル（例: 'Pos1'〜'Pos16'）
Pos_labels = arrayfun(@(x) sprintf('Pos%d', x), 1:16, 'UniformOutput', false);
Pos_labels_sorted = Pos_labels(sort_idx_deg);

% PCスコア（並び替え）
PC_score_sorted = score(sort_idx_deg, 1:3);  % PC1〜3のスコア

% 表示調整用にバイアス加算（正の値へシフト）
r_shift = 4;
r_plot_all = PC_score_sorted + r_shift;

% 始点と終点をつなげるためにループさせる
theta_loop = [theta, theta(1)];
r_plot_all_loop = [r_plot_all; r_plot_all(1,:)];  % N+1×3

% ---- プロット開始 ----
figure;
pax = polaraxes;
hold(pax, 'on');

% グリッド非表示調整
pax.ThetaTick = [];
rmax = max(r_plot_all_loop(:)) * 1.1;
r_ticks = 0:1:ceil(rmax);
pax.RLim = [0 rmax];
pax.RTick = r_ticks;
pax.RAxis.Label.String = '';
pax.RTickLabel = repmat({''}, size(pax.RTick));

% R軸のカスタムラベル
theta_label = 90;  % ラベルの向き（右側）
for i = 1:length(r_ticks)
    rtick_val = r_ticks(i);
    [x, y] = pol2cart(deg2rad(theta_label), rtick_val);
    text(x, y, sprintf('%d', rtick_val - r_shift), ...
         'HorizontalAlignment', 'left', ...
         'VerticalAlignment', 'middle', ...
         'FontSize', 20, 'Color', [0 0 0]);
end

% カラー設定（PC1→緑, PC2→青, PC3→赤）
colors_for_PCA = [0 0.6 0; 0 0 1; 1 0 0];

% 各PCのプロット
for pc = 1:3
    polarplot(pax, theta_loop, r_plot_all_loop(:, pc), '-o', ...
              'LineWidth', 2, ...
              'Color', colors_for_PCA(pc, :), ...
              'MarkerFaceColor', colors_for_PCA(pc, :), ...
              'MarkerSize', 8);  % ★追加
end

% 不均等角度のグリッド線
for i = 1:length(theta)
    polarplot(pax, [theta(i) theta(i)], [0 rmax], '-', ...
              'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end


% タイトル
title(pax, 'Polar Plot with PC1–3');

set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.6 0.8]);
tifFileName3D = fullfile(PCA_folder, 'PCA_score_PC123_polar.tif');
print(gcf, tifFileName3D, '-dtiff', '-r300');

%% polar plot new version
% ---- プロット開始 ----
figure;
pax = polaraxes;
hold(pax, 'on');

% グリッド非表示調整
pax.ThetaTick = [];
rmax = max(r_plot_all_loop(:)) * 1.1;
r_ticks = 0:1:ceil(rmax);
pax.RLim = [0 9];
pax.RTick = r_ticks;
pax.RAxis.Label.String = '';
pax.RTickLabel = repmat({''}, size(pax.RTick));

% R軸のカスタムラベル
%{
theta_label = 90;  % ラベルの位置
for i = 1:length(r_ticks)
    rtick_val = r_ticks(i);
    [x, y] = pol2cart(deg2rad(theta_label), rtick_val);
    text(x, y, sprintf('%d', rtick_val - r_shift), ...
         'HorizontalAlignment', 'left', ...
         'VerticalAlignment', 'middle', ...
         'FontSize', 20, 'Color', [0 0 0]);
end
%}

% 不均等角度のグリッド線
for i = 1:length(theta)
    polarplot(pax, [theta(i) theta(i)], [0 rmax], '-', ...
              'Color', [0.85 0.85 0.85], 'LineWidth', 1);
end

% ---- 特定の円を強調 ----
rlim_vals = [4, 9]; % 強調したい半径
theta_dense = linspace(0, 2*pi, 400);

for rv = rlim_vals
    r_circle = rv * ones(size(theta_dense));
    if rv == 4
        polarplot(pax, theta_dense, r_circle, ...
                  'Color', [0.4 0.4 0.4], 'LineWidth', 1.5); % 濃いグレー
    elseif rv == 9
        polarplot(pax, theta_dense, r_circle, ...
                  'k', 'LineWidth', 2); % 黒
    end
end


% ---- プロット設定 ----



% PCごとの色とマーカー
colors_for_PCA = [0.0 0.75 0.75;   % PC1 濃いグレー
          0.6 0.3 0.0;   % PC2 茶色
          0.49 0.18 0.56]; % PC3 紫
markers = {'o','s','^'};   % 丸, 四角, 三角

for pc = 1:3
    polarplot(pax, theta_loop, r_plot_all_loop(:, pc), '-', ...
              'LineWidth', 2, ...
              'Color', colors_for_PCA(pc, :), ...
              'Marker', markers{pc}, ...
              'MarkerFaceColor', colors_for_PCA(pc, :), ...
              'MarkerSize', 4);
end

% ---- 中心に黒い点 ----
polarplot(pax, 0, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
% タイトル

fontsize(gcf, 15, "points");


% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）

set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(PCA_folder, ...
    'PCA_plor_plot_for_fig_Cat A.pdf');
print(fig, pdfFileName, '-dpdf');


%% 
% === 面積を1に正規化 ===
r_plot_all_norm = zeros(size(r_plot_all_loop));

for pc = 1:3
    % 半径データ（列ベクトル）を取得
    r_vals = r_plot_all_loop(:, pc);

    % xy座標に変換
    [x, y] = pol2cart(theta_loop', r_vals);

    % 面積を計算（スカラー）
    area_pc = polyarea(x, y);

    % スケーリング係数
    scaleFactor = 1 / sqrt(area_pc);

    % 半径をスケーリング
    r_plot_all_norm(:, pc) = r_vals * scaleFactor;
end


% ---- プロット ----
figure;
pax = polaraxes;
hold(pax, 'on');
pax.ThetaTick = [];

rmax = max(r_plot_all_norm(:)) * 1.1;
pax.RLim = [0 rmax];

colors_for_PCA = [0 0.6 0; 0 0 1; 1 0 0]; % PC1緑, PC2青, PC3赤

for pc = 1:3
    polarplot(pax, theta_loop, r_plot_all_norm(:, pc), '-o', ...
              'LineWidth', 2, ...
              'Color', colors_for_PCA(pc, :), ...
              'MarkerFaceColor', colors_for_PCA(pc, :), ...
              'MarkerSize', 8);
end
% 不均等角度のグリッド線
for i = 1:length(theta)
    polarplot(pax, [theta(i) theta(i)], [0 rmax], '-', ...
              'Color', [0.8 0.8 0.8], 'LineWidth', 1);
end

pax.ThetaTick = [];              % 角度目盛りを消す
pax.ThetaTickLabel = {};         % 角度ラベルも消す
%pax.RTick = [];                  % 半径方向の目盛りを消す
pax.RTickLabel = {};             % 半径ラベルも消す

title(pax, 'Polar Plot (Area-normalized to 1)');
set(gcf, 'Units', 'normalized', 'Position', [0.1 0.1 0.6 0.8]);
tifFileName3D = fullfile(PCA_folder, 'PCA_score_PC123_polar_normalized_area.tif');
print(gcf, tifFileName3D, '-dtiff', '-r300');


%% plot bar for fig
figure;

% 棒グラフ（各主成分の寄与率）
bar(explained, 'FaceColor', [0.5 0.5 0.5]);  
hold on;

% 累積寄与率を折れ線で追加
cumulativeExplained = cumsum(explained);
plot(1:length(explained), cumulativeExplained, ':o', ...
    'Color', [0 0 0], 'LineWidth', 2, 'MarkerFaceColor', [0 0 0]);

% 80% ライン
yline(80, '--r', 'LineWidth', 2);

% 軸の設定
xlabel('Principal Component');
ylabel('Explained Variance (%)');
ylim([0, 100]);  % 常に 0〜100%

fontsize(gcf, 15, "points");

ax = gca;
% --- 軸設定 ---       
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
box off; 


% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
set(gca,  'FontName', 'Arial', 'FontWeight', 'bold');
set(gca, 'XTickLabelRotation',0)
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(PCA_folder, ...
    'PCA_bar_plot_for_fig-Cat A.pdf');
print(fig, pdfFileName, '-dpdf');

%% Loading Analysis
PCA_Loading_folder = createNamedFolder(PCA_folder, 'Loading_analysis');


PCA_loading_analysis_select = 'Weigth_of_loading';
%PCA_loading_analysis_select = 'Threthold_by_loading';
%
if strcmp(PCA_loading_analysis_select, 'Define')
    PCA_Loading_folder_select = createNamedFolder(PCA_Loading_folder, PCA_loading_analysis_select);
    PCA_angle_folder = createNamedFolder(PCA_Loading_folder_select, angle_definition);

elseif strcmp(PCA_loading_analysis_select, 'Weigth_of_loading')
    PCA_Loading_folder_select = createNamedFolder(PCA_Loading_folder, PCA_loading_analysis_select);

pcs = [1 2 3];   % 可視化したいPC番号リスト
nPC = numel(pcs);

All_neuron_weight = cell(nPC,1); 

figure;
tiledlayout(1, nPC, 'Padding', 'compact', 'TileSpacing', 'compact');

for i = 1:nPC
    pc = pcs(i);
    L = coeff(:, pc);     % loadingベクトル

    % 二乗寄与
    sq = L.^2;

    % 正規化（全72で和=1）
    p = sq / sum(sq);

    % 降順ソート
    [p_sorted, idx_sorted] = sort(p, 'descend');

    % 累積寄与
    cum_p = cumsum(p_sorted);

    % 80%を初めて超えるインデックスを検出
    idx_thresh = find(cum_p > 0.8, 1, 'first');

    % ---- 80%までのニューロン群を抽出 ----
    top_idx = idx_sorted(1:idx_thresh);    % ニューロン番号
    top_weights = p_sorted(1:idx_thresh);  % 元の寄与度

    % 再正規化
    top_weights_norm = top_weights / sum(top_weights);

    % 保存
    All_neuron_weight{i} = p;

    % 棒の色を指定
    barColors = repmat([0 0 0], length(p_sorted), 1); % 初期は黒
    %barColors(1:idx_thresh, :) = repmat([0.2 0.6 0.8], idx_thresh, 1); % 閾値まで青

    % サブプロット描画
    nexttile;
    b = bar(p_sorted, 'FaceColor','flat'); 
    b.CData = barColors; 
    hold on;

    % 累積寄与のプロット
    
    yyaxis right
    plot(cum_p, '-or','LineWidth',1.2);
    %yline(0.8,'--k','80% threshold');
    

    % 軸ラベルなど
    xlabel('Neuron rank');
    ylabel('Normalized contribution');
    title(sprintf('PC%d', pc));
    grid on;
    ylim([0 1]); % 累積寄与の範囲を0-1に固定
end

% 結果の表示

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(PCA_Loading_folder_select, 'Laoding_normalized_value');
print(gcf, tifFileName, '-dtiff', '-r300');


end



%% plot PCA results
figure;

tiledlayout(1,3,"TileSpacing","compact","Padding","compact");
PC_element_percent = zeros(max(particular_R_angle_related_neuron)+1,3);
for selectPC = 1:3
    labels = particular_R_angle_related_neuron;

    % --- group_sums を全ラベル(0～4)で計算 ---
    group_sums_all = zeros(max(particular_R_angle_related_neuron)+1,1);
    for lbl = 0:max(particular_R_angle_related_neuron)
        group_sums_all(lbl+1) = sum(All_neuron_weight{selectPC}(labels == lbl));
    end
    PC_element_percent(:,selectPC) = group_sums_all*100;
    % --- 時計回りにしたいので順番を逆転させる ---
    group_sums = group_sums_all(fliplr(desired_order)+1);
    pieColors  = colorMap(fliplr(desired_order)+1,:);

    % --- プロット ---
    nexttile;
    pie(group_sums); 
    colormap(pieColors);
    title(sprintf('PC%d', selectPC));
end

% === グラフ全体のタイトル ===
%sgtitle(sprintf('Neuron weight distribution (R > %.2f, p < %.3f %.2fSD)', threshold_R, p_thresh,SD_value));
sgtitle(sprintf('Neuron weight distribution (R > %.2f, p < %.3f) %s', threshold_R, p_thresh,include_specifc_parameter));
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

% ファイル名に条件を反映（ドット無し）
%tifFileName = fullfile(PCA_Loading_folder_select, ...
%    sprintf('PCA_loading_analysis_results_R%s_p%s_%sSD.tif', threshold_R_str, p_thresh_str,SD_value));
tifFileName = fullfile(PCA_Loading_folder_select, sprintf('PCA_loading_analysis_results_R%s_p%s_%s.tif', threshold_R_str, p_thresh_str,include_specifc_parameter));
print(gcf, tifFileName, '-dtiff', '-r300');




%% Figure 10
% plot PCA results main figures
figure;


% === カラー定義 ===
colorMap = [ ...
    0.6 0.6 0.6;      % 0 → グレー（そのまま）
    0.0 0.0 1.0;      % 1 → 青（そのまま）
    0.0 0.7 0.7;      % 2 → ターコイズ
    0.8 0.0 0.8;      % 3 → マゼンタ
    1.0 0.6 0.0];     % 4 → オレンジ（そのまま）


tiledlayout(1,3,"TileSpacing","compact","Padding","compact");
PC_element_percent = zeros(max(particular_R_angle_related_neuron)+1,3);
for selectPC = 1:3
    labels = particular_R_angle_related_neuron;

    % --- group_sums を全ラベル(0～4)で計算 ---
    group_sums_all = zeros(max(particular_R_angle_related_neuron)+1,1);
    for lbl = 0:max(particular_R_angle_related_neuron)
        group_sums_all(lbl+1) = sum(All_neuron_weight{selectPC}(labels == lbl));
    end
    PC_element_percent(:,selectPC) = group_sums_all*100;
    % --- 時計回りにしたいので順番を逆転させる ---
    group_sums = group_sums_all(fliplr(desired_order)+1);
    pieColors  = colorMap(fliplr(desired_order)+1,:);

    % --- プロット ---
   nexttile;

pie(group_sums);   % 合計1の比率データ
colormap(pieColors);

% --- パッチとテキスト取得 ---
patches = findobj(gca,'Type','patch');
texts   = findobj(gca,'Type','text');

% 取得順が逆なので反転
patches = flipud(patches);
texts   = flipud(texts);

for k = 1:length(group_sums)

    % ---- 割合 ----
    percent_val = group_sums(k) * 100;

    % ---- 文字設定 ----
    texts(k).String = sprintf('%.1f%%', percent_val);
    texts(k).Color = [0.9 0.9 0.9];
    texts(k).FontWeight = 'bold';
    texts(k).FontSize = 6;
    texts(k).FontName = 'Arial';   % ← ここ追加

    % ---- 中央に移動 ----
    % パッチの頂点から中心角を計算
    verts = patches(k).Vertices;
    centerAngle = atan2(mean(verts(:,2)), mean(verts(:,1)));

    % Ajast position
    if selectPC == 1
        r_adjust = [0.4 0.35 0.3 0.6 0.32];   % 各kごとの半径
        angle_adjust = [-deg2rad(15) -deg2rad(5) deg2rad(10) deg2rad(15) 0];   % 各kごとの角度
    elseif selectPC == 2
        r_adjust = [0.4 0.3 0.3 0.3 0.6];   % 各kごとの半径
        angle_adjust = [-deg2rad(15) deg2rad(10) -deg2rad(10) deg2rad(3) -deg2rad(5)];   % 各kごとの角度
    else
        r_adjust = [0.4 0.35 0.4 0.5 0.7];   % 各kごとの半径
        angle_adjust = [-deg2rad(15) deg2rad(15) deg2rad(10) deg2rad(10) -deg2rad(5)];   % 各kごとの角度
    end

    % if stationary period is different
    if strcmp(static_calculation, 'Defined')
        if str_sep_dynamic_static == 5

        elseif str_sep_dynamic_static == 10
            if selectPC == 1
            r_adjust = [0.4 0.35 0.3 0.6 0.32];   % 各kごとの半径
            angle_adjust = [-deg2rad(15) -deg2rad(5) deg2rad(10) 0 0];   % 各kごとの角度
            elseif selectPC == 2
            r_adjust = [0.4 0.4 0.3 0.3 0.6];   % 各kごとの半径
            angle_adjust = [-deg2rad(15) deg2rad(20) -deg2rad(10) deg2rad(3) -deg2rad(5)];   % 各kごとの角度
            else
            r_adjust = [0.4 0.35 0.4 0.5 0.7];   % 各kごとの半径
            angle_adjust = [-deg2rad(15) 0 deg2rad(10) deg2rad(15) -deg2rad(5)];   % 各kごとの角度
            end
        end
    
    else

    end

    for label_of_PC_num = 1:length(group_sums)

    verts = patches(label_of_PC_num).Vertices;
    centerAngle = atan2(mean(verts(:,2)), mean(verts(:,1)));

    r = r_adjust(label_of_PC_num);
    a = centerAngle + angle_adjust(label_of_PC_num);

    texts(label_of_PC_num).Position = [r*cos(a), r*sin(a), 0];
    end
end
titleHandle = title(sprintf('PC%d', selectPC), ...
    'FontName','Arial', ...
    'FontSize',10, ...
    'FontWeight','bold');

% ---- タイトルを少し下に移動 ----
titlePos = titleHandle.Position;
titleHandle.Position = [titlePos(1), titlePos(2)-0.2, titlePos(3)];


end

% === グラフ全体のタイトル ===
sg = sgtitle('Cat A', ...
    'FontName','Arial', ...
    'FontSize',12, ...
    'FontWeight','bold');

% 少し上に上げる（重なり防止）

% ===== PDFサイズ設定（17cm × 23cm）=====
% ===== サイズ設定 =====
set(gcf,'Units','centimeters');
set(gcf,'Position',[2 2 12 5]);

set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[12 7.5]);
set(gcf,'PaperPosition',[0 0 12 7.5]);
set(gcf,'PaperPositionMode','manual');

% ===== PDF保存 =====
baseFileName = fullfile(PCA_Loading_folder_select, ...
    sprintf('CatA_PCA_loading_analysis_results_R%s_p%s_%s', ...
    threshold_R_str, p_thresh_str, include_specifc_parameter));

% ===== 高解像度PNG（600dpi推奨）=====
print(gcf, [baseFileName '.png'], '-dpng', '-r600');

% ===== ベクターEMF保存 =====
print(gcf, [baseFileName '.emf'], '-dmeta');



%% Plot PCA caluculation Method
PCA_Loading_folder = createNamedFolder(PCA_folder, 'Loading_analysis');


PCA_loading_analysis_select = 'Weigth_of_loading';
%PCA_loading_analysis_select = 'Threthold_by_loading';
%
if strcmp(PCA_loading_analysis_select, 'Define')
    PCA_Loading_folder_select = createNamedFolder(PCA_Loading_folder, PCA_loading_analysis_select);
    PCA_angle_folder = createNamedFolder(PCA_Loading_folder_select, angle_definition);

elseif strcmp(PCA_loading_analysis_select, 'Weigth_of_loading')
    PCA_Loading_folder_select = createNamedFolder(PCA_Loading_folder, PCA_loading_analysis_select);

nPC = 3;
% === カラー定義 ===
colorMap = [ ...
    0.6 0.6 0.6;   % 0 → 灰
    0 0 1.0;       % 1 → 青
    0 0.5 0;       % 2 → 緑
    1.0 0.2 0.2;   % 3 → 赤
    1.0 0.6 0.0];  % 4 → オレンジ
L = coeff(:, nPC); % loadingベクトル % 二乗寄与 
sq = L.^2; % 正規化（全72で和=1）
p = sq / sum(sq);
[p_sorted, idx_sorted] = sort(p, 'descend');

% particular_R_angle_related_neuron も同じ順序に並べ替え
label_sorted = particular_R_angle_related_neuron(idx_sorted);

% === 棒グラフの色をここで決定 ===
barColors = zeros(length(label_sorted), 3);
for k = 1:length(label_sorted)
    label = label_sorted(k);
    barColors(k,:) = colorMap(label+1, :);   % 0〜4 → colorMap(1〜5)
end

% === 棒グラフ描画 ===
figure;
b = bar(p_sorted, 'FaceColor','flat');
b.CData = barColors;
hold on;

xlabel('Neuron rank');
ylabel('Normalized contribution');
title(sprintf('PC%d', nPC));
grid on;
ylim([0 0.15]);
fontsize(gcf, 15, "points");

ax = gca;
% --- 軸設定 ---       
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
box off; 


% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
set(gca,  'FontName', 'Arial', 'FontWeight', 'bold');
set(gca, 'XTickLabelRotation',0)
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(PCA_Loading_folder_select, ...
    'Laoding_normalized_value_calucuration_method.pdf');
print(fig, pdfFileName, '-dpdf');

end


%% === Method 1
nPC = 2;
L = coeff(:, nPC); % loadingベクトル % 二乗寄与 
figure;
b = bar(L, 'FaceColor','flat');
b.CData = [0.6 0.6 0.6];
hold on;

xlabel('Neuron');
ylabel('Loading of PC');
title(sprintf('PC%d', nPC));
grid on;
ylim([-0.4 0.4]);
fontsize(gcf, 15, "points");

ax = gca;
% --- 軸設定 ---       
% === メモリ設定 ===
ax.TickDir = 'out';              % メモリを外向きに
ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
ax.YMinorTick = 'on';            % Y軸の小目盛をON
ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
box off; 


% === FigureのサイズをA4幅に縮小 ===
target_width = 20;     % cm （A4幅に収める）
target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
set(gca,  'FontName', 'Arial', 'FontWeight', 'bold');
set(gca, 'XTickLabelRotation',0)
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% === PDF出力用にPaperSizeを合わせる ===
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];      % 幅 × 高さ
fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(PCA_Loading_folder_select, ...
    'Laoding_normalized_value_calucuration_method_1.pdf');
print(fig, pdfFileName, '-dpdf');



%% plot mean firing rate each neuron type
% plot 3D
neurons_per_fig = 12;
label_cell_angle = {'Hip Angle [deg]', 'Knee Angle [deg]'};
label_cell_multi = {'Orientation [deg]', 'Length [deg]'};
both_angle_scotter_folder = createNamedFolder(angle_related_folder, 'Scottter_both_parameter_neuron_type');
particular_R_angle_related_neuron;

% plot 3D hip and knee
both_angle_foldername = 'Hip_and_knee_angle';
plotBothJointAngleScatter_neuron_type(hip_knee_joint_angle_orignal(:,1), hip_knee_joint_angle_orignal(:,2), MFR_sep_pos, newSpkCH, neurons_per_fig, both_angle_scotter_folder, label_cell_angle,particular_R_angle_related_neuron,both_angle_foldername);


%% plot only specific endpoint neuron
both_angle_scotter_folder = createNamedFolder(experiment3_multcomparefolder, 'Scottter_only_specific_neuron');
plotBothJointAngleScatter_specific_neuron(hip_knee_joint_angle_orignal(:,1), hip_knee_joint_angle_orignal(:,2), MFR_sep_pos, newSpkCH, 6, both_angle_scotter_folder, label_cell_angle,particular_R_angle_related_neuron,StrongNeuronMatrix,both_angle_foldername);



%% ------caluculate length

% ---- ビン幅と物理スケール設定 ----
bin_width = 4;                  % チャンネル数
channel_pitch_um = 10;          % 1チャンネルあたりの距離（μm）
bin_pitch_um = bin_width * channel_pitch_um;  % = 40μm

% ---- ビン数 ----
num_bins = 384 / bin_width;
Hip_neuron_spk_ch = [];
Knee_neuron_spk_ch = [];
Hip_and_knee_neuron_spk_ch = [];
Specific_endpoint_neuron_spk_ch = [];
No_modulation_neuron_spk_ch = [];
% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if particular_R_angle_related_neuron(i,1)  == 1
            Hip_neuron_spk_ch = [Hip_neuron_spk_ch; newSpkCH(i,1)];  
    elseif particular_R_angle_related_neuron(i,1) == 2
            Knee_neuron_spk_ch = [Knee_neuron_spk_ch; newSpkCH(i,1)];
    elseif particular_R_angle_related_neuron(i,1) == 3
            Hip_and_knee_neuron_spk_ch = [Hip_and_knee_neuron_spk_ch; newSpkCH(i,1)];
    elseif particular_R_angle_related_neuron(i,1) == 4
            Specific_endpoint_neuron_spk_ch = [Specific_endpoint_neuron_spk_ch; newSpkCH(i,1)];
    else
            No_modulation_neuron_spk_ch = [No_modulation_neuron_spk_ch; newSpkCH(i,1)];
    end
end

%

% for Hip
% ---- 各ニューロンの属するビンを計算 ----
Hip_bin_indices = floor(Hip_neuron_spk_ch / bin_width) + 1;
Knee_bin_indices = floor(Knee_neuron_spk_ch / bin_width) + 1;
Hip_and_Knee_bin_indices = floor(Hip_and_knee_neuron_spk_ch / bin_width) + 1;
Specific_endpoint_neuron_bin_indices = floor(Specific_endpoint_neuron_spk_ch / bin_width) + 1;
No_modulation_neuron_bin_indices = floor(No_modulation_neuron_spk_ch / bin_width) + 1;
% ---- 各ビンに何個ニューロンが属するかをカウント ----
Hip_joint_neuron_counts_per_bin = histcounts(Hip_bin_indices, 0.5:1:(num_bins + 0.5));
Knee_joint_neuron_counts_per_bin = histcounts(Knee_bin_indices, 0.5:1:(num_bins + 0.5));
Hip_and_Knee_joint_neuron_counts_per_bin = histcounts(Hip_and_Knee_bin_indices, 0.5:1:(num_bins + 0.5));
Specific_endpoint_neuron_counts_per_bin = histcounts(Specific_endpoint_neuron_bin_indices, 0.5:1:(num_bins + 0.5));
No_modulation_neuron_counts_per_bin = histcounts(No_modulation_neuron_bin_indices, 0.5:1:(num_bins + 0.5));

% ---- Y軸（深さμm）データ ----
Y_um = (1:num_bins) * bin_pitch_um;  % 1ビンごとに40μm

% 各行 = ビン, 各列 = カテゴリ（Hip, Knee, Hip&Knee）
stack_data = [Hip_joint_neuron_counts_per_bin(:), ...
              Knee_joint_neuron_counts_per_bin(:), ...
              Hip_and_Knee_joint_neuron_counts_per_bin(:), ...
              Specific_endpoint_neuron_counts_per_bin(:), ...
              No_modulation_neuron_counts_per_bin(:)];

% --- 横積み棒グラフ ---
figure;
b = barh(Y_um, stack_data, 'stacked');

% --- 色設定（Hip=赤, Knee=青, 両方=緑 など）
b(1).FaceColor = [0 0 1.0];     % Hip
b(2).FaceColor = [0 0.5 0];     % Knee
b(3).FaceColor = [1.0 0.2 0.2];   % Hip & Knee
b(4).FaceColor = [1.0 0.6 0.0];   % specific endpoint
b(5).FaceColor = [0.6 0.6 0.6];   % No modulation

% --- 軸や表示調整 ---
ylim([0 3840]);
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
xlabel('Neuron Count');
ylabel('Depth (μm)');
grid on;

% --- 保存処理 ---
filename = 'neuron_depth_distribution_stacked_with_endpoint_neuron.tif';
full_path = fullfile(hip_and_knee_folder_cross_particular_p, filename);
set(gcf, 'Units', 'inches', 'Position', [1, 1, 6, 8], 'Color', 'w');
print(gcf, full_path, '-dtiff', '-r300');

%% calucurate mean and depth
% ---- チャンネルをμmに変換 ----
Hip_depth = Hip_neuron_spk_ch * channel_pitch_um;
Knee_depth = Knee_neuron_spk_ch * channel_pitch_um;
HK_depth = Hip_and_knee_neuron_spk_ch * channel_pitch_um;
Endpoint_depth = Specific_endpoint_neuron_spk_ch * channel_pitch_um;
NoMod_depth = No_modulation_neuron_spk_ch * channel_pitch_um;

% ---- 平均と標準偏差 ----
mu = [ mean(Hip_depth), mean(Knee_depth), mean(HK_depth), ...
       mean(Endpoint_depth), mean(NoMod_depth) ];

sd = [ std(Hip_depth), std(Knee_depth), std(HK_depth), ...
       std(Endpoint_depth), std(NoMod_depth) ];

% ---- 全データをまとめる ----
depth_all = [Hip_depth; Knee_depth; HK_depth; Endpoint_depth; NoMod_depth];
group_all = [ repmat({'Hip'}, length(Hip_depth), 1);
              repmat({'Knee'}, length(Knee_depth), 1);
              repmat({'Hip and Knee'}, length(HK_depth), 1);
              repmat({'Endpoint'}, length(Endpoint_depth), 1);
              repmat({'NoMod'}, length(NoMod_depth), 1) ];

% ---- ANOVA ----
[p, tbl, stats] = anova1(depth_all, group_all, 'off');

% ---- 多重比較 ----
results_mult = multcompare(stats, 'Display', 'off');
figure;
bar(mu,'FaceColor',[0.7 0.7 0.7]); hold on;
errorbar(1:5, mu, sd, 'k.', 'LineWidth', 1.5);

set(gca, 'XTick', 1:5, ...
         'XTickLabel', {'Hip','Knee','Hip+Knee','Endpoint','NoMod'}, ...
         'FontSize', 16, 'FontWeight','bold');
ylabel('Depth (μm)');
title('Mean depth ± SD for each neuron type');
sigPairs = results_mult(results_mult(:,6) < 0.05, 1:2);

hold on;
yMax = max(mu + sd) * 1.1;

for k = 1:size(sigPairs,1)
    i = sigPairs(k,1);
    j = sigPairs(k,2);

    plot([i j], [yMax yMax], 'k-', 'LineWidth', 1.5);
    text(mean([i j]), yMax+0.02*yMax, '*', ...
         'HorizontalAlignment','center','FontSize',20);
    yMax = yMax * 1.08;
end

%% 
figure;

% ===========================
%  ① 左側：横積み棒グラフ
% ===========================
subplot(1,2,1);
b = barh(Y_um, stack_data, 'stacked');
b(1).FaceColor = [0 0 1.0];
b(2).FaceColor = [0 0.5 0];
b(3).FaceColor = [1.0 0.2 0.2];
b(4).FaceColor = [1.0 0.6 0.0];
b(5).FaceColor = [0.6 0.6 0.6];

ylim([0 3840]);
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Neuron Count');
ylabel('Depth (μm)');
title('Depth distribution (stacked histogram)');
grid on;

% ===========================
%  ② 右側：平均±SD + 有意差
% ===========================
% ===========================
%  ② 右側：平均±SD + 有意差
% ===========================
subplot(1,2,2);

group_names = {'Hip','Knee','Hip&Knee','Endpoint','NoMod'};

% ---- バーの色を左と同じに設定 ----
colors_for_PCA = [
    0   0     1.0;    % Hip
    0   0.5   0;      % Knee
    1.0 0.2   0.2;    % Hip & Knee
    1.0 0.6   0.0;    % Endpoint
    0.6 0.6   0.6     % NoMod
];

hold on;
bar_handle = bar(mu, 'FaceColor', 'flat');

% --- 各バーの色を設定 ---
for k = 1:5
    bar_handle.CData(k,:) = colors_for_PCA(k,:);
end

% --- SD ---
errorbar(1:5, mu, sd, 'k', 'LineWidth', 1.5, 'LineStyle', 'none');

set(gca, 'XTick', 1:5, 'XTickLabel', group_names);
ylabel('Depth (μm)');
title('Mean depth ± SD with significance');
set(gca, 'FontSize', 14, 'FontWeight', 'bold');

% ---- 多重比較の有意差を星で示す ----
sig_level = 0.05;
y_max = max(mu + sd) * 1.2;

for r = 1:size(results_mult,1)
    g1 = results_mult(r,1);
    g2 = results_mult(r,2);
    p  = results_mult(r,6);

    if p < sig_level
        x1 = g1; x2 = g2;
        y = y_max + 20*r;

        plot([x1 x2], [y y], 'r-', 'LineWidth', 1.5);
        plot([x1 x1], [mu(x1)+sd(x1) y], 'r-');
        plot([x2 x2], [mu(x2)+sd(x2) y], 'r-');

        text((x1+x2)/2, y + 10, '*', 'HorizontalAlignment','center', ...
            'FontSize', 20, 'FontWeight', 'bold');
    end
end

ylim([0 3840]);
hold off;

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
% --- 保存処理 ---
filename = 'neuron_depth_distribution_stacked_with_endpoint_neuron_with_significant.tif';
full_path = fullfile(hip_and_knee_folder_cross_particular_p, filename);
print(gcf, full_path, '-dtiff', '-r300');
%% save neuron type
newSpkID;
newSpkCH;
particular_R_angle_related_neuron;
particular_R_angle_related_neuron_new = particular_R_angle_related_neuron+1;
labels_for_group = ["No modulation", "Hip joint angle", "Knee joint angle", "Dual joint angle", "Specific endpoint"];

Neuron_posture_respond_type = [cell2mat(newSpkID),newSpkCH,particular_R_angle_related_neuron_new];

Neuron_type_folder = createNamedFolder(output_folder, 'Neuron_type_for_posture');

% === ファイル名（日時入りにしておくと便利） ===
save_name_for_neuron_type_for_pos = fullfile(Neuron_type_folder, 'Neuron_posture_type_info.mat');

% === 保存 ===
save(save_name_for_neuron_type_for_pos, 'labels_for_group', 'Neuron_posture_respond_type');

fprintf('Saved: %s\n', save_name_for_neuron_type_for_pos);


%% =====================================================
%  LASSO Decoding model analysis (10 repetitions) ramda 10000
% =====================================================
default_rng = rng;   % 現在の乱数状態を保存
rng(255);             % シード固定
%rng(10);             % シード固定
num_ramda = 10000;
%decording_parameter = 'Hip_and_Knee';
decording_parameter = 'Orientation_and_Length';
%decording_parameter = 'X_and_Y';
decording_folder = createNamedFolder(experiment3_static_folder_select, 'Decording analysis');
use1SE = false;   % ← true: 1SE, false: MinMSE

% XY position
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

B_param1_all_set = zeros(num_neurons,num_postures);
B_param2_all_set = zeros(num_neurons,num_postures);
% --- 姿勢ごとのラベル設定 ---


%
if strcmp(decording_parameter, 'Hip_and_Knee')
    obserbed_param = hip_knee_joint_angle_orignal;  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    labels = ["Hip","Knee"];
elseif strcmp(decording_parameter, 'Orientation_and_Length')
    obserbed_param = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'Orientation');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Length');
    labels = ["Orientation","Length"];
elseif strcmp(decording_parameter, 'X_and_Y')
    obserbed_param = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'X');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Y');
else
    disp('error: select parameter Hip_and_Knee or Orientation_and_Length or X_and_Y')
end
% --- データ行列作成 ---
MFR_all = [];   
Y_all   = [];   
posture_id = [];

for pos = 1:num_postures
    for tr = 1:num_trials
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; obserbed_param(pos,:)]; 
        posture_id = [posture_id; pos];
    end
end

% =====================================================

    % --- Leave-one-posture-out decoding ---
    Y_pred_all = zeros(size(Y_all));
    Y_true_all = Y_all;

    for leave_out = 1:num_postures
        train_idx = posture_id ~= leave_out;
        test_idx  = posture_id == leave_out;

        X_train = MFR_all(train_idx,:);
        Y_train = Y_all(train_idx,:);
        X_test  = MFR_all(test_idx,:);
        Y_test  = Y_all(test_idx,:);

        % --- LASSO回帰（Hip, Knee）---
        [B1, FitInfo1] = lasso(X_train, Y_train(:,1), 'Alpha', 1, 'CV', 5, 'NumLambda', num_ramda);

        if use1SE
            idx1 = FitInfo1.Index1SE;
        else
            idx1 = FitInfo1.IndexMinMSE;
        end

        B_param1 = B1(:, idx1);
        B_param1_all_set(:, leave_out) = B_param1;


        [B2, FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha', 1, 'CV', 5, 'NumLambda', num_ramda);

        if use1SE
            idx2 = FitInfo2.Index1SE;
        else
            idx2 = FitInfo2.IndexMinMSE;
            disp('false')
        end
        B_param2 = B2(:, idx2);
        B_param2_all_set(:, leave_out) = B_param2;

        % --- テストデータ予測 ---
        Y_pred_param1 = X_test * B_param1 + FitInfo1.Intercept(idx1);
        Y_pred_param2 = X_test * B_param2 + FitInfo2.Intercept(idx2);
        Y_pred_all(test_idx,:) = [Y_pred_param1, Y_pred_param2];
    end

    % --- 結果のまとめ ---
    Y_true_mean_all = mean(Y_true_all);
    SSE_param1_decording = sum((Y_true_all(:,1)-Y_pred_all(:,1)).^2);
    SST_param1_decording = sum((Y_true_all(:,1)-Y_true_mean_all(1,1)).^2);
    R_square_param1_decording = 1-(SSE_param1_decording/SST_param1_decording);

    SSE_param2_decording = sum((Y_true_all(:,2)-Y_pred_all(:,2)).^2);
    SST_param2_decording = sum((Y_true_all(:,2)-Y_true_mean_all(1,2)).^2);
    R_square_param2_decording = 1-(SSE_param2_decording/SST_param2_decording);

    param1_mean_eachPos = zeros(num_postures, 1);
    param1_std_eachPos  = zeros(num_postures, 1);

    param2_mean_eachPos = zeros(num_postures, 1);
    param2_std_eachPos  = zeros(num_postures, 1);

    for pos = 1:num_postures
        % その姿勢の該当行インデックス（例：1–5, 6–10, …）
        idx_range = (pos-1)*num_trials + (1:num_trials);
    
        % 該当する5行×10列を取り出す
        block_param1 = Y_pred_all(idx_range, 1);  % 5×10
        block_param2 = Y_pred_all(idx_range, 2);  % 5×10

        % 各列（run）ごとに平均と標準偏差
        param1_mean_eachPos(pos, 1) = mean(block_param1(:));
        param1_std_eachPos(pos, 1)  = std(block_param1(:));
        param2_mean_eachPos(pos, 1) = mean(block_param2(:));
        param2_std_eachPos(pos, 1)  = std(block_param2(:));
    end
B_param1_all_set;
B_param2_all_set;

%
B_param1_all_set_mean = mean(abs(B_param1_all_set),2);
B_param2_all_set_mean = mean(abs(B_param2_all_set),2);
%  
if strcmp(decording_parameter, 'Hip_and_Knee')
    % --- 可視化（平均＋標準偏差）---
    figure;
    % ==== Hip (orientation) ====
    subplot(1,2,1);
    errorbar(obserbed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed hip joint [degree]');
    ylabel({'Decoded hip joint [degree]'});
    grid on; axis equal;
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([10 110]); ylim([10 110]);
    
    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(25, 100, sprintf('R^2 = %.3f', R_square_param1_decording), ...
     'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial', 'Color', [0 0 0]);
    ax = gca; 
    ax.FontWeight = 'bold'; % 必要なら太字
    ax.FontSize = 12; % 必要なら太字
    ax.FontName = 'Arial';
    ax.XTickLabelRotation = 0;
    % --- 軸設定 ---       
    % === メモリ設定 ===
    ax.TickDir = 'out';              % メモリを外向きに
    ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    ax.YMinorTick = 'on';            % Y軸の小目盛をON
    ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off; 


    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed knee joint [degree]');
    ylabel('Decoded knee joint [degree]');
    grid on; axis equal;
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([30 140]); ylim([30 140]);
    text(45, 130, sprintf('R^2 = %.3f', R_square_param2_decording), ...
     'FontSize', 12, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);
    bx = gca; 
    bx.FontWeight = 'bold'; % 必要なら太字
    bx.FontSize = 12; % 必要なら太字
    bx.FontName = 'Arial';
    bx.XTickLabelRotation = 0;
    % === メモリ設定 ===
    bx.TickDir = 'out';              % メモリを外向きに
    bx.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    bx.YMinorTick = 'on';            % Y軸の小目盛をON
    bx.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off;
    % === FigureのサイズをA4幅に縮小 ===
    target_width = 20;     % cm （A4幅に収める）
    target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし
    
    % === PDF保存 ===
    pdfFileName = fullfile(decording_lasso_folder, 'Mean_SD_Hip_Knee CatA.pdf');
    print(fig, pdfFileName, '-dpdf');

elseif strcmp(decording_parameter, 'Orientation_and_Length')
    % --- 可視化（平均＋標準偏差）---
    figure;
    % ==== Hip (orientation) ====
    subplot(1,2,1);
    errorbar(obserbed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed orientation [degree]');
    ylabel({'Decoded orientation [degree]'});
    grid on; axis equal;
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([20 120]); ylim([20 120]);
    xticks(20:20:120);
    xticks(20:20:120);
    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(27, 110, sprintf('R^2 = %.3f', R_square_param1_decording), ...
     'FontSize', 15, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);
    ax = gca; 
    ax.FontWeight = 'bold'; % 必要なら太字
    ax.FontSize = 12; % 必要なら太字
    ax.FontName = 'Arial';
    ax.XTickLabelRotation = 0;
    % --- 軸設定 ---       
    % === メモリ設定 ===
    ax.TickDir = 'out';              % メモリを外向きに
    ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    ax.YMinorTick = 'on';            % Y軸の小目盛をON
    ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off; 



    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed length [mm]');
    ylabel('Decoded length [mm]');
    grid on; axis equal;
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([65 205]); ylim([65 205]);
    xticks(50:25:200);
    yticks(50:25:200);
    text(75, 190 ...
        , sprintf('R^2 = %.3f', R_square_param2_decording), ...
     'FontSize', 15, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);
    bx = gca; 
    bx.FontWeight = 'bold'; % 必要なら太字
    bx.FontSize = 12; % 必要なら太字
    bx.FontName = 'Arial';
    bx.XTickLabelRotation = 0;
    % === メモリ設定 ===
    bx.TickDir = 'out';              % メモリを外向きに
    bx.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    bx.YMinorTick = 'on';            % Y軸の小目盛をON
    bx.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off;
    % === FigureのサイズをA4幅に縮小 ===
    target_width = 20;     % cm （A4幅に収める）
    target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === EMF保存 ===
emfFileName = fullfile(decording_lasso_folder, ['Mean_SD_O_length CatA.emf']);
print(fig, emfFileName, '-dmeta');
end

rng(default_rng);
% plot decording parameter in each model ---------------------------------------------------------
B_param1_all_set;
B_param2_all_set;

% 係数を2乗
B1_sq = B_param1_all_set .^ 2;
B2_sq = B_param2_all_set .^ 2;
% 各モデル（各列）ごとに和が1になるよう正規化
B1_sq_norm = B1_sq ./ sum(B1_sq, 1);
B2_sq_norm = B2_sq ./ sum(B2_sq, 1);


%% model Zero count
zero_count_B1_sq = sum(B1_sq == 0, 1);
zero_count_B2_sq = sum(B2_sq == 0, 1);
zero_count_B1_sq_mean = mean(zero_count_B1_sq);
zero_count_B2_sq_mean = mean(zero_count_B2_sq);



% 元の姿勢順（1～16）
orig_idx = 1:16;
% 4×4 に配置
idx_4x4 = reshape(orig_idx, [4,4])';   % ← firing rate と同じ並び
% 縦に並べて subplot 用に
model_order = idx_4x4(:);   % 16×1
B1_reordered = B1_sq_norm(:, model_order);
B2_reordered = B2_sq_norm(:, model_order);



% === カラー定義（ニューロンタイプ 0–4）===
colorMap = [ ...
    0.6 0.6 0.6;  % 0 → 灰
    0 0 1.0;      % 1 → 青
    0 0.5 0;      % 2 → 緑
    1.0 0.2 0.2;  % 3 → 赤
    1.0 0.6 0.0]; % 4 → オレンジ

%% loop rng 100 5 fold lamda
default_rng = rng;   % 現在の乱数状態を保存
num_ramda = 10000;

decording_parameter = 'Orientation_and_Length';
decording_folder = createNamedFolder(experiment3_static_folder_select, 'Decording analysis');
use1SE = true;   % ← true: 1SE, false: MinMSE
% XY position
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- 姿勢ごとのラベル設定 ---
%
if strcmp(decording_parameter, 'Hip_and_Knee')
    obserbed_param = hip_knee_joint_angle_orignal;  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    labels = ["Hip","Knee"];
elseif strcmp(decording_parameter, 'Orientation_and_Length')
    obserbed_param = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'Orientation');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Length');
    labels = ["Orientation","Length"];
elseif strcmp(decording_parameter, 'X_and_Y')
    obserbed_param = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'X');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Y');
else
    disp('error: select parameter Hip_and_Knee or Orientation_and_Length or X_and_Y')
end

num_repeat = 100;   % 乱数の数
lambda_types = {'MinMSE','1SE'};

B_param1_all = cell(num_repeat, 2);
B_param2_all = cell(num_repeat, 2);

R2_param1_all = zeros(num_repeat, 2);
R2_param2_all = zeros(num_repeat, 2);


baseFigDir = fullfile(decording_lasso_folder, 'Rng_compare_5fold');
mkdir(baseFigDir);

mkdir(fullfile(baseFigDir,'MinMSE'));
mkdir(fullfile(baseFigDir,'1SE'));
% 
for iRand = 1:num_repeat
    rng(iRand);   % ← 乱数固定（論文再現性OK）


    for iLambdaType = 1:2
        
        use1SE = (iLambdaType == 2);
        if use1SE
            lambdaName = '1SE';
        else
            lambdaName = 'MinMSE';
        end
        saveDir = fullfile(baseFigDir, lambdaName);


        % ★ 乱数・λ条件ごとに初期化 ★
        B_param1_all_set = zeros(num_neurons, num_postures);
        B_param2_all_set = zeros(num_neurons, num_postures);

        Y_pred_all = zeros(size(Y_all));

        % ===== Leave-one-posture-out =====
        for leave_out = 1:num_postures

            train_idx = posture_id ~= leave_out;
            test_idx  = posture_id == leave_out;

            X_train = MFR_all(train_idx,:);
            Y_train = Y_all(train_idx,:);
            X_test  = MFR_all(test_idx,:);

            % --- param1 ---
            [B1, FitInfo1] = lasso(X_train, Y_train(:,1), ...
                'Alpha',1,'CV',5,'NumLambda',num_ramda);

            idx1 = FitInfo1.Index1SE;
            if ~use1SE
                idx1 = FitInfo1.IndexMinMSE;
            end

            B_param1 = B1(:,idx1);
            B_param1_all_set(:,leave_out) = B_param1;

            % --- param2 ---
            [B2, FitInfo2] = lasso(X_train, Y_train(:,2), ...
                'Alpha',1,'CV',5,'NumLambda',num_ramda);

            idx2 = FitInfo2.Index1SE;
            if ~use1SE
                idx2 = FitInfo2.IndexMinMSE;
            end

            B_param2 = B2(:,idx2);
            B_param2_all_set(:,leave_out) = B_param2;

            % --- prediction ---
            Y_pred_all(test_idx,1) = X_test * B_param1 + FitInfo1.Intercept(idx1);
            Y_pred_all(test_idx,2) = X_test * B_param2 + FitInfo2.Intercept(idx2);
        end

        % ===== R² =====
        Y_mean = mean(Y_all);
        R2_param1_all(iRand,iLambdaType) = ...
            1 - sum((Y_all(:,1)-Y_pred_all(:,1)).^2) / ...
                sum((Y_all(:,1)-Y_mean(1)).^2);

        R2_param2_all(iRand,iLambdaType) = ...
            1 - sum((Y_all(:,2)-Y_pred_all(:,2)).^2) / ...
                sum((Y_all(:,2)-Y_mean(2)).^2);

        % ===== 保存（超重要）=====
        B_param1_all{iRand,iLambdaType} = B_param1_all_set;
        B_param2_all{iRand,iLambdaType} = B_param2_all_set;
        
        % parameter for plot
        param1_mean_eachPos = zeros(num_postures,1);
        param1_std_eachPos  = zeros(num_postures,1);
        param2_mean_eachPos = zeros(num_postures,1);
        param2_std_eachPos  = zeros(num_postures,1);
        observed_param      = zeros(num_postures,2);

        for p = 1:num_postures
            idx = posture_id == p;

            observed_param(p,:) = mean(Y_all(idx,:),1);

            param1_mean_eachPos(p) = mean(Y_pred_all(idx,1));
            param1_std_eachPos(p)  = std(Y_pred_all(idx,1));

            param2_mean_eachPos(p) = mean(Y_pred_all(idx,2));
            param2_std_eachPos(p)  = std(Y_pred_all(idx,2));
        end
        %plot
        figure;
        % ==== Orientation ====
        subplot(1,2,1);
        errorbar(observed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
            'Color','k','MarkerFaceColor','k','LineWidth',1,'CapSize',3); hold on;
        xlabel('Observed orientation [degree]');
        ylabel({'Decoded orientation [degree]'});
        plot([min(Y_all(:,1)) max(Y_all(:,1))], ...
        [min(Y_all(:,1)) max(Y_all(:,1))], '-', ...
        'Color',[0.5 0.5 0.5],'LineWidth',3);
        axis equal; grid on;
        xlim([20 120]); ylim([20 120]);
        text(27,110,sprintf('R^2 = %.3f',R2_param1_all(iRand,iLambdaType)), ...
        'FontSize',15,'FontWeight','bold');
        ax = gca; 
        ax.FontWeight = 'bold'; % 必要なら太字
        ax.FontSize = 12; % 必要なら太字
        ax.FontName = 'Arial';
        ax.XTickLabelRotation = 0;
        % --- 軸設定 ---       
        % === メモリ設定 ===
        ax.TickDir = 'out';              % メモリを外向きに
        ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
        ax.YMinorTick = 'on';            % Y軸の小目盛をON
        ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
        box off; 

        % ==== Length ====
        subplot(1,2,2);
        errorbar(observed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
        'Color','k','MarkerFaceColor','k','LineWidth',1,'CapSize',3); hold on;
         xlabel('Observed length [mm]');
        ylabel('Decoded length [mm]');
        plot([min(Y_all(:,2)) max(Y_all(:,2))], ...
        [min(Y_all(:,2)) max(Y_all(:,2))], '-', ...
        'Color',[0.5 0.5 0.5],'LineWidth',3);
        axis equal; grid on;
        xlim([65 205]); ylim([65 205]);
        text(75,190,sprintf('R^2 = %.3f',R2_param2_all(iRand,iLambdaType)), ...
        'FontSize',15,'FontWeight','bold');
        bx = gca; 
        bx.FontWeight = 'bold'; % 必要なら太字
        bx.FontSize = 12; % 必要なら太字
        bx.FontName = 'Arial';
        bx.XTickLabelRotation = 0;
        % === メモリ設定 ===
        bx.TickDir = 'out';              % メモリを外向きに
        bx.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
        bx.YMinorTick = 'on';            % Y軸の小目盛をON
        bx.LineWidth = 2;                % 軸線を太く（見やすさアップ）
        box off;
        % === FigureのサイズをA4幅に縮小 ===
        target_width = 20;     % cm （A4幅に収める）
        target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
        set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

        % === PDF出力用にPaperSizeを合わせる ===
        fig = gcf;
        fig.PaperUnits = 'centimeters';
        fig.PaperSize = [target_width target_height];      % 幅 × 高さ
        fig.PaperPosition = [0 0 target_width target_height]; % 余白なし
        fileName = sprintf('5_fold_Decoding_Rand%02d_%s.pdf', iRand, lambdaName);
        print(gcf, fullfile(saveDir,fileName), '-dpdf');
        close(gcf);
    end
end

figure
subplot(2,1,1); hold on
plot(R2_param1_all(:,1), '-o')
plot(R2_param1_all(:,2), '-o')
title('param1')
ylabel('R^2')
legend('MinMSE','1SE')
grid on

subplot(2,1,2); hold on
plot(R2_param2_all(:,1), '-o')
plot(R2_param2_all(:,2), '-o')
title('param2')
xlabel('Random seed index')
ylabel('R^2')
legend('MinMSE','1SE')
grid on
print(gcf, fullfile(baseFigDir,'Decoding_Rand_5fold'), '-dpdf');
close(gcf);

% 
figure;
% ===== param1 =====
subplot(2,1,1); hold on
histogram(R2_param1_all(:,1), 'BinWidth',0.1, 'FaceAlpha',0.5)
histogram(R2_param1_all(:,2), 'BinWidth',0.1, 'FaceAlpha',0.5)
title('param1 R^2 distribution')
xlabel('R^2')
ylabel('Count')
legend('MinMSE','1SE')
grid on

% ===== param2 =====
subplot(2,1,2); hold on
histogram(R2_param2_all(:,1), 'BinWidth',0.1, 'FaceAlpha',0.5)
histogram(R2_param2_all(:,2), 'BinWidth',0.1, 'FaceAlpha',0.5)
title('param2 R^2 distribution')
xlabel('R^2')
ylabel('Count')
legend('MinMSE','1SE')
grid on

print(gcf, fullfile(baseFigDir,'Decoding_Rand_Histogram_bin0p1_5fold'), '-dpdf');
close(gcf);

% -----------------------------------------------------------------------------------------------------------------------------------
efault_rng = rng;   % 現在の乱数状態を保存
num_ramda = 10000;

decording_parameter = 'Orientation_and_Length';
decording_folder = createNamedFolder(experiment3_static_folder_select, 'Decording analysis');
use1SE = true;   % ← true: 1SE, false: MinMSE
% XY position
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- 姿勢ごとのラベル設定 ---
%
if strcmp(decording_parameter, 'Hip_and_Knee')
    obserbed_param = hip_knee_joint_angle_orignal;  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    labels = ["Hip","Knee"];
elseif strcmp(decording_parameter, 'Orientation_and_Length')
    obserbed_param = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'Orientation');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Length');
    labels = ["Orientation","Length"];
elseif strcmp(decording_parameter, 'X_and_Y')
    obserbed_param = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'X');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Y');
else
    disp('error: select parameter Hip_and_Knee or Orientation_and_Length or X_and_Y')
end
num_repeat = 100;   % 乱数の数
lambda_types = {'MinMSE','1SE'};

B_param1_all_3fold = cell(num_repeat, 2);
B_param2_all_3fold= cell(num_repeat, 2);

R2_param1_all_3fold = zeros(num_repeat, 2);
R2_param2_all_3fold= zeros(num_repeat, 2);


baseFigDir = fullfile(decording_lasso_folder, 'Rng_compare_3fold');
mkdir(baseFigDir);

mkdir(fullfile(baseFigDir,'MinMSE'));
mkdir(fullfile(baseFigDir,'1SE'));
% 
for iRand = 1:num_repeat
    rng(iRand);   % ← 乱数固定（論文再現性OK）


    for iLambdaType = 1:2
        
        use1SE = (iLambdaType == 2);
        if use1SE
            lambdaName = '1SE';
        else
            lambdaName = 'MinMSE';
        end
        saveDir = fullfile(baseFigDir, lambdaName);


        % ★ 乱数・λ条件ごとに初期化 ★
        B_param1_all_set = zeros(num_neurons, num_postures);
        B_param2_all_set = zeros(num_neurons, num_postures);

        Y_pred_all = zeros(size(Y_all));

        % ===== Leave-one-posture-out =====
        for leave_out = 1:num_postures

            train_idx = posture_id ~= leave_out;
            test_idx  = posture_id == leave_out;

            X_train = MFR_all(train_idx,:);
            Y_train = Y_all(train_idx,:);
            X_test  = MFR_all(test_idx,:);

            % --- param1 ---
            [B1, FitInfo1] = lasso(X_train, Y_train(:,1), ...
                'Alpha',1,'CV',3,'NumLambda',num_ramda);

            idx1 = FitInfo1.Index1SE;
            if ~use1SE
                idx1 = FitInfo1.IndexMinMSE;
            end

            B_param1 = B1(:,idx1);
            B_param1_all_set(:,leave_out) = B_param1;

            % --- param2 ---
            [B2, FitInfo2] = lasso(X_train, Y_train(:,2), ...
                'Alpha',1,'CV',3,'NumLambda',num_ramda);

            idx2 = FitInfo2.Index1SE;
            if ~use1SE
                idx2 = FitInfo2.IndexMinMSE;
            end

            B_param2 = B2(:,idx2);
            B_param2_all_set(:,leave_out) = B_param2;

            % --- prediction ---
            Y_pred_all(test_idx,1) = X_test * B_param1 + FitInfo1.Intercept(idx1);
            Y_pred_all(test_idx,2) = X_test * B_param2 + FitInfo2.Intercept(idx2);
        end

        % ===== R² =====
        Y_mean = mean(Y_all);
        R2_param1_all_3fold(iRand,iLambdaType) = ...
            1 - sum((Y_all(:,1)-Y_pred_all(:,1)).^2) / ...
                sum((Y_all(:,1)-Y_mean(1)).^2);

        R2_param2_all_3fold(iRand,iLambdaType) = ...
            1 - sum((Y_all(:,2)-Y_pred_all(:,2)).^2) / ...
                sum((Y_all(:,2)-Y_mean(2)).^2);

        % ===== 保存（超重要）=====
        B_param1_all_3fold{iRand,iLambdaType} = B_param1_all_set;
        B_param2_all_3fold{iRand,iLambdaType} = B_param2_all_set;
        
        % parameter for plot
        param1_mean_eachPos_3fold = zeros(num_postures,1);
        param1_std_eachPos_3fold  = zeros(num_postures,1);
        param2_mean_eachPos_3fold = zeros(num_postures,1);
        param2_std_eachPos_3fold  = zeros(num_postures,1);
        observed_param      = zeros(num_postures,2);

        for p = 1:num_postures
            idx = posture_id == p;

            observed_param(p,:) = mean(Y_all(idx,:),1);

            param1_mean_eachPos_3fold(p) = mean(Y_pred_all(idx,1));
            param1_std_eachPos_3fold(p)  = std(Y_pred_all(idx,1));

            param2_mean_eachPos_3fold(p) = mean(Y_pred_all(idx,2));
            param2_std_eachPos_3fold(p)  = std(Y_pred_all(idx,2));
        end
        %plot
        figure;
        % ==== Orientation ====
        subplot(1,2,1);
        errorbar(observed_param(:,1), param1_mean_eachPos_3fold, param1_std_eachPos_3fold, 'o', ...
            'Color','k','MarkerFaceColor','k','LineWidth',1,'CapSize',3); hold on;
        xlabel('Observed orientation [degree]');
        ylabel({'Decoded orientation [degree]'});
        plot([min(Y_all(:,1)) max(Y_all(:,1))], ...
        [min(Y_all(:,1)) max(Y_all(:,1))], '-', ...
        'Color',[0.5 0.5 0.5],'LineWidth',3);
        axis equal; grid on;
        xlim([20 120]); ylim([20 120]);
        text(27,110,sprintf('R^2 = %.3f',R2_param1_all_3fold(iRand,iLambdaType)), ...
        'FontSize',15,'FontWeight','bold');
         ax = gca; 
        ax.FontWeight = 'bold'; % 必要なら太字
        ax.FontSize = 12; % 必要なら太字
        ax.FontName = 'Arial';
        ax.XTickLabelRotation = 0;
        % --- 軸設定 ---       
        % === メモリ設定 ===
        ax.TickDir = 'out';              % メモリを外向きに
        ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
        ax.YMinorTick = 'on';            % Y軸の小目盛をON
        ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
        box off; 

        % ==== Length ====
        subplot(1,2,2);
        errorbar(observed_param(:,2), param2_mean_eachPos_3fold, param2_std_eachPos_3fold, 'o', ...
        'Color','k','MarkerFaceColor','k','LineWidth',1,'CapSize',3); hold on;
         xlabel('Observed length [mm]');
        ylabel('Decoded length [mm]');
        plot([min(Y_all(:,2)) max(Y_all(:,2))], ...
        [min(Y_all(:,2)) max(Y_all(:,2))], '-', ...
        'Color',[0.5 0.5 0.5],'LineWidth',3);
        axis equal; grid on;
        xlim([65 205]); ylim([65 205]);
        text(75,190,sprintf('R^2 = %.3f',R2_param2_all_3fold(iRand,iLambdaType)), ...
        'FontSize',15,'FontWeight','bold');
        bx = gca; 
        bx.FontWeight = 'bold'; % 必要なら太字
        bx.FontSize = 12; % 必要なら太字
        bx.FontName = 'Arial';
        bx.XTickLabelRotation = 0;
        % === メモリ設定 ===
        bx.TickDir = 'out';              % メモリを外向きに
        bx.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
        bx.YMinorTick = 'on';            % Y軸の小目盛をON
        bx.LineWidth = 2;                % 軸線を太く（見やすさアップ）
        box off;
        % === FigureのサイズをA4幅に縮小 ===
        target_width = 20;     % cm （A4幅に収める）
        target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
        set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

        % === PDF出力用にPaperSizeを合わせる ===
        fig = gcf;
        fig.PaperUnits = 'centimeters';
        fig.PaperSize = [target_width target_height];      % 幅 × 高さ
        fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

        fileName = sprintf('lamda_3_fold_Decoding_Rand%02d_%s.pdf', iRand, lambdaName);
        print(gcf, fullfile(saveDir,fileName), '-dpdf');
        close(gcf);
    end
end


% 
figure
subplot(2,1,1); hold on
plot(R2_param1_all(:,1), '-o')
plot(R2_param1_all(:,2), '-o')
title('param1')
ylabel('R^2')
legend('MinMSE','1SE')
grid on

subplot(2,1,2); hold on
plot(R2_param2_all(:,1), '-o')
plot(R2_param2_all(:,2), '-o')
title('param2')
xlabel('Random seed index')
ylabel('R^2')
legend('MinMSE','1SE')
grid on
print(gcf, fullfile(baseFigDir,'Decoding_Rand_3fold'), '-dpdf');
close(gcf);

% 
figure;

% ===== param1 =====
subplot(2,1,1); hold on
histogram(R2_param1_all(:,1), 'BinWidth',0.1, 'FaceAlpha',0.5)
histogram(R2_param1_all(:,2), 'BinWidth',0.1, 'FaceAlpha',0.5)
title('param1 R^2 distribution')
xlabel('R^2')
ylabel('Count')
legend('MinMSE','1SE')
grid on

% ===== param2 =====
subplot(2,1,2); hold on
histogram(R2_param2_all(:,1), 'BinWidth',0.1, 'FaceAlpha',0.5)
histogram(R2_param2_all(:,2), 'BinWidth',0.1, 'FaceAlpha',0.5)
title('param2 R^2 distribution')
xlabel('R^2')
ylabel('Count')
legend('MinMSE','1SE')
grid on

print(gcf, fullfile(baseFigDir,'Decoding_Rand_Histogram_bin0p1_3fold'), '-dpdf');
close(gcf);



%% =====================================================
%  LASSO Decoding model analysis fix_ramda
% =====================================================
default_rng = rng;   % 現在の乱数状態を保存
%rng(255);             % シード固定
rng(104);             % シード固定
num_ramda = 10000;
%decording_parameter = 'Hip_and_Knee';
decording_parameter = 'Orientation_and_Length';
%decording_parameter = 'X_and_Y';
decording_folder = createNamedFolder(experiment3_static_differential_folder, 'Decording analysis');
use1SE = true;   % ← true: 1SE, false: MinMSE

% XY position
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

B_param1_all_set = zeros(num_neurons,num_postures);
B_param2_all_set = zeros(num_neurons,num_postures);
% --- 姿勢ごとのラベル設定 ---


%
if strcmp(decording_parameter, 'Hip_and_Knee')
    obserbed_param = hip_knee_joint_angle_orignal;  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s_fix', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    labels = ["Hip","Knee"];
elseif strcmp(decording_parameter, 'Orientation_and_Length')
    obserbed_param = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s_fix', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'Orientation');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Length');
    labels = ["Orientation","Length"];
elseif strcmp(decording_parameter, 'X_and_Y')
    obserbed_param = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s_fix', num_ramda, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
    param1_result_folder = createNamedFolder(decording_lasso_folder,'X');
    param2_result_folder = createNamedFolder(decording_lasso_folder,'Y');
else
    disp('error: select parameter Hip_and_Knee or Orientation_and_Length or X_and_Y')
end

% =====================================================
%  データ行列作成
% =====================================================

MFR_all = [];
Y_all   = [];
posture_id = [];

for pos = 1:num_postures
    for tr = 1:num_trials
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; obserbed_param(pos,:)];
        posture_id = [posture_id; pos];
    end
end

% =====================================================
%  ★ λを1回だけ決定（全データ）
% =====================================================

[B1_all, FitInfo1_all] = lasso(MFR_all, Y_all(:,1), ...
    'Alpha', 1, 'CV', 5, 'NumLambda', num_ramda);

[B2_all, FitInfo2_all] = lasso(MFR_all, Y_all(:,2), ...
    'Alpha', 1, 'CV', 5, 'NumLambda', num_ramda);

if use1SE
    idx1_fixed = FitInfo1_all.Index1SE;
    idx2_fixed = FitInfo2_all.Index1SE;
else
    idx1_fixed = FitInfo1_all.IndexMinMSE;
    idx2_fixed = FitInfo2_all.IndexMinMSE;
end

lambda1_fixed = FitInfo1_all.Lambda(idx1_fixed);
lambda2_fixed = FitInfo2_all.Lambda(idx2_fixed);

fprintf('Fixed lambda (Param1): %.4e\n', lambda1_fixed);
fprintf('Fixed lambda (Param2): %.4e\n', lambda2_fixed);

% =====================================================
%  Leave-one-posture-out decoding（λ固定）
% =====================================================

Y_pred_all = zeros(size(Y_all));
Y_true_all = Y_all;

B_param1_all_set = zeros(num_neurons, num_postures);
B_param2_all_set = zeros(num_neurons, num_postures);

for leave_out = 1:num_postures

    train_idx = posture_id ~= leave_out;
    test_idx  = posture_id == leave_out;

    X_train = MFR_all(train_idx,:);
    Y_train = Y_all(train_idx,:);
    X_test  = MFR_all(test_idx,:);

    % --- LASSO（CVなし・λ固定）---
    [B1, FitInfo1] = lasso(X_train, Y_train(:,1), ...
        'Alpha', 1, 'Lambda', lambda1_fixed);

    [B2, FitInfo2] = lasso(X_train, Y_train(:,2), ...
        'Alpha', 1, 'Lambda', lambda2_fixed);

    B_param1_all_set(:, leave_out) = B1;
    B_param2_all_set(:, leave_out) = B2;

    % --- 予測 ---
    Y_pred_param1 = X_test * B1 + FitInfo1.Intercept;
    Y_pred_param2 = X_test * B2 + FitInfo2.Intercept;

    Y_pred_all(test_idx,:) = [Y_pred_param1, Y_pred_param2];
end

% =====================================================
%  決定係数 R^2
% =====================================================

Y_true_mean_all = mean(Y_true_all);

SSE1 = sum((Y_true_all(:,1) - Y_pred_all(:,1)).^2);
SST1 = sum((Y_true_all(:,1) - Y_true_mean_all(1)).^2);
R2_param1 = 1 - SSE1 / SST1;

SSE2 = sum((Y_true_all(:,2) - Y_pred_all(:,2)).^2);
SST2 = sum((Y_true_all(:,2) - Y_true_mean_all(2)).^2);
R2_param2 = 1 - SSE2 / SST2;

fprintf('R^2 (%s): %.3f\n', labels(1), R2_param1);
fprintf('R^2 (%s): %.3f\n', labels(2), R2_param2);

% =====================================================
%  姿勢ごとの平均・SD
% =====================================================

param1_mean_eachPos = zeros(num_postures,1);
param1_std_eachPos  = zeros(num_postures,1);
param2_mean_eachPos = zeros(num_postures,1);
param2_std_eachPos  = zeros(num_postures,1);

for pos = 1:num_postures
    idx_range = (pos-1)*num_trials + (1:num_trials);

    block1 = Y_pred_all(idx_range,1);
    block2 = Y_pred_all(idx_range,2);

    param1_mean_eachPos(pos) = mean(block1);
    param1_std_eachPos(pos)  = std(block1);

    param2_mean_eachPos(pos) = mean(block2);
    param2_std_eachPos(pos)  = std(block2);
end


B_param1_all_set;
B_param2_all_set;

%
B_param1_all_set_mean = mean(abs(B_param1_all_set),2);
B_param2_all_set_mean = mean(abs(B_param2_all_set),2);
%%  
if strcmp(decording_parameter, 'Hip_and_Knee')
    % --- 可視化（平均＋標準偏差）---
    figure;
    % ==== Hip (orientation) ====
    subplot(1,2,1);
    errorbar(obserbed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed hip joint [degree]');
    ylabel({'Decoded hip joint [degree]'});
    grid on; axis equal;
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([10 110]); ylim([10 110]);
    
    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(25, 100, sprintf('R^2 = %.3f', R2_param1), ...
     'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial', 'Color', [0 0 0]);
    ax = gca; 
    ax.FontWeight = 'bold'; % 必要なら太字
    ax.FontSize = 12; % 必要なら太字
    ax.FontName = 'Arial';
    ax.XTickLabelRotation = 0;
    % --- 軸設定 ---       
    % === メモリ設定 ===
    ax.TickDir = 'out';              % メモリを外向きに
    ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    ax.YMinorTick = 'on';            % Y軸の小目盛をON
    ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off; 


    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed knee joint [degree]');
    ylabel('Decoded knee joint [degree]');
    grid on; axis equal;
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([30 140]); ylim([30 140]);
    text(45, 130, sprintf('R^2 = %.3f', R2_param2), ...
     'FontSize', 12, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);
    bx = gca; 
    bx.FontWeight = 'bold'; % 必要なら太字
    bx.FontSize = 12; % 必要なら太字
    bx.FontName = 'Arial';
    bx.XTickLabelRotation = 0;
    % === メモリ設定 ===
    bx.TickDir = 'out';              % メモリを外向きに
    bx.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    bx.YMinorTick = 'on';            % Y軸の小目盛をON
    bx.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off;
    % === FigureのサイズをA4幅に縮小 ===
    target_width = 20;     % cm （A4幅に収める）
    target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし
    
    % === PDF保存 ===
    pdfFileName = fullfile(decording_lasso_folder, 'Mean_SD_Hip_Knee CatA.pdf');
    print(fig, pdfFileName, '-dpdf');

elseif strcmp(decording_parameter, 'Orientation_and_Length')
    % --- 可視化（平均＋標準偏差）---
    figure;
    % ==== Hip (orientation) ====
    subplot(1,2,1);
    errorbar(obserbed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed orientation [degree]');
    ylabel({'Decoded orientation [degree]'});
    grid on; axis equal;
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([20 120]); ylim([20 120]);
    xticks(20:20:120);
    xticks(20:20:120);
    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(27, 110, sprintf('R^2 = %.3f', R2_param1), ...
     'FontSize', 15, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);
    ax = gca; 
    ax.FontWeight = 'bold'; % 必要なら太字
    ax.FontSize = 12; % 必要なら太字
    ax.FontName = 'Arial';
    ax.XTickLabelRotation = 0;
    % --- 軸設定 ---       
    % === メモリ設定 ===
    ax.TickDir = 'out';              % メモリを外向きに
    ax.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    ax.YMinorTick = 'on';            % Y軸の小目盛をON
    ax.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off; 



    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed length [mm]');
    ylabel('Decoded length [mm]');
    grid on; axis equal;
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([65 205]); ylim([65 205]);
    xticks(50:25:200);
    yticks(50:25:200);
    text(75, 190 ...
        , sprintf('R^2 = %.3f', R2_param2), ...
     'FontSize', 15, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);
    bx = gca; 
    bx.FontWeight = 'bold'; % 必要なら太字
    bx.FontSize = 12; % 必要なら太字
    bx.FontName = 'Arial';
    bx.XTickLabelRotation = 0;
    % === メモリ設定 ===
    bx.TickDir = 'out';              % メモリを外向きに
    bx.TickLength = [0.02 0.02];     % メモリの長さ調整（[主メモリ 小メモリ]）
    bx.YMinorTick = 'on';            % Y軸の小目盛をON
    bx.LineWidth = 2;                % 軸線を太く（見やすさアップ）
    box off;
    % === FigureのサイズをA4幅に縮小 ===
    target_width = 20;     % cm （A4幅に収める）
    target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
pdfFileName = fullfile(decording_lasso_folder, 'Mean_SD_O_length CatA.pdf');
print(fig, pdfFileName, '-dpdf');
end

%% plot neuron type lasso coefficient


for param_num = 1:2

    % === paramごとの係数行列 ===
    if param_num == 1
        Bmat_lineup = B1_reordered;
        Bmat = B1_sq_norm;
    else
        Bmat_lineup = B2_reordered;
        Bmat = B2_sq_norm;
    end

    label_str = char(labels(param_num));
    param_folder = createNamedFolder(decording_lasso_folder, label_str);

    fig = figure;

    for iModel = 1:16
        ax = subplot(4,4,iModel);

        b = bar(Bmat_lineup(:,iModel), 'FaceColor','flat');
        ylim([0 0.8])
        

        % === ニューロンタイプ色分け ===
        for iNeuron = 1:length(particular_R_angle_related_neuron)
            type_id = particular_R_angle_related_neuron(iNeuron);
            type_id = max(0, min(4, type_id));
            b.CData(iNeuron,:) = colorMap(type_id+1,:);
        end

        % === 軸スタイル（全体共通）===
        set(ax, ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'TickDir','out', ...
    'LineWidth',1.2, ...
    'Box','off', ...
    'XAxisLocation','bottom', ...
    'YAxisLocation','left');
        title(['Leave-out Pos- ' num2str(model_order(iModel))], ...
            'FontWeight','bold','FontSize',18)

        

        % === 左下（13番目）のみラベルを入れる ===
        if iModel == 13
            xlabel({'Electrode ID of', 'the single neuron'}, ...
      'FontSize',18,'FontWeight','bold')
            ylabel({'Normalized coefficient', '(L2 norm = 1)'}, ...
      'FontSize',18,'FontWeight','bold')

        end
    end

    % === Figureサイズ（A4正方）===
    target_width  = 50;   % cm
    target_height = 30;   % cm

    set(fig, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);

    % === 保存 ===
    baseName = fullfile(param_folder, ...
        ['Decoding_model_NormalizedCoeff_' label_str]);

    print(fig, [baseName '.pdf'], '-dpdf', '-painters');
    print(fig, [baseName '.png'], '-dpng', '-r300');
   



% plot neuron pie graph
figure

type_order = [0 4 3 1 2];   % ← 逆順（時計回りに見える）

for iModel = 1:16
    subplot(4,4,iModel)

    % このモデルの係数（2乗和=1）
    weights = Bmat_lineup(:, iModel);

    % ニューロンタイプごとの寄与（0–4）
    contrib_by_type = zeros(1,5);
    for type_id = 0:4
        idx = (particular_R_angle_related_neuron == type_id);
        contrib_by_type(type_id+1) = sum(weights(idx));
    end

    % === 並び替え ===
    contrib_reordered = contrib_by_type(type_order+1);
    color_reordered   = colorMap(type_order+1, :);

    if sum(contrib_reordered) == 0
        pie(1)
        continue
    end

    % 正規化して割合に
    frac = contrib_reordered / sum(contrib_reordered);

    % 円グラフ
    h = pie(frac);

    patch_handles = h(1:2:end);
    text_handles  = h(2:2:end);

    for k = 1:length(patch_handles)

    % 色
    patch_handles(k).FaceColor = color_reordered(k,:);

    % 割合表示
    percent_val = frac(k) * 100;
    text_handles(k).String = sprintf('%.1f%%', percent_val);
    text_handles(k).Color = color_reordered(k,:);
    text_handles(k).FontWeight = 'bold';
    text_handles(k).FontSize = 14;

    % 位置取得
    pos = text_handles(k).Position;
    % ★ type=2 のラベルだけ
    if k == find(type_order == 2)
            pos(2) = pos(2) - 0.05;   
    end

    % 反映
    text_handles(k).Position = pos;
    if param_num == 1
        % ★ type=1 のラベルだけ右へ
        if k == find(type_order == 1)
            pos(1) = pos(1) + 0.4;   
            pos(2) = pos(2) - 0.1;   
        end

        % 反映
        text_handles(k).Position = pos;
    end
    end
    title(['Leave-out Pos- ' num2str(model_order(iModel))], 'FontWeight','bold', 'FontSize',18)

end
 % === Figureサイズ（A4正方）===
    target_width  = 50;   % cm
    target_height = 50;   % cm

    set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);

    % === 保存 ===
    baseName = fullfile(param_folder, ...selected_ratio
        ['Decoding_model_NormalizedCoeff_neuron_type_percent_' label_str]);

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');




 % plot slective frecency
selected_matrix = Bmat ~= 0;

[num_neurons, num_models] = size(selected_matrix);

% 各ニューロンの選択回数（0–16）
selected_count = sum(selected_matrix, 2);

% 正規化（0–1）
selected_ratio = selected_count / num_models;
% ============================================
% neuron × posture RGB マップ作成
% ============================================
RGB = ones(num_neurons, num_models, 3);   % 白背景

for iNeuron = 1:num_neurons
    type_id = particular_R_angle_related_neuron(iNeuron);
    type_id = max(0, min(4, type_id));   % 安全対策
    neuron_color = colorMap(type_id+1, :);

    for iModel = 1:num_models
        if selected_matrix(iNeuron, iModel)
            RGB(iNeuron, iModel, :) = neuron_color;
        end
    end
end




figure

% ===== レイアウト（横長）=====
t = tiledlayout(1,3, 'TileSpacing','compact', 'Padding','compact');

% ============================================
% [左2列] neuron × posture 選択マップ
% ============================================
ax1 = nexttile([1 2]);

image(RGB)
axis tight
hold on

num_models = size(RGB,2);

% --- 姿勢ごとの区切り線（縦線） ---
for x = 0.5 : 1 : num_models + 0.5
    xline(x, 'k-', 'LineWidth', 0.8);
end

hold off

xlabel('Posture (leave-one-out)', 'FontWeight','bold','FontSize',18)
ylabel(('Electrode ID of the single neuron'), ...
      'FontSize',18,'FontWeight','bold')

set(ax1, ...
    'TickDir','out', ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'YDir','normal', ...
    'XTick', 1:num_models, ...
    'XTickLabel', 1:num_models, ...
    'XAxisLocation','bottom', ...
    'YAxisLocation','left')

box off


% ============================================
% [右1列] ニューロン選択頻度（barh）
% ============================================
ax2 = nexttile;

b = barh(selected_ratio, 'FaceColor','flat');

xlim([0 1])
xlabel('Selection frequency (normalized)', 'FontWeight','bold')

% ニューロンタイプ色
for iNeuron = 1:length(selected_ratio)
    type_id = particular_R_angle_related_neuron(iNeuron);
    type_id = max(0, min(4, type_id));
    b.CData(iNeuron,:) = colorMap(type_id+1,:);
end

set(ax2, ...
    'TickDir','out', ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'YDir','normal', ...
    'YTick', [], ...              % ← Y軸目盛りを消す
    'YAxisLocation','left', ...
    'XAxisLocation','bottom')

    box off

    % === Figureサイズ（A4正方）===
    target_width  = 50;   % cm
    target_height = 30;   % cm

    set(gcf, 'Units','centimeters', ...
        'Position',[5 5 target_width target_height], ...
        'PaperUnits','centimeters', ...
        'PaperSize',[target_width target_height], ...
        'PaperPosition',[0 0 target_width target_height]);

    % === 保存 ===
    baseName = fullfile(param_folder, ...
        ['Decoding_model_Coeff_Selection_frequency' label_str]);

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');
end

%% --- 集計 ---
B_param1_mean  = mean(B_param1_all, 2);
B_param1_std   = std(B_param1_all, 0, 2);
B_param2_mean = mean(B_param2_all, 2);
B_param2_std  = std(B_param2_all, 0, 2);

R2_param1_mean  = mean(R2_param1_all);
R2_param1_std   = std(R2_param1_all);
R2_param2_mean = mean(R2_param2_all);
R2_param2_std  = std(R2_param2_all);

fprintf('\n===== Summary (10 runs) =====\n');
fprintf('Hip:  R^2 = %.3f ± %.3f\n', R2_param1_mean,  R2_param1_std);
fprintf('Knee: R^2 = %.3f ± %.3f\n', R2_param2_mean, R2_param2_std);





num_postures = 16;
num_trials = 5;
num_runs = size(param1_predict_all, 2); % =10

param1_mean_eachPos = zeros(num_postures, 1);
param1_std_eachPos  = zeros(num_postures, 1);

param2_mean_eachPos = zeros(num_postures, 1);
param2_std_eachPos  = zeros(num_postures, 1);

for pos = 1:num_postures
    % その姿勢の該当行インデックス（例：1–5, 6–10, …）
    idx_range = (pos-1)*num_trials + (1:num_trials);

    % 該当する5行×10列を取り出す
    block_param1 = param1_predict_all(idx_range, :);  % 5×10
    block_param2 = param2_predict_all(idx_range, :);  % 5×10

    % 各列（run）ごとに平均と標準偏差
    param1_mean_eachPos(pos, 1) = mean(block_param1(:));
    param1_std_eachPos(pos, 1)  = std(block_param1(:));
    param2_mean_eachPos(pos, 1) = mean(block_param2(:));
    param2_std_eachPos(pos, 1)  = std(block_param2(:));

end

rng(default_rng);

%% =====================================================
%  LASSO Decoding model analysis (10 repetitions) ramda 100 *100
% =====================================================
%{
default_rng = rng;   % 現在の乱数状態を保存
rng(255);             % シード固定

num_runs = 10;
%decording_parameter = 'Hip_and_Knee';
decording_parameter = 'Orientation_and_Length';
%decording_parameter = 'X_and_Y';
decording_folder = createNamedFolder(experiment3_static_differential_folder, 'Decording analysis');

% XY position
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- 姿勢ごとのラベル設定 ---


%
if strcmp(decording_parameter, 'Hip_and_Knee')
    obserbed_param = hip_knee_joint_angle_orignal;  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%druns_%s', num_runs, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
elseif strcmp(decording_parameter, 'Orientation_and_Length')
    obserbed_param = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%druns_%s', num_runs, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
elseif strcmp(decording_parameter, 'X_and_Y')
    obserbed_param = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%druns_%s', num_runs, decording_parameter);
    decording_lasso_folder = createNamedFolder(decording_folder, folder_name);
else
    disp('error: select parameter Hip_and_Knee or Orientation_and_Length or X_and_Y')
end
% --- データ行列作成 ---
MFR_all = [];   
Y_all   = [];   
posture_id = [];

for pos = 1:num_postures
    for tr = 1:num_trials
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; obserbed_param(pos,:)]; 
        posture_id = [posture_id; pos];
    end
end

% =====================================================

B_param1_all  = zeros(num_neurons, num_runs);
B_param2_all = zeros(num_neurons, num_runs);

FitInfo1_all = cell(num_runs,1);
FitInfo2_all = cell(num_runs,1);

R2_param1_all  = zeros(num_runs,1);
R2_param2_all = zeros(num_runs,1);

param1_predict_all  = zeros(num_trials*num_postures,num_runs);
param2_predict_all = zeros(num_trials*num_postures,num_runs);

rng(10)
for run_i = 1:num_runs

    % --- Leave-one-posture-out decoding ---
    Y_pred_all = zeros(size(Y_all));
    Y_true_all = Y_all;

    for leave_out = 1:num_postures
        train_idx = posture_id ~= leave_out;
        test_idx  = posture_id == leave_out;

        X_train = MFR_all(train_idx,:);
        Y_train = Y_all(train_idx,:);
        X_test  = MFR_all(test_idx,:);
        Y_test  = Y_all(test_idx,:);

        % --- LASSO回帰（Hip, Knee）---
        [B1,FitInfo1] = lasso(X_train, Y_train(:,1), 'Alpha', 1, 'CV', 5);
        idxLambdaMinMSE1 = FitInfo1.IndexMinMSE;
        B_param1 = B1(:, idxLambdaMinMSE1);

        [B2,FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha', 1, 'CV', 5);
        idxLambdaMinMSE2 = FitInfo2.IndexMinMSE;
        B_param2 = B2(:, idxLambdaMinMSE2);

        % --- テストデータ予測 ---
        Y_pred_hip  = X_test * B_param1 + FitInfo1.Intercept(idxLambdaMinMSE1);
        Y_pred_knee = X_test * B_param2 + FitInfo2.Intercept(idxLambdaMinMSE2);
        Y_pred_all(test_idx,:) = [Y_pred_hip, Y_pred_knee];
    end

    % --- 結果のまとめ ---
    Y_true_mean_all = mean(Y_true_all);
    SSE_param1_decording = sum((Y_true_all(:,1)-Y_pred_all(:,1)).^2);
    SST_param1_decording = sum((Y_true_all(:,1)-Y_true_mean_all(1,1)).^2);
    R_square_param1_decording = 1-(SSE_param1_decording/SST_param1_decording);

    SSE_param2_decording = sum((Y_true_all(:,2)-Y_pred_all(:,2)).^2);
    SST_param2_decording = sum((Y_true_all(:,2)-Y_true_mean_all(1,2)).^2);
    R_square_param2_decording = 1-(SSE_param2_decording/SST_param2_decording);

    % 保存
    R2_param1_all(run_i)  = R_square_param1_decording;
    R2_param2_all(run_i) = R_square_param2_decording;
    B_param1_all(:,run_i)  = B_param1;
    B_param2_all(:,run_i) = B_param2;
    FitInfo1_all{run_i} = FitInfo1;
    FitInfo2_all{run_i} = FitInfo2;
    param1_predict_all(:,run_i) = Y_pred_all(:,1);
    param2_predict_all(:,run_i) = Y_pred_all(:,2);

    % --- 可視化（各Run）---
    if strcmp(decording_parameter, 'Hip_and_Knee')
        fig = figure('Visible','off');
        subplot(1,2,1);
        scatter(Y_true_all(:,1), Y_pred_all(:,1), 20, 'k', 'filled'); hold on;
        xlabel('Observed hip joint angle [degree]');
        ylabel({'Decoded hip joint angle [degree]'});
        grid on; axis equal;
        plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 2);
        xlim([10 110]); ylim([10 110]);
        % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
        text(25, 100, sprintf('R^2 = %.3f', R_square_param1_decording), ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
        subplot(1,2,2);
        scatter(Y_true_all(:,2), Y_pred_all(:,2), 20, 'k', 'filled'); hold on;
        xlabel('Observed knee joint angle [degree]');
        ylabel('Decoded knee joint angle [degree]');
        grid on; axis equal;
        plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);
        xlim([30 140]); ylim([30 140]);
        text(45, 130, sprintf('R^2 = %.3f', R_square_param2_decording), ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
        set(gcf, 'Units', 'centimeters');  
        set(gcf, 'Position', [2, 2, 21.0, 10]);  % A4縦の1/4サイズ
        set(findall(gcf,'-property','FontName'),'FontName','Arial');
        set(findall(gcf,'-property','FontSize'),'FontSize',12);
        pdf_file = fullfile(decording_lasso_folder, sprintf('Theta_true_vs_L_run%02d.pdf', run_i));
        exportgraphics(gcf, pdf_file, 'ContentType', 'vector', 'Resolution', 300, 'BackgroundColor', 'white');
        close(fig);
        fprintf('✅ Run %d saved to: %s\n', run_i, pdf_file);
    elseif strcmp(decording_parameter, 'Orientation_and_Length')
        fig = figure('Visible','off');
        subplot(1,2,1);
        scatter(Y_true_all(:,1), Y_pred_all(:,1), 20, 'k', 'filled'); hold on;
        xlabel('Observed orientation [degree]');
        ylabel({'Decoded orientation [degree]'});
        grid on; axis equal;
        plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 2);
        xlim([0 150]); ylim([0 150]);
        % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
        text(25, 125, sprintf('R^2 = %.3f', R_square_param1_decording), ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
        subplot(1,2,2);
        scatter(Y_true_all(:,2), Y_pred_all(:,2), 20, 'k', 'filled'); hold on;
        xlabel('Observed length [mm]');
        ylabel('Decoded length [mm]');
        grid on; axis equal;
        plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);
        xlim([50 250]); ylim([50 250]);
        text(75, 225, sprintf('R^2 = %.3f', R_square_param2_decording), ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
        set(gcf, 'Units', 'centimeters');  
        set(gcf, 'Position', [2, 2, 21.0, 10]);  % A4縦の1/4サイズ
        set(findall(gcf,'-property','FontName'),'FontName','Arial');
        set(findall(gcf,'-property','FontSize'),'FontSize',12);
        pdf_file = fullfile(decording_lasso_folder, sprintf('Theta_true_vs_L_run%02d.pdf', run_i));
        exportgraphics(gcf, pdf_file, 'ContentType', 'vector', 'Resolution', 300, 'BackgroundColor', 'white');
        close(fig);
        fprintf('✅ Run %d saved to: %s\n', run_i, pdf_file);
        elseif strcmp(decording_parameter, 'X_and_Y')

    end
end

% --- 集計 ---
B_param1_mean  = mean(B_param1_all, 2);
B_param1_std   = std(B_param1_all, 0, 2);
B_param2_mean = mean(B_param2_all, 2);
B_param2_std  = std(B_param2_all, 0, 2);

R2_param1_mean  = mean(R2_param1_all);
R2_param1_std   = std(R2_param1_all);
R2_param2_mean = mean(R2_param2_all);
R2_param2_std  = std(R2_param2_all);

fprintf('\n===== Summary (10 runs) =====\n');
fprintf('Hip:  R^2 = %.3f ± %.3f\n', R2_param1_mean,  R2_param1_std);
fprintf('Knee: R^2 = %.3f ± %.3f\n', R2_param2_mean, R2_param2_std);





num_postures = 16;
num_trials = 5;
num_runs = size(param1_predict_all, 2); % =10

param1_mean_eachPos = zeros(num_postures, 1);
param1_std_eachPos  = zeros(num_postures, 1);

param2_mean_eachPos = zeros(num_postures, 1);
param2_std_eachPos  = zeros(num_postures, 1);

for pos = 1:num_postures
    % その姿勢の該当行インデックス（例：1–5, 6–10, …）
    idx_range = (pos-1)*num_trials + (1:num_trials);

    % 該当する5行×10列を取り出す
    block_param1 = param1_predict_all(idx_range, :);  % 5×10
    block_param2 = param2_predict_all(idx_range, :);  % 5×10

    % 各列（run）ごとに平均と標準偏差
    param1_mean_eachPos(pos, 1) = mean(block_param1(:));
    param1_std_eachPos(pos, 1)  = std(block_param1(:));
    param2_mean_eachPos(pos, 1) = mean(block_param2(:));
    param2_std_eachPos(pos, 1)  = std(block_param2(:));

end

% K
if strcmp(decording_parameter, 'Hip_and_Knee')
    % --- 可視化（平均＋標準偏差）---
    figure;
    % ==== Hip (orientation) ====
    subplot(1,2,1);
    errorbar(obserbed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed hip joint angle [degree]');
    ylabel({'Decoded hip joint angle [degree]'});
    grid on; axis equal;
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([10 110]); ylim([10 110]);

    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(25, 100, sprintf('R^2 = %.3f ± %.3f\n', R2_param1_mean,  R2_param1_std), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed knee joint angle [degree]');
    ylabel('Decoded knee joint angle [degree]');
    grid on; axis equal;
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([30 140]); ylim([30 140]);
    text(45, 130, sprintf('R^2 = %.3f ± %.3f\n', R2_param2_mean, R2_param2_std), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
    % ==== Figure設定 ====
    set(gcf, 'Units', 'centimeters');  
    set(gcf, 'Position', [2, 2, 21.0, 10]);  % A4縦の1/4サイズ
    set(findall(gcf,'-property','FontName'),'FontName','Arial');
    set(findall(gcf,'-property','FontSize'),'FontSize',12);
    % ==== PDF保存 ====
    pdf_file = fullfile(decording_lasso_folder, 'Mean_SD_Hip_Knee.pdf');
    exportgraphics(gcf, pdf_file, 'ContentType', 'vector', 'Resolution', 300, 'BackgroundColor', 'white');
    fprintf('✅ 平均＋標準偏差グラフを保存しました: %s\n', pdf_file);
elseif strcmp(decording_parameter, 'Orientation_and_Length')
    % --- 可視化（平均＋標準偏差）---
    figure;
    % ==== Hip (orientation) ====
    subplot(1,2,1);
    errorbar(obserbed_param(:,1), param1_mean_eachPos, param1_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed orientation [degree]');
    ylabel({'Decoded orientation [degree]'});
    grid on; axis equal;
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([20 120]); ylim([20 120]);

    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(25, 110, sprintf('R^2 = %.3f ± %.3f\n', R2_param1_mean,  R2_param1_std), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed length [mm]');
    ylabel('Decoded length [mm]');
    grid on; axis equal;
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([50 200]); ylim([50 200]);
    text(70, 185, sprintf('R^2 = %.3f ± %.3f\n', R2_param2_mean, R2_param2_std), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
    % ==== Figure設定 ====
    set(gcf, 'Units', 'centimeters');  
    set(gcf, 'Position', [2, 2, 21.0, 10]);  % A4縦の1/4サイズ
    set(findall(gcf,'-property','FontName'),'FontName','Arial');
    set(findall(gcf,'-property','FontSize'),'FontSize',12);
    % ==== PDF保存 ====
    pdf_file = fullfile(decording_lasso_folder, 'Mean_SD_O_length.pdf');
    exportgraphics(gcf, pdf_file, 'ContentType', 'vector', 'Resolution', 300, 'BackgroundColor', 'white');
    fprintf('✅ 平均＋標準偏差グラフを保存しました: %s\n', pdf_file);
    % 乱数を元に戻す
end
rng(default_rng);
%}

%% 
%{
%% === 乱数シードの固定と保存 === decording analysis main part
default_rng = rng;   % 現在の乱数状態を保存
rng(42);             % 再現性のためシードを固定（任意の数）

% =====================================================
% 以下、あなたの既存コード
% =====================================================

decording_folder = createNamedFolder(experiment3_static_differential_folder, 'Decording analysis');
decording_lasso_folder = createNamedFolder(decording_folder, 'Lasso');

% XY position 
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
%{
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Endpoint_Xpos_center = Endpoint_Xpos-mean(Endpoint_Xpos);
Endpoint_Ypos_center = Endpoint_Ypos-mean(Endpoint_Ypos);
scatter(Endpoint_Xpos_center,Endpoint_Ypos_center)
%}

Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- 姿勢ごとのラベル設定 ---
joint_angles = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]

% --- データ行列作成 ---
MFR_all = [];   
Y_all   = [];   
posture_id = [];

for pos = 1:num_postures
    for tr = 1:num_trials
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; joint_angles(pos,:)]; 
        posture_id = [posture_id; pos];
    end
end

% --- 姿勢ごとのクロスバリデーション ---
Y_pred_all = zeros(size(Y_all));
Y_true_all = Y_all;

for leave_out = 1:num_postures
    train_idx = posture_id ~= leave_out;
    test_idx  = posture_id == leave_out;

    X_train = MFR_all(train_idx,:);
    Y_train = Y_all(train_idx,:);
    X_test  = MFR_all(test_idx,:);
    Y_test  = Y_all(test_idx,:);

    % --- LASSO回帰（Hip, Knee）---
    [B1,FitInfo1] = lasso(X_train, Y_train(:,1), 'Alpha', 1, 'CV', 5); % Hip
    idxLambdaMinMSE1 = FitInfo1.IndexMinMSE;
    B_hip = B1(:, idxLambdaMinMSE1);

    [B2,FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha', 1, 'CV', 5); % Knee
    idxLambdaMinMSE2 = FitInfo2.IndexMinMSE;
    B_knee = B2(:, idxLambdaMinMSE2);

    % --- テストデータ予測 ---
    Y_pred_hip  = X_test * B_hip + FitInfo1.Intercept(idxLambdaMinMSE1);
    Y_pred_knee = X_test * B_knee + FitInfo2.Intercept(idxLambdaMinMSE2);

    Y_pred_all(test_idx,:) = [Y_pred_hip, Y_pred_knee];
end

% --- 結果のまとめ ---
Y_pred_mean = zeros(num_postures, 2);
Y_true_mean = zeros(num_postures, 2);
for pos = 1:num_postures
    idx = posture_id == pos;
    Y_pred_mean(pos,:) = mean(Y_pred_all(idx,:),1);
    Y_true_mean(pos,:) = mean(Y_true_all(idx,:),1);
end

% --- R^2計算 ---
Y_true_mean_all = mean(Y_true_all);
SSE_hip_decording = sum((Y_true_all(:,1)-Y_pred_all(:,1)).^2);
SST_hip_decording = sum((Y_true_all(:,1)-Y_true_mean_all(1,1)).^2);
R_square_hip_decording = 1-(SSE_hip_decording/SST_hip_decording);

SSE_knee_decording = sum((Y_true_all(:,2)-Y_pred_all(:,2)).^2);
SST_knee_decording = sum((Y_true_all(:,2)-Y_true_mean_all(1,2)).^2);
R_square_knee_decording = 1-(SSE_knee_decording/SST_knee_decording);

%% --- 可視化 ---
figure;
subplot(1,2,1);
scatter(Y_true_all(:,1), Y_pred_all(:,1), 20, 'k', 'filled'); hold on;
xlabel('True theta');
ylabel('Predicted theta');
xlabel('Observed orientation [degree]'); ylabel({'Decoded orientation [degree]'});
%title(sprintf('theta (R^2 = %.3f)', R_square_hip_decording));
%title('Sub A',sprintf('R^2 = %.3f', R_square_hip_decording));
title(sprintf('R^2 = %.3f', R_square_hip_decording));
grid on; axis equal;
plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
     [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
     '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 2);
xlim([0 150])
ylim([0 150])
fontsize(20,'points')

subplot(1,2,2);
scatter(Y_true_all(:,2), Y_pred_all(:,2), 20, 'k', 'filled'); hold on;
xlabel('Observed length [mm]'); ylabel('Decorded length [mm]');
%title('Sub B',sprintf('R^2 = %.3f', R_square_knee_decording));
title(sprintf('R^2 = %.3f', R_square_hip_decording));
grid on; axis equal;
plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
     [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
     '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);
xlim([50 250])
ylim([50 250])
% === A4縦の1/4サイズ設定 ===
set(gcf, 'Units', 'centimeters');  
set(gcf, 'Position', [2, 2, 21.0, 7.425]);  % 横21cm × 縦7.425cm（A4縦の1/4）

% フォントや余白の見栄えを調整（必要に応じて）
set(findall(gcf,'-property','FontName'),'FontName','Arial');
set(findall(gcf,'-property','FontSize'),'FontSize',12);

% === PDF保存 ===
pdf_file = fullfile(decording_lasso_folder, 'Theta_true_vs_L.pdf');
exportgraphics(gcf, pdf_file, 'ContentType', 'vector', 'Resolution', 300, 'BackgroundColor', 'white');

disp(['✅ PDFファイルとして保存しました: ' pdf_file]);


% =====================================================
% === 乱数シードを元に戻す ===
rng(default_rng);
%% =====================================================

%% Decording model analysis
%----------------------------------------------------------------------
MFR_sep_zscore_pos;
% --- 基本設定 ---
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- 姿勢ごとのラベル（関節角度） ---
% 例：16×2 の行列
%joint_angles = [hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1)];
joint_angles = hip_knee_joint_angle_orignal;
% --- データ行列を作成 ---
% 各試行×姿勢ごとにニューロン発火率を並べる
MFR_all = [];   % (試行×姿勢) × ニューロン
Y_all   = [];   % (試行×姿勢) × 2
trial_id = [];

for tr = 1:num_trials
    for pos = 1:num_postures
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; joint_angles(pos,:)]; % 関節角度
        trial_id = [trial_id; tr];
    end
end

% --- 学習データ（試行4–5）とテストデータ（試行1–3）に分割 ---
train_idx = ismember(trial_id, [1,2,3]);
test_idx  = ismember(trial_id, [4,5]);

X_train = MFR_all(train_idx,:);
Y_train = Y_all(train_idx,:);
X_test  = MFR_all(test_idx,:);
Y_test  = Y_all(test_idx,:);

% --- スパース回帰（LASSOなど） ---
[B,FitInfo] = lasso(X_train, Y_train(:,1), 'Alpha', 0.1, 'CV', 5); % Hip
idxLambdaMinMSE = FitInfo.IndexMinMSE;
B_knee = B(:, idxLambdaMinMSE);

[B2,FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha', 0.1, 'CV', 5); % Knee
idxLambdaMinMSE2 = FitInfo2.IndexMinMSE;
B_ankle = B2(:, idxLambdaMinMSE2);

% --- 予測 ---
Y_pred_knee  = X_test * B_knee + FitInfo.Intercept(idxLambdaMinMSE);
Y_pred_ankle = X_test * B_ankle + FitInfo2.Intercept(idxLambdaMinMSE2);
Y_pred = [Y_pred_knee, Y_pred_ankle];

% --- 評価 ---
R_knee  = corr(Y_pred(:,1), Y_test(:,1));
R_ankle = corr(Y_pred(:,2), Y_test(:,2));
fprintf('Hip R=%.2f, Knee R=%.2f\n', R_knee, R_ankle);

% --- 相関プロット（Hip / Knee） ---

figure;
subplot(1,2,1)
scatter(Y_test(:,1), Y_pred(:,1), 70, 'filled');
hold on;
plot(xlim, xlim, 'r--', 'LineWidth', 1.5);
xlabel('True Hip Angle');
ylabel('Predicted Hip Angle');
title(sprintf('Hip: R = %.2f', R_knee));
axis equal; grid on;

subplot(1,2,2)
scatter(Y_test(:,2), Y_pred(:,2), 70, 'filled');
hold on;
plot(xlim, xlim, 'r--', 'LineWidth', 1.5);
xlabel('True Knee Angle');
ylabel('Predicted Knee Angle');
title(sprintf('Knee: R = %.2f', R_ankle));
axis equal; grid on;
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(decording_lasso_folder, 'Lasso_1_3Train_45test.tif');
print(gcf, tifFileName, '-dtiff', '-r300');
% --- 回帰係数の可視化 ---
figure;

% Hipの係数
subplot(2,1,1)
bar(B_knee, 'FaceColor',[0.2 0.6 0.9]);
xlabel('Neuron Index');
ylabel('Weight');
title('LASSO Coefficients for Hip Angle');
grid on;

% Kneeの係数
subplot(2,1,2)
bar(B_ankle, 'FaceColor',[0.9 0.4 0.2]);
xlabel('Neuron Index');
ylabel('Weight');
title('LASSO Coefficients for Knee Angle');
grid on;
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(decording_lasso_folder, 'Lasso_cofficients_1_3Train_45test.tif');
print(gcf, tifFileName, '-dtiff', '-r300');



%% Decoding model analysis (leave-one-posture-out)
%----------------------------------------------------------------------
decording_folder = createNamedFolder(experiment3_static_differential_folder, 'Decording analysis');
decording_lasso_folder = createNamedFolder(decording_folder, 'Lasso');

%XY position 
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Endpoint_Xpos_center = Endpoint_Xpos-mean(Endpoint_Xpos);
Endpoint_Ypos_center = Endpoint_Ypos-mean(Endpoint_Ypos);
scatter(Endpoint_Xpos_center,Endpoint_Ypos_center)


Leg_length = [link_HipToAnkle,pos_number'];
Theta_hip_to_ankle_ori = [compute_joint_angle(orientation_standard,hip_mean,Ankle_mean),pos_number'];

MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% if joint angle or nxy position

% --- 姿勢ごとのラベル（関節角度） ---
joint_angles = hip_knee_joint_angle_orignal;  % [16 x 2]
% --- 姿勢ごとのラベル（Endpoint） ---
joint_angles = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
% --- 姿勢ごとのラベル（L and theta） ---
joint_angles = [Theta_hip_to_ankle_ori(:,1),Leg_length(:,1)];  % [16 x 2]

% --- データ行列作成 ---
MFR_all = [];   % (試行×姿勢) × ニューロン
Y_all   = [];   % (試行×姿勢) × 2
posture_id = [];

for pos = 1:num_postures
    for tr = 1:num_trials
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; joint_angles(pos,:)]; % 関節角度
        posture_id = [posture_id; pos];
    end
end

% --- 姿勢ごとのクロスバリデーション ---
Y_pred_all = zeros(size(Y_all));
Y_true_all = Y_all;

for leave_out = 1:num_postures
    % --- 学習・テスト分割 ---
    train_idx = posture_id ~= leave_out;
    test_idx  = posture_id == leave_out;

    X_train = MFR_all(train_idx,:);
    Y_train = Y_all(train_idx,:);
    X_test  = MFR_all(test_idx,:);
    Y_test  = Y_all(test_idx,:);

    % --- LASSO回帰（Hip, Knee）---
    [B1,FitInfo1] = lasso(X_train, Y_train(:,1), 'Alpha', 1, 'CV', 5); % Hip
    idxLambdaMinMSE1 = FitInfo1.IndexMinMSE;
    B_hip = B1(:, idxLambdaMinMSE1);

    [B2,FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha', 1, 'CV', 5); % Knee
    idxLambdaMinMSE2 = FitInfo2.IndexMinMSE;
    B_knee = B2(:, idxLambdaMinMSE2);

    % --- テストデータ予測 ---
    Y_pred_hip  = X_test * B_hip + FitInfo1.Intercept(idxLambdaMinMSE1);
    Y_pred_knee = X_test * B_knee + FitInfo2.Intercept(idxLambdaMinMSE2);

    Y_pred_all(test_idx,:) = [Y_pred_hip, Y_pred_knee];
end

% --- 結果のまとめ ---
% 姿勢ごと平均（試行の平均をとる）
Y_pred_mean = zeros(num_postures, 2);
Y_true_mean = zeros(num_postures, 2);

for pos = 1:num_postures
    idx = posture_id == pos;
    Y_pred_mean(pos,:) = mean(Y_pred_all(idx,:),1);
    Y_true_mean(pos,:) = mean(Y_true_all(idx,:),1);
end
 
%Rsquare each angle
Y_true_mean_all = mean(Y_true_all);

%for hip
SSE_hip_decording = sum((Y_true_all(:,1)-Y_pred_all(:,1)).^2);
SST_hip_decording = sum((Y_true_all(:,1)-Y_true_mean_all(1,1)).^2);

R_square_hip_decording = 1-(SSE_hip_decording/SST_hip_decording);

%for knee
SSE_knee_decording = sum((Y_true_all(:,2)-Y_pred_all(:,2)).^2);
SST_knee_decording = sum((Y_true_all(:,2)-Y_true_mean_all(1,2)).^2);
R_square_knee_decording = 1-(SSE_knee_decording/SST_knee_decording);

% --- 可視化 ---
figure;

% 1. Hip
subplot(1,2,1);
scatter(Y_true_all(:,1), Y_pred_all(:,1), 40, 'b', 'filled'); hold on;
xlabel('True theta');
ylabel('Predicted theta');
title(sprintf('theta (R^2 = %.3f)', R_square_hip_decording));
%xlabel('True X position');
%ylabel('Predicted X position');
%title(sprintf('Xpos decoding (R^2 = %.3f)', R_square_hip_decording));
%xlabel('True Hip angle');
%ylabel('Predicted Hip angle');
%title(sprintf('Hip decoding (R^2 = %.3f)', R_square_hip_decording));
grid on; axis equal;

% 45°ライン（理想線）
xlim_auto = xlim;
ylim_auto = ylim;
plot([min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], ...
     [min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], 'r--', 'LineWidth', 1.5);

% 回帰直線を描画
p_hip = polyfit(Y_true_all(:,1), Y_pred_all(:,1), 1);
x_fit = linspace(min(Y_true_all(:,1)), max(Y_true_all(:,1)), 100);
y_fit = polyval(p_hip, x_fit);
plot(x_fit, y_fit, 'k-', 'LineWidth', 1.5);
legend('Data points', 'Ideal line', 'Regression line', 'Location', 'best');
fontsize(20,'points')

% 2. Knee
subplot(1,2,2);
scatter(Y_true_all(:,2), Y_pred_all(:,2), 40, 'b', 'filled'); hold on;
xlabel('True L');
ylabel('Predicted L');
title(sprintf('L decoding (R^2 = %.3f)', R_square_knee_decording));
%xlabel('True Y position');
%ylabel('Predicted Y position');
%title(sprintf('Ypos decoding (R^2 = %.3f)', R_square_knee_decording));
%xlabel('True Knee angle');
%ylabel('Predicted Knee angle');
%title(sprintf('Knee decoding (R^2 = %.3f)', R_square_knee_decording));
grid on; axis equal;

xlim_auto = xlim;
ylim_auto = ylim;
plot([min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], ...
     [min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], 'r--', 'LineWidth', 1.5);

p_knee = polyfit(Y_true_all(:,2), Y_pred_all(:,2), 1);
x_fit = linspace(min(Y_true_all(:,2)), max(Y_true_all(:,2)), 100);
y_fit = polyval(p_knee, x_fit);
plot(x_fit, y_fit, 'k-', 'LineWidth', 1.5);
legend('Data points', 'Ideal line', 'Regression line', 'Location', 'best');
sgtitle('Decoding performance: True vs Predicted Endpoint L theta');
%sgtitle('Decoding performance: True vs Predicted joint angles');
fontsize(20,'points')
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
saveas(gcf, fullfile(decording_lasso_folder, 'Theta_true_vs_L.tif'));
%saveas(gcf, fullfile(decording_lasso_folder, 'Angle_true_vs_predicted_angle.tif'));
%saveas(gcf, fullfile(decording_lasso_folder, 'Angle_true_vs_predicted_endpoint.tif'));


%% 
% --- 可視化 ---
% --- 姿勢ごとの Hip / Knee 予測結果を棒グラフで比較 ---
figure;
set(gcf, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.6]);

% 姿勢インデックス
postures = 1:num_postures;

% ==== Hip ====
subplot(2,1,1);
bar(postures, [Y_true_mean(:,1), Y_pred_mean(:,1)], 'grouped');
xlabel('Posture index');
ylabel('Hip angle');
legend({'True', 'Predicted'}, 'Location', 'best');
title('Hip angle: True vs Predicted');
grid on;

% ==== Knee ====
subplot(2,1,2);
bar(postures, [Y_true_mean(:,2), Y_pred_mean(:,2)], 'grouped');
xlabel('Posture index');
ylabel('Knee angle');
legend({'True', 'Predicted'}, 'Location', 'best');
title('Knee angle: True vs Predicted');
fontsize(16,'points')
grid on;
%saveas(gcf, fullfile(decording_lasso_folder, 'Posture_wise_true_vs_predicted_bar.tif'));

%{
% --- オプション: 図を保存 ---
%saveas(gcf, fullfile(decording_lasso_folder, 'Posture_wise_true_vs_predicted_bar.tif'));
%
figure;
hold on; axis equal; grid on;

% 真の関節角度（赤）
scatter(Y_true_mean(:,1), Y_true_mean(:,2), 80, 'r', 'filled', 'DisplayName','True');

% 予測された関節角度（青）
scatter(Y_pred_mean(:,1), Y_pred_mean(:,2), 80, 'b', 'filled', 'DisplayName','Predicted');

% 姿勢ごとの対応を線で結ぶ（真値→予測）
for p = 1:num_postures
    plot([Y_true_mean(p,1), Y_pred_mean(p,1)], ...
         [Y_true_mean(p,2), Y_pred_mean(p,2)], ...
         'k-', 'LineWidth', 1.0);
end

xlabel('Hip angle');
ylabel('Knee angle');
title('True (red) vs Predicted (blue) posture positions');
legend('Location','best');
set(gca, 'FontSize', 12);

% 図を保存
saveas(gcf, fullfile(decording_lasso_folder, 'True_vs_Predicted_2D_PostureSpace.tif'));
%}
% 
% === 姿勢ごとの誤差解析 ===
error_all = Y_pred_all - Y_true_all;  % 各試行の誤差（予測 - 真値）
error_mean = zeros(num_postures, 2);
error_std  = zeros(num_postures, 2);

for pos = 1:num_postures
    idx = posture_id == pos;
    error_mean(pos,:) = mean(error_all(idx,:), 1);
    error_std(pos,:)  = std(error_all(idx,:), [], 1);
end

% === 可視化 ===
figure;
set(gcf, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.6]);

% ==== Hip ====
subplot(2,1,1);
bar(postures, error_mean(:,1), 'FaceColor', [0.2 0.6 0.9]);
hold on;
errorbar(postures, error_mean(:,1), error_std(:,1), 'k.', 'LineWidth', 1.2);
yline(0,'--r');
ylim([-30 30])
xlabel('Posture index');
ylabel('Prediction error (Pred - True)');
title('Hip angle prediction error (mean ± SD)');
grid on;

% ==== Knee ====
subplot(2,1,2);
bar(postures, error_mean(:,2), 'FaceColor', [0.9 0.4 0.2]);
hold on;
errorbar(postures, error_mean(:,2), error_std(:,2), 'k.', 'LineWidth', 1.2);
yline(0,'--r');
ylim([-30 30])
xlabel('Posture index');
ylabel('Prediction error (Pred - True)');
title('Knee angle prediction error (mean ± SD)');
grid on;
fontsize(16,'points')
%saveas(gcf, fullfile(decording_lasso_folder, 'Error_predict_actual.tif'));

%% 
figure;

% --- Hipの係数 ---
subplot(2,1,1)
bar(B_knee, 'FaceColor',[0.2 0.6 0.9]);
xlabel('Neuron Index');
ylabel('Weight');
title('LASSO Coefficients for Hip Angle');
grid on;
hold on;

% 棒の上に番号を表示
x = 1:length(B_knee);
for i = 1:length(B_knee)
    if B_knee(i) ~= 0  % 非ゼロ係数のみ表示（必要に応じて削除可能）
        text(x(i), B_knee(i), sprintf('%d', i), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment', ifelse(B_knee(i) >= 0, 'bottom', 'top'), ...
            'FontSize',8, 'Color','k');
    end
end

% --- Kneeの係数 ---
subplot(2,1,2)
bar(B_ankle, 'FaceColor',[0.9 0.4 0.2]);
xlabel('Neuron Index');
ylabel('Weight');
title('LASSO Coefficients for Knee Angle');
grid on;
hold on;

x = 1:length(B_ankle);
for i = 1:length(B_ankle)
    if B_ankle(i) ~= 0
        text(x(i), B_ankle(i), sprintf('%d', i), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment', ifelse(B_ankle(i) >= 0, 'bottom', 'top'), ...
            'FontSize',8, 'Color','k');
    end
end

% --- 図全体の設定 ---
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(decording_lasso_folder, 'Lasso_coefficients_1_3Train_45test.tif');
print(gcf, tifFileName, '-dtiff', '-r300');


%% decording analysis new
% Decoding model analysis (leave-one-posture-out)
%----------------------------------------------------------------------
decording_folder = createNamedFolder(experiment3_static_differential_folder, 'Decording analysis');
decording_lasso_folder = createNamedFolder(decording_folder, 'Lasso');

% --- 基本データ ---
H_bone_mean; 
hip_mean;
Knee_mean_new;
Ankle_mean;
MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- Endpoint位置を計算 ---
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
Endpoint_Xpos_center = Endpoint_Xpos-mean(Endpoint_Xpos);
Endpoint_Ypos_center = Endpoint_Ypos-mean(Endpoint_Ypos);
scatter(Endpoint_Xpos_center, Endpoint_Ypos_center);
title('Endpoint position');
xlabel('Xpos'); ylabel('Ypos');

%--- デコード対象の選択 ---
% モードを選択: 'joint'（関節角度） or 'endpoint'（XY座標）
decode_mode = 'endpoint';   % ← ここを変更して切り替え

if strcmp(decode_mode, 'joint')
    fprintf('Decoding joint angles (Hip & Knee)...\n');
    joint_angles = hip_knee_joint_angle_orignal;  % [16 x 2]

elseif strcmp(decode_mode, 'endpoint')
    fprintf('Decoding Endpoint XY position...\n');
    joint_angles = [Endpoint_Xpos, Endpoint_Ypos];  % [16 x 2]

else
    error('decode_mode must be either "joint" or "endpoint".');
end

% --- データ行列作成 ---
MFR_all = [];   % (試行×姿勢) × ニューロン
Y_all   = [];   % (試行×姿勢) × 2
posture_id = [];

for pos = 1:num_postures
    for tr = 1:num_trials
        x = zeros(1, num_neurons);
        for n = 1:num_neurons
            x(n) = MFR_sep_zscore_pos{n}(tr, pos);
        end
        MFR_all = [MFR_all; x];
        Y_all   = [Y_all; joint_angles(pos,:)]; 
        posture_id = [posture_id; pos];
    end
end

% --- クロスバリデーションの設定 ---
% モード選択: 'random' または 'block'
cv_mode = 'random';    % ← ここを 'random' にすれば通常ランダムCV
num_folds = 5;       % CV分割数

fprintf('CV mode = %s (%d-fold)\n', cv_mode, num_folds);

if strcmp(cv_mode, 'random')
    % ランダム分割
    cvp = cvpartition(size(MFR_all,1), 'KFold', num_folds);

elseif strcmp(cv_mode, 'block')
    % 姿勢ごとブロック分割
    cv_index = zeros(size(posture_id));
    unique_postures = unique(posture_id);
    num_unique_postures = numel(unique_postures);

    % 姿勢をfoldに順に割り当て
    folds = repmat(1:num_folds, 1, ceil(num_unique_postures/num_folds));
    folds = folds(1:num_unique_postures);

    for i = 1:num_unique_postures
        cv_index(posture_id == unique_postures(i)) = folds(i);
    end

    cvp = cvpartition(cv_index, 'KFold', num_folds);
else
    error('cv_mode must be "random" or "block".');
end

% --- 姿勢ごとのleave-one-posture-outデコード ---
Y_pred_all = zeros(size(Y_all));
Y_true_all = Y_all;

for leave_out = 1:num_postures
    % 学習・テスト分割
    train_idx = posture_id ~= leave_out;
    test_idx  = posture_id == leave_out;

    X_train = MFR_all(train_idx,:);
    Y_train = Y_all(train_idx,:);
    X_test  = MFR_all(test_idx,:);
    Y_test  = Y_all(test_idx,:);

    % --- LASSO回帰（X軸とY軸 or Hip/Knee）---
    [B1,FitInfo1] = lasso(X_train, Y_train(:,1), ...
        'Alpha', 1, 'CV', 15);
    idxLambdaMinMSE1 = FitInfo1.IndexMinMSE;
    B_hip = B1(:, idxLambdaMinMSE1);

    [B2,FitInfo2] = lasso(X_train, Y_train(:,2), ...
        'Alpha', 1, 'CV', 15);
    idxLambdaMinMSE2 = FitInfo2.IndexMinMSE;
    B_knee = B2(:, idxLambdaMinMSE2);

    % --- テストデータ予測 ---
    Y_pred_hip  = X_test * B_hip + FitInfo1.Intercept(idxLambdaMinMSE1);
    Y_pred_knee = X_test * B_knee + FitInfo2.Intercept(idxLambdaMinMSE2);

    Y_pred_all(test_idx,:) = [Y_pred_hip, Y_pred_knee];
end

% --- 結果のまとめ ---
Y_pred_mean = zeros(num_postures, 2);
Y_true_mean = zeros(num_postures, 2);

for pos = 1:num_postures
    idx = posture_id == pos;
    Y_pred_mean(pos,:) = mean(Y_pred_all(idx,:),1);
    Y_true_mean(pos,:) = mean(Y_true_all(idx,:),1);
end

% --- R^2の計算 ---
Y_true_mean_all = mean(Y_true_all);

SSE_1 = sum((Y_true_all(:,1)-Y_pred_all(:,1)).^2);
SST_1 = sum((Y_true_all(:,1)-Y_true_mean_all(1,1)).^2);
R2_1 = 1 - (SSE_1/SST_1);

SSE_2 = sum((Y_true_all(:,2)-Y_pred_all(:,2)).^2);
SST_2 = sum((Y_true_all(:,2)-Y_true_mean_all(1,2)).^2);
R2_2 = 1 - (SSE_2/SST_2);

% --- 可視化 ---
figure;

subplot(1,2,1);
scatter(Y_true_all(:,1), Y_pred_all(:,1), 40, 'b', 'filled'); hold on;
xlabel('True X');
ylabel('Predicted X');
title(sprintf('Decoding X (R^2 = %.3f)', R2_1));
grid on; axis equal;
xlim_auto = xlim; ylim_auto = ylim;
plot([min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], ...
     [min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], 'r--', 'LineWidth', 1.5);
p1 = polyfit(Y_true_all(:,1), Y_pred_all(:,1), 1);
x_fit = linspace(min(Y_true_all(:,1)), max(Y_true_all(:,1)), 100);
y_fit = polyval(p1, x_fit);
plot(x_fit, y_fit, 'k-', 'LineWidth', 1.5);
legend('Data', 'Ideal', 'Regression', 'Location', 'best');
fontsize(20,'points');

subplot(1,2,2);
scatter(Y_true_all(:,2), Y_pred_all(:,2), 40, 'b', 'filled'); hold on;
xlabel('True Y');
ylabel('Predicted Y');
title(sprintf('Decoding Y (R^2 = %.3f)', R2_2));
grid on; axis equal;
xlim_auto = xlim; ylim_auto = ylim;
plot([min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], ...
     [min(xlim_auto(1), ylim_auto(1)), max(xlim_auto(2), ylim_auto(2))], 'r--', 'LineWidth', 1.5);
p2 = polyfit(Y_true_all(:,2), Y_pred_all(:,2), 1);
x_fit = linspace(min(Y_true_all(:,2)), max(Y_true_all(:,2)), 100);
y_fit = polyval(p2, x_fit);
plot(x_fit, y_fit, 'k-', 'LineWidth', 1.5);
legend('Data', 'Ideal', 'Regression', 'Location', 'best');
fontsize(20,'points');

if strcmp(decode_mode, 'joint')
    sgtitle('Decoding performance: True vs Predicted joint angles');
    saveas(gcf, fullfile(decording_lasso_folder, 'Angle_true_vs_predicted_joint.tif'));
else
    sgtitle('Decoding performance: True vs Predicted endpoint XY');
    saveas(gcf, fullfile(decording_lasso_folder, 'Angle_true_vs_predicted_endpoint.tif'));
end

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
%}

%% calculate cosign tuning model---------------------------------------------------------------------------------------------------
n_neurons = length(newSpkCH);
n_trials = 5;
large_posture_num = 8;

theta = deg2rad(linspace(30, 330, large_posture_num))'; % [8x1]

b_all = zeros(n_neurons, 3); % [n_neurons x 3]
p_values = zeros(1, n_neurons); % p値保存

preferd_drirection = zeros(1, n_neurons);
Amplitudes = zeros(1, n_neurons);
R_squared = zeros(1, n_neurons);

for i = 1:n_neurons
    fr = MFR_sep_lineup_mean_endP{1,i}'; % [8x1]

    % デザインマトリクス（sinを先に）
    X = [sin(theta), cos(theta), ones(size(theta))]; % [8x3]
    [b, ~, residuals] = regress(fr, X);

    % 最小二乗法
    b = X\fr; % [3x1]

    % 保存
    b_all(i,:) = b';

    % フィッティング結果
    fr_fit = X * b;

    % Preferd direction
    preferd_drirection(i) = mod(atan2(b(1), b(2)), 2*pi); % atan2(sin成分, cos成分)

    % 振幅
    Amplitudes(i) = sqrt(b(1)^2 + b(2)^2);

    % R squared
    ss_tot = sum((fr - mean(fr)).^2);
    ss_res = sum((fr - fr_fit).^2);
    R_squared(i) = 1 - (ss_res / ss_tot);

    MFR_by_model_all{1,i} = fr_fit';

    %f kentei
    % --- F検定 ---
    y_hat = X * b;
    ss_tot = sum((fr - mean(fr)).^2);
    ss_res = sum(residuals.^2);
    ss_reg = ss_tot - ss_res;

    df_reg = 2; % b1, b2 pvalue_fittingの2自由度（b0は基線なので除く）
    df_res = length(fr) - 3; % 残差の自由度（パラメータ3つ）
    ms_reg = ss_reg / df_reg;
    ms_res = ss_res / df_res;

    F_value = ms_reg / ms_res;
    p_values(i) = 1 - fcdf(F_value, df_reg, df_res);
end


% 閾値超えた数をカウント
num_above_threshold = sum(R_squared > 0.7);
preferd_drirection_degree = rad2deg(preferd_drirection);
fit_cos_tuning_model_index = find(R_squared > 0.7);
Amplitudes_fitting = Amplitudes(fit_cos_tuning_model_index);
pvalue_fitting = p_values(fit_cos_tuning_model_index);

%% t test model
theta = deg2rad(linspace(30, 330, large_posture_num))'; % [8x1]

b_all = zeros(n_neurons, 3);



%% plot Rsquare
Preferd_direction_folder =createNamedFolder(experiment3_polor_plot_end_point_f, 'Preferd_direction');
Cosine_tuning =createNamedFolder(Preferd_direction_folder, 'Cosine_tuning_model');

figure;
plot(1:length(newSpkCH), R_squared, 'o', ...
    'MarkerSize', 8, ...
    'MarkerFaceColor', [0 0 1], ... % 塗りつぶし色（青）
    'MarkerEdgeColor', [0 0 1]);    % 枠線の色も青
hold on;
line([1 length(newSpkCH)], [0.7 0.7], 'LineStyle', '--', 'Color', [0 0 0]);
% 左上にテキスト表示（座標を調整）
text(1, 0.95, ['R^2 > 0.7 : ' num2str(num_above_threshold) '/' num2str(length(newSpkCH))], ...
    'FontSize', 14, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
xlim([0 length(newSpkCH)+1])
ylim([0 1])
xlabel('Neuron');
ylabel('R-squared');
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(Cosine_tuning, ['R_square_not_normalized'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
 
%% plot cosign tuning model results
Cosine_tuning_end_point =createNamedFolder(Cosine_tuning, 'Cosine_tuning_model_end_point');
figure;

polaraxes;
hold on;

% 角度とラベル設定
angles = linspace(0, 2*pi, large_posture_num+1) + pi/large_posture_num;
angles(end) = [];
theta_labels = arrayfun(@(x) sprintf('Pos%d', x), Line_up_matrix_polar(1:large_posture_num), 'UniformOutput', false);

ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'counterclockwise';
set(ax, 'ThetaTick', rad2deg(angles));
set(ax, 'ThetaTickLabels', theta_labels);
ax.RLim = [0 25];

% 各ニューロンの preferred direction を矢印で描画（線をつなげず個別）
for idx = fit_cos_tuning_model_index
    theta = preferd_drirection(idx);
    r = Amplitudes(idx);
    polarplot([0 theta], [0 r], 'k-', 'LineWidth', 2);
end
tifFileName = fullfile(Cosine_tuning_end_point, 'RESULT_CosineTuning.tif');
print(gcf, tifFileName, '-dtiff', '-r300');
%% plot table  single angle or multi angle plus only 5 condition
threshold_R = 0.4;
% 3列分のマトリクス作成（1. cosign 2:Hip, 3:Knee, 4:Hip and kenee 5: 2 :parameter）
heatmap_data = zeros(nNeurons, 5);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Cos
    if abs(R_squared(i)) > 0.7 && p_values(i) < 0.05
        heatmap_data(i,1) = 5;  % 赤

    end

    % Hip
    if abs(Rsq_single_hip(i)) > threshold_R && p_joint_hip(i) < p_thresh
        if cofficient_hip(i,2) > 0
            heatmap_data(i,2) = 1;  % 赤
        else
            heatmap_data(i,2) = -1; % 青
        end
    end

    % Knee
    if abs(Rsq_single_knee(i)) > threshold_R && p_joint_knee(i) < p_thresh
        if cofficient_knee(i,2) > 0
            heatmap_data(i,3) = 1;
        else
            heatmap_data(i,3) = -1;
        end
    end
    % plus angle
     % plus angle
    if abs(Rsq_multi_hip_knee_inter_plus(i)) > threshold_R 
        if p_multi_hip_knee_inter_plus(i,1) < p_thresh && p_multi_hip_knee_inter_plus(i,2) < p_thresh
            heatmap_data(i,4) = 2;
        elseif p_multi_hip_knee_inter_plus(i,1) < p_thresh
            heatmap_data(i,4) = 3;
        elseif p_multi_hip_knee_inter_plus(i,2) < p_thresh
            heatmap_data(i,4) = 4;
        else
            heatmap_data(i,4) = 0;
        end
    end


     % plus orientation and lemgth
    if abs(Rsq_multi_ori_len_inter_plus(i)) > threshold_R 
        if p_multi_ori_len_inter_plus(i,1) < p_thresh && p_multi_ori_len_inter_plus(i,2) < p_thresh
            heatmap_data(i,5) = 2;
        elseif p_multi_ori_len_inter_plus(i,1) < p_thresh
            heatmap_data(i,5) = 3;
        elseif p_multi_ori_len_inter_plus(i,2) < p_thresh
            heatmap_data(i,5) = 4;
        else
            heatmap_data(i,4) = 0;
        end
    end

end
    


% --- カラーマップ: -1=青, 0=白, 1=赤, 2=緑 ---
cmap = [
    0 0 0
    0 0 1;   % -1: 青
    1 1 1;   %  0: 白
    1 0 0;   %  1: 赤
    1 0.5 0    %  2: orange
    0 1 1;
    1 0 1;
    0 1 0;
];

% ヒートマップ表示
figure;
imagesc(heatmap_data);
colormap(cmap);
caxis([-2 5]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:8);
%xticklabels({'Hip', 'Knee', 'orientation', 'length','Hip and knee plus','Hip and knee cross','orientation and length plus','orientation and length cross'});
xticklabels({'COSIGN','Hip', 'Knee','Hip and knee plus','orientation and length plus'});
ax.Layer = 'top';
ax.LineWidth = 1.5;

% 標準グリッド無効化
ax.XGrid = 'off';
ax.YGrid = 'off';

% --- 手動グリッド線（Y方向：1.5, 2.5, 3.5, ...） ---
hold on;

% 対象列のインデックスと名前
col_labels = {'COSIGN','Hip', 'Knee','Hip and knee plus','orientation and length plus'};
col_indices = [1, 2, 3, 4,5];  % heatmap_dataの対応列
text_y = 0.5;  % 上に少し表示するためのY位置

for col = 1:length(col_indices)
    if col < 3
        idx = col_indices(col);
    
        % 閾値を満たすデータ数をカウント（絶対値が 1, 2, 3 などで判定）
        count_significant = sum(heatmap_data(:,idx) ~= 0);  % 0以外（有意）な数
        % 軸上にテキストで表示
        text(col, text_y, sprintf('%d/%d', count_significant, nNeurons), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 14, ...
        'FontWeight', 'bold', ...
        'Color', 'k');
    else
        idx = col_indices(col);
    
        % 閾値を満たすデータ数をカウント（絶対値が 1, 2, 3 などで判定）
        count_significant = sum(heatmap_data(:,idx) == 2);  % 0以外（有意）な数
        % 軸上にテキストで表示
        text(col, text_y, sprintf('%d/%d', count_significant, nNeurons), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 14, ...
        'FontWeight', 'bold', ...
        'Color', 'k');
    end
end

y_lines = 1.5:1:nNeurons - 0.5;
for y = y_lines
    line([0.5, 10.5], [y, y], 'Color', [0.7 0.7 0.7], 'LineStyle', '-', 'LineWidth', 1);  % 横線
end

% --- 必要ならX方向も同様に描画 ---
x_lines = 1.5:1:10 - 0.5;
for x = x_lines
    line([x, x], [0.5, nNeurons + 0.5], 'Color', [0.7 0.7 0.7], 'LineStyle', '-', 'LineWidth', 1);  % 縦線
end

% カラーバーとタイトル
colorbar('Ticks',[-1 0 1 2 3 4 5], ...
         'TickLabels', {'Negative', 'None', 'Positive', ['BothP > ' num2str(p_thresh)],['OnlyP_1 > ' num2str(p_thresh)],['OnlyP_2 > ' num2str(threshold_R)],'R^2 > 0.7 COS '}, 'FontSize', 18);
title(['Correlation Significance Heatmap'],['Threshold R^2 > ' num2str(threshold_R) ' and p < ' num2str(p_thresh)],'FontSize', 18);
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存
tifFileName = fullfile(threshold_folder, ...
    'Molde_fitting_evaluation_5_model_model_include_cos.tif');
print(gcf, tifFileName, '-dtiff', '-r300');








%% plot 
Cosine_tuning_end_point =createNamedFolder(Cosine_tuning, 'Cosine_tuning_model_end_point');
Cosine_tuning_end_point =createNamedFolder(Cosine_tuning_end_point, 'Normalized_by_zscore');
for neuron = 1:length(newSpkCH)
    figure
    % Cosine tuning モデル（水色）
    plot(1:length(theta_labels), MFR_by_model_all{1,neuron}, '.-', ...
        'Color', [0 0.6 1], 'DisplayName', 'Cosine tuning'); 
    hold on;

    % 実測データ（赤色）
    plot(1:length(theta_labels), MFR_sep_lineup_mean_endP{1,neuron}, '.-', ...
        'Color', [1 0 0], 'DisplayName', 'Raw Data');

    % 凡例表示
    legend('Location', 'northeast');

    % y軸の調整
    max_val = max(MFR_sep_lineup_mean_endP{1,neuron}, [], 'all');
    if max_val > 100
        ylim_fig = [0 110];
    elseif max_val > 80
        ylim_fig = [0 100];
    elseif max_val > 40
        ylim_fig = [0 80];
    elseif max_val > 20
        ylim_fig = [0 40];
    elseif max_val > 5
        ylim_fig = [0 20];
    else
        ylim_fig = [0 5];
    end
    ylim(ylim_fig)

    % R_squared の表示（右上に）
    x_text = 1.5;
    y_text = ylim_fig(2) * 0.95;   % 上のほう
    if R_squared(1,neuron) > 0.7
        text(x_text, y_text, ['R^2 = ' num2str(R_squared(1,neuron), '%.2f')], ...
            'FontSize', 18, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Color', [1 0 0]);
    else
        text(x_text, y_text, ['R^2 = ' num2str(R_squared(1,neuron), '%.2f')], ...
            'FontSize', 18, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Color', [0 0 0]);
    end

    % x軸設定
    xlim([1 large_posture_num]);
    xlabel('Posture');
    ylabel('Firing rate');

    % x軸ラベルを polar 順序に
    xticks(1:length(Line_up_matrix_polar));
    xticklabels(string(Line_up_matrix_polar));
    sgtitle(gcf, ['End pint cosign tuning model not normalized Neuron ' num2str(neuron)  ' ' num2str(newSpkCH(neuron)) 'channel']);

    % グラフ見やすく
    fontsize(gcf, 20, "points");
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % 保存
    tifFileName = fullfile(Cosine_tuning_end_point, ['Neuron_' num2str(neuron) '_CosineTuning.tif']);
    print(gcf, tifFileName, '-dtiff', '-r300');
end

close all hidden;



%% plot table  single angle or multi angle

threshold_R = 0.5;
p_thresh = 0.05;

% 3列分のマトリクス作成（1:Hip, 2:Knee, 3:End）
heatmap_data = zeros(nNeurons, 3);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(r_vals_hip(i)) >= threshold_R && p_vals_hip(i) < p_thresh
        if r_vals_hip(i) >= threshold_R
            heatmap_data(i,1) = 1;  % 赤
        else
            heatmap_data(i,1) = -1; % 青
        end
    end

    % Knee
    if abs(r_vals_knee(i)) >= threshold_R && p_vals_knee(i) < p_thresh
        if r_vals_knee(i) >= threshold_R
            heatmap_data(i,2) = 1;
        else
            heatmap_data(i,2) = -1;
        end
    end

    % End Point
    if R_squared(i) > 0.7
        heatmap_data(i,3) = 2;  % 緑
    end
end

% --- カラーマップ: -1=青, 0=白, 1=赤, 2=緑 ---
cmap = [
    0 0 1;   % -1: 青
    1 1 1;   %  0: 白
    1 0 0;   %  1: 赤
    0 1 0    %  2: 緑
];

% ヒートマップ作成
figure;
imagesc(heatmap_data);
colormap(cmap);
caxis([-1 2]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:3);
xticklabels({'Hip', 'Knee', 'End'});
ax.Layer = 'top';   % 枠線とtickを前面に
ax.LineWidth = 1.5;

% 格子線風に
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = [0.7 0.7 0.7];
ax.GridAlpha = 0.5;

% カラーバー
colorbar('Ticks',[-1 0 1 2], ...
         'TickLabels', {'Negative', 'None', 'Positive', 'End > 0.7'});

title('Correlation Significance Heatmap');



%% polar plot not normalized

% 姿勢の角度（ラジアン単位）を30°左にシフト
angles = linspace(0, 2*pi, large_posture_num+1) + pi/large_posture_num;
theta_labels = arrayfun(@(x) sprintf('Pos%d', x), Line_up_matrix_polar(1:large_posture_num), 'UniformOutput', false);

% 色指定
linecolors = jet(size(MFR_sep_lineup_endP{1,1},1));
legend_labels = {'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5'};
%legend_labels = {'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5','Trial 6', 'Trial 7', 'Trial 8', 'Trial 9', 'Trial 10'};

% ユニット数とページ分割設定
total_neurons = length(newSpkCH);
neurons_per_page = 20;
num_pages = ceil(total_neurons / neurons_per_page);

for page = 1:num_pages
    figure;
    legend_handles = gobjects(1, 5); % 毎ページごとに初期化

    % 現在のページでプロットするユニット番号
    start_idx = (page - 1) * neurons_per_page + 1;
    end_idx = min(page * neurons_per_page, total_neurons);
    
    for i = start_idx:end_idx
        subplot_idx = i - start_idx + 1;
        subplot(4, 5, subplot_idx);

        for j = 1:size(MFR_sep_lineup_endP{1,1},1)
            h = polarplot(angles, [MFR_sep_lineup_endP{1,i}(j, :), MFR_sep_lineup_endP{1,i}(j, 1)], ...
                'LineWidth', 2, 'Color', linecolors(j, :), 'LineStyle', ':');
            hold on;

            if i == 1
                legend_handles(j) = h;
            end
        end

        polarplot(angles, [MFR_sep_lineup_mean_endP{1,i}, MFR_sep_lineup_mean_endP{1,i}(1)], ...
            'LineWidth', 2, 'Color', 'k', 'LineStyle', '-');

        title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
        ax = gca;
        ax.ThetaZeroLocation = 'top';
        set(ax, 'ThetaTick', rad2deg(angles));
        set(ax, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);

        % R軸の調整
        max_val = max(MFR_sep_lineup_endP{1,i}, [], 'all');
        if max_val > 100
            ax.RLim = [0 110];
        elseif max_val > 80
            ax.RLim = [0 100];
        elseif max_val > 40
            ax.RLim = [0 80];
        elseif max_val > 20
            ax.RLim = [0 40];
        elseif max_val > 5
            ax.RLim = [0 20];
        else
            ax.RLim = [0 5];
        end
    end

    hold off;
    sgtitle(sprintf('All neuron mean firing rate not normalized (Page %d)', page));

    % 有効なハンドルだけで凡例を作成
    valid_idx = isgraphics(legend_handles);  
    legend1 = legend(legend_handles(valid_idx), legend_labels(valid_idx));
    set(legend1, ...
        'Position', [0.9231 0.8206 0.0486 0.1105], ...
        'FontSize', 18);

    % オプション: 図を保存したい場合
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_polor_plot_folder, sprintf('Not_normalized_all_neuron_MFR_each_trial_End_point_page_%d.tif', page));
    print(gcf, tifFileName, '-dtiff', '-r300');
end
close all hidden

%% polar plot ZSCORE

% 色指定
linecolors = jet(5);
legend_labels = {'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5'};

% ユニット数とページ分割設定
total_neurons = length(newSpkCH);
neurons_per_page = 20;
num_pages = ceil(total_neurons / neurons_per_page);

for page = 1:num_pages
    figure;
    legend_handles = gobjects(1, 5); % 毎ページごとに初期化

    % 現在のページでプロットするユニット番号
    start_idx = (page - 1) * neurons_per_page + 1;
    end_idx = min(page * neurons_per_page, total_neurons);
    
    for i = start_idx:end_idx
        subplot_idx = i - start_idx + 1;
        subplot(4, 5, subplot_idx);

        for j = 1:5
            h = polarplot(angles, [MFR_sep_lineup_z_endP{1,i}(j, :), MFR_sep_lineup_z_endP{1,i}(j, 1)], ...
                'LineWidth', 2, 'Color', linecolors(j, :), 'LineStyle', ':');
            hold on;

            if i == 1
                legend_handles(j) = h;
            end
        end

        polarplot(angles, [MFR_sep_lineup_z_mean_endP{1,i}, MFR_sep_lineup_z_mean_endP{1,i}(1)], ...
            'LineWidth', 2, 'Color', 'k', 'LineStyle', '-');

        title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
        ax = gca;
        ax.ThetaZeroLocation = 'top';
        set(ax, 'ThetaTick', rad2deg(angles));
        set(ax, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);

        % R軸の調整
        max_val = max(MFR_sep_lineup_z_endP{1,i}, [], 'all');
        % 半径方向の範囲と目盛りの設定
        if max(MFR_sep_lineup_z_endP{1,i}, [], 'all') > 4
            ax.RLim = [-2 7]; % 半径方向の範囲を設定
        elseif max(MFR_sep_lineup_z_endP{1,i}, [], 'all') > 2
            ax.RLim = [-2 4];
        elseif max(MFR_sep_lineup_z_endP{1,i}, [], 'all') > 1
            ax.RLim = [-2 2];
        else
            ax.RLim = [-2 1];
        end
    end

    hold off;
    sgtitle(sprintf('All neuron mean firing rate normalized by Zscore (Page %d)', page));

    % 有効なハンドルだけで凡例を作成
    valid_idx = isgraphics(legend_handles);  
    legend1 = legend(legend_handles(valid_idx), legend_labels(valid_idx));
    set(legend1, ...
        'Position', [0.9231 0.8206 0.0486 0.1105], ...
        'FontSize', 18);

    % オプション: 図を保存したい場合
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_polor_plot_end_point_f, sprintf('Normalized_all_neuron_MFR_each_trial_End_point_page_%d.tif', page));
    print(gcf, tifFileName, '-dtiff', '-r300');
end



%% polar plot zscore
 
figure;

% 色指定（例: 5つのデータ）
linecolors = jet(5); % カラーマップから5色を取得
legend_labels = {'Trial 1', 'Trail 2', 'Trial 3', 'Trail 4', 'Trial 5'}; % 凡例用ラベル

% 凡例用のハンドル格納
legend_handles = gobjects(1, 5);

for i = 1:length(newSpkCH)
    subplot(8, 10, i);
    % プロット
    for j = 1:5
        h = polarplot(angles, [MFR_sep_lineup_z_endP{1,i}(j, :), MFR_sep_lineup_z_endP{1,i}(j, 1)], ...
            'LineWidth', 2, 'Color', linecolors(j, :)); 
        hold on;
        % 最初のサブプロットでハンドルを格納（凡例用）
        if i == 1
            legend_handles(j) = h;
        end
    end
    % タイトルと設定
    title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
    ax = gca;
    ax.ThetaZeroLocation = 'top';
    set(ax, 'ThetaTick', linspace(0, 360, 12+1));
    set(ax, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);
    
    % 半径方向の範囲と目盛りの設定
    if max(MFR_sep_lineup_z_endP{1,i}, [], 'all') > 4
        ax.RLim = [-2 7]; % 半径方向の範囲を設定
    elseif max(MFR_sep_lineup_z_endP{1,i}, [], 'all') > 2
        ax.RLim = [-2 4];
    elseif max(MFR_sep_lineup_z_endP{1,i}, [], 'all') > 1
        ax.RLim = [-2 2];
    else
        ax.RLim = [-2 1];
    end
end

hold off;
sgtitle('All neuron mean firing rate Zscore');

% 図全体で凡例を右上に配置
legend1 = legend(ax,legend_labels);
set(legend1,...
    'Position',[0.923138568543042 0.820590458439385 0.0485999476225437 0.110522336009663],...
    'FontSize',18);

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);








%% polar plot both not normalized and z score
% 姿勢の角度（ラジアン単位）
angles = linspace(0, 2*pi, 16+1); % 16分割（最後の点で始点に戻る）
theta_labels = arrayfun(@(x) sprintf('Pos%d', x), 1:16, 'UniformOutput', false); 

% 色指定（例: 5つのデータ）
linecolors = jet(5); % カラーマップから5色を取得
legend_labels = {'Trial 1', 'Trail 2', 'Trial 3', 'Trail 4', 'Trial 5'}; % 凡例用ラベル

% 凡例用のハンドル格納
legend_handles = gobjects(1, 5);

for i = 1:length(newSpkTime)
    % プロット
    figure;
    for j = 1:5
        ax1 = subplot(1, 2, 1);
        polarplot(angles, [MFR_sep_pos{1,i}(j, :), MFR_sep_pos{1,i}(j, 1)], ...
            'LineWidth', 2, 'Color', linecolors(j, :)); 
        hold on;
    end
    for j = 1:5
        ax2 =  subplot(1, 2, 2);
        polarplot(angles, [MFR_sep_zscore_pos{1,i}(j, :), MFR_sep_zscore_pos{1,i}(j, 1)], ...
            'LineWidth', 2, 'Color', linecolors(j, :)); 
        hold on;
    end
            
    % タイトルと設定
    title(ax1,'Mean firing rate not normalized');
    title(ax2,'Mean firing rate zscore');
    ax1.ThetaZeroLocation = 'top';
    ax2.ThetaZeroLocation = 'top';
    set(ax1, 'ThetaTick', linspace(0, 360, 16+1));
    set(ax1, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);
    set(ax2, 'ThetaTick', linspace(0, 360, 16+1));
    set(ax2, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);
    
    % 半径方向の範囲と目盛りの設定
    if max(MFR_sep_pos{1,i}, [], 'all') > 100
        ax1.RLim = [0 110]; % 半径方向の範囲を設定
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 80
        ax1.RLim = [0 100];
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 40
        ax1.RLim = [0 80];
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 20
        ax1.RLim = [0 40];
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 5
        ax1.RLim = [0 20];
    else
        ax1.RLim = [0 5];
    end

    if max(MFR_sep_zscore_pos{1,i}, [], 'all') > 4
        ax2.RLim = [-2 7]; % 半径方向の範囲を設定
    elseif max(MFR_sep_zscore_pos{1,i}, [], 'all') > 2
        ax2.RLim = [-2 4];
    elseif max(MFR_sep_zscore_pos{1,i}, [], 'all') > 1
        ax2.RLim = [-2 2];
    else
        ax2.RLim = [-2 1];
    end
sgtitle(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
fontsize(gcf,20,"points")
hold off;
% 図全体で凡例を右上に配置
legend1 = legend(ax2,legend_labels);
set(legend1,...
    'Position',[0.923138568543042 0.820590458439385 0.0485999476225437 0.110522336009663],...
    'FontSize',18);

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_polor_plot_folder, ['Neuron_' num2str(i) '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
end
close all hidden;



%% Cos model
% コサイン距離の計算（16×16の距離行列を作成）
D_cosine = pdist(MFR_sep_zscore_average_trial, 'cosine');        % 上三角ベクトル形式
D_cosine_mat = squareform(D_cosine);  % 対称行列へ変換（16x16）

% ヒートマップで可視化
figure;
imagesc(D_cosine_mat);
colorbar;
title('Cosine Distance Between Postures');
xlabel('Posture'); ylabel('Posture');
axis square;

%% 
posture_labels = cell(16,1);
for i = 1:16
    posture_labels{i} = ['Posture' num2str(i)];
end
[coeff, score] = pca(MFR_sep_zscore_average_trial);  % M: 16×72
scatter(score(:,1), score(:,2), 100, 'filled');
text(score(:,1), score(:,2), posture_labels);  % 16姿勢の名前をつけると見やすい
title('PCA of posture-related firing patterns');
xlabel('PC1'); ylabel('PC2');
%% 距離計算
% M：16姿勢 × 72ニューロンの発火率ベクトル
% 1. ユークリッド距離を計算
D_euc = pdist(MFR_sep_zscore_average_trial, 'euclidean');
D_euc_mat = squareform(D_euc);

% 2. MDSで次元削減（距離を保って2Dに）
[Y, stress] = mdscale(D_euc, 2);  % Y: 16×2

% 3. プロット
figure;
scatter(Y(:,1), Y(:,2), 100, 'filled');
text(Y(:,1)+0.02, Y(:,2), compose('P%02d',1:16), 'FontSize', 12);
xlabel('MDS Dim 1'); ylabel('MDS Dim 2');
title('MDS based on Euclidean Distance (between postures)');
grid on;
axis equal;

%% all firing rate
figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
%line change for firing rate for heatmap time
Ex3N_static_firing_rate_for_psth;
% 1×16のセル配列を4×4に変換
firing_rate_for_psth_rechange = reshape(Ex3N_static_firing_rate_for_psth, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
firing_rate_for_psth_rechange = firing_rate_for_psth_rechange';
% 縦に並べて16×1のセル配列に変換
Ex3N_firing_rate_for_psth_rechange = reshape(firing_rate_for_psth_rechange, [length(Postures_name), 1]);
%line up posture name
Postures_name;
Postures_name_rechange = reshape(Postures_name, [length(Postures_name)/4, length(Postures_name)/4]);
Postures_name_rechange = Postures_name_rechange';
Postures_name_rechange = reshape(Postures_name_rechange,[length(Postures_name), 1]);
%}
experiment3N_firingrate_heatmap = createNamedFolder(experiment3N_folder, 'experiment3_firingrate_heatmap');

for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Posture_heatmap_time{pos},Ex3_time_window_each(1:end-1),length(newSpkTime):-1,Ex3N_firing_rate_for_psth_rechange{pos,1});
    caxis([0 110]);
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_heatmap_time(pos));
end


cellfun(@(x) caxis(x,[0 110]),Posture_heatmap_time(1:16));
cellfun(@(x) xlabel(x,'Time (s)'),Posture_heatmap_time(1:16));
cellfun(@(x) ylabel(x,'Single-unit'),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3N_firingrate_heatmap, [' All_Posture'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');


%% combine data or not conbine data
Combine = 1;

if Combine == 1
    for pos = 1:length(Mean_firing_rate_Each_pos)
        Mean_firing_rate_Each_pos_Averege_cell_conbine{1,pos} = mean([Mean_firing_rate_Each_pos{1,pos},Ex3N_Mean_firing_rate_Each_pos{1,pos}],2);
        Task_spike_time_all_Each_pos_combine{1,pos} = [Task_spike_time_all_Each_pos{1,pos},Ex3N_Task_spike_time_all_Each_pos{1,pos}];
    end
    Ex3_static_firing_rate_for_psth_each_combine = [Ex3_static_firing_rate_for_psth_each;Ex3N_static_firing_rate_for_psth_each];
    experiment3_10tri_folder = createNamedFolder(step4savefolder, 'Experment3 10 trial');
    experiment3_polor_plot_folder =createNamedFolder(experiment3_10tri_folder, 'Mean_firing_rate_each_trial');
else

    experiment3_polor_plot_folder = createNamedFolder(experiment3_static_folder_select, 'Mean_firing_rate_each_trial');
    disp('Use main experiment only')
end

%{
% analyze for MFR

Postures_name;
Mean_firing_rate_Each_pos;
experiment3_MFR = createNamedFolder(experiment3_folder, 'Mean firing rate');
Mean_firing_rate_Each_pos_Averege_cell = cell(size(Mean_firing_rate_Each_pos));
Mean_firing_rate_Each_pos_SD = cell(size(Mean_firing_rate_Each_pos));
Mean_firing_rate_Each_pos_Averege_matrix = zeros(length(newSpkTime),length(Mean_firing_rate_Each_pos));

for pos = 1:length(Mean_firing_rate_Each_pos)
    Mean_firing_rate_Each_pos_Averege_cell{1,pos} = mean(Mean_firing_rate_Each_pos{1,pos},2);
    Mean_firing_rate_Each_pos_SD{1,pos} = std(Mean_firing_rate_Each_pos{1,pos}, 0, 2);
    Mean_firing_rate_Each_pos_Averege_matrix(:,pos) = Mean_firing_rate_Each_pos_Averege_cell{1,pos};
end

% find maximum value
max_meanfining_rate = zeros(1,length(Mean_firing_rate_Each_pos));
for i = 1:length(Mean_firing_rate_Each_pos)
    max_meanfining_rate(1,i) = max(Mean_firing_rate_Each_pos{1,i},[],'all');
    
end

Max_Mean_firing_rate_Each_pos_Averege_matrix = max(Mean_firing_rate_Each_pos_Averege_matrix,[],'all');
% Plot bar each

plot_Ex3_staticMFR = 2;
if plot_Ex3_staticMFR == 1
    for pos = 1:length(Postures_name)
        experiment3_mfrpos = createNamedFolder(experiment3_MFR, Postures_name(1,pos));
        for neuron = 1:length(newSpkTime)
            figure;
            MRFBAR = bar(Mean_firing_rate_Each_pos{1,pos}(neuron,:));hold on;
            MRFBAR.FaceColor = 'flat';
            MRFBAR.CData = [0 0 0];
            line([-5, 10], [Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron), Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron)], 'Color',[1 0 0], 'LineStyle', '-', 'LineWidth', 5);
            sd_rectangle_x = [-5 10 10 -5];
            minus_SD = Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron) - Mean_firing_rate_Each_pos_SD{1,pos}(neuron);
            plus_SD = Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron) + Mean_firing_rate_Each_pos_SD{1,pos}(neuron);
            sd_rectangle_y = [minus_SD minus_SD plus_SD plus_SD]; %minus minus plus plus
            patch(sd_rectangle_x,sd_rectangle_y,'cyan','FaceAlpha',0.3);
            xlim([0 6])
            ylim([0 110])
            xlabel('Time (s)');
            ylabel('Mean Firing Rate [Hz]');
            sgtitle(gcf, [char(Postures_name(1,pos))  ' Neuron ' num2str(neuron)  ' ' num2str(newSpkCH(neuron)) 'channel']);
            xticks(1:5);
            Label_name_of_trial = { 'Trial 1', 'Trial 2', 'Trial 3','Trial 4','Trial 5'};
            xticklabels(Label_name_of_trial);
            fontsize(gcf,20,"points");
            set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
            tifFileName = fullfile(experiment3_mfrpos, [char(Postures_name(1,pos))  'Neuron' num2str(neuron) '.tif']);
            print(gcf, tifFileName, '-dtiff', '-r300'); 
        end
        close all hidden
    end
    disp('end plot bar')
else
    disp('not plot bar')
end
% Plot bar all posture

for i = 1:length(Postures_name)
    Posture_MFR{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
%line change for firing rate for heatmap time
Mean_firing_rate_Each_pos_Averege_cell;
% 1×16のセル配列を4×4に変換
Mean_firing_rate_Each_pos_Averege_rechange = reshape(Mean_firing_rate_Each_pos_Averege_cell, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
Mean_firing_rate_Each_pos_Averege_rechange = Mean_firing_rate_Each_pos_Averege_rechange';
% 縦に並べて16×1のセル配列に変換
Mean_firing_rate_Each_pos_Averege_rechange = reshape(Mean_firing_rate_Each_pos_Averege_rechange, [length(Postures_name), 1]);

for i = 1:length(Postures_name)
    Mean_firing_rate_Each_pos_Averege_rechange{i,1} = Mean_firing_rate_Each_pos_Averege_rechange{i,1}';
end
experiment3_firingrate_MFR = createNamedFolder(experiment3_mfrpos, 'experiment3_MFR_allpos');

for pos = 1:length(Postures_name)
    %plot firing rate
    MRFBARall = bar(Posture_MFR{pos},Mean_firing_rate_Each_pos_Averege_rechange{pos,1}(1,:));hold on;
    MRFBARall.FaceColor = 'flat';
    MRFBARall.CData = [0 0 1];
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_MFR(pos));
end

cellfun(@(x) xlabel(x,'Single-Unit'),Posture_MFR(1:16));
cellfun(@(x) ylabel(x,'Firing rate[Hz]'),Posture_MFR(1:16));
cellfun(@(x) xlim(x,[0 length(newSpkTime)+1]),Posture_MFR(1:16));
cellfun(@(x) ylim(x,[0 110]),Posture_MFR(1:16));

% カラーバーを全体の横に1つだけ配置
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_mfrpos, [' All_Posture_Mean_Firing_Rate'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');


disp('end plot bar')
%}




%{
%% plot 3D
both_angle_related_folder = createNamedFolder(angle_related_folder, 'Both_angle');
for i = 1:72
% データ準備
hip_angle = hip_joint_angle_ori(:,1);     
knee_angle = knee_joint_angle_ori(:,1);   % Knee angle (16x1)
firing_rate_mean = mean(MFR_sep_pos{1,i}, 1);  % Mean firing rate (16x1)

% --- 格子点を作成 ---
hip_grid = linspace(min(hip_angle), max(hip_angle), 50);
knee_grid  = linspace(min(knee_angle), max(knee_angle), 50);
[AnkleGrid, KneeGrid] = meshgrid(ankle_grid, knee_grid);

% --- 発火率データをグリッド上に内挿 ---
FiringRateGrid = griddata(hip_angle(:), knee_angle(:), firing_rate_mean(:), AnkleGrid, KneeGrid, 'cubic');

% --- surfプロット ---
figure;
surf(AnkleGrid, KneeGrid, FiringRateGrid);
shading interp;    % 滑らか表示
colormap(jet);     % カラーマップ
colorbar;

xlabel('Hip Angle [deg]');
ylabel('Knee Angle [deg]');
zlabel('Mean Firing Rate [Hz]');

view(-40, 60);     % 見やすい角度に調整
grid on;
% 保存
sgtitle(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH  not normalized']);
 % グラフ見やすく
fontsize(gcf, 20, "points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(both_angle_related_folder, ['Neuron_' num2str(i) '_not_normalized.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
end
close all hidden;

%% calculate cosign tuning model
n_neurons = 72;
n_trials = 5;
large_posture_num = 8;

% 12 direction（例: 15, 45, ..., 345）
theta = deg2rad(linspace(30, 330, large_posture_num))'; % [12x1]
MFR_by_model = zeros(1,length(theta));
% モデル関数
model_fun = @(p, theta) p(1) + p(2) * cos(theta - p(3)); % f0 + f1*cos(theta - thetap)

% オプション設定（ここが必要！）
options = optimoptions('lsqcurvefit','Display','off');

PDs = zeros(1, n_neurons);
Amplitudes = zeros(1, n_neurons); % f1

for i = 1:n_neurons
    fr = MFR_sep_lineup_mean_endP{1,i}'; % [12x1
    p0 = [mean(fr), max(fr)-min(fr), 0];
    p_est = lsqcurvefit(model_fun, p0, theta, fr, [], [], options);

    PDs(i) = mod(p_est(3), 2*pi); % ラジアン
    Amplitudes(i) = abs(p_est(2)); % 振幅（方向選択性の強さ、絶対値で取ると安心）
    R_squared(i) = (4*(p_est(2)^2))/(sum((fr-mean(fr)).^2));
    MFR_by_model(1,:) = mean(fr)+p_est(2)*cos(theta-PDs(i));
    MFR_by_model_all{1,i} = MFR_by_model;
end
% 閾値超えた数をカウント
num_above_threshold = sum(R_squared > 0.7);


%% plot Rsquare
Preferd_direction_folder =createNamedFolder(experiment3_folder, 'Preferd_direction');
Cosine_tuning =createNamedFolder(Preferd_direction_folder, 'Cosine_tuning_model');

figure;
plot(1:length(newSpkCH), R_squared, 'o', ...
    'MarkerSize', 8, ...
    'MarkerFaceColor', [0 0 1], ... % 塗りつぶし色（青）
    'MarkerEdgeColor', [0 0 1]);    % 枠線の色も青
hold on;
line([1 length(newSpkCH)], [0.7 0.7], 'LineStyle', '--', 'Color', [0 0 0]);
% 左上にテキスト表示（座標を調整）
text(1, 0.95, ['R^2 > 0.7 : ' num2str(num_above_threshold) '/' num2str(length(newSpkCH))], ...
    'FontSize', 14, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
xlim([0 length(newSpkCH)+1])
ylim([0 1])
xlabel('Neuron');
ylabel('R-squared');
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(Cosine_tuning, ['R_square_not_normalized'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
    

%% plot 
Cosine_tuning_end_point =createNamedFolder(Cosine_tuning, 'Cosine_tuning_model_end_point');
for neuron = 1:length(newSpkCH)
    figure
    % Cosine tuning モデル（水色）
    plot(1:length(theta_labels), MFR_by_model_all{1,neuron}, '.-', ...
        'Color', [0 0.6 1], 'DisplayName', 'Cosine tuning'); 
    hold on;

    % 実測データ（赤色）
    plot(1:length(theta_labels), MFR_sep_lineup_mean_endP{1,neuron}, '.-', ...
        'Color', [1 0 0], 'DisplayName', 'Raw Data');

    % 凡例表示
    legend('Location', 'northeast');

    % y軸の調整
    max_val = max(MFR_sep_lineup_mean_endP{1,neuron}, [], 'all');
    if max_val > 100
        ylim_fig = [0 110];
    elseif max_val > 80
        ylim_fig = [0 100];
    elseif max_val > 40
        ylim_fig = [0 80];
    elseif max_val > 20
        ylim_fig = [0 40];
    elseif max_val > 5
        ylim_fig = [0 20];
    else
        ylim_fig = [0 5];
    end
    ylim(ylim_fig)

    % R_squared の表示（右上に）
    x_text = 1.5;
    y_text = ylim_fig(2) * 0.95;   % 上のほう
    if R_squared(1,neuron) > 0.7
        text(x_text, y_text, ['R^2 = ' num2str(R_squared(1,neuron), '%.2f')], ...
            'FontSize', 18, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Color', [1 0 0]);
    else
        text(x_text, y_text, ['R^2 = ' num2str(R_squared(1,neuron), '%.2f')], ...
            'FontSize', 18, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Color', [0 0 0]);
    end

    % x軸設定
    xlim([1 large_posture_num]);
    xlabel('Posture');
    ylabel('Firing rate');

    % x軸ラベルを polar 順序に
    xticks(1:length(Line_up_matrix_polar));
    xticklabels(string(Line_up_matrix_polar));
    sgtitle(gcf, ['End pint cosign tuning model not normalized Neuron ' num2str(neuron)  ' ' num2str(newSpkCH(neuron)) 'channel']);

    % グラフ見やすく
    fontsize(gcf, 20, "points");
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % 保存
    tifFileName = fullfile(Cosine_tuning_end_point, ['Neuron_' num2str(neuron) '_CosineTuning.tif']);
    print(gcf, tifFileName, '-dtiff', '-r300');
end

close all hidden;

%% polar plot not normalized

% 姿勢の角度（ラジアン単位）を30°左にシフト
angles = linspace(0, 2*pi, large_posture_num+1) + pi/large_posture_num;
theta_labels = arrayfun(@(x) sprintf('Pos%d', x), Line_up_matrix_polar(1:large_posture_num), 'UniformOutput', false);

% 色指定
linecolors = jet(size(MFR_sep_lineup_endP{1,1},1));
legend_labels = {'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5'};
%legend_labels = {'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5','Trial 6', 'Trial 7', 'Trial 8', 'Trial 9', 'Trial 10'};

% ユニット数とページ分割設定
total_neurons = 72;
neurons_per_page = 20;
num_pages = ceil(total_neurons / neurons_per_page);

for page = 1:num_pages
    figure;
    legend_handles = gobjects(1, 5); % 毎ページごとに初期化

    % 現在のページでプロットするユニット番号
    start_idx = (page - 1) * neurons_per_page + 1;
    end_idx = min(page * neurons_per_page, total_neurons);
    
    for i = start_idx:end_idx
        subplot_idx = i - start_idx + 1;
        subplot(4, 5, subplot_idx);

        for j = 1:size(MFR_sep_lineup_endP{1,1},1)
            h = polarplot(angles, [MFR_sep_lineup_endP{1,i}(j, :), MFR_sep_lineup_endP{1,i}(j, 1)], ...
                'LineWidth', 2, 'Color', linecolors(j, :), 'LineStyle', ':');
            hold on;

            if i == 1
                legend_handles(j) = h;
            end
        end

        polarplot(angles, [MFR_sep_lineup_mean_endP{1,i}, MFR_sep_lineup_mean_endP{1,i}(1)], ...
            'LineWidth', 2, 'Color', 'k', 'LineStyle', '-');

        title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
        ax = gca;
        ax.ThetaZeroLocation = 'top';
        set(ax, 'ThetaTick', rad2deg(angles));
        set(ax, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);

        % R軸の調整
        max_val = max(MFR_sep_fig{1,i}, [], 'all');
        if max_val > 100
            ax.RLim = [0 110];
        elseif max_val > 80
            ax.RLim = [0 100];
        elseif max_val > 40
            ax.RLim = [0 80];
        elseif max_val > 20
            ax.RLim = [0 40];
        elseif max_val > 5
            ax.RLim = [0 20];
        else
            ax.RLim = [0 5];
        end
    end

    hold off;
    sgtitle(sprintf('All neuron mean firing rate not normalized (Page %d)', page));

    % 有効なハンドルだけで凡例を作成
    valid_idx = isgraphics(legend_handles);  
    legend1 = legend(legend_handles(valid_idx), legend_labels(valid_idx));
    set(legend1, ...
        'Position', [0.9231 0.8206 0.0486 0.1105], ...
        'FontSize', 18);

    % オプション: 図を保存したい場合
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_polor_plot_end_point_f, sprintf('Not_normalized_all_neuron_MFR_each_trial_End_point_page_%d.tif', page));
    print(gcf, tifFileName, '-dtiff', '-r300');
end


%% polar plot ZSCORE

% 色指定
linecolors = jet(5);
legend_labels = {'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5'};

% ユニット数とページ分割設定
total_neurons = 72;
neurons_per_page = 20;
num_pages = ceil(total_neurons / neurons_per_page);

for page = 1:num_pages
    figure;
    legend_handles = gobjects(1, 5); % 毎ページごとに初期化

    % 現在のページでプロットするユニット番号
    start_idx = (page - 1) * neurons_per_page + 1;
    end_idx = min(page * neurons_per_page, total_neurons);
    
    for i = start_idx:end_idx
        subplot_idx = i - start_idx + 1;
        subplot(4, 5, subplot_idx);

        for j = 1:5
            h = polarplot(angles, [MFR_sep_lineup_z_endP{1,i}(j, :), MFR_sep_lineup_z_endP{1,i}(j, 1)], ...
                'LineWidth', 2, 'Color', linecolors(j, :), 'LineStyle', ':');
            hold on;

            if i == 1
                legend_handles(j) = h;
            end
        end

        polarplot(angles, [MFR_sep_lineup_z_mean_endP{1,i}, MFR_sep_lineup_z_mean_endP{1,i}(1)], ...
            'LineWidth', 2, 'Color', 'k', 'LineStyle', '-');

        title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
        ax = gca;
        ax.ThetaZeroLocation = 'top';
        set(ax, 'ThetaTick', rad2deg(angles));
        set(ax, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);

        % R軸の調整
        max_val = max(MFR_sep_fig{1,i}, [], 'all');
        % 半径方向の範囲と目盛りの設定
        if max(MFR_sep_fig{1,i}, [], 'all') > 4
            ax.RLim = [-2 7]; % 半径方向の範囲を設定
        elseif max(MFR_sep_fig{1,i}, [], 'all') > 2
            ax.RLim = [-2 4];
        elseif max(MFR_sep_fig{1,i}, [], 'all') > 1
            ax.RLim = [-2 2];
        else
            ax.RLim = [-2 1];
        end
    end

    hold off;
    sgtitle(sprintf('All neuron mean firing rate normalized by Zscore (Page %d)', page));

    % 有効なハンドルだけで凡例を作成
    valid_idx = isgraphics(legend_handles);  
    legend1 = legend(legend_handles(valid_idx), legend_labels(valid_idx));
    set(legend1, ...
        'Position', [0.9231 0.8206 0.0486 0.1105], ...
        'FontSize', 18);

    % オプション: 図を保存したい場合
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_polor_plot_end_point_f, sprintf('Normalized_all_neuron_MFR_each_trial_End_point_page_%d.tif', page));
    print(gcf, tifFileName, '-dtiff', '-r300');
end



%% polar plot zscore
 
figure;

% 色指定（例: 5つのデータ）
linecolors = jet(5); % カラーマップから5色を取得
legend_labels = {'Trial 1', 'Trail 2', 'Trial 3', 'Trail 4', 'Trial 5'}; % 凡例用ラベル

% 凡例用のハンドル格納
legend_handles = gobjects(1, 5);

for i = 1:78
    subplot(8, 10, i);
    % プロット
    for j = 1:5
        h = polarplot(angles, [MFR_sep_lineup_z_endP{1,i}(j, :), MFR_sep_lineup_z_endP{1,i}(j, 1)], ...
            'LineWidth', 2, 'Color', linecolors(j, :)); 
        hold on;
        % 最初のサブプロットでハンドルを格納（凡例用）
        if i == 1
            legend_handles(j) = h;
        end
    end
    % タイトルと設定
    title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
    ax = gca;
    ax.ThetaZeroLocation = 'top';
    set(ax, 'ThetaTick', linspace(0, 360, 12+1));
    set(ax, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);
    
    % 半径方向の範囲と目盛りの設定
    if max(MFR_sep_fig{1,i}, [], 'all') > 4
        ax.RLim = [-2 7]; % 半径方向の範囲を設定
    elseif max(MFR_sep_fig{1,i}, [], 'all') > 2
        ax.RLim = [-2 4];
    elseif max(MFR_sep_fig{1,i}, [], 'all') > 1
        ax.RLim = [-2 2];
    else
        ax.RLim = [-2 1];
    end
end

hold off;
sgtitle('All neuron mean firing rate Zscore');

% 図全体で凡例を右上に配置
legend1 = legend(ax,legend_labels);
set(legend1,...
    'Position',[0.923138568543042 0.820590458439385 0.0485999476225437 0.110522336009663],...
    'FontSize',18);

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);








%% polar plot both not normalized and z score
% 姿勢の角度（ラジアン単位）
angles = linspace(0, 2*pi, 16+1); % 16分割（最後の点で始点に戻る）
theta_labels = arrayfun(@(x) sprintf('Pos%d', x), 1:16, 'UniformOutput', false); 

% 色指定（例: 5つのデータ）
linecolors = jet(5); % カラーマップから5色を取得
legend_labels = {'Trial 1', 'Trail 2', 'Trial 3', 'Trail 4', 'Trial 5'}; % 凡例用ラベル

% 凡例用のハンドル格納
legend_handles = gobjects(1, 5);

for i = 1:length(newSpkTime)
    % プロット
    figure;
    for j = 1:5
        ax1 = subplot(1, 2, 1);
        polarplot(angles, [MFR_sep_pos{1,i}(j, :), MFR_sep_pos{1,i}(j, 1)], ...
            'LineWidth', 2, 'Color', linecolors(j, :)); 
        hold on;
    end
    for j = 1:5
        ax2 =  subplot(1, 2, 2);
        polarplot(angles, [MFR_sep_zscore_pos{1,i}(j, :), MFR_sep_zscore_pos{1,i}(j, 1)], ...
            'LineWidth', 2, 'Color', linecolors(j, :)); 
        hold on;
    end
            
    % タイトルと設定
    title(ax1,'Mean firing rate not normalized');
    title(ax2,'Mean firing rate zscore');
    ax1.ThetaZeroLocation = 'top';
    ax2.ThetaZeroLocation = 'top';
    set(ax1, 'ThetaTick', linspace(0, 360, 16+1));
    set(ax1, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);
    set(ax2, 'ThetaTick', linspace(0, 360, 16+1));
    set(ax2, 'ThetaTickLabels', [theta_labels, theta_labels(1)]);
    
    % 半径方向の範囲と目盛りの設定
    if max(MFR_sep_pos{1,i}, [], 'all') > 100
        ax1.RLim = [0 110]; % 半径方向の範囲を設定
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 80
        ax1.RLim = [0 100];
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 40
        ax1.RLim = [0 80];
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 20
        ax1.RLim = [0 40];
    elseif max(MFR_sep_pos{1,i}, [], 'all') > 5
        ax1.RLim = [0 20];
    else
        ax1.RLim = [0 5];
    end

    if max(MFR_sep_zscore_pos{1,i}, [], 'all') > 4
        ax2.RLim = [-2 7]; % 半径方向の範囲を設定
    elseif max(MFR_sep_zscore_pos{1,i}, [], 'all') > 2
        ax2.RLim = [-2 4];
    elseif max(MFR_sep_zscore_pos{1,i}, [], 'all') > 1
        ax2.RLim = [-2 2];
    else
        ax2.RLim = [-2 1];
    end
sgtitle(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH']);
fontsize(gcf,20,"points")
hold off;
% 図全体で凡例を右上に配置
legend1 = legend(ax2,legend_labels);
set(legend1,...
    'Position',[0.923138568543042 0.820590458439385 0.0485999476225437 0.110522336009663],...
    'FontSize',18);

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_polor_plot_folder, ['Neuron_' num2str(i) '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
end
close all hidden;
%% PCA
% PCAの実行
[coeff, score, latent, tsquared, explained] = pca(Mean_firing_rate_Each_pos_Averege_matrix');

% 結果の確認
disp('主成分の係数（各列が主成分の線形結合を示す）：');
disp(coeff);

disp('各データ点の主成分得点：');
disp(score);

disp('各主成分の固有値（分散を表す）：');
disp(latent);

disp('分散説明率（各主成分がデータの分散を何％説明するか）：');
disp(explained);

% 累積分散説明率をプロット
cumulative_explained = cumsum(explained);
figure;
bar(explained);
hold on;
plot(cumulative_explained, '-o', 'LineWidth', 1.5);
xlabel('主成分');
ylabel('分散説明率 (%)');
title('分散説明率と累積分散説明率');
legend('分散説明率', '累積分散説明率');
grid on;

            

%% data combine total 10 trial







%% all firing rate
figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
%line change for firing rate for heatmap time
Ex3N_static_firing_rate_for_psth;
% 1×16のセル配列を4×4に変換
firing_rate_for_psth_rechange = reshape(Ex3N_static_firing_rate_for_psth, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
firing_rate_for_psth_rechange = firing_rate_for_psth_rechange';
% 縦に並べて16×1のセル配列に変換
Ex3N_firing_rate_for_psth_rechange = reshape(firing_rate_for_psth_rechange, [length(Postures_name), 1]);
%line up posture name
Postures_name;
Postures_name_rechange = reshape(Postures_name, [length(Postures_name)/4, length(Postures_name)/4]);
Postures_name_rechange = Postures_name_rechange';
Postures_name_rechange = reshape(Postures_name_rechange,[length(Postures_name), 1]);
%}
experiment3N_firingrate_heatmap = createNamedFolder(experiment3N_folder, 'experiment3_firingrate_heatmap');

for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Posture_heatmap_time{pos},Ex3_time_window_each(1:end-1),length(newSpkTime):-1,Ex3N_firing_rate_for_psth_rechange{pos,1});
    caxis([0 110]);
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_heatmap_time(pos));
end


cellfun(@(x) caxis(x,[0 110]),Posture_heatmap_time(1:16));
cellfun(@(x) xlabel(x,'Time (s)'),Posture_heatmap_time(1:16));
cellfun(@(x) ylabel(x,'Single-unit'),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3N_firingrate_heatmap, [' All_Posture'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');


%% combine data or not conbine data
Combine = 1;

if Combine == 1
    for pos = 1:length(Mean_firing_rate_Each_pos)
        Mean_firing_rate_Each_pos_Averege_cell_conbine{1,pos} = mean([Mean_firing_rate_Each_pos{1,pos},Ex3N_Mean_firing_rate_Each_pos{1,pos}],2);
        Task_spike_time_all_Each_pos_combine{1,pos} = [Task_spike_time_all_Each_pos{1,pos},Ex3N_Task_spike_time_all_Each_pos{1,pos}];
    end
    Ex3_static_firing_rate_for_psth_each_combine = [Ex3_static_firing_rate_for_psth_each;Ex3N_static_firing_rate_for_psth_each];
    experiment3_10tri_folder = createNamedFolder(step4savefolder, 'Experment3 10 trial');
    experiment3_polor_plot_folder =createNamedFolder(experiment3_10tri_folder, 'Mean_firing_rate_each_trial');
else

    experiment3_polor_plot_folder = createNamedFolder(experiment3_folder, 'Mean_firing_rate_each_trial');
    disp('Use main experiment only')
end

%{
% analyze for MFR

Postures_name;
Mean_firing_rate_Each_pos;
experiment3_MFR = createNamedFolder(experiment3_folder, 'Mean firing rate');
Mean_firing_rate_Each_pos_Averege_cell = cell(size(Mean_firing_rate_Each_pos));
Mean_firing_rate_Each_pos_SD = cell(size(Mean_firing_rate_Each_pos));
Mean_firing_rate_Each_pos_Averege_matrix = zeros(length(newSpkTime),length(Mean_firing_rate_Each_pos));

for pos = 1:length(Mean_firing_rate_Each_pos)
    Mean_firing_rate_Each_pos_Averege_cell{1,pos} = mean(Mean_firing_rate_Each_pos{1,pos},2);
    Mean_firing_rate_Each_pos_SD{1,pos} = std(Mean_firing_rate_Each_pos{1,pos}, 0, 2);
    Mean_firing_rate_Each_pos_Averege_matrix(:,pos) = Mean_firing_rate_Each_pos_Averege_cell{1,pos};
end

% find maximum value
max_meanfining_rate = zeros(1,length(Mean_firing_rate_Each_pos));
for i = 1:length(Mean_firing_rate_Each_pos)
    max_meanfining_rate(1,i) = max(Mean_firing_rate_Each_pos{1,i},[],'all');
    
end

Max_Mean_firing_rate_Each_pos_Averege_matrix = max(Mean_firing_rate_Each_pos_Averege_matrix,[],'all');
% Plot bar each

plot_Ex3_staticMFR = 2;
if plot_Ex3_staticMFR == 1
    for pos = 1:length(Postures_name)
        experiment3_mfrpos = createNamedFolder(experiment3_MFR, Postures_name(1,pos));
        for neuron = 1:length(newSpkTime)
            figure;
            MRFBAR = bar(Mean_firing_rate_Each_pos{1,pos}(neuron,:));hold on;
            MRFBAR.FaceColor = 'flat';
            MRFBAR.CData = [0 0 0];
            line([-5, 10], [Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron), Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron)], 'Color',[1 0 0], 'LineStyle', '-', 'LineWidth', 5);
            sd_rectangle_x = [-5 10 10 -5];
            minus_SD = Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron) - Mean_firing_rate_Each_pos_SD{1,pos}(neuron);
            plus_SD = Mean_firing_rate_Each_pos_Averege_cell{1,pos}(neuron) + Mean_firing_rate_Each_pos_SD{1,pos}(neuron);
            sd_rectangle_y = [minus_SD minus_SD plus_SD plus_SD]; %minus minus plus plus
            patch(sd_rectangle_x,sd_rectangle_y,'cyan','FaceAlpha',0.3);
            xlim([0 6])
            ylim([0 110])
            xlabel('Time (s)');
            ylabel('Mean Firing Rate [Hz]');
            sgtitle(gcf, [char(Postures_name(1,pos))  ' Neuron ' num2str(neuron)  ' ' num2str(newSpkCH(neuron)) 'channel']);
            xticks(1:5);
            Label_name_of_trial = { 'Trial 1', 'Trial 2', 'Trial 3','Trial 4','Trial 5'};
            xticklabels(Label_name_of_trial);
            fontsize(gcf,20,"points");
            set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
            tifFileName = fullfile(experiment3_mfrpos, [char(Postures_name(1,pos))  'Neuron' num2str(neuron) '.tif']);
            print(gcf, tifFileName, '-dtiff', '-r300'); 
        end
        close all hidden
    end
    disp('end plot bar')
else
    disp('not plot bar')
end
% Plot bar all posture

for i = 1:length(Postures_name)
    Posture_MFR{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
%line change for firing rate for heatmap time
Mean_firing_rate_Each_pos_Averege_cell;
% 1×16のセル配列を4×4に変換
Mean_firing_rate_Each_pos_Averege_rechange = reshape(Mean_firing_rate_Each_pos_Averege_cell, [length(Postures_name)/4, length(Postures_name)/4]);
% 転置して4×4のセル配列を取得
Mean_firing_rate_Each_pos_Averege_rechange = Mean_firing_rate_Each_pos_Averege_rechange';
% 縦に並べて16×1のセル配列に変換
Mean_firing_rate_Each_pos_Averege_rechange = reshape(Mean_firing_rate_Each_pos_Averege_rechange, [length(Postures_name), 1]);

for i = 1:length(Postures_name)
    Mean_firing_rate_Each_pos_Averege_rechange{i,1} = Mean_firing_rate_Each_pos_Averege_rechange{i,1}';
end
experiment3_firingrate_MFR = createNamedFolder(experiment3_mfrpos, 'experiment3_MFR_allpos');

for pos = 1:length(Postures_name)
    %plot firing rate
    MRFBARall = bar(Posture_MFR{pos},Mean_firing_rate_Each_pos_Averege_rechange{pos,1}(1,:));hold on;
    MRFBARall.FaceColor = 'flat';
    MRFBARall.CData = [0 0 1];
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_MFR(pos));
end

cellfun(@(x) xlabel(x,'Single-Unit'),Posture_MFR(1:16));
cellfun(@(x) ylabel(x,'Firing rate[Hz]'),Posture_MFR(1:16));
cellfun(@(x) xlim(x,[0 length(newSpkTime)+1]),Posture_MFR(1:16));
cellfun(@(x) ylim(x,[0 110]),Posture_MFR(1:16));

% カラーバーを全体の横に1つだけ配置
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_mfrpos, [' All_Posture_Mean_Firing_Rate'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');


disp('end plot bar')
%}
%}
