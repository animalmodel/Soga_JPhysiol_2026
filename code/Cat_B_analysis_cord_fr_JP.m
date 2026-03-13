%Cat experiment first step
%set pass
% function path
clc
close all hidden;
%clearvars -except Ext_COMBdata COMBdata Easily_OEdata

%load path
addpath(genpath('D:\Cat article M2\For article analysis\Code\9-03 lumbar\function_for_0903Experiment'));
addpath(genpath('D:\Cat article M2\For article analysis\Code\9-03 lumbar\function_for_video/function_for_video'));
addpath(genpath('D:\Cat article M2\For article analysis\Code\9-03 lumbar\function_by_trever'));


%{
addpath(genpath('E:\Cat_experiment_result\function_for_0831Experiment'));
addpath(genpath('E:\Cat_experiment_result\Experiment_sqript'));
addpath(genpath('E:\Cat_experiment_result\function_for_video'));
addpath(genpath('E:\Cat_experiment_result\function_by_trever'));
%}



[fName,fnameORI{1,1}] = uigetfile('*Ext_COMBdata_step2.mat','Select a "Ext_COMBdata_step2.mat file" in data.');


%if you want to reload additional file you put path hereope
Fmat1 = [fnameORI{1,1},fName];
Parts = strsplit(Fmat1, filesep);
Fmat2=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs3/Easily_OEdata.mat'];
Fmat4=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs2/Wave_data_main_channel.mat'];
%Fmat5=[strjoin(Parts(1:end-2),filesep),filesep,'postanalysisfigs3/Analog_input_data.mat'];
FPAnew=[strjoin(Parts(1:end-2),filesep)];
PostureIDPath=[strjoin(Parts(1:end-5),filesep),filesep,'posture_data'];
Posture_data_2Dpath = [strjoin(Parts(1:end-5),filesep),filesep,'posture_data',filesep,'2D'];

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
both = 0;           %both 1 load only main channel, both2 load main and main+-20 channel

if both == 1
    if exist('Wave_data_all','var')==1
        disp('Wave_data_all exists. Did not load again. Clear this if you need to load a New data set.');
    else
        disp('Load Wave_data_all');
        load(Fmat3); % it may take time due to large file size. 
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

%% load Position_ID_data
%read static posture position data
addpath(genpath(PostureIDPath));
Position_ID_data_table = readtable('static posture.csv');
Position_ID_data = table2cell(Position_ID_data_table);
% Define mapping
mapping = containers.Map({'P7', 'P8', 'P10', 'P11', 'P15', 'P14', 'P13', ...
                          'P12', 'P18', 'P19', 'P17', 'P16', 'P22', 'P23', ...
                          'P21', 'P20'}, ...
                         [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);

%Convert Participant column based on mapping
Position_ID = zeros(size(Position_ID_data));
for i = 1:size(Position_ID_data,2)
    Position_ID_Trial = cellfun(@(x) mapping(x), Position_ID_data(:,i));
    Position_ID(:,i) = Position_ID_Trial;
end

disp('Position data was completly lined')


%% load Position data 2D
%read static posture position data
%trial 1
%{
addpath(genpath(Posture_data_2Dpath));
Trial1_2d_position_ch2 = 'ch02_trial1_ex3DLC_resnet50_Cat9_3_ch2_4partsJul25shuffle1_800000.csv';
Trial2_2d_position_ch2 = 'ch02_trial2_ex3DLC_resnet50_Cat9_3_ch2_4partsJul25shuffle1_800000.csv';
Trial3_2d_position_ch2 = 'ch02_trial3_ex3DLC_resnet50_Cat9_3_ch2_4partsJul25shuffle1_800000.csv';
Trial4_2d_position_ch2 = 'ch02_trial4_ex3DLC_resnet50_Cat9_3_ch2_4partsJul25shuffle1_800000.csv';
Trial5_2d_position_ch2 = 'ch02_trial5_ex3DLC_resnet50_Cat9_3_ch2_4partsJul25shuffle1_800000.csv';

fps = 30;
[trial1_time_data,trial1_video_data_all,trial1_evaluation_value,trial1_label_name] = get_all_position_data(Trial1_2d_position_ch2,fps);
[trial2_time_data,trial2_video_data_all,trial2_evaluation_value,trial2_label_name] = get_all_position_data(Trial2_2d_position_ch2,fps);
[trial3_time_data,trial3_video_data_all,trial3_evaluation_value,trial3_label_name] = get_all_position_data(Trial3_2d_position_ch2,fps);
[trial4_time_data,trial4_video_data_all,trial4_evaluation_value,trial4_label_name] = get_all_position_data(Trial4_2d_position_ch2,fps);
[trial5_time_data,trial5_video_data_all,trial5_evaluation_value,trial5_label_name] = get_all_position_data(Trial5_2d_position_ch2,fps);
%}



%% select MUA
Probe = 1; %1:ProbeA   
if Probe == 1
    MUA_ID = [56 1112 1989 22 121 1972 1993 1217 2023 1360 1385 300 294 1441 1627 385 2043 1059 1710 1344 250 1621 344 1662 2041 1689 960 1792 593 635 1719 507];
elseif Probe == 2
    MUA_ID = []; %The spike what want to delete if you do not have mua please set 0
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
EventTIM_new = EventTIM;

EventTIM_new(15:16,:) = [];
%% Separate each experiment
% make folder for result
%[fig_folder,fig_folder_tif,fig_folder_pdf,fig_folder_fig]=MakeFolder([FPAnew,filesep],'postanalysisfigs4');
step4savefolder = createNamedFolder(FPAnew, 'postanalysisfigs4');


%landmark for expriment3
experiment3_1_4_trial_landmark = "ex3";
%landmark for expriment3 no control (it could not position control when resting)
experiment3_5_trial_landmark = "ex3 5th trial start";
%landmark for expriment3 for analysis
experiment3_end = "experiment 3 end2 min later";
%obtain each separate timing
[Ex3_trial_1_4] = findNearestValue_experiment_separate(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task ,EventTIM_new, experiment3_1_4_trial_landmark,0); %if experiment3 no control set 1
[Ex3_trial_5] = findNearestValue_experiment_separate(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task ,EventTIM_new, experiment3_5_trial_landmark,1); %if experiment3 no control set 1
[Ex3_end] = findNearestValue_experiment_separate(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task ,EventTIM_new, experiment3_end,1); %if experiment3 no control set 1

%


%separate experiment
[Ex3_1_4_control_control_DI_not_separate,Ex3_1_4_control_task_DI_not_separate] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex3_trial_1_4,Ex3_trial_5);
Ex3_trial_1_4_end_time = Ex3_1_4_control_control_DI_not_separate(5,2);
[Ex3_1_4_control_control_DI,Ex3_1_4_task_DI] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex3_trial_1_4,Ex3_trial_1_4_end_time);

%
[EX3_5_control_DI,EX3_5_task_DI] = Extract_Task_related_DI_INput(start_up_DI_related_control_and_separate_task,fall_DI_related_control_and_separate_task,start_up_DI_related_task,fall_DI_related_task,Ex3_trial_5,Ex3_end);

%Before 5 trial control LED on timing
[~, idx_control_before_trial5] = min(abs(start_up_DI_related_control_and_separate_task - Ex3_trial_5));
Ex3_trial_5_LED_ON_control = start_up_DI_related_control_and_separate_task(idx_control_before_trial5(1,1),1);
EX3_5_control_before_trial5 = [Ex3_trial_5_LED_ON_control, Ex3_trial_5_LED_ON_control+mean(Ex3_1_4_control_control_DI(:,3)),mean(Ex3_1_4_control_control_DI(:,3))];

%% gather trial 1to5
Ex3_1_5_task_DI = [Ex3_1_4_task_DI;EX3_5_task_DI];

%
%Separate sech trial
Trial = 5;
[EX3_task_DI_Trial] = SepTrial(Ex3_1_5_task_DI,Trial);




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
% Separate each timing
    Ex3_Posture_cutting_time = [-20 20];
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

%% extract trial
Ex3_1_4_control_control_DI;
EX3_5_control_before_trial5;
EX3_5_control_DI;

Trial_timing_1_4 = [Ex3_1_4_control_control_DI(1:4,1),Ex3_1_4_control_control_DI(2:5,2)];
Trial_timing_5 = [EX3_5_control_before_trial5(1,1),EX3_5_control_DI(1,1)];
Trial_timing_all_trial = [Trial_timing_1_4;Trial_timing_5];
Trial_timing_all_trial = [Trial_timing_all_trial,(Trial_timing_all_trial(:,2)-Trial_timing_all_trial(:,1))];

%% plot all trial 
[Ex3_trial_spike_all,Ex3_trial_spike_time_all,Ex3_trial_Mean_firing_rate_all,Ex3_trial_each_main_wavedata] = Cutting_data_for_each_DI(newSpkTime,newWavedata,Trial_timing_all_trial,[0 375]);

bin_size_each = 0.05; % 50 ms bin size (adjust as needed)
start_time_trial = 0; % Time before stimulus onset (in seconds)
end_time_trial = 375;    % Time after stimulus onset (in seconds)
Ex3_time_window_trial = start_time_trial:bin_size_each:end_time_trial;
[Ex3_trial1_firing_rate_for_psth,Ex3_trial1_max_fining_rate] = Firing_rate_calculate(newSpkTime,Ex3_trial_spike_time_all(:,1),Ex3_time_window_trial,bin_size_each);
[Ex3_trial2_firing_rate_for_psth,Ex3_trial2_max_fining_rate] = Firing_rate_calculate(newSpkTime,Ex3_trial_spike_time_all(:,2),Ex3_time_window_trial,bin_size_each);
[Ex3_trial3_firing_rate_for_psth,Ex3_trial3_max_fining_rate] = Firing_rate_calculate(newSpkTime,Ex3_trial_spike_time_all(:,3),Ex3_time_window_trial,bin_size_each);
[Ex3_trial4_firing_rate_for_psth,Ex3_trial4_max_fining_rate] = Firing_rate_calculate(newSpkTime,Ex3_trial_spike_time_all(:,4),Ex3_time_window_trial,bin_size_each);
[Ex3_trial5_firing_rate_for_psth,Ex3_trial5_max_fining_rate] = Firing_rate_calculate(newSpkTime,Ex3_trial_spike_time_all(:,5),Ex3_time_window_trial,bin_size_each);


%% plot robot time stamp
Ex3_1_5_task_DI;
Robot_stop_time_mean = mean(Ex3_1_5_task_DI(:,3));
Robot_stop_time_std = std(Ex3_1_5_task_DI(:,3));
% --- プロット ---
figure;
x = 1:length(Ex3_1_5_task_DI);
y = Ex3_1_5_task_DI(:,3);

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
%% calculate moving time
Ex3_1_4_control_control_DI;
EX3_5_control_before_trial5;
% 

EX3_task_DI_Trial;
control_all = [Ex3_1_4_control_control_DI;EX3_5_control_before_trial5];
All_time_not_align = [control_all(1,:);EX3_task_DI_Trial{1,1};control_all(2,:);EX3_task_DI_Trial{2,1};control_all(3,:);EX3_task_DI_Trial{3,1};control_all(4,:);EX3_task_DI_Trial{4,1};control_all(5,:);EX3_task_DI_Trial{5,1}];


Robot_moving_time = All_time_not_align(2:length(All_time_not_align),1) - All_time_not_align(1:length(All_time_not_align)-1,2);
%Delete ecause of not series monement of robot
Robot_moving_time(Robot_moving_time > 10) = 0;
[max_time_robot_moving, max_idx_robot_moving] = max(Robot_moving_time);



%% for each trial
figure;
colormap(newCmap)
%experiment3_pos = createNamedFolder(experiment3_psth, Postures_name(1,pos));
imagesc(Ex3_time_window_trial(1:end-1),length(newSpkTime):-1:1,Ex3_trial1_firing_rate_for_psth);
caxis([0 110]);
xlim([0 374])
ylim([0.5 length(newSpkTime)+0.5])
xlabel('Time (s)');
ylabel('Single Unit');
% Y軸のラベルを反転
yticks(1:length(newSpkTime)); % 元のY軸の位置を設定
yticklabels(fliplr(1:length(newSpkTime))); % ラベルを逆順に設定
colorbar;
title(['Firing rate Trial 1']);
fontsize(gcf,20,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

%tifFileName = fullfile(experiment3_pos, [char(Postures_name(1,pos)) '_Firing_Rate' '.tif']);
%print(gcf, tifFileName, '-dtiff', '-r300'); 

%% plot all trial
numTrials = 5;
Ex3_trial_firing_rate = {
    Ex3_trial1_firing_rate_for_psth, ...
    Ex3_trial2_firing_rate_for_psth, ...
    Ex3_trial3_firing_rate_for_psth, ...
    Ex3_trial4_firing_rate_for_psth, ...
    Ex3_trial5_firing_rate_for_psth};

figure;
for t = 1:numTrials
    subplot(numTrials, 1, t); % 横に5分割
    imagesc(Ex3_time_window_trial(1:end-1), ...
            length(newSpkTime):-1:1, ...
            Ex3_trial_firing_rate{t});
    caxis([0 110]);
    xlim([0 374]);
    ylim([0.5 length(newSpkTime)+0.5]);
    xlabel('Time (s)');
    ylabel('Single Unit');
    
    % Y軸ラベルを反転
    yticks(1:length(newSpkTime));
    yticklabels(fliplr(1:length(newSpkTime)));
    
    colormap(newCmap);
    title(sprintf('Firing rate Trial %d', t));
end

% 共通のカラーバーを右端に追加
h = colorbar('Position', [0.92 0.11 0.02 0.815]);
ylabel(h, 'Firing rate (Hz)');

fontsize(gcf,10,"points");
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);


%% check motion is OK or not
%{
[trial1_time_data,trial1_video_data_all,trial1_evaluation_value,trial1_label_name];
[trial2_time_data,trial2_video_data_all,trial2_evaluation_value,trial2_label_name];
[trial3_time_data,trial3_video_data_all,trial3_evaluation_value,trial3_label_name];
[trial4_time_data,trial4_video_data_all,trial4_evaluation_value,trial4_label_name];
[trial5_time_data,trial5_video_data_all,trial5_evaluation_value,trial5_label_name];
%}
%{
trial1_time_data_new = trial1_time_data+Ex3_1_4_control_control_DI(1,1);
trial2_time_data_new = trial2_time_data+Ex3_1_4_control_control_DI(2,1);
trial3_time_data_new = trial3_time_data+Ex3_1_4_control_control_DI(3,1);
trial4_time_data_new = trial4_time_data+Ex3_1_4_control_control_DI(4,1);
trial5_time_data_new = trial5_time_data+EX3_5_control_before_trial5(1,1);
video_time_all = [trial1_time_data_new;trial2_time_data_new;trial3_time_data_new;trial4_time_data_new;trial5_time_data_new];
hip_data_all_trial = [trial1_video_data_all(:,1:2);trial2_video_data_all(:,1:2);trial3_video_data_all(:,1:2);trial4_video_data_all(:,1:2);trial5_video_data_all(:,1:2);];
knee_data_all_trial = [trial1_video_data_all(:,3:4);trial2_video_data_all(:,3:4);trial3_video_data_all(:,3:4);trial4_video_data_all(:,3:4);trial5_video_data_all(:,3:4);];
ankle_data_all_trial = [trial1_video_data_all(:,5:6);trial2_video_data_all(:,5:6);trial3_video_data_all(:,5:6);trial4_video_data_all(:,5:6);trial5_video_data_all(:,5:6);];
paw_data_all_trial = [trial1_video_data_all(:,7:8);trial2_video_data_all(:,7:8);trial3_video_data_all(:,7:8);trial4_video_data_all(:,7:8);trial5_video_data_all(:,7:8);];

% 例: StartとEndの時間（秒）
Position_data_2D_all_trial = cell(length(EX3_task_DI_Lineup_Trial),1);
Position_data_2D_all_trial_mean = cell(length(EX3_task_DI_Lineup_Trial),1);
Position_data_2D_each_trial = cell(length(EX3_task_DI_Lineup_Trial{1,1}),1);
Position_data_2D_each_trial_mean = zeros(length(EX3_task_DI_Lineup_Trial{1,1}),8);
% 時間インデックスを検索
for tr =1:length(EX3_task_DI_Lineup_Trial)
    for pos = 1:length(EX3_task_DI_Lineup_Trial{1,1})
        offset_time = 1;
        Start_time = EX3_task_DI_Lineup_Trial{tr,1}(pos,1)+offset_time;
        End_time = EX3_task_DI_Lineup_Trial{tr,1}(pos,2)-offset_time;
        idx = (video_time_all >= Start_time) & (video_time_all <= End_time);
        % 対応する時間とXY座標を切り抜き
        cut_time = video_time_all(idx);
        hip_XY   = hip_data_all_trial(idx, :);
        knee_XY   = knee_data_all_trial(idx, :);
        ankle_XY   = ankle_data_all_trial(idx, :);
        paw_XY   = paw_data_all_trial(idx, :);
        Position_data_2D_each_trial{pos,1} = [cut_time,hip_XY,knee_XY,ankle_XY,paw_XY];
        Position_data_2D_each_trial_mean(pos,:) = [mean(hip_XY),mean(knee_XY),mean(ankle_XY),mean(paw_XY)];
    end
    Position_data_2D_all_trial{tr,1} = Position_data_2D_each_trial;
    Position_data_2D_all_trial_mean{tr,1} = Position_data_2D_each_trial_mean;
end


%% plot 2D data
% 仮データ: 5 Trial分を cell 配列に入れる
% TrialData{trial} = 16x8 の行列
% 例: TrialData{1} = rand(16,8);

numTrials = 5;
numPostures = 16;

colors = lines(numPostures);  % 16色を自動生成

figure;
for t = 1:numTrials
    subplot(1, numTrials, t); hold on;
    
    % 各Trialのデータ (16x8)
    data = Position_data_2D_all_trial_mean{t};
    
    % 各姿勢ごとに線を描画
    for p = 1:numPostures
        x = data(p, 5); % HipX, KneeX, AnkleX, ToeX
        y = data(p, 6); % HipY, KneeY, AnkleY, ToeY
        plot(x, y, '-o', 'Color', colors(p,:), 'LineWidth', 1.5, ...
             'DisplayName', sprintf('Posture %d', p));
    end
    
    title(sprintf('Trial %d', t));
    axis equal;
    xlabel('X'); ylabel('Y');
    grid on;
    if t == numTrials
        legend('show'); % 最後のサブプロットに凡例を表示
    end
end
%}
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






%% plot psth 
% make name
Postures_name = strings(1, length(Task_spike_time_all_Each_pos));  % 文字列配列を作成
for i = 1:length(Postures_name)
    Postures_name(i) = "Pos-" + string(i);  % 'Posture'に数字を付けて文字列を作成
end
 %%


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

%% plot firing rate each for fig
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
%{
pdfFileName = fullfile(PCA_folder, ...
    'PCA_plor_plot_for_fig_subB.pdf');
print(fig, pdfFileName, '-dpdf');
%}


%% find max value
dataCell = Ex3_static_firing_rate_for_psth;  % 1×16 のセル
each_pos_maxVal = [];  % ここに数値を集める

for i = 1:numel(dataCell)
    innerCell = dataCell{i};  % 136×800 のセル
    each_pos_maxVal(i,1) = max(innerCell,[],'all');
    
end



%% plot firing rate for fig
Firing_rate_folder_for_fig = createNamedFolder(experiment3_psth, 'Firing rate for fig');
nColors = 256;
cmap = jet(nColors);

% データ範囲
dataMin = 0;
dataMax = 150;

% カスタム変換: データ値 -> colormap index (0〜1)
% ここで 80 が 0.75 (オレンジ) に来るように調整
mapFunc = @(val) (val/50) * 0.75 .* (val<=50) + ...
                 (0.75 + (val-50)/(dataMax-50)*0.25) .* (val>50);

% サンプリング
nPoints = 256;
customRange = mapFunc(linspace(dataMin, dataMax, nPoints));
num_of_neuron = length(newSpkCH);
% 新しいカラーマップ
newmyCmap = interp1(linspace(0,1,nColors), cmap, customRange);

% === 描画 ===
for pos = 1:length(Postures_name)
figure;
colormap(newmyCmap);
imagesc(Ex3_time_window_each(1:end-1), length(newSpkTime):-1:1, Ex3_static_firing_rate_for_psth{1,pos});
caxis([0 150]);   
%colorbar;
xlim([-5 20])
ylim([0.5 length(newSpkTime)+0.5])

yticks([num_of_neuron-125+1 num_of_neuron-100+1 num_of_neuron-75+1 num_of_neuron-50+1 num_of_neuron-25+1]); 
yticklabels(fliplr({'25 ','50 ','75 ','100 ','125 '}));

% --- X軸 ---
xticks([0 15]);      % 目盛りの位置を指定
xticklabels({'0','15'});  % 表示ラベル
hold on;
% --- グレー線 ---
xline(0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);
xline(15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 4);




% --- 軸の設定 ---
ax = gca;
ax.FontSize = 50;          % 軸のフォントサイズ
ax.FontName = 'Arial';     
ax.FontWeight = 'bold';    % 軸ラベル・目盛を太字に

% === FigureサイズをA4幅に縮小 ===
target_width = 19;    % cm
target_height = 20;   % cm
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% --- タイトルを太字かつ80ポイントに ---
title(['Pos-' num2str(pos)], 'FontName', 'Arial','FontWeight','bold', 'FontSize', 80);

% Create textarrow
%{
annotation(gcf,'textarrow',[0.095447870778267 0.129221732745961],...
    [0.337517433751742 0.337517433751741],'LineWidth',5,'HeadStyle','plain');
%}

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


%% all firing rate

figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
% line change for firing rate for heatmap time
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

% 
experiment3_firingrate_heatmap = createNamedFolder(experiment3_folder, 'experiment3_firingrate_heatmap');

for pos = 1:length(Postures_name)
    %plot firing rate
    colormap(newCmap);  % ここでは'jet'カラーマップを使用
    Heat_map = imagesc(Posture_heatmap_time{pos},Ex3_time_window_each(1:end-1),length(newSpkTime):-1,firing_rate_for_psth_rechange{pos,1});
    caxis([0 140]);
    cellfun(@(x) title(x, Postures_name_rechange(pos)),Posture_heatmap_time(pos));
end


cellfun(@(x) caxis(x,[0 140]),Posture_heatmap_time(1:16));
cellfun(@(x) xlabel(x,'Time (s)'),Posture_heatmap_time(1:16));
cellfun(@(x) ylabel(x,'Single-unit'),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整
fontsize(gcf,10,"points")
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_firingrate_heatmap, ['All_Posture'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
%close all hidden

%% plot all firing rate for fig---------------------------------------------------------------------------

experiment3_firingrate_heatmap = createNamedFolder(experiment3_folder, 'experiment3_firingrate_heatmap');
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);
% --- colorsを行単位で再配置 ---
n = length(Postures_name);  % 例: 16
side = sqrt(n);             % 例: 4
idx_color = reshape(1:n, [side, side]);  % 4x4 のインデックスマトリクス
idx_color = idx_color';                        % 転置して縦横を入れ替える
idx_color = idx_color(:);                      % 再び縦ベクトル化（並び替えインデックス）
colors_rechange = colors(idx_color, :);  % 行単位で並び替え


figure;
for i = 1:length(Postures_name)
    Posture_heatmap_time{i} = subplot(length(Postures_name)/4,length(Postures_name)/4,i);hold on;
end
for pos = 1:length(Postures_name)
    % ヒートマップ描画
    colormap(newmyCmap);
    imagesc(Posture_heatmap_time{pos}, Ex3_time_window_each(1:end-1), length(newSpkTime):-1, firing_rate_for_psth_rechange{pos,1});
    caxis([0 150]);
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
            yticks(ax,[30 60 90 120]); 
            yticklabels(ax,{'30','60','90','120','150'});
            % === ラベルを水平に ===
            ax.XTickLabelRotation = 0;                    % ラベルを回転させない（水平）
            % === 小目盛（線のみ） ===
            ax.YMinorTick = 'on';          
            %ax.YAxis.MinorTickValues = ([3 8 18 23 28 38 43 48 58 63 68]);
            ax.YAxis.MinorTickValues = ([10 20 40 50 70 80 100 110 130]);
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
 %{
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
 %}
cellfun(@(x) caxis(x,[0 150]),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.93, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整

% === カラーバー目盛とラベル設定 ===
colorbarHandle.Ticks = [0 50 100 150];                % 目盛の位置
colorbarHandle.TickLabels = {'0','50','100','150'}; % 表示ラベル（省略可）

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
 pdfFileName = fullfile(experiment3_firingrate_heatmap, ['Firing_rate_heat_map_for_fig_catB.pdf']);
 print(fig, pdfFileName, '-dpdf');
% --- PNG出力（高解像度）---
pngFileName = fullfile(experiment3_firingrate_heatmap, 'Firing_rate_heat_map_for_fig_catB.png');
print(fig, pngFileName, '-dpng', '-r600');   % 600dpiの高解像度PNG
%----------------------------------------------------------------------------


%% Cat B
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
            yticks(ax,[30 60 90 120]); 
            yticklabels(ax,{'30','60','90','120','150'});
            % === ラベルを水平に ===
            ax.XTickLabelRotation = 0;                    % ラベルを回転させない（水平）
            % === 小目盛（線のみ） ===
            ax.YMinorTick = 'on';          
            %ax.YAxis.MinorTickValues = ([3 8 18 23 28 38 43 48 58 63 68]);
            ax.YAxis.MinorTickValues = ([10 20 40 50 70 80 100 110 130]);
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

cellfun(@(x) caxis(x,[0 150]),Posture_heatmap_time(1:16));
cellfun(@(x) xlim(x,[-5 20]),Posture_heatmap_time(1:16));
cellfun(@(x) ylim(x,[0.5 length(newSpkTime)+0.5]),Posture_heatmap_time(1:16));
% カラーバーを全体の横に1つだけ配置
colorbarHandle = colorbar;
colorbarHandle.Position = [0.92, 0.1, 0.02, 0.8]; % カラーバーの位置とサイズを調整

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_firingrate_heatmap, ['All_Posture_labeld_CatB'  '.tif']);
print(gcf, tifFileName, '-dtiff', '-r300');
close all hidden

%% plot representative neuron firing rate ------------------------------------------------------------------------------

Posture_PSTH = cell(length(Postures_name),1);
experiment3_each_pos_psth = createNamedFolder(experiment3_psth,'each_pos_psth_fig');
plot_Ex3_staticPSTH = 2;
if plot_Ex3_staticPSTH == 1
    for neuron = 64:64
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
            ylim(Posture_PSTH{pos}, [0 50]);
            
            
            for task = 1:size(Task_spike_time_all_Each_pos_rechange{1,1},2)
                scatter(Posture_PSTH{pos},Task_spike_time_all_Each_pos_rechange{pos,1}{neuron,task},50-5*5+task*5,'.','MarkeredgeColor','k');hold on;
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
            b.FaceColor = [0.3 0.7 1]; % 水色（好みに応じて変更）
            b.FaceAlpha = 0.8;
            
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
            xline(Posture_PSTH{pos}, 0, '-', 'LineWidth', 2, 'Color', [0 1 1]);  % シアン
            xline(Posture_PSTH{pos}, mean(DI_each_pos_rechange{pos,1}(:,3)), '-', 'LineWidth', 2, 'Color', [1 0 1]);  % マゼンタ
        end
    fontsize(gcf,16,"points");
    % --- 図全体タイトル ---
    sgtitle(gcf, ['Neuron ' num2str(neuron) ' ' num2str(newSpkCH(neuron)) 'channel PSTH across postures'],'FontSize', 30);
     % --- 全体のX軸/Y軸ラベル ---
    han = axes(gcf, 'visible', 'off');
    han.XLabel.Visible = 'on';
    han.YLabel.Visible = 'on';
    xlabel(han, 'Time [s]', 'FontSize', 30, 'Units', 'normalized', 'Position', [0.5, -0.08, 0]);
    ylabel(han, 'Firing rate [Hz] (bin size 0.05 s)', 'FontSize', 30, 'Units', 'normalized', 'Position', [-0.08, 0.5, 0]);
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
    tifFileName = fullfile(experiment3_each_pos_psth, ['Neuron_' num2str(neuron) '.tif']);
    print(gcf, tifFileName, '-dtiff', '-r300'); 
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



%% load position data caluculated by Cat_analysis_lumbar_2024_0903_main_Ex3_motion_analysis.m
%{
addpath(genpath('/data3/202408-09Cat/0903-lumbar/posture/2024-09-03_08-59-05/Record Node 101/experiment1/recording1/video_data'));
load('9_3_hindlimb_position_data.mat');
Knee_mean_ = Knee_mean;
%}

% losd video data
Video_data_Path=[strjoin(Parts(1:end-5),filesep),filesep,'video_data'];
addpath(genpath('D:\Cat article M2\For article analysis\Code\9-03 lumbar\function_for_video'));

addpath(genpath(Video_data_Path));
fps = 30;
length_competition = 10;

%video name
%load main view
filename_of_video_data_experiment3_main_trial1= 'ch02_ch04_trial1_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_main_trial2= 'ch02_ch04_trial2_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_main_trial3= 'ch02_ch04_trial3_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_main_trial4= 'ch02_ch04_trial4_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_main_trial5= 'ch02_ch04_trial5_ex3_DLC_3D.csv';

%load ilium view
filename_of_video_data_experiment3_ilium_trial1= 'ch03_ch04_trial1_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_ilium_trial2= 'ch03_ch04_trial2_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_ilium_trial3= 'ch03_ch04_trial3_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_ilium_trial4= 'ch03_ch04_trial4_ex3_DLC_3D.csv';
filename_of_video_data_experiment3_ilium_trial5= 'ch03_ch04_trial5_ex3_DLC_3D.csv';

%

[main_time_data_trial1,main_data_table_trial1,main_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_main_trial1,fps);
[main_time_data_trial2,main_data_table_trial2,main_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_main_trial2,fps);
[main_time_data_trial3,main_data_table_trial3,main_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_main_trial3,fps);
[main_time_data_trial4,main_data_table_trial4,main_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_main_trial4,fps);
[main_time_data_trial5,main_data_table_trial5,main_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_main_trial5,fps);

main_start_index = [1;length(main_time_data_trial1)+1;length(main_time_data_trial1)+length(main_time_data_trial2)+1;length(main_time_data_trial1)+length(main_time_data_trial2)+length(main_time_data_trial3)+1;length(main_time_data_trial1)+length(main_time_data_trial2)+length(main_time_data_trial3)+length(main_time_data_trial4)+1];
main_end_index = [length(main_time_data_trial1);length(main_time_data_trial1)+length(main_time_data_trial2);length(main_time_data_trial1)+length(main_time_data_trial2)+length(main_time_data_trial3);length(main_time_data_trial1)+length(main_time_data_trial2)+length(main_time_data_trial3)+length(main_time_data_trial4);length(main_time_data_trial1)+length(main_time_data_trial2)+length(main_time_data_trial3)+length(main_time_data_trial4)+length(main_time_data_trial5)];
main_start_end_index = [main_start_index,main_end_index];

main_time_data_all = [main_time_data_trial1;main_time_data_trial2;main_time_data_trial3;main_time_data_trial4;main_time_data_trial5];
main_data_table_all = [main_data_table_trial1;main_data_table_trial2;main_data_table_trial3;main_data_table_trial4;main_data_table_trial5];

%
hip_main = main_data_table_all(:,1:3)*length_competition;
knee_main = main_data_table_all(:,4:6)*length_competition;
ankle_main = main_data_table_all(:,7:9)*length_competition;
paw_main = main_data_table_all(:,10:12)*length_competition;

% 

[ilium_time_data_trial1,ilium_data_table_trial1,ilium_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_ilium_trial1,fps);
[ilium_time_data_trial2,ilium_data_table_trial2,ilium_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_ilium_trial2,fps);
[ilium_time_data_trial3,ilium_data_table_trial3,ilium_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_ilium_trial3,fps);
[ilium_time_data_trial4,ilium_data_table_trial4,ilium_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_ilium_trial4,fps);
[ilium_time_data_trial5,ilium_data_table_trial5,ilium_label_name] = get_all_position_data_3D(filename_of_video_data_experiment3_ilium_trial5,fps);

ilium_start_index = [1;length(ilium_time_data_trial1)+1;length(ilium_time_data_trial1)+length(ilium_time_data_trial2)+1;length(ilium_time_data_trial1)+length(ilium_time_data_trial2)+length(ilium_time_data_trial3)+1;length(ilium_time_data_trial1)+length(ilium_time_data_trial2)+length(ilium_time_data_trial3)+length(ilium_time_data_trial4)+1];
ilium_end_index = [length(ilium_time_data_trial1);length(ilium_time_data_trial1)+length(ilium_time_data_trial2);length(ilium_time_data_trial1)+length(ilium_time_data_trial2)+length(ilium_time_data_trial3);length(ilium_time_data_trial1)+length(ilium_time_data_trial2)+length(ilium_time_data_trial3)+length(ilium_time_data_trial4);length(ilium_time_data_trial1)+length(ilium_time_data_trial2)+length(ilium_time_data_trial3)+length(ilium_time_data_trial4)+length(ilium_time_data_trial5)];
ilium_start_end_index = [ilium_start_index,ilium_end_index];

ilium_time_data_all = [ilium_time_data_trial1;ilium_time_data_trial2;ilium_time_data_trial3;ilium_time_data_trial4;ilium_time_data_trial5];
ilium_data_table_all = [ilium_data_table_trial1;ilium_data_table_trial2;ilium_data_table_trial3;ilium_data_table_trial4;ilium_data_table_trial5];

%

hip_ilium_view = ilium_data_table_all(:,1:3)*length_competition;
knee_ilium_view = ilium_data_table_all(:,4:6)*length_competition;
ankle_ilium_view = ilium_data_table_all(:,7:9)*length_competition;
paw_ilium_view = ilium_data_table_all(:,10:12)*length_competition;
ilium_ilium_view = ilium_data_table_all(:,13:15)*length_competition;

disp('Video data was completly loaded')


%% 
figure;
% main
plot3(hip_main(:,1), hip_main(:,2), hip_main(:,3), 'ro');
hold on;
plot3(knee_main(:,1), knee_main(:,2), knee_main(:,3), 'bo');
plot3(ankle_main(:,1), ankle_main(:,2), ankle_main(:,3), 'go');
%plot3(paw_main(:,1), paw_main(:,2), paw_main(:,3), 'go');

figure;
% ilium
plot3(hip_ilium_view(:,1), hip_ilium_view(:,2), hip_ilium_view(:,3), 'ro');
hold on;
plot3(knee_ilium_view(:,1), knee_ilium_view(:,2), knee_ilium_view(:,3), 'bo');
plot3(ankle_ilium_view(:,1), ankle_ilium_view(:,2), ankle_ilium_view(:,3), 'go');
plot3(ilium_ilium_view(:,1), ilium_ilium_view(:,2), ilium_ilium_view(:,3), 'ko');

% hip-ankle のリンク長さを計算（main座標系）
link_main = sqrt( sum((hip_main - ankle_main).^2, 2) );  % N×1ベクトル

% hip-ankle のリンク長さを計算（ilium座標系）
link_ilium = sqrt( sum((hip_ilium_view - ankle_ilium_view).^2, 2) );

% 平均や標準偏差も計算して比較
mean_main  = mean(link_main, 'omitnan');
std_main   = std(link_main, 'omitnan');
mean_ilium = mean(link_ilium, 'omitnan');
std_ilium  = std(link_ilium, 'omitnan');

fprintf('Main view:  mean = %.2f, std = %.2f\n', mean_main, std_main);
fprintf('Ilium view: mean = %.2f, std = %.2f\n', mean_ilium, std_ilium);

% 可視化（時間 vs リンク長さ）
figure;
plot(link_main, 'b-'); hold on;
plot(link_ilium, 'r-');
xlabel('Frame');
ylabel('Hip-Ankle length (units same as coords)');
legend('Main view','Ilium view');
title('Hip-Ankle link length comparison');

%% --- 1) hip と ankle を100フレームごとにサンプリング
% --- 1) ankle のみで対応点作成 ---
N = min([size(ankle_main,1), size(ankle_ilium_view,1)]);
step = 1;                       % 100フレームごと
idx  = 1:step:N;

P_main  = ankle_main(idx,:);
P_ilium = ankle_ilium_view(idx,:);

% --- 2) NaN除去 ---
valid_idx = all(~isnan(P_main),2) & all(~isnan(P_ilium),2);
P_main  = P_main(valid_idx,:);
P_ilium = P_ilium(valid_idx,:);
% ====== 2.5) Kabsch法で R_align, T を計算 ======
centroid_main  = mean(P_main, 1);
centroid_ilium = mean(P_ilium,1);

A = P_main  - centroid_main;     % (M x 3)
B = P_ilium - centroid_ilium;    % (M x 3)

H = B.' * A;                     % 3x3
[U, ~, V] = svd(H);

R_align = V * U.';
% --- 反射補正 ---
if det(R_align) < 0
    V(:,3)   = -V(:,3);
    R_align  = V * U.';
end
% === ここで平行移動ベクトルを定義 ===
T = centroid_main' - R_align * centroid_ilium';

% ====== 3) 推定した (R_align, T) を ilium view の全データに適用 ======
Ilium_ilium_rot = (R_align * ilium_ilium_view.').' + T.';
hip_ilium_rot   = (R_align * hip_ilium_view.').'   + T.';
knee_ilium_rot  = (R_align * knee_ilium_view.').'  + T.';
ankle_ilium_rot = (R_align * ankle_ilium_view.').' + T.';
paw_ilium_rot   = (R_align * paw_ilium_view.').'   + T.';


% ====== 4) （任意）平面合わせ：ankleの平面をXZ面に揃える ======
% 既存コードの平面合わせパートはこの後にそのまま使えます。
% 例：P1,P2,P3 は main 側 ankle の3点（または時間的に離れた代表点）を使う
origin = [hip_main(1,1), hip_main(1,2), hip_main(1,3)];
P1 = ankle_main(1,:);
P2 = ankle_main(13700,:);
P3 = ankle_main(44000,:);

v1 = P2 - P1;  v2 = P3 - P1;
normal_vec = cross(v1, v2);  normal_vec = normal_vec / norm(normal_vec);
target_normal = [0 1 0];                          % XZ平面の法線（Y軸）
rot_axis = cross(normal_vec, target_normal);
axis_norm = norm(rot_axis);
angle = acos(dot(normal_vec, target_normal));
if axis_norm ~= 0
    rot_axis = rot_axis / axis_norm;
    K = [  0        -rot_axis(3)  rot_axis(2);
          rot_axis(3)  0         -rot_axis(1);
         -rot_axis(2)  rot_axis(1)  0        ];
    R_plane = eye(3) + sin(angle)*K + (1-cos(angle))*(K^2);
else
    R_plane = eye(3);
end

% 回転を main/変換後ilium の双方に適用（中心を origin に）
hip_rotated          = (R_plane * (hip_main-origin).').'            + origin;
knee_rotated         = (R_plane * (knee_main-origin).').'           + origin;
ankle_rotated        = (R_plane * (ankle_main-origin).').'          + origin;
paw_rotated          = (R_plane * (paw_main-origin).').'            + origin;

Ilium_rotated_ilium  = (R_plane * (Ilium_ilium_rot-origin).').'     + origin;
hip_rotated_ilium    = (R_plane * (hip_ilium_rot-origin).').'       + origin;
knee_rotated_ilium   = (R_plane * (knee_ilium_rot-origin).').'      + origin;
ankle_rotated_ilium  = (R_plane * (ankle_ilium_rot-origin).').'     + origin;
paw_rotated_ilium    = (R_plane * (paw_ilium_rot-origin).').'       + origin;
% Z軸反転用行列
flipZ = diag([1 1 -1]);   % Xそのまま, Yそのまま, Zだけ反転

% --- main側 ---
hip_rotated    = (flipZ * hip_rotated.').';
knee_rotated   = (flipZ * knee_rotated.').';
ankle_rotated  = (flipZ * ankle_rotated.').';
paw_rotated    = (flipZ * paw_rotated.').';

% --- ilium側（変換後） ---
Ilium_rotated_ilium = (flipZ * Ilium_rotated_ilium.').';
hip_rotated_ilium   = (flipZ * hip_rotated_ilium.').';
knee_rotated_ilium  = (flipZ * knee_rotated_ilium.').';
ankle_rotated_ilium = (flipZ * ankle_rotated_ilium.').';
paw_rotated_ilium   = (flipZ * paw_rotated_ilium.').';



%
figure;

subplot(1,2,1);
% main
plot3(hip_main(:,1), hip_main(:,2), hip_main(:,3), 'go');
hold on;
plot3(knee_main(:,1), knee_main(:,2), knee_main(:,3), 'go');
plot3(ankle_main(:,1), ankle_main(:,2), ankle_main(:,3), 'go');
%plot3(paw_main(:,1), paw_main(:,2), paw_main(:,3), 'go');



% hip（変換後）
plot3(hip_ilium_rot(:,1), hip_ilium_rot(:,2), hip_ilium_rot(:,3), 'r.');
plot3(knee_ilium_rot(:,1), knee_ilium_rot(:,2), knee_ilium_rot(:,3), 'r.');
plot3(ankle_ilium_rot(:,1), ankle_ilium_rot(:,2), ankle_ilium_rot(:,3), 'r.');
%plot3(paw_ilium_rot(:,1), paw_ilium_rot(:,2), paw_ilium_rot(:,3), 'r.');
plot3(Ilium_ilium_rot(:,1), Ilium_ilium_rot(:,2), Ilium_ilium_rot(:,3), 'b.');

title('Before transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on; view(3);
hold off;

subplot(1,2,2);
%plot3(hip_rotated(:,1), hip_rotated(:,2), hip_rotated(:,3), 'yo');
hold on;
plot3(knee_rotated(:,1), knee_rotated(:,2), knee_rotated(:,3), 'go');
plot3(ankle_rotated(:,1), ankle_rotated(:,2), ankle_rotated(:,3), 'go');
%plot3(paw_rotated(:,1), paw_rotated(:,2), paw_rotated(:,3), 'go');
% hip（変換後）
plot3(hip_rotated_ilium(:,1), hip_rotated_ilium(:,2), hip_rotated_ilium(:,3), 'r.');
plot3(knee_rotated_ilium(:,1), knee_rotated_ilium(:,2), knee_rotated_ilium(:,3), 'r.');
plot3(ankle_rotated_ilium(:,1), ankle_rotated_ilium(:,2), ankle_rotated_ilium(:,3), 'r.');
%plot3(paw_rotated_ilium(:,1), paw_rotated_ilium(:,2), paw_rotated_ilium(:,3), 'r.');
plot3(Ilium_rotated_ilium(:,1), Ilium_rotated_ilium(:,2), Ilium_rotated_ilium(:,3), 'b.');
title('After transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on; view(3);

%% plot detail
figure
%plot3(hip_rotated(:,1), hip_rotated(:,2), hip_rotated(:,3), 'yo');
hold on;
plot3(knee_rotated(:,1), knee_rotated(:,2), knee_rotated(:,3), 'go');
plot3(ankle_rotated(:,1), ankle_rotated(:,2), ankle_rotated(:,3), 'go');
%plot3(paw_rotated(:,1), paw_rotated(:,2), paw_rotated(:,3), 'go');
% hip（変換後）
plot3(hip_rotated_ilium(:,1), hip_rotated_ilium(:,2), hip_rotated_ilium(:,3), 'r.');
plot3(knee_rotated_ilium(:,1), knee_rotated_ilium(:,2), knee_rotated_ilium(:,3), 'r.');
plot3(ankle_rotated_ilium(:,1), ankle_rotated_ilium(:,2), ankle_rotated_ilium(:,3), 'r.');
%plot3(paw_rotated_ilium(:,1), paw_rotated_ilium(:,2), paw_rotated_ilium(:,3), 'r.');
plot3(Ilium_rotated_ilium(:,1), Ilium_rotated_ilium(:,2), Ilium_rotated_ilium(:,3), 'b.');
title('After transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
zlim([-600 -300])
axis equal; grid on; view(3);





Pos_main_data_label = ["Ilium","hip","knee","ankle","paw"];
Pos_main_data = {Ilium_rotated_ilium,hip_rotated_ilium,knee_rotated,ankle_rotated,paw_rotated};



%% Align video data
if strcmp(experiment3_select_trial, 'main')
    Ex3_main_time_data_align = [];
    for tr = 1:length(Trial_timing_all_trial)
        Ex3_main_time_data_align_offset = Trial_timing_all_trial(tr,1);

        Ex3_main_time_data_align_each = Ex3_main_time_data_align_offset + main_time_data_all(main_start_end_index(tr,1):main_start_end_index(tr,2),1);
        Ex3_main_time_data_align = [Ex3_main_time_data_align;Ex3_main_time_data_align_each];
        
    end
    % define position
    each_pos_position_data = Cutting_pos_data(EX3_task_DI_Lineup_Trial,Ex3_main_time_data_align,Pos_main_data,[-5 20]);

else

end



%3D plot
figure;
colors = jet(16);
for i = 1:5
    for postutre_num = 1:16
    color = colors(postutre_num, :);
    plot3(each_pos_position_data{1,i}{1,postutre_num}(1,:), each_pos_position_data{1,i}{1,postutre_num}(2,:), each_pos_position_data{1,i}{1,postutre_num}(3,:), 'o','Color', color);
    hold on;
    plot3(each_pos_position_data{1,i}{2,postutre_num}(1,:), each_pos_position_data{1,i}{2,postutre_num}(2,:), each_pos_position_data{1,i}{2,postutre_num}(3,:), 'o','Color', [0 0 0]);
    plot3(each_pos_position_data{1,i}{3,postutre_num}(1,:), each_pos_position_data{1,i}{3,postutre_num}(2,:), each_pos_position_data{1,i}{3,postutre_num}(3,:), 'o','Color', color);
    plot3(each_pos_position_data{1,i}{4,postutre_num}(1,:), each_pos_position_data{1,i}{4,postutre_num}(2,:), each_pos_position_data{1,i}{4,postutre_num}(3,:), 'o','Color', color);
    plot3(each_pos_position_data{1,i}{5,postutre_num}(1,:), each_pos_position_data{1,i}{5,postutre_num}(2,:), each_pos_position_data{1,i}{5,postutre_num}(3,:), 'o','Color', color);
    end
end
title('After transformation');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal; grid on; view(3);


%% plot static neuron 

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



%% ===============================
%  plot each ankle position
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
        %close(gcf);

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

% 閾値ライン（赤破線）
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
file_base = fullfile(experiment3_static_folder, 'Ankle_speed_onset_CatB');

% PNG保存（高解像度）
print(gcf, [file_base '.png'], '-dpng', '-r300');

% PDF保存（ベクター形式）
print(gcf, [file_base '.pdf'], '-dpdf', '-painters');



%% calculate static posture position
static_posture_cuttime = [1 14];
only_static_posture_position = Cutting_pos_data(EX3_task_DI_Lineup_Trial,Ex3_main_time_data_align,Pos_main_data,static_posture_cuttime);





%% estimate all posture with actual link model
hip_knee_link_length_actual = 119;
knee_ankle_link_length_actual = 123;



Compensated_knee_joint_position = Knee_joint_position_Compensation(hip_mean, Knee_mean, Ankle_mean, ...
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
    knee  = Knee_mean(i,:)  - offset;
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
    knee  = Knee_mean(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];
    if i == 1
        text(coords(1,1)-13, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 2
        text(coords(1,1)-32, coords(1,3)-5, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 3
        text(coords(1,1)-13, coords(1,3)-12, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 5
        text(coords(1,1)-9, coords(1,3)+3, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 6
        text(coords(1,1)-16, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
     elseif i == 7
        text(coords(1,1)-5, coords(1,3)-13, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20,'FontName', 'Arial', ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 9
        text(coords(1,1)-8, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 10
        text(coords(1,1)+4, coords(1,3)-5, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20,'FontName', 'Arial', ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 11
        text(coords(1,1)-12, coords(1,3)-14, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 12
        text(coords(1,1)-15, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
     elseif i == 14
        text(coords(1,1)+3, coords(1,3)-2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
      elseif i == 15
        text(coords(1,1)-3, coords(1,3)-13, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
      else
        % それ以外のPosは普通
        text(coords(1,1)-13, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end
 % ilium label
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% Hip joint psotion label
text(hip(1,1)+6, hip(1,3)-5, 'Hip joint position', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-80 150])
ylim([-220 20])
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
    '_fig_Cat B.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');
% --- PNG出力（高解像度）---
pngFileName = fullfile(experiment3_folder,'Recorded_posture_xy_for_fig_Cat B.png');
print(gcf, pngFileName, '-dpng', '-r600');   % 600dpiの高解像度PNG



%% plot hindlimb xy compensate
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
    if i == 1
        text(coords(1,1)-13, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 2
        text(coords(1,1)-32, coords(1,3)-5, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 3
        text(coords(1,1)-13, coords(1,3)-12, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 5
        text(coords(1,1)-9, coords(1,3)+3, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 6
        text(coords(1,1)-16, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
     elseif i == 7
        text(coords(1,1)-5, coords(1,3)-13, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20,'FontName', 'Arial', ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 9
        text(coords(1,1)-8, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    elseif i == 10
        text(coords(1,1)+4, coords(1,3)-5, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20,'FontName', 'Arial', ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 11
        text(coords(1,1)-12, coords(1,3)-14, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 12
        text(coords(1,1)-15, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
     elseif i == 14
        text(coords(1,1)+3, coords(1,3)-2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
      elseif i == 15
        text(coords(1,1)-3, coords(1,3)-13, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
      else
        % それ以外のPosは普通
        text(coords(1,1)-13, coords(1,3)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end
 % ilium label
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% Hip joint psotion label
text(hip(1,1)+6, hip(1,3)-5, 'Hip joint position', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-90 150])
ylim([-220 20])
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
    '_fig_Cat B_compensation_position.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');
% --- PNG出力（高解像度）---
pngFileName = fullfile(experiment3_folder,'Recorded_posture_xy_for_fig_Cat_B_compensation_position.png');
print(gcf, pngFileName, '-dpng', '-r600');   % 600dpiの高解像度PNG

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
    knee  = Knee_mean(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];


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
    knee  = Knee_mean(i,:)  - offset;
    hip   = hip_mean  - offset;   
    Hbone = H_bone_mean - offset;

    coords = [ankle; knee; hip; Hbone];
    if i == 7
        text(coords(1,1)-2, coords(1,3)-14, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20,'FontName', 'Arial', ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    elseif i == 10
        text(coords(1,1)-5.5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20,'FontName', 'Arial', ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 11
        text(coords(1,1)-7, coords(1,3)-14, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 12
        text(coords(1,1)-5.5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
     elseif i == 13
        text(coords(1,1)-5.5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
     elseif i == 14
        text(coords(1,1)-3, coords(1,3)-14, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
      elseif i == 15
        text(coords(1,1)-8.5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
     elseif i == 16
        text(coords(1,1)-5.5, coords(1,3)+1, sprintf('%d', i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
      else
        % それ以外のPosは普通
        text(coords(1,1)-3, coords(1,3)+1, sprintf(['%d'], i), ...
            'FontWeight','bold','FontSize', 20, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end

 % ilium label
text(Hbone(1,1)-8, Hbone(1,3)+2, 'Ilium', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% Hip joint psotion label
text(hip(1,1)+6, hip(1,3)-5, 'Hip joint position', ...
            'FontSize', 25, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
pbaspect([1 1 1]);
xlim([-80 150])
ylim([-220 20])
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
    '_fig_plot_4_4_Cat B.pdf']);
print(gcf, pdfFileName, '-dpdf', '-bestfit');
pngFileName = fullfile(experiment3_folder,'Recorded_posture_xy_for_fig_Cat B_4_4.png');
print(gcf, pngFileName, '-dpng', '-r600');   % 600dpiの高解像度PNG

%% separate dynamic phase and static phase
% extract non firedneuron  remove non fired neuron

experiment3_sepstatic_dynamic_folder = createNamedFolder(experiment3_folder, 'Separate Static and Dynamic');
% セル配列を行列に変換
MFR_pos_matrix = zeros(length(Ex3_Mean_firing_rate_all{1,1}),size(Ex3_Mean_firing_rate_all{1,1},2));
MFR_pos_component = zeros(length(Ex3_Mean_firing_rate_all{1,1}),length(Ex3_Mean_firing_rate_all));

for i = 1:size(Ex3_Mean_firing_rate_all{1,1},2)
    for ii = 1:length(Ex3_Mean_firing_rate_all)
        MFR_pos_component(:,ii) = Ex3_Mean_firing_rate_all{1,ii}(:,i);
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
% rectify baced on bace line


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
tilt_cal_bin = 10;
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
static_calculation = 'Defined';
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
    %experiment3_static_folder_select = experiment3_static_defined_folder;
    str_sep_dynamic_static = 1.75;
    end_sep_dynamic_static = 14.5;
    %str_sep_dynamic_static = 5;
    %end_sep_dynamic_static = 15
    %onset_time;

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


%% calculate angle

pos_number = 1:1:16;

angle_definition = 'relative_normalized_centering';

angle_definition = 'relative_normalized_centering_knee_compensation';
% relative, diff_from_standard,abs_by_horizontal
angle_folder =createNamedFolder(experiment3_static_folder_select, 'Angle_compare');

%
if strcmp(angle_definition, 'relative')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean),pos_number'];
    vec_hipknee = hip_mean - Knee_mean;
    standard_vec_hip_knee = Knee_mean - vec_hipknee;
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean),pos_number'];
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean),compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)];
    hip_joint_lim = [25 90];
    knee_joint_lim = [35 125];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
elseif strcmp(angle_definition, 'relative_normalized')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean),pos_number'];
    vec_hipknee = hip_mean - Knee_mean;
    standard_vec_hip_knee = Knee_mean - vec_hipknee;
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean),pos_number'];
    hip_joint_lim = [-1 1];
    knee_joint_lim = [-1 1];
    %original angle information
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean),compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)];
    % normalized hip and knee angle -1 to 1
    hip_joint_angle_ori_normalized = 2 * (hip_joint_angle_ori(:,1) - min(hip_joint_angle_ori(:,1))) / (max(hip_joint_angle_ori(:,1)) - min(hip_joint_angle_ori(:,1))) - 1;
    knee_joint_angle_ori_normalized = 2 * (knee_joint_angle_ori(:,1) - min(knee_joint_angle_ori(:,1))) / (max(knee_joint_angle_ori(:,1)) - min(knee_joint_angle_ori(:,1))) - 1;
    hip_joint_angle_ori = [hip_joint_angle_ori_normalized,hip_joint_angle_ori(:,2)];
    knee_joint_angle_ori = [knee_joint_angle_ori_normalized,knee_joint_angle_ori(:,2)];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
    %centering
    hip_joint_angle_ori_centering = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean)-mean(compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean)),pos_number'];
    knee_joint_angle_ori_centering = [compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)-mean(compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)),pos_number'];

    hip_joint_angle_ori_normalized_centering = 2 * (hip_joint_angle_ori_centering(:,1) - min(hip_joint_angle_ori_centering(:,1))) / (max(hip_joint_angle_ori_centering(:,1)) - min(hip_joint_angle_ori_centering(:,1))) - 1;
    knee_joint_angle_ori_normalized_centering = 2 * (knee_joint_angle_ori_centering(:,1) - min(knee_joint_angle_ori_centering(:,1))) / (max(knee_joint_angle_ori_centering(:,1)) - min(knee_joint_angle_ori_centering(:,1))) - 1;
    hip_joint_angle_ori_centering = [hip_joint_angle_ori_normalized_centering,hip_joint_angle_ori_centering(:,2)];
    knee_joint_angle_ori_centering = [knee_joint_angle_ori_normalized_centering,knee_joint_angle_ori_centering(:,2)];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
elseif strcmp(angle_definition, 'relative_normalized_centering')
    vec_hip_hipBone = H_bone_mean - hip_mean;
    standard_vec_hip_hipBone = hip_mean - vec_hip_hipBone;
    vec_hipknee = hip_mean - Knee_mean;
    standard_vec_hip_knee = Knee_mean - vec_hipknee;
    hip_joint_angle_ori = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean)-mean(compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean)),pos_number'];
    knee_joint_angle_ori = [compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)-mean(compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)),pos_number'];
    hip_joint_lim = [-1 1];
    knee_joint_lim = [-1 1];
    %original angle information
    hip_knee_joint_angle_orignal = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean),compute_joint_angle(standard_vec_hip_knee, Knee_mean, Ankle_mean)];
    % normalized hip and knee angle -1 to 1
    hip_joint_angle_ori_normalized = 2 * (hip_joint_angle_ori(:,1) - min(hip_joint_angle_ori(:,1))) / (max(hip_joint_angle_ori(:,1)) - min(hip_joint_angle_ori(:,1))) - 1;
    knee_joint_angle_ori_normalized = 2 * (knee_joint_angle_ori(:,1) - min(knee_joint_angle_ori(:,1))) / (max(knee_joint_angle_ori(:,1)) - min(knee_joint_angle_ori(:,1))) - 1;
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);
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
    hip_joint_angle = compute_joint_angle(H_bone_mean, hip_mean, Knee_mean);
    knee_joint_angle = compute_joint_angle(hip_mean, Knee_mean, Ankle_mean);
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
    abs_angle_standard_end_point   = Knee_mean + abs_angle_standard_vec;
    hip_joint_angle = compute_joint_angle(abs_angle_standard, hip_mean, Knee_mean);
    knee_joint_angle = compute_joint_angle(abs_angle_standard_end_point, Ankle_mean, Knee_mean);
    idx_abs_knee = Knee_mean(:,3) < Ankle_mean(:,3);
    knee_joint_angle(idx_abs_knee)  = -abs(knee_joint_angle(idx_abs_knee));
    knee_joint_angle(~idx_abs_knee) =  abs(knee_joint_angle(~idx_abs_knee)); 
    hip_joint_angle_ori = [hip_joint_angle,pos_number'];
    knee_joint_angle_ori = [knee_joint_angle,pos_number'];
    hip_joint_lim = [30 105];
    knee_joint_lim = [-10 25];
    angle_related_folder =createNamedFolder(angle_folder,  angle_definition);

else 
    hip_joint_angle = compute_joint_angle(H_bone_mean, hip_mean, Knee_mean);
    knee_joint_angle = compute_joint_angle(hip_mean, Knee_mean, Ankle_mean);
    hip_joint_angle_ori = [hip_joint_angle,pos_number'];
    knee_joint_angle_ori = [knee_joint_angle,pos_number'];
    hip_joint_lim = [95 155];
    knee_joint_lim = [55 145];
    angle_related_folder =createNamedFolder(angle_folder,  'normal');
end


%experiment3_select_trial = 'main';
%plot_Ex3_staticPSTH = 2;   % 1 plot psth 2 skip psth
hip_joint_angle_gonios = compute_joint_angle(H_bone_mean, hip_mean, Knee_mean);
knee_joint_angle_gonios = compute_joint_angle(hip_mean, Knee_mean, Ankle_mean);
gonios_hip_and_knee = [hip_joint_angle_gonios,knee_joint_angle_gonios];
Hip_max_of_ginios_rad_by_article = 164;
Hip_min_of_ginios_rad_by_article = 32;
Hip_range_prrcentage = (max(hip_joint_angle_gonios)-min(hip_joint_angle_gonios))/(Hip_max_of_ginios_rad_by_article-Hip_min_of_ginios_rad_by_article)

Hip_range_of_ginios_by_article = Hip_max_of_ginios_rad_by_article-Hip_min_of_ginios_rad_by_article;
Knee_max_of_ginios_rad_by_article = 166;
Knee_min_of_ginios_rad_by_article = 22;
Knee_range_of_ginios_by_article = Knee_max_of_ginios_rad_by_article-Knee_min_of_ginios_rad_by_article;
Knee_range_prrcentage = (max(knee_joint_angle_gonios)-min(knee_joint_angle_gonios))/(Knee_max_of_ginios_rad_by_article-Knee_min_of_ginios_rad_by_article)


%% データの取得（1列目: X, 2列目: Y）---------------------------------------------------------
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);

% 点数（＝16と仮定）
nPoints = length(X);

% カラーマップ（jetの16色）
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);
cmap = colors;

figure;
hold on;

for i = 1:nPoints
    % マーカーサイズをさらに大きく（例: 150）
    scatter(X(i), Y(i), 150, cmap(i,:), 'filled');
   if i == 7 || i == 11 
       text(X(i), Y(i) - 2.5, sprintf('Pos-%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   elseif i == 11
       text(X(i)+5, Y(i) + 2.5, sprintf('Pos-%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   elseif i == 14
       text(X(i)-1, Y(i) - 2.5, sprintf('Pos-%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   else
    % ラベルをY方向に少し上にずらして表示
    text(X(i), Y(i) + 2.5, sprintf('Pos-%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   end
end

xlabel('Hip joint angle [degree]', 'FontSize', 12);
ylabel('Knee joint angle [degree]', 'FontSize', 12);



ax = gca;  % 現在の軸を取得
ax.FontSize = 20;       % 目盛りの文字サイズを大きく
ax.FontWeight = 'bold'; % 目盛りの文字を太字に

grid on;
xlim([60 100])
ylim([30 130])
if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    xlim([60 110])
    ylim([50 140])
end

% 目盛りの刻みを指定（10刻み）
ax = gca;
ax.XTick = 60:10:100;  % X軸 60, 70, 80, 90, 100
ax.YTick = 30:10:130;  % Y軸 30, 40, ..., 130


if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    tifFileName = fullfile(angle_related_folder, 'Recorded_angle_compensetion.tif');
else
    tifFileName = fullfile(experiment3_folder, 'Recorded_angle.tif');
end

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_folder, 'Recorded_angle.tif');
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
if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    baseName = fullfile(angle_related_folder, 'Recorded_angle_knee_position_compemsation_CatB');
else
    baseName = fullfile(experiment3_folder, 'Recorded_angle_CatB');
end
    

print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
print(gcf, [baseName '.png'], '-dpng', '-r300');


%% compare hip joint angle and knee joint angle

hip_knee_joint_angle_original_definition_motion_data = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Knee_mean),compute_joint_angle(Knee_mean - (hip_mean - Knee_mean), Knee_mean, Ankle_mean)];
hip_knee_joint_angle_original_definition_compensated_data = [compute_joint_angle(standard_vec_hip_hipBone, hip_mean, Compensated_knee_joint_position),compute_joint_angle(Compensated_knee_joint_position - (hip_mean - Compensated_knee_joint_position), Compensated_knee_joint_position, Ankle_mean)];


% 角度差
angle_diff = hip_knee_joint_angle_original_definition_compensated_data ...
           - hip_knee_joint_angle_original_definition_motion_data;

% 絶対値差
abs_angle_diff = abs(angle_diff);

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
    if i == 2
         text(Theta_hip_to_ankle_ori(i), Leg_length(i) - 4, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
    elseif i == 11
         text(Theta_hip_to_ankle_ori(i)+3, Leg_length(i) + 4, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
    elseif i == 15
         text(Theta_hip_to_ankle_ori(i), Leg_length(i) - 4, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
    else
    % ラベルをY方向に少し上にずらして表示
    text(Theta_hip_to_ankle_ori(i), Leg_length(i) + 4, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
    end
end

xlabel('Orientation [degree]', 'FontSize', 12);
ylabel('length [mm]', 'FontSize', 12);

ax = gca;  % 現在の軸を取得
ax.FontSize = 20;       % 目盛りの文字サイズを大きく
ax.FontWeight = 'bold'; % 目盛りの文字を太字に

grid on;
xlim([50 100])
ylim([100 225])

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
    baseName = fullfile(experiment3_folder, 'Recorded_angle_orientation_and_length_CatB');

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');



%% change save folder for competition knee joint position

if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    experiment3_static_folder_select = angle_related_folder;
else

end
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



MFR_sep_pos

%{
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
%}

% line up
hip_joint_angle_sort = sortrows(hip_joint_angle_ori, 1);
knee_joint_angle_sort = sortrows(knee_joint_angle_ori, 1);
[MFR_sep_lineup_hip,MFR_sep_lineup_mean_hip,MFR_sep_lineup_z_hip,MFR_sep_lineup_z_mean_hip] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,hip_joint_angle_sort(:,2)');
[MFR_sep_lineup_knee,MFR_sep_lineup_mean_knee,MFR_sep_lineup_z_knee,MFR_sep_lineup_z_mean_knee] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,knee_joint_angle_sort(:,2)');

leg_orientation_sort = sortrows(Theta_hip_to_ankle_ori, 1);
leg_length_sort = sortrows(Leg_length, 1);
[MFR_sep_lineup_leg_orientation,MFR_sep_lineup_mean_leg_orientation,MFR_sep_lineup_z_leg_orientation,MFR_sep_lineup_z_mean_leg_orientation] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,leg_orientation_sort(:,2)');
[MFR_sep_lineup_leg_length,MFR_sep_lineup_mean_leg_length,MFR_sep_lineup_z_leg_length,MFR_sep_lineup_z_mean_leg_length] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,leg_length_sort(:,2)');

%% Figure 5
% =========================
% 基本設定
% =========================

% 保存フォルダ
% =========================
save_base_folder = fullfile(experiment3_static_folder_select, 'Mean_firing_rate');
if ~exist(save_base_folder,'dir')
    mkdir(save_base_folder);
end


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
    'Mean_firing_rate_allNeurons_sortedBy_AnkleXY_CarB.png');

save_name = fullfile(save_base_folder, ...
    'Mean_firing_rate_allNeurons_sortedBy_AnkleXY_CatB.emf');

print(gcf, save_name, '-dmeta', '-r600');



%% plot angle related 
num_neurons = length(newSpkCH);  % 72
neurons_per_fig = 12;            % 12個ずつ表示
num_figs = ceil(num_neurons / neurons_per_fig);  % 6ページ


%{
for ThR = 2:5
threshold_R = 0.1*ThR;
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


    % 交互作用項を含めnai 説明変数行列 hip angle and knee model plus
    hip_plus = hip_joint_angle_sort_for_analyze-mean(hip_joint_angle_sort_for_analyze);
    knee_plus = knee_joint_angle_sort_for_analyze-mean(knee_joint_angle_sort_for_analyze);
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

     %hip angle and knee model cross hip&knee poralitry aligned by 0
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

%% 
%{
Plot_angle_MFR_multiple_regression_leg_and_ori_cross(neurons_per_fig, newSpkCH, orientation_sort_for_analyze(1:16,1), length_sort_for_analyze(1:16,1), MFR_sep_pos, Fig_name_leg_and_orientation_length_cross, leg_length_orientation_related_folder_cross, Rsq_multi_ori_len_inter_cross, p_multi_ori_len_inter_cross, cofficient_multi_ori_len_inter_cross,threshold_R,p_thresh)


% 例：2つのモデルのR値（72個のニューロン分）

% 差分を計算
R_diff = Rsq_multi_hip_knee_inter_cross - Rsq_multi_ori_len_inter_cross;
%R_diff = Rsq_multi_hip_knee_inter_cross-Rsq_multi_hip_knee_inter_cross_centering;
R_diff = Rsq_multi_hip_knee_inter_plus-Rsq_multi_hip_knee_inter_cross_centering;
R_diff = Rsq_single_hip-Rsq_multi_hip_knee_inter_cross_centering
% ヒストグラムで分布を表示
figure;
histogram(R_diff, 'BinWidth', 0.05, 'FaceColor', [0.2 0.6 0.8]);
xlim([-1 1])
xlabel('R_{model1} - R_{model2}');
ylabel('Neuron Count');
title('Distribution of R Difference (Model1 - Model2)');
grid on;

% 平均差を赤線で表示
hold on;
xline(mean(R_diff), 'r--', 'LineWidth', 2, 'DisplayName', 'Mean Difference');
legend('show');
%}

% 

%% cross
%{
%Plot_angle_MFR_multiple_regression_hip_knee_cross(neurons_per_fig, newSpkCH, hip_cross_centering(1:16,1), knee_cross_centering(1:16,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_centering, hip_and_knee_folder_cross_centering, Rsq_multi_hip_knee_inter_cross_centering, p_multi_hip_knee_inter_cross_centering, cofficient_multi_hip_knee_inter_cross_centering,threshold_R,p_thresh)

Plot_angle_MFR_multiple_regression_hip_knee_cross(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross, hip_and_knee_folder_cross, Rsq_multi_hip_knee_inter_cross, p_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)

Plot_angle_MFR_multiple_regression_hip_knee_cross(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross, hip_and_knee_folder_cross, Rsq_multi_hip_knee_inter_cross, p_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)
%}
%% 
hip_and_knee_folder_cross_particular_p = createNamedFolder(hip_and_knee_PCAfolder, 'cross_particular_p');
Fig_name_knee_and_hip_cross_particular_p  = 'Knee angle and Hip angle interaction particular p';
Plot_angle_MFR_multiple_regression_hip_knee_cross_particular_R(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_particular_p, hip_and_knee_folder_cross_particular_p, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R,p_value_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)
%% 

hip_and_knee_folder_cross_particular_p_for_fig = createNamedFolder(hip_and_knee_folder_cross_particular_p, 'for_fig');
Plot_angle_MFR_regression_hip_knee_cross_particular_R_for_fig(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_particular_p, hip_and_knee_folder_cross_particular_p_for_fig, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R,p_value_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)


%% plot figure for master thesis
hip_and_knee_folder_cross_particular_p_for_fig = createNamedFolder(hip_and_knee_folder_cross_particular_p, 'for_master_thesis');
Plot_angle_MFR_regression_hip_knee_cross_particular_R_for_M2(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross_particular_p, hip_and_knee_folder_cross_particular_p_for_fig, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R,p_value_multi_hip_knee_inter_cross, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh)

%% plot representative neuron for fig
responsible_neuron = [64,81,1];

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
    title(['SubB Neuron ' num2str(responsible_neuron(num_n))]);

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


%% plot 2D heat map
responsible_neuron = [64,81];

% 格子点作成
hip_range  = linspace(min(hip_joint_angle_ori(:,1)), max(hip_joint_angle_ori(:,1)), 30);
knee_range = linspace(min(knee_joint_angle_ori(:,1)), max(knee_joint_angle_ori(:,1)), 30);
[Hip_coff, Knee_coff] = meshgrid(hip_range, knee_range);

figure('Color','w');
for num_n = 1:length(responsible_neuron)
    subplot(1, 3, num_n);
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
    colormap(jet);
    caxis(clim);   % カラーマップ範囲固定
    c = colorbar;
    c.FontName   = 'Arial';
    c.FontWeight = 'bold';
    c.FontSize   = 14;

    % 実測値の散布図（色=発火率, 枠線=グレー）
    scatter(hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), 100, z, ...
            'filled', 'MarkerEdgeColor', [0.6 0.6 0.6], 'LineWidth', 1.5);

    % 軸ラベル・タイトル
    xlabel('Normalized hip joint angle', 'FontName','Arial','FontWeight','bold','FontSize',16);

    if num_n == 1
    ylabel('Normalized knee joint angle', 'FontName','Arial','FontWeight','bold','FontSize',16);
    else

    end
    title(['CatB Neuron #' num2str(responsible_neuron(num_n))], ...
          'FontName','Arial','FontWeight','bold','FontSize',18);

    % 軸設定
    axis([-1.1 1.1 -1.1 1.1]);
    axis square;
    xticks([-1 -0.5 0 0.5 1]);
    yticks([-1 -0.5 0 0.5 1]);
    grid on;

    ax = gca;
    ax.FontName   = 'Arial';
    ax.FontWeight = 'bold';
    ax.FontSize   = 14;
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
    'Regression_model_representative_neuron_Cat_ABwidth_2D.pdf');
print(fig, pdfFileName, '-dpdf');

%% Figure 6
% 2D color map with fixed color limits

responsible_neuron = [64,81];

% 格子点作成
hip_range  = linspace(min(hip_joint_angle_ori(:,1)), max(hip_joint_angle_ori(:,1)), 20);
knee_range = linspace(min(knee_joint_angle_ori(:,1)), max(knee_joint_angle_ori(:,1)), 20);
[Hip_coff, Knee_coff] = meshgrid(hip_range, knee_range);

figure('Units','centimeters','Position',[5 5 17 8],'Color','w');
tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
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
    c.FontSize   = 8;

    % 実測値の散布図（色=発火率, 枠線=グレー）
    scatter(hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), 30, z, ...
            'filled', 'MarkerEdgeColor', [0.6 0.6 0.6], 'LineWidth', 1.5);

    title(['Cat B Neuron #' num2str(responsible_neuron(num_n))], ...
          'FontName','Arial','FontWeight','bold','FontSize',10);

    % 軸設定
    axis([-1.1 1.1 -1.1 1.1]);
    axis square;
    xticks([-1 -0.5 0 0.5 1]);
    yticks([-1 -0.5 0 0.5 1]);
    grid on;

    ax = gca;
    ax.FontName   = 'Arial';
    ax.FontWeight = 'bold';
    ax.FontSize   = 8;
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
set(fig, 'Position', [5 5 17 8]);   % 幅17cm, 高さ8cm

emfFileName = fullfile(hip_and_knee_folder_cross_particular_p, ...
    'Regression_model_representative_neuron_Cat_B_4width_2D.emf');

print(fig, emfFileName, '-dmeta', '-r600');



%% Figure 6 vertical
% 2D color map with fixed color limits

responsible_neuron = [64,81];

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

    title(['Cat B Neuron #' num2str(responsible_neuron(num_n))], ...
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
    'Regression_model_representative_neuron_Cat_B_4width_2D_vertical.emf');

print(fig, emfFileName, '-dmeta', '-r600');





%%
%{
%hip angle and knee angle
Plot_angle_MFR_multiple_regression_plus_hip_and_knee(neurons_per_fig, newSpkCH, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, ...
    Fig_name_knee_and_hip_plus, hip_and_knee_folder_plus, ...
    Rsq_multi_ori_len_inter_plus, p_multi_hip_knee_inter_plus, cofficient_multi_hip_knee_inter_plus,threshold_R,p_thresh);

% orientation and length
Plot_angle_MFR_multiple_regression_plus_ori_and_len(neurons_per_fig, newSpkCH, Theta_hip_to_ankle_ori(:,1), Leg_length(:,1), MFR_sep_pos, ...
    Fig_name_leg_and_orientation_length_plus, leg_length_orientation_related_folder_plus, ...
    Rsq_multi_ori_len_inter_plus, p_multi_ori_len_inter_plus, cofficient_multi_ori_len_inter_plus,threshold_R,p_thresh);

%

Fig_name_knee = 'Knee angle firingrate not normalized';
Fig_name_hip = 'Hip angle firingrate not normalized';
neurons_per_fig = 12;

Plot_angle_MFR(neurons_per_fig,newSpkCH,hip_joint_angle_sort,MFR_sep_lineup_mean_hip,MFR_sep_lineup_hip,Fig_name_hip,hip_angle_related_folder,hip_joint_lim,Rsq_single_hip,p_joint_hip,cofficient_hip,threshold_R)

Plot_angle_MFR(neurons_per_fig,newSpkCH,knee_joint_angle_sort,MFR_sep_lineup_mean_knee,MFR_sep_lineup_knee,Fig_name_knee,knee_angle_related_folder,knee_joint_lim,Rsq_single_knee,p_joint_knee,cofficient_knee,threshold_R)

%
Plot_angle_MFR(neurons_per_fig,newSpkCH,leg_orientation_sort,MFR_sep_lineup_mean_leg_orientation,MFR_sep_lineup_leg_orientation,Fig_name_leg_orientation,leg_orientation_related_folder,orientation_lim,Rsq_orientation,p_orientation,cofficient_orientation,threshold_R)
Plot_angle_MFR(neurons_per_fig,newSpkCH,leg_length_sort,MFR_sep_lineup_mean_leg_length,MFR_sep_lineup_leg_length,Fig_name_leg_length,leg_length_related_folder,[75 200],Rsq_length,p_length,cofficient_length,threshold_R)

%}

%% plot table  single angle or multi angle plus
% ヒートマップ表示 particular p

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
heatmap_data = zeros(nNeurons, 3);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_multi_hip_knee_inter_cross(i)) > threshold_R &&  p_value_multi_hip_knee_inter_cross(i) < p_thresh
        if All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,3) = 3;  % 赤
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) > p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) > p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) < p_thresh
            heatmap_data(i,3) = 3;
        elseif All_neuron_pval_by_particular_R(i,1) < p_thresh && All_neuron_pval_by_particular_R(i,2) < p_thresh && All_neuron_pval_by_particular_R(i,3) > p_thresh
            if abs(cofficient_multi_hip_knee_inter_cross(i,2)) < abs(cofficient_multi_hip_knee_inter_cross(i,3))
                heatmap_data(i,2) = 2;
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2))>abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
                heatmap_data(i,1) = 1;
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
    1 0 0;   % 3 parameter p < 0.05
];

figure;
imagesc(heatmap_data);
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




% caluculate length

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
            if abs(cofficient_multi_hip_knee_inter_cross(i,2)) < abs(cofficient_multi_hip_knee_inter_cross(i,3))
                Knee_neuron_spk_ch = [Knee_neuron_spk_ch; newSpkCH(i,1)];  
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2)) > abs(cofficient_multi_hip_knee_inter_cross(i,3))
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
%{
end
end
%}
%% plot 3D
neurons_per_fig = 12;
label_cell_angle = {'Hip Angle [deg]', 'Knee Angle [deg]'};
label_cell_multi = {'Orientation [deg]', 'Length [deg]'};
both_angle_scotter_folder = createNamedFolder(angle_related_folder, 'Scottter_both_parameter');
both_angle_foldername = 'Hip_and_knee_angle';
multi_parameter_foldername = 'orientation_and_length';
plotBothJointAngleScatter(hip_joint_angle_ori, knee_joint_angle_ori, MFR_sep_pos, newSpkCH, neurons_per_fig, both_angle_scotter_folder, label_cell_angle,both_angle_foldername);
plotBothJointAngleScatter(Theta_hip_to_ankle_ori, Leg_length, MFR_sep_pos, newSpkCH, neurons_per_fig, both_angle_scotter_folder, label_cell_multi,multi_parameter_foldername);

%{
%% plot scatter


both_angle_related_folder = createNamedFolder(angle_related_folder, 'Both_angle_plot3');
for i = 1:1
    % データ準備
    hip_angle = hip_joint_angle_ori(:,1);       % (16x1)
    knee_angle = knee_joint_angle_ori(:,1);     % (16x1)
    firing_rate_mean = mean(MFR_sep_pos{1,i}, 1);  % (1x16) → (16x1)

    % 3次元散布図プロット
    figure;
    scatter3(hip_angle, knee_angle, firing_rate_mean(:), ...
             100, firing_rate_mean(:), 'filled');  % カラーバー付き

    colormap(jet);
    colorbar;
    xlabel('Hip Angle [deg]');
    ylabel('Knee Angle [deg]');
    zlabel('Mean Firing Rate [Hz]');
    title(['Neuron ', num2str(i), '  ', num2str(newSpkCH(i)), ' CH  not normalized']);
    grid on;
    view([-30 30]);  % 見やすい角度に調整（任意）

    % 軸の範囲やカラースケール調整
    max_val = max(firing_rate_mean);
    if max_val > 100
        zlim_fig = [0 120];
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
    caxis(zlim_fig);  % 色のスケーリングも一致させる

    % 見た目調整
    fontsize(gcf, 20, "points");
    set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

    % 保存
    %tifFileName = fullfile(both_angle_related_folder,['Neuron_' num2str(i) '_not_normalized_plot3.tif']);
    %print(gcf, tifFileName, '-dtiff', '-r300');
end




%% xy related value

coords_all_pos_endpoint;
coords_all_pos_endpoint_xz = [coords_all_pos_endpoint(:,1),coords_all_pos_endpoint(:,3)];
endpoint_x_center = mean(coords_all_pos_endpoint(:,1));
endpoint_z_center = mean(coords_all_pos_endpoint(:,3));
coords_all_pos_endpoint_xz_centered = [coords_all_pos_endpoint_xz(:,1)-endpoint_x_center,coords_all_pos_endpoint_xz(:,2)-endpoint_z_center];

x = coords_all_pos_endpoint_xz_centered(:,1);
y = coords_all_pos_endpoint_xz_centered(:,2);

% 相関係数と P値
[R, P] = corrcoef(x, y);
R_value = R(1,2);
P_value = P(1,2);

% 散布図の描画
figure;
scatter(x, y, 40, 'filled');
xlabel('X position');
ylabel('Z position');
title('Correlation between x and z');

% 相関係数と P 値の注釈を図中に追加
txt = sprintf('R = %.2f, p = %.2f', R_value, P_value);
text(mean(x), mean(y), txt, 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', 'w');

grid on;




x_and_y_pos_related_folder = createNamedFolder(x_and_y_pos_related_folder, 'x_y_position');
xpos_related_folder = createNamedFolder(x_and_y_pos_related_folder, 'x_position');
ypos_related_folder = createNamedFolder(x_and_y_pos_related_folder, 'y_position');
nNeurons = length(newSpkCH);
Rsq_x_pos = zeros(nNeurons, 1);    % 単関節モデルのR²
Rsq_y_pos = zeros(nNeurons, 1);

p_x_pos = zeros(nNeurons, 1);          % 股関節のp値
p_y_pos = zeros(nNeurons, 1);          % 膝関節のp値


cofficient_x_pos = zeros(nNeurons, 2); 
cofficient_y_pos = zeros(nNeurons, 2); 

%xpos and ypos
Rsq_multi_xy_pos_plus = zeros(nNeurons, 1);
p_multi_xy_pos_plus = zeros(nNeurons, 2);  % 各係数のp値（intercept除く）
cofficient_multi_xy_pos_plus = zeros(nNeurons, 3); 
%xpos and ypos cross
Rsq_multi_xy_pos_cross =  zeros(nNeurons, 1);
p_multi_xy_pos_cross = zeros(nNeurons, 3); % 各説明変数のp値（intercept除く）
cofficient_multi_xy_pos_cross = zeros(nNeurons, 4);  % [intercept, ori, len, ori*len]


%plus orientation and length
Rsq_multi_ori_len_inter_plus = zeros(nNeurons, 1);
p_multi_ori_len_inter_plus = zeros(nNeurons, 2);  % 各係数のp値（intercept除く）
cofficient_multi_ori_len_inter_plus = zeros(nNeurons, 3); % [intercept, ori, len, ori*len]



for i = 1:nNeurons
    rates_mat = MFR_sep_pos{i}';  % 5×16
    firing_vec = [];
    xpos_sort_for_analyze = [];
    ypos_sort_for_analyze = [];
    %orientation_sort_for_analyze = [];
    %length_sort_for_analyze = [];
    
    for trial = 1:size(rates_mat,2)
        firing_vec = [firing_vec; rates_mat(:,trial)];
        xpos_sort_for_analyze = [xpos_sort_for_analyze; coords_all_pos_endpoint_xz_centered(:,1)];
        ypos_sort_for_analyze = [ypos_sort_for_analyze; coords_all_pos_endpoint_xz_centered(:,2)];
        %orientation_sort_for_analyze = [orientation_sort_for_analyze; Theta_hip_to_ankle_ori(:,1)];
        %length_sort_for_analyze = [length_sort_for_analyze; Leg_length(:,1)];
    end

    % 単回帰 xpos
    xmodel = fitlm(xpos_sort_for_analyze, firing_vec);
    Rsq_x_pos(i) = xmodel.Rsquared.Adjusted;
    p_x_pos(i) = xmodel.Coefficients.pValue(2);  % 係数のp値
    cofficient_x_pos(i,1) = xmodel.Coefficients.Estimate(1);
    cofficient_x_pos(i,2) = xmodel.Coefficients.Estimate(2); 

    % 単回帰 ypos
    ymodel = fitlm(ypos_sort_for_analyze, firing_vec);
    Rsq_y_pos(i) = ymodel.Rsquared.Adjusted;
    p_y_pos(i) = ymodel.Coefficients.pValue(2);
    cofficient_y_pos(i,1) = ymodel.Coefficients.Estimate(1);
    cofficient_y_pos(i,2) = ymodel.Coefficients.Estimate(2); 
%{
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
%}

    
    % 交互作用項を含めnai 説明変数行列 hip angle and knee model plus
    XY_inter_angle_plus = [xpos_sort_for_analyze, ypos_sort_for_analyze];
    model_x_and_y = fitlm(XY_inter_angle_plus, firing_vec);
    Rsq_multi_xy_pos_plus(i) = model_x_and_y.Rsquared.Adjusted;
    p_multi_xy_pos_plus(i, :) = model_x_and_y.Coefficients.pValue(2:3)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_xy_pos_plus(i, :) = model_x_and_y.Coefficients.Estimate';  


    % 交互作用項を含めnai 説明変数行列 hip angle and knee model plus
    XY_inter_angle_cross = [xpos_sort_for_analyze, ypos_sort_for_analyze, xpos_sort_for_analyze.*ypos_sort_for_analyze];
    model_x_and_y_cross = fitlm(XY_inter_angle_cross, firing_vec);
    Rsq_multi_xy_pos_cross(i) = model_x_and_y_cross.Rsquared.Adjusted;
    p_multi_xy_pos_cross(i, :) = model_x_and_y_cross.Coefficients.pValue(2:4)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_xy_pos_cross(i, :) = model_x_and_y_cross.Coefficients.Estimate';  

     % 交互作用項を含めた説明変数行列 orientation angle and length model cross
    ori = orientation_sort_for_analyze;
    len = length_sort_for_analyze;
    %interaction = ori .* len;
    X_inter = [ori, len];
    mdl_inter = fitlm(X_inter, firing_vec);
    Rsq_multi_ori_len_inter_plus(i) = mdl_inter.Rsquared.Adjusted;
    p_multi_ori_len_inter_plus(i, :) = mdl_inter.Coefficients.pValue(2:3)';  % 各説明変数のp値（intercept除く）
    cofficient_multi_ori_len_inter_plus(i, :) = mdl_inter.Coefficients.Estimate';  % [intercept, ori, len, ori*len]
    
end




%% 結果の確認例（有意なものだけを抽出）
Rsq_good_x = find(Rsq_x_pos > threshold_R);
Rsq_good_y = find(Rsq_y_pos > threshold_R);
Rsq_good_xy = find(Rsq_multi_xy_pos_plus > threshold_R );
Rsq_good_xy_cross = find(Rsq_multi_xy_pos_cross > threshold_R );
Rsq_good_ori_and_length = find(Rsq_multi_ori_len_inter_plus > threshold_R);
%% 
pos_num_length = 1:1:16;
xpos_sort = sortrows([x,pos_num_length'], 1);
ypos_sort = sortrows([y,pos_num_length'], 1);
[MFR_sep_lineup_xpos,MFR_sep_lineup_mean_xpos,MFR_sep_lineup_z_xpos,MFR_sep_lineup_z_mean_xpos] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,xpos_sort(:,2)');
[MFR_sep_lineup_ypos,MFR_sep_lineup_mean_ypos,MFR_sep_lineup_z_ypos,MFR_sep_lineup_z_mean_ypos] = lineup_position_firingrate(MFR_sep_pos, MFR_sep_zscore_pos,ypos_sort(:,2)');


Fig_name_ypos = 'Y position firingrate not normalized';
Fig_name_xpos = 'X position firingrate not normalized';
Plot_angle_MFR(neurons_per_fig,newSpkCH,xpos_sort,MFR_sep_lineup_mean_xpos,MFR_sep_lineup_xpos,Fig_name_xpos,xpos_related_folder,[-100 90],Rsq_x_pos,p_x_pos,cofficient_x_pos,threshold_R)

Plot_angle_MFR(neurons_per_fig,newSpkCH,ypos_sort,MFR_sep_lineup_mean_ypos,MFR_sep_lineup_ypos,Fig_name_ypos,ypos_related_folder,[-90 70],Rsq_y_pos,p_y_pos,cofficient_y_pos,threshold_R)

%% 
label_cell_xypos = {'X position [mm]', 'Y position [mm]'};
both_angle_scotter_folder = createNamedFolder(angle_related_folder, 'Scottter_both_parameter');
xy_position_foldername = 'x_y_position';
plotBothJointAngleScatter(x, y, MFR_sep_pos, newSpkCH, neurons_per_fig, both_angle_scotter_folder, label_cell_xypos,xy_position_foldername);

%% cross
% 3列分のマトリクス作成（1:Hip, 2:Knee, 3:End）
heatmap_data = zeros(nNeurons, 6);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_single_hip(i)) > threshold_R && p_joint_hip(i) < p_thresh
        if cofficient_hip(i,2) > 0
            heatmap_data(i,1) = 1;  % 赤
        else
            heatmap_data(i,1) = -1; % 青
        end
    end

    % Knee
    if abs(Rsq_single_knee(i)) > threshold_R && p_joint_knee(i) < p_thresh
        if cofficient_knee(i,2) > 0
            heatmap_data(i,2) = 1;
        else
            heatmap_data(i,2) = -1;
        end
    end
    
    % orientation
    if abs(Rsq_x_pos(i)) > threshold_R && p_x_pos(i) < p_thresh
        if cofficient_x_pos(i,2) > 0
            heatmap_data(i,3) = 1;
        else
            heatmap_data(i,3) = -1;
        end
    end

     % length
    if abs(Rsq_y_pos(i)) > threshold_R && p_y_pos(i) < p_thresh
        if cofficient_y_pos(i,2) > 0
            heatmap_data(i,4) = 1;
        else
            heatmap_data(i,4) = -1;
        end
    end

    % orientation
    if abs(Rsq_orientation(i)) > threshold_R && p_orientation(i) < p_thresh
        if cofficient_orientation(i,2) > 0
            heatmap_data(i,5) = 1;
        else
            heatmap_data(i,5) = -1;
        end
    end

     % length
    if abs(Rsq_length(i)) > threshold_R && p_length(i) < p_thresh
        if cofficient_length(i,2) > 0
            heatmap_data(i,6) = 1;
        else
            heatmap_data(i,6) = -1;
        end
    end

end
    


% --- カラーマップ: -1=青, 0=白, 1=赤, 2=緑 ---
cmap = [
    0 0 0
    0 0 1;   % -1: 青
    1 1 1;   %  0: 白
    1 0 0;   %  1: 赤
];

% ヒートマップ表示
figure;
imagesc(heatmap_data);
colormap(cmap);
caxis([-2 1]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:6);
%xticklabels({'Hip', 'Knee', 'orientation', 'length','Hip and knee plus','Hip and knee cross','orientation and length plus','orientation and length cross'});
xticklabels({'Hip', 'Knee','X Position','Y Position','Orientation','Length'});
ax.Layer = 'top';
ax.LineWidth = 1.5;

% 標準グリッド無効化
ax.XGrid = 'off';
ax.YGrid = 'off';

% --- 手動グリッド線（Y方向：1.5, 2.5, 3.5, ...） ---
hold on;

% 対象列のインデックスと名前
col_labels = {'Hip', 'Knee','X Position','Y Position','Orientation','Length'};
col_indices = [1, 2, 3, 4, 5, 6];  % heatmap_dataの対応列
text_y = 0.5;  % 上に少し表示するためのY位置

for col = 1:length(col_indices)
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
colorbar('Ticks',[-1 0 1 ], ...
         'TickLabels', {'Negative', 'None', 'Positive'}, 'FontSize', 18);
title(['Correlation Significance Heatmap'],['Threshold R^2 > ' num2str(threshold_R) ' and p < ' num2str(p_thresh)],'FontSize', 18);
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存
tifFileName = fullfile(threshold_folder, ...
    'Neuron_modulation_by_joint_position_2linkparam.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

heatmap_data = zeros(nNeurons, 6);

% 条件を満たすところを +1 (赤) または -1 (青)、Endは 2 (緑)
for i = 1:nNeurons
    % Hip
    if abs(Rsq_single_hip(i)) > threshold_R && p_joint_hip(i) < p_thresh
        if cofficient_hip(i,2) > 0
            heatmap_data(i,1) = 1;  % 赤
        else
            heatmap_data(i,1) = -1; % 青
        end
    end

    % Knee
    if abs(Rsq_single_knee(i)) > threshold_R && p_joint_knee(i) < p_thresh
        if cofficient_knee(i,2) > 0
            heatmap_data(i,4) = 1;
        else
            heatmap_data(i,4) = -1;
        end
    end
    
    % xposition
    if abs(Rsq_x_pos(i)) > threshold_R && p_x_pos(i) < p_thresh
        if cofficient_x_pos(i,2) > 0
            heatmap_data(i,2) = 1;
        else
            heatmap_data(i,2) = -1;
        end
    end

     % yposition
    if abs(Rsq_y_pos(i)) > threshold_R && p_y_pos(i) < p_thresh
        if cofficient_y_pos(i,2) > 0
            heatmap_data(i,5) = 1;
        else
            heatmap_data(i,5) = -1;
        end
    end

    % orientation
    if abs(Rsq_orientation(i)) > threshold_R && p_orientation(i) < p_thresh
        if cofficient_orientation(i,2) > 0
            heatmap_data(i,3) = 1;
        else
            heatmap_data(i,3) = -1;
        end
    end

     % length
    if abs(Rsq_length(i)) > threshold_R && p_length(i) < p_thresh
        if cofficient_length(i,2) > 0
            heatmap_data(i,6) = 1;
        else
            heatmap_data(i,6) = -1;
        end
    end

end
    


% --- カラーマップ: -1=青, 0=白, 1=赤, 2=緑 ---
cmap = [
    0 0 0
    0 0 1;   % -1: 青
    1 1 1;   %  0: 白
    1 0 0;   %  1: 赤
];

% ヒートマップ表示
figure;
imagesc(heatmap_data);
colormap(cmap);
caxis([-2 1]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:6);
%xticklabels({'Hip', 'Knee', 'orientation', 'length','Hip and knee plus','Hip and knee cross','orientation and length plus','orientation and length cross'});
xticklabels({'Hip','X Position','Orientation', 'Knee','Y Position','Length'});
ax.Layer = 'top';
ax.LineWidth = 1.5;

% 標準グリッド無効化
ax.XGrid = 'off';
ax.YGrid = 'off';

% --- 手動グリッド線（Y方向：1.5, 2.5, 3.5, ...） ---
hold on;

% 対象列のインデックスと名前
col_labels = {'Hip','X Position','Orientation', 'Knee','Y Position','Length'};
col_indices = [1, 2, 3, 4, 5, 6];  % heatmap_dataの対応列
text_y = 0.5;  % 上に少し表示するためのY位置

for col = 1:length(col_indices)
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
colorbar('Ticks',[-1 0 1 ], ...
         'TickLabels', {'Negative', 'None', 'Positive'}, 'FontSize', 18);
title(['Correlation Significance Heatmap'],['Threshold R^2 > ' num2str(threshold_R) ' and p < ' num2str(p_thresh)],'FontSize', 18);
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存
tifFileName = fullfile(threshold_folder, ...
    'Neuron_modulation_by_joint_position_2linkparam_lineup.tif');
print(gcf, tifFileName, '-dtiff', '-r300');
%}

%% calculat slope for joint related neuron----------------------------------------------------------------------------
angle_sensitivity_folder_cross_particular_p = createNamedFolder(hip_and_knee_folder_cross_particular_p, 'angle_sensitivity');
angle_sensitivity_folder_cross_particular_p_neuron = createNamedFolder(angle_sensitivity_folder_cross_particular_p, 'Each_neuron');
coef = cofficient_multi_hip_knee_inter_cross;
hip  = hip_joint_angle_ori(:,1);
knee = knee_joint_angle_ori(:,1);

nNeuron  = size(coef,1);
nPosture = length(hip);


% set parameter
Excluding_joint_relted_neuron_for_endpoint_neuron = 'No';
%Excluding_joint_relted_neuron_for_endpoint_neuron = 'Yes';

threshold_R = 0.4;
p_thresh = 0.001;
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
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2))>abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
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

for t = 1:3
    idx = type_i_all == t;
    scatter_handles(t) = scatter(Hip_dir(idx), Knee_dir(idx), 50, cmap_joint(t,:), 'filled');
end

xlim([-0.05 1.05])
ylim([-0.05 1.05])
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
legend(scatter_handles, {'Hip','Knee','Hip and Knee'}, 'Location','northeast', 'FontSize',12);


% ===== PNG保存 =====
fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
                     'Hip_knee_sensitivity_direction_scatter_only_phase1_CatA.png');
exportgraphics(gcf, fname, 'Resolution',300);

close;  % 図を閉じる


%% calculat slope for joint related neuron----------------------------------------------------------------------------
cofficient_multi_hip_knee_inter_plus;

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
    0   1   0;     % 2 only knee
    1   0   0;     % 3 all / strong
];
%


figure('Color','w'); hold on
axis equal
box on

for i = 1:length(cofficient_multi_hip_knee_inter_plus)
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

for i = 1:length(cofficient_multi_hip_knee_inter_plus)
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
title('Cat B','FontName','Arial','FontWeight','bold','FontSize',12)

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

title('Cat B','FontName','Arial','FontWeight','bold','FontSize',12)

cb = colorbar;
cb.Layout.Tile = 'east';

% ===== EMF保存 =====
set(gcf,'Renderer','painters');   % ベクター形式

fname = fullfile(angle_sensitivity_folder_cross_particular_p, ...
    'Hip_Knee_direction_and_magnitude_CatB.emf');

exportgraphics(gcf,fname,'Resolution',600);



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

%% zscore
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
 
% カラーマップを用意
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
%% check contract analysis
MFR_sep_pos;
experiment3_multcomparefolder = createNamedFolder(experiment3_static_folder_select, 'Multcompare');
Multcompare_p_map_all_neuron = cell(length(newSpkCH),1);
for neuron =1:136
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

%% -----------------------------
Multcompare_p_map_all_neuron;
numNeurons = numel(Multcompare_p_map_all_neuron);   % = 72
numPosture = 16;                  % 姿勢の数
plotsPerPage = 12;                % 1ページあたりのニューロン数
rows = 3; 
cols = 4;

for nBlock = 1:ceil(numNeurons/plotsPerPage)
    figure;
    tiledlayout(rows, cols, "TileSpacing","compact","Padding","compact");

    % 今のブロックで処理するニューロン番号
    neuronRange = (nBlock-1)*plotsPerPage + 1 : min(nBlock*plotsPerPage, numNeurons);

    for i = 1:numel(neuronRange)
        n = neuronRange(i);

        binMat = Multcompare_p_map_all_neuron{n};
        if isempty(binMat)
            continue;
        end

        % 各姿勢について有意差 (1) の回数をカウント
        counts = sum(binMat==1,1);

        % 正規化（最大値を1にスケーリング）
        if max(counts) > 0
            normalized_counts = counts / (numPosture-1);
        else
            normalized_counts = counts;
        end

        % サブプロットに描画
        nexttile;
        bar(1:numPosture, normalized_counts, 'FaceColor',[0.3 0.7 0.3]);
        ylim([0 1]);
        xlabel('Posture');
        ylabel('Norm count');
        title(sprintf('Neuron %d', n));
        set(gca,'FontSize',10);
    end

    % ページ全体のタイトル
    sgtitle(sprintf('Neurons %d–%d', neuronRange(1), neuronRange(end)), 'FontSize',14);
end
%% 
Multcompare_p_map_all_neuron;
numNeurons = numel(Multcompare_p_map_all_neuron);   % = 72
numPosture = 16;                  
plotsPerPage = 12;                
rows = 3; 
cols = 4;
experiment3_multcompare_all_neuron_folder = createNamedFolder(experiment3_multcomparefolder, 'Number_of_Significant_Neurons');

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
    tifFileName = fullfile(experiment3_multcompare_all_neuron_folder, sprintf('Significant_neuron_all_page_%d.tif', nBlock));
    print(fig, tifFileName, '-dtiff', '-r300');

    % 図を閉じる（現在の図のみ）
    close(fig);
end

% 結果の確認（表示・ファイル出力）
disp('StrongNeuronMatrix (Flag(4/0), ConditionID):');
disp(StrongNeuronMatrix);



%% plot bar
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
figure;
bar(1:16, counts);
xlabel('値 (1〜16)');
ylabel('出現回数');


%% Figure 4S
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



neuron_pair = [];   
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
    axis equal
    axis square
    pbaspect([1 1 1])

   
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

    xlim([60 110])
    ylim([40 140])
    ax = gca;
    ax.XTick = 60:20:100;  % X軸 60, 70, 80, 90, 100
    ax.YTick = 20:20:120;  % Y軸 30, 40, ..., 130

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
    elseif range_max >= 40
        tick_step = 10;
    elseif range_max >= 20
        tick_step = 5;
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
    title(sprintf('Cat B Neuron #%d', neuron_idx), ...
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
            if j == 2
                text(X(j)+4, Y(j) + 4, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
             elseif j == 5
                text(X(j), Y(j) + 5.5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
            elseif j == 6
                text(X(j)+1, Y(j) + 5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
             elseif j == 10
                text(X(j)-0.5, Y(j) - 5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
            elseif j == 11
                text(X(j)+2, Y(j) - 5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
            elseif j == 14
                text(X(j)-1.5, Y(j) -5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
            elseif j == 15
                text(X(j), Y(j) + 5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
                'Color', txtColor);
            else
            text(X(j), Y(j) - 5, ...
                ['Pos-', num2str(j)], ...
                'FontWeight', 'bold',...
                'FontSize', 4, ...
                'HorizontalAlignment', 'center', ...
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
    'FR_Map_CatB_single_endpoint_neuron_FigureS4.emf'), ...
    '-dmeta', '-r600');


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



figure;
colors = jet(16);  % 姿勢ごとの色

% 3D散布図
scatter3(score(:,1), score(:,2), score(:,3), ...
    100, colors(1:16,:), 'filled');
grid on;
axis equal;
xlabel(['PC1 (' num2str(explained(1), '%.1f') '%)']);
ylabel(['PC2 (' num2str(explained(2), '%.1f') '%)']);
zlabel(['PC3 (' num2str(explained(3), '%.1f') '%)']);
title('3D PCA: PC1 vs PC2 vs PC3');
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
colors = [0 0.6 0; 0 0 1; 1 0 0];

% 各PCのプロット
for pc = 1:3
    polarplot(pax, theta_loop, r_plot_all_loop(:, pc), '-o', ...
              'LineWidth', 2, ...
              'Color', colors(pc, :), ...
              'MarkerFaceColor', colors(pc, :), ...
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

%% === 面積を1に正規化 ===
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

colors = [0 0.6 0; 0 0 1; 1 0 0]; % PC1緑, PC2青, PC3赤

for pc = 1:3
    polarplot(pax, theta_loop, r_plot_all_norm(:, pc), '-o', ...
              'LineWidth', 2, ...
              'Color', colors(pc, :), ...
              'MarkerFaceColor', colors(pc, :), ...
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




%% plot fig for analysis
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

set(gca, 'FontSize', 15,'FontName', 'Arial', 'FontWeight', 'bold');
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
    'PCA_bar_plot_for_fig_Cat B.pdf');
print(fig, pdfFileName, '-dpdf');
%}


%% polar plot new version
% ---- プロット開始 ----
figure;
pax = polaraxes;
hold(pax, 'on');

% グリッド非表示調整
pax.ThetaTick = [];
rmax = max(r_plot_all_loop(:)) * 1.1;
r_ticks = 0:1:ceil(rmax);
pax.RLim = [0 7];
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
    polarplot(pax, [theta(i) theta(i)], [0 rmax+1], '-', ...
              'Color', [0.85 0.85 0.85], 'LineWidth', 1);
end

% ---- 特定の円を強調 ----
rlim_vals = [4, 7]; % 強調したい半径
theta_dense = linspace(0, 2*pi, 400);

for rv = rlim_vals
    r_circle = rv * ones(size(theta_dense));
    if rv == 4
        polarplot(pax, theta_dense, r_circle, ...
                  'Color', [0.4 0.4 0.4], 'LineWidth', 1.5); % 濃いグレー
    elseif rv == 7
        polarplot(pax, theta_dense, r_circle, ...
                  'k', 'LineWidth', 2); % 黒
    end
end


% ---- プロット設定 ----



% PCごとの色とマーカー
colors = [0.0 0.75 0.75;   % PC1 濃いグレー
          0.6 0.3 0.0;   % PC2 茶色
          0.49 0.18 0.56]; % PC3 紫
markers = {'o','s','^'};   % 丸, 四角, 三角

for pc = 1:3
    polarplot(pax, theta_loop, r_plot_all_loop(:, pc), '-', ...
              'LineWidth', 2, ...
              'Color', colors(pc, :), ...
              'Marker', markers{pc}, ...
              'MarkerFaceColor', colors(pc, :), ...
              'MarkerSize', 4);
end

% ---- 中心に黒い点 ----
polarplot(pax, 0, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);

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
    'PCA_plor_plot_for_fig_CAT B.pdf');
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

TopNeurons_by80 = cell(nPC,1); % 80%までのニューロン番号
TopWeights_by80 = cell(nPC,1); % 80%まで再正規化した寄与度
All_neuron_weight = cell(nPC,1); % all neuron再正規化した寄与度

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
    TopNeurons_by80{i} = top_idx;
    TopWeights_by80{i} = top_weights_norm;
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
for i = 1:nPC
    fprintf('PC%d: 80%%までのニューロン番号 = %s\n', pcs(i), mat2str(TopNeurons_by80{i}));
    fprintf('      再正規化した寄与度 = %s\n', mat2str(TopWeights_by80{i},3));
end

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(PCA_Loading_folder_select, 'Laoding_normalized_value');
print(gcf, tifFileName, '-dtiff', '-r300');


end
%}

%% -----------------------------------------------------------------------------------------------------------------------------
% set parameter
Excluding_joint_relted_neuron_for_endpoint_neuron = 'No';
%Excluding_joint_relted_neuron_for_endpoint_neuron = 'Yes';

threshold_R = 0.4;
p_thresh = 0.001;
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
            elseif abs(cofficient_multi_hip_knee_inter_cross(i,2))>abs(cofficient_multi_hip_knee_inter_cross(i,3))
                
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

%PC_select = 1;
%Neuron_label = particular_R_angle_related_neuron(TopNeurons_by80{PC_select},1);


figure;
hold on;
tiledlayout(1,3,"TileSpacing","compact","Padding","compact");
PC_element_percent = zeros(max(desired_order)+1,3);
for selectPC = 1:3
    labels = particular_R_angle_related_neuron;

    % --- group_sums を全ラベル(0～4)で計算 ---
    group_sums_all = zeros(max(desired_order)+1,1);
    for lbl = 0:max(desired_order)
        disp(lbl)
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
%sgtitle(sprintf('Neuron weight distribution (R > %.2f, p < %.3f %.plotBothJointAngleScatter_specific_neuron2fSD)', threshold_R, p_thresh,SD_value));
sgtitle(sprintf('Neuron weight distribution (R > %.2f, p < %.3f) %s', threshold_R, p_thresh,include_specifc_parameter));
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存
% ファイル名に条件を反映（ドット無し）
%tifFileName = fullfile(PCA_Loading_folder_select, ...
 %   sprintf('PCA_loading_analysis_results_R%s_p%s_%sSD.tif', threshold_R_str, p_thresh_str,SD_value));
tifFileName = fullfile(PCA_Loading_folder_select, sprintf('PCA_loading_analysis_results_R%s_p%s_%s.tif', threshold_R_str, p_thresh_str,include_specifc_parameter));
print(gcf, tifFileName, '-dtiff', '-r300');
hold off;

%% Figure 9: PCA 3D Scatter Plot (Refined for Reviewer)
% ========================================================
% 姿勢グループの定義（ソート順に基づいて4つずつ割り当て）
% ========================================================
az_angle = 50;   % 水平回転
el_angle = 30;   % ← 低くする（5〜15がおすすめ）

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
panel_labels = {'Cat B', 'Cat B'};

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
         if j==10 || j == 3 || j== 8 || j == 12 
            text(score(j,1)-0.22, score(j,2)-0.26, score(j,3)-0.15, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         elseif j == 1 || j == 2
             text(score(j,1)-0.16, score(j,2)-0.16, score(j,3)-0.15, ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');

         elseif j == 14 || j == 11
             text(score(j,1)-0.5, score(j,2)-0.5, score(j,3), ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         elseif j == 6
             text(score(j,1)-0.25, score(j,2)+0.07, score(j,3), ['  P' num2str(j)], ...
            'FontSize', 8, ...
            'FontWeight', 'bold', ...
            'Color', [0.4 0.4 0.4], ...   % ← 追加
            'Clipping', 'off');
         else
             text(score(j,1)-0.2, score(j,2)+0.1, score(j,3), ['  P' num2str(j)], ...
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
    ax.XAxis.Label.Rotation = -40;  % 数値調整
    ax.YAxis.Label.Rotation = 30;
    ax.FontName = 'Arial';   % ← 追加
    zlim([-1.25 1.25])
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
export_path = fullfile(PCA_folder, 'Figure9_PCA_AnkleSideBySide_CatB.emf');
set(fig, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 17 10]);
print(fig, export_path, '-dmeta', '-r600');


%% Figure 10
% plot PCA results main figures
figure;

% === カラー定義 ===
desired_order = [2 1 3 4 0];  % 好きな順番
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

    if percent_val == 0
        texts(k).String = '';
    else
        texts(k).String = sprintf('%.1f%%', percent_val);
    end

    % Ajast position
    if selectPC == 1
        r_adjust = [0.4 0.7 0.3 0.3 0.8];   % 各kごとの半径
        angle_adjust = [-deg2rad(10) deg2rad(17.5) deg2rad(10) deg2rad(15) 0];   % 各kごとの角度
    elseif selectPC == 2
        r_adjust = [0.4 0.5 0.5 0.6 0.35];   % 各kごとの半径
        angle_adjust = [-deg2rad(10) deg2rad(10) -deg2rad(10) deg2rad(3) -deg2rad(5)];   % 各kごとの角度
    else
        r_adjust = [0.3 0.35 0.4 0.5 0.8];   % 各kごとの半径
        angle_adjust = [-deg2rad(15) deg2rad(5) deg2rad(10) deg2rad(10) -deg2rad(5)];   % 各kごとの角度
    end

    % if stationary period is different
    if strcmp(static_calculation, 'Defined')
            if str_sep_dynamic_static == 5

            elseif str_sep_dynamic_static == 10
            if selectPC == 1
                r_adjust = [0.4 0.7 0.3 0.3 0.8];   % 各kごとの半径
                angle_adjust = [-deg2rad(10) deg2rad(1.5) deg2rad(10) deg2rad(15) 0];   % 各kごとの角度
            elseif selectPC == 2
                r_adjust = [0.4 0.5 0.5 0.6 0.35];   % 各kごとの半径
                angle_adjust = [-deg2rad(10) deg2rad(10) -deg2rad(10) deg2rad(3) -deg2rad(5)];   % 各kごとの角度
            else
                r_adjust = [0.3 0.35 0.4 0.5 0.8];   % 各kごとの半径
                angle_adjust = [-deg2rad(15) deg2rad(5) deg2rad(10) deg2rad(10) -deg2rad(5)];   % 各kごとの角度
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
sg = sgtitle('Cat B', ...
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
    sprintf('CatB_PCA_loading_analysis_results_R%s_p%s_%s', ...
    threshold_R_str, p_thresh_str, include_specifc_parameter));

% ===== 高解像度PNG（600dpi推奨）=====
print(gcf, [baseFileName '.png'], '-dpng', '-r600');

% ===== ベクターEMF保存 =====
print(gcf, [baseFileName '.emf'], '-dmeta');





%% plot mean firing rate each lavel
% plot 3D hip and knee
both_angle_foldername = 'Hip_and_knee_angle';
plotBothJointAngleScatter_neuron_type(hip_knee_joint_angle_orignal(:,1), hip_knee_joint_angle_orignal(:,2), MFR_sep_pos, newSpkCH, neurons_per_fig, both_angle_scotter_folder, label_cell_angle,particular_R_angle_related_neuron,both_angle_foldername);


%% plot only specific endpoint neuron
both_angle_scotter_folder = createNamedFolder(experiment3_multcomparefolder, 'Scottter_only_specific_neuron');
plotBothJointAngleScatter_specific_neuron(hip_knee_joint_angle_orignal(:,1), hip_knee_joint_angle_orignal(:,2), MFR_sep_pos, newSpkCH, 6, both_angle_scotter_folder, label_cell_angle,particular_R_angle_related_neuron,StrongNeuronMatrix,both_angle_foldername);


%% 
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);

% 点数（＝16と仮定）
nPoints = length(X);

% カラーマップ（jetの16色）
cmap = colors;
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);

figure;
hold on;

for i = 1:nPoints
    % マーカーサイズをさらに大きく（例: 150）
    scatter(X(i), Y(i), 150, cmap(i,:), 'filled');
   if i == 7 || i == 11 
       text(X(i), Y(i) - 2.5, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   elseif i == 14
       text(X(i)-1, Y(i) - 2.5, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   else
    % ラベルをY方向に少し上にずらして表示
    text(X(i), Y(i) + 2.5, sprintf('Pos%d', i), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', cmap(i,:));              % 点と同じ色で文字を表示
   end
end

xlabel('Hip joint angle [degree]', 'FontSize', 12);
ylabel('Knee joint angle [degree]', 'FontSize', 12);



ax = gca;  % 現在の軸を取得
ax.FontSize = 20;       % 目盛りの文字サイズを大きく
ax.FontWeight = 'bold'; % 目盛りの文字を太字に

grid on;
xlim([60 100])
ylim([30 130])
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
tifFileName = fullfile(experiment3_folder, 'Recorded_angle.tif');
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
    baseName = fullfile(experiment3_folder, ...
        'Recorded_angle_CatB');

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');


%% plot multicompare pattern
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);
cmap = colors;


% --- データ ---
X = hip_knee_joint_angle_orignal(:,1);
Y = hip_knee_joint_angle_orignal(:,2);

% 点数（＝姿勢数）
nPoints = length(X);
idx_4_specific = find(StrongNeuronMatrix(:,1) == 4);
neunum_1_specific_neuron_pos = StrongNeuronMatrix(idx_4_specific,2);
% --- カラーマップを jet の16分割に変更 ---
fullJet = turbo(256);               % Jetを細かく定義
idx = round(linspace(1, 256, 16)); % 256色から16色を等間隔に抽出
colors = fullJet(idx, :);
cmap = colors;

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
        labelText = sprintf('Pos-%d (%d/%d)', i, counts(i),length(neunum_1_specific_neuron_pos));
        Shift_value_in_fig  = 5;
    else
        labelText = sprintf('Pos-%d', i);
        Shift_value_in_fig  = 3;
    end

    if i == 2
       text(X(i)+1.5, Y(i) + Shift_value_in_fig, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
    elseif i == 7
       text(X(i), Y(i) - Shift_value_in_fig, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
    elseif i == 11
       text(X(i)+1.5, Y(i) - Shift_value_in_fig, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示  
   elseif i == 14
       text(X(i)-1, Y(i) - Shift_value_in_fig, labelText, ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 25, ...               % 文字サイズを大きく
        'FontWeight', 'bold', ...         % 太字にする場合
        'FontName', 'Arial', ...          % フォント指定（例：Arial）
        'Color', colors(i,:));              % 点と同じ色で文字を表示
   elseif i == 16
       text(X(i)+1.5, Y(i) + Shift_value_in_fig, labelText, ...
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

xlim([60 100])
ylim([30 130])
if strcmp(angle_definition, 'relative_normalized_centering_knee_compensation')
    xlim([60 110])
    ylim([50 140])
end
xlabel('Hip joint angle [degree]', 'FontSize', 12);
ylabel('Knee joint angle [degree]', 'FontSize', 12);


ax = gca;
ax.FontWeight = 'bold';
ax.FontSize   = 20;
ax.FontName   = 'Arial';
ax.XTickLabelRotation = 0;

ax.Units = 'normalized';
ax.Position = [0.15 0.15 0.7 0.7];
grid on;

% ===== 主目盛り（10刻み）=====
ax.XTick = 60:10:100;
ax.YTick = 30:10:130;

% ===== 補助目盛り（5刻み）=====
ax.XMinorTick = 'off';
ax.YMinorTick = 'on';

ax.YAxis.MinorTickValues = 30:5:130;

% ===== 軸スタイル =====
ax.TickDir   = 'out';          % メモリを外向き
ax.TickLength = [0.02 0.01];   % [主 小]
ax.LineWidth = 2;

box off
grid on



set(gcf, 'Units', 'pixels', 'Position', [100 100 1000 1000]);


tifFileName = fullfile(experiment3_multcomparefolder, 'Recorded_angle_and_specific_neuron_CatB.tif');
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
        'Recorded_angle_and_specific_neuron_CatB');

    print(gcf, [baseName '.pdf'], '-dpdf', '-painters');
    print(gcf, [baseName '.png'], '-dpng', '-r300');


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
b(5).FaceColor = [0.6 0.6 0.6];   % Nomodulation

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
colors = [
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
    bar_handle.CData(k,:) = colors(k,:);
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
%% Loading Analysis
%{
PCA_Loading_folder = createNamedFolder(PCA_folder, 'Loading_analysis');
PCA_angle_folder = createNamedFolder(PCA_Loading_folder, angle_definition);

topK = 10;
numPCs = 3;
Loading_condition_name = sprintf('PC1to%d_top%d_neuron', numPCs, topK);

Loading_condition_folder = createNamedFolder(PCA_angle_folder,Loading_condition_name );

num_neurons_total = length(newSpkCH);  % 例: 72
num_neurons = length(newSpkTime);  % 総ニューロン数

contributed_neurons  = zeros(topK, numPCs);
contributed_neurons_original_all = zeros(topK, numPCs);

figure;
for PC = 1:numPCs
    abs_loading = abs(coeff(:, PC));  % 除外後のローディング値
    abs_loading_full = NaN(num_neurons_total, 1);  % フルサイズ（削除ニューロンはNaN）
    abs_loading_full(include_idx) = abs_loading;  % 含めたニューロンのみ値を代入

    % 上位インデックス（除外後）を取得
    withIdx = [(1:length(abs_loading))', abs_loading];
    sorted = sortrows(withIdx, -2);
    topIdx = sorted(1:topK, 1);  % 除外後のインデックス

    % 元インデックスに変換
    topIdx_original = include_idx(topIdx);
    contributed_neurons(:, PC) = topIdx;
    contributed_neurons_original_all(:, PC) = topIdx_original;

    % カラーマップ作成（すべて青系）
    barColors = repmat([0.2 0.6 0.8], num_neurons_total, 1);
    barColors(topIdx_original, :) = repmat([1 0 0], topK, 1);  % 上位だけ赤

    % サブプロット
    subplot(2, 2, PC);
    b = bar(abs_loading_full, 'FaceColor', 'flat');
    b.CData = barColors;
    hold on;

    % 上位の棒に元番号ラベル
    for i = 1:topK
        idx_orig = topIdx_original(i);
        val = abs_loading_full(idx_orig);
        if ~isnan(val)
            if ismember(idx_orig, exclude_idx)
                text_color = 'b';  % 除外されたが上位に入った → 青
            else
                text_color = 'k';  % 通常
            end
            text(idx_orig, val * 1.05, ...
                num2str(idx_orig), ...
                'HorizontalAlignment', 'center', ...
                'Color', text_color, ...
                'FontSize', 14, 'FontWeight', 'bold');
        end
    end


    xlabel('Neuron Index (Original)');
    ylabel('Loading (abs)');
    title(['Principal Component ', num2str(PC)]);
    ylim([0, 0.7]);
end

fontsize(gcf, 18, 'points');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

if ~isempty(exclude_idx)
    % 数字をカンマ区切りで文字列に
    removed_str = sprintf('%d, ', exclude_idx);
    removed_str = removed_str(1:end-2);  % 最後のカンマ削除
    superTitleStr = sprintf('Removed neuron(s): %s', removed_str);
    sgtitle({superTitleStr; ''}, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'b');
else
    sgtitle('', 'FontSize', 16);  % 空欄でもOK
end

tifFileName = fullfile(Loading_condition_folder, sprintf('Loading_pc1_to_pc3_%dneuron_all72.tif', topK));
print(gcf, tifFileName, '-dtiff', '-r300');




% マップ初期化（0: 非貢献, 1〜topK: 順位）
nNeurons = length(newSpkCH);
neuron_map = zeros(num_neurons, numPCs);
neuron_map(exclude_idx, :) = -1;
% 順位に応じて値を格納（1=1位, 2=2位, ..., 5=5位）
for pc = 1:numPCs
    for rank = 1:topK
        neuron_idx = contributed_neurons_original_all(rank, pc);
        neuron_map(neuron_idx, pc) = topK - rank + 1;  % 値は 5→1（1位ほど大きく）
    end
end

% 非貢献ニューロン用の白を最初に追加
cmap = [0 0 0 ;
    1.0 1.0 1.0];  % 0番目（非貢献）→白

% 1〜topK番目（赤→オレンジへ）のカラー生成
reds = [linspace(1, 1, topK)', linspace(0, 0.6, topK)', zeros(topK,1)];
% これで [1 0 0] → [1 0.6 0] の赤〜オレンジ色グラデーション

% cmap に結合
cmap = [cmap; reds];  % 最終サイズ: (topK+1) x 3

% ヒートマップ表示
figure;
imagesc(neuron_map);
colormap(cmap);
caxis([-1 topK]);

% 軸設定
ax = gca;
set(ax, 'YDir', 'normal');
yticks(1:nNeurons);
yticklabels(1:nNeurons);
xticks(1:3);
xticklabels({'PC1','PC2','PC3'});
ax.Layer = 'top';
ax.LineWidth = 1.5;
% 標準グリッド無効化
ax.XGrid = 'off';
ax.YGrid = 'off';
hold on;
% 対象列のインデックスと名前
col_labels = {'PC1','PC2','PC3'};
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

% --- 重複ニューロンの検出とマーク（○）表示（色別） ---
all_top_neurons = contributed_neurons_original_all(:);
[unique_neurons, ~, ic] = unique(all_top_neurons);
dup_counts = accumarray(ic, 1);
duplicated_neurons = unique_neurons(dup_counts > 1);

% 色の指定
color_map = containers.Map;
color_map('PC1_PC2') = 'b';    % 青
color_map('PC1_PC3') = 'g';    % 緑
color_map('PC2_PC3') = 'w';    % 白
color_map('PC1_PC2_PC3') = 'k';% 黒

% PC名の配列（インデックスに対応）
PC_names = {'PC1','PC2','PC3','PC4'};  % PC4もあるなら追加

for i = 1:length(duplicated_neurons)
    neuron_id = duplicated_neurons(i);

    % どのPCにこのニューロンがいるか（0/1の論理配列）
    present_in_pc = neuron_map(neuron_id, :) > 0;

    % 対象PCインデックスを取得（例: [1 3]）
    pc_indices = find(present_in_pc);

    % カラー決定
    color_key = strjoin(PC_names(pc_indices), '_');
    if isKey(color_map, color_key)
        plot_color = color_map(color_key);
    else
        plot_color = 'm';  % その他の組み合わせはマゼンタなど
    end

    % ○を描画（該当PCすべてに描く）
    for pc = pc_indices
        plot(pc, neuron_id, 'o', 'Color', plot_color, ...
             'MarkerSize', 10, 'LineWidth', 2);
    end
end

% カラーバーとタイトル


if ~isempty(exclude_idx)
    % 数字をカンマ区切りで文字列に
    removed_str = sprintf('%d, ', exclude_idx);
    removed_str = removed_str(1:end-2);  % 最後のカンマ削除
    superTitleStr = sprintf('Removed neuron(s): %s', removed_str);
    title(['PC1 PC2 PC3 distributed neuron number ' num2str(topK) ' ' superTitleStr],'FontSize', 18);
else
   title(['PC1 PC2 PC3 distributed neuron number ' num2str(topK) ],'FontSize', 18);
end

set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, sprintf('PCA_PC123_destributed_neuron_%dneuron.tif', topK));
print(gcf, tifFileName, '-dtiff', '-r300');

close all hidden


%% -----------------------------

pc = 2;   % 可視化したいPC番号
L = coeff(:, pc);     % loadingベクトル

% 二乗寄与
sq = L.^2;

% 正規化（合計=1）
p = sq / sum(sq);

% 降順ソート
[p_sorted, idx_sorted] = sort(p, 'descend');

% 棒グラフ
figure;
bar(p_sorted, 'FaceColor',[0.2 0.6 0.8]);
xlabel('Neuron rank (sorted by contribution)');
ylabel('Normalized contribution');
title(sprintf('PC%d contributions (sorted, sum=1)', pc));
grid on;

% 累積和を重ねて表示する場合（右Y軸）
yyaxis right
plot(cumsum(p_sorted), '-or','LineWidth',1.2);
ylabel('Cumulative contribution');
ylim([0 1]);
yline(0.8,'--k','80% threshold');



%% -----------------------------
Multcompare_p_map_all_neuron;
numNeurons = numel(Multcompare_p_map_all_neuron);   % = 72
numPosture = 16;                  % 姿勢の数
plotsPerPage = 12;                % 1ページあたりのニューロン数
rows = 3; 
cols = 4;

for nBlock = 1:ceil(numNeurons/plotsPerPage)
    figure;
    tiledlayout(rows, cols, "TileSpacing","compact","Padding","compact");

    % 今のブロックで処理するニューロン番号
    neuronRange = (nBlock-1)*plotsPerPage + 1 : min(nBlock*plotsPerPage, numNeurons);

    for i = 1:numel(neuronRange)
        n = neuronRange(i);

        binMat = Multcompare_p_map_all_neuron{n};
        if isempty(binMat)
            continue;
        end

        % 各姿勢について有意差 (1) の回数をカウント
        counts = sum(binMat==1,1);

        % 正規化（最大値を1にスケーリング）
        if max(counts) > 0
            normalized_counts = counts / (numPosture-1);
        else
            normalized_counts = counts;
        end

        % サブプロットに描画
        nexttile;
        bar(1:numPosture, normalized_counts, 'FaceColor',[0.3 0.7 0.3]);
        ylim([0 1]);
        xlabel('Posture');
        ylabel('Norm count');
        title(sprintf('Neuron %d', n));
        set(gca,'FontSize',10);
    end

    % ページ全体のタイトル
    sgtitle(sprintf('Neurons %d–%d', neuronRange(1), neuronRange(end)), 'FontSize',14);
end


%% hip angle and knee angle
threshold_R = 0.4;
p_thresh = 0.05;
hip_and_knee_PCA_folder = createNamedFolder(Loading_condition_folder, 'Hip_and_Knee_angle');
if strcmp(angle_definition, 'relative_normalized')
    hip_and_knee_folder_PCA_cross = createNamedFolder(hip_and_knee_PCA_folder, 'cross_centering');
else
    hip_and_knee_folder_PCA_cross = createNamedFolder(hip_and_knee_PCA_folder, 'cross');
end
threshold_folder_name_PCA = sprintf('threshold_R_%02d_p_%03d', round(threshold_R*10), round(p_thresh*100));
threshold_folder_PCA = createNamedFolder(hip_and_knee_folder_PCA_cross, threshold_folder_name_PCA);
Plot_all_PC_folder = createNamedFolder(threshold_folder_PCA, 'ALL_PC');
Plot_angle_MFR_multiple_regression_hip_knee_cross_PCA_ploteach(numPCs,5, newSpkCH, contributed_neurons, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross, threshold_folder_PCA, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh);


Plot_angle_MFR_multiple_regression_hip_knee_cross_PCA_plotall(numPCs,4, newSpkCH, contributed_neurons, hip_joint_angle_ori(:,1), knee_joint_angle_ori(:,1), MFR_sep_pos, Fig_name_knee_and_hip_cross, Plot_all_PC_folder, Rsq_multi_hip_knee_inter_cross, All_neuron_pval_by_particular_R, cofficient_multi_hip_knee_inter_cross,threshold_R,p_thresh);

%
label_cell_angle = {'Hip Angle [deg]', 'Knee Angle [deg]'};

both_angle_foldername = 'Hip_and_knee_angle';

both_angle_scotter_folder_PCA = createNamedFolder(Loading_condition_folder, 'Scottter_both_parameter');
plotBothJointAngleScatter_topneuron(hip_joint_angle_ori, knee_joint_angle_ori, MFR_sep_pos, newSpkCH,contributed_neurons, 5, both_angle_scotter_folder_PCA, label_cell_angle,both_angle_foldername);
plotBothJointAngleScatter_topneuron_allPC(hip_joint_angle_ori, knee_joint_angle_ori, MFR_sep_pos, newSpkCH,contributed_neurons, 5, both_angle_scotter_folder_PCA, label_cell_angle,both_angle_foldername);
%% 
PCA_multicompare_foldername = 'Multcompare_for_PCA';
plotMulticompare_byPC(MFR_sep_pos, contributed_neurons, 5, Loading_condition_folder, PCA_multicompare_foldername)
%% 
PCA_each_neuron__mean_bar_foldername = 'MFR_for_PCA';
plotBar_perNeuron(MFR_sep_pos, contributed_neurons, 5, Loading_condition_folder, PCA_each_neuron__mean_bar_foldername)


%% plot bar 
mean_vals = mean(data);
sem_vals  = std(data) / sqrt(size(data,1));

figure; hold on;
bar(1:16, mean_vals, 'FaceColor', [0.7 0.7 0.7])
errorbar(1:16, mean_vals, sem_vals, 'k.')
xlabel('Posture')
ylabel('Mean Firing rate [Hz]')
title('Neuron response per posture')


%% 

% データ（割合）
PC1_joint_related_neuron = [5, 3, 2];
PC1_joint_related_neuron = fliplr(PC1_joint_related_neuron);  % データ反転
% 円グラフの作成
figure;
pie(PC1_joint_related_neuron);
% タイトル（任意）
title('Example Pie Chart');
% カラーマップ指定（例：3色）
PC1_joint_related_neuron_color = [0 1 0; 1 0 0; 0 0 0];
colormap(PC1_joint_related_neuron_color);  
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, 'PCA_PC1_joint_related_neuron.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%% 順番通りに表示したいデータ（順序：1番目→2番目→3番目）
data = [6, 4];
labels = {' ', ' ', ' '};  % 任意のラベル

% 順番を守って「左回り」にしたい場合 → データを反転
data = fliplr(data);       % → [2, 3, 5]

% パーセンテージ計算
percentages = data / sum(data) * 100;

% パイチャート描画
figure;
h = pie(data);

% 色を指定（順序は反転しているので注意: [2,3,5]に対応）
color_list = [ ...
    0 0 0;      % black
    0.0 0 1];     % blue

label_idx = 1;
wedge_idx = 1;
for k = 1:2:length(h)
    if isgraphics(h(k), 'patch')
        h(k).FaceColor = color_list(wedge_idx, :);  % 色指定
        wedge_idx = wedge_idx + 1;
    end
end

title('PC1');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, 'PCA_PC1_joint_related_neuron.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%% 順番を守って「左回り」にしたい場合 → データを反転
data = [2, 2, 1,5];
labels = {' ', ' ', ' '};  % 任意のラベル


data = fliplr(data);       % → [2, 3, 5]

% パーセンテージ計算
percentages = data / sum(data) * 100;

% パイチャート描画
figure;
h = pie(data);

% 色を指定（順序は反転しているので注意: [2,3,5]に対応）
color_list = [ ...
    0 0 0;      % black
    1.0 0.5 0.0;
    0 0.5 0;      %  green
    0.0 0.0 1.0];     % blue

label_idx = 1;
wedge_idx = 1;
for k = 1:2:length(h)
    if isgraphics(h(k), 'patch')
        h(k).FaceColor = color_list(wedge_idx, :);  % 色指定
        wedge_idx = wedge_idx + 1;
    end
end

title('PC2');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, 'PCA_PC2_joint_related_neuron.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%% 順番を守って「左回り」にしたい場合 → データを反転 PC1
data = [2, 1, 2, 5];
labels = {' ', ' ', ' '};  % 任意のラベル


data = fliplr(data);       % → [2, 3, 5]

% パーセンテージ計算
percentages = data / sum(data) * 100;

% パイチャート描画
figure;
h = pie(data);

% 色を指定（順序は反転しているので注意: [2,3,5]に対応）
color_list = [ ...
    0 0 0;      % black
    1.0 0.5 0.0;
    0 0.5 0;
    0 0 1;];     % blue

label_idx = 1;
wedge_idx = 1;
for k = 1:2:length(h)
    if isgraphics(h(k), 'patch')
        h(k).FaceColor = color_list(wedge_idx, :);  % 色指定
        wedge_idx = wedge_idx + 1;
    end
end

title('PC3');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, 'PCA_PC3_joint_related_neuron.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%% 順番を守って「左回り」にしたい場合 → データを反転 PC3 include specific neuron
data = [3,1,3, 3];
labels = {' ', ' ', ' '};  % 任意のラベル


data = fliplr(data);       % → [2, 3, 5]

% パーセンテージ計算
percentages = data / sum(data) * 100;

% パイチャート描画
figure;
h = pie(data);

% 色を指定（順序は反転しているので注意: [2,3,5]に対応）
color_list = [ ...
    0 0 0;      % black
    1.0 0.5 0.0;
    1.0 0.25 0.0;
    1 0 0];     % red

label_idx = 1;
wedge_idx = 1;
for k = 1:2:length(h)
    if isgraphics(h(k), 'patch')
        h(k).FaceColor = color_list(wedge_idx, :);  % 色指定
        wedge_idx = wedge_idx + 1;
    end
end

title('PC3_include_specific');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, 'PCA_PC3_joint_related_neuron_include_specific_neuron.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%% 順番を守って「左回り」にしたい場合 → データを反転 PC2 include specific neuron
data = [1, 5,1,1,2];
labels = {' ', ' ', ' '};  % 任意のラベル


data = fliplr(data);       % → [2, 3, 5]

% パーセンテージ計算
percentages = data / sum(data) * 100;

% パイチャート描画
figure;
h = pie(data);

% 色を指定（順序は反転しているので注意: [2,3,5]に対応）
color_list = [ ...
    0 0 0;      % black
    1 0.5 0;
    1.0 0.25 0.0;
    1 0 0;
    0 0 1];     % blue

label_idx = 1;
wedge_idx = 1;
for k = 1:2:length(h)
    if isgraphics(h(k), 'patch')
        h(k).FaceColor = color_list(wedge_idx, :);  % 色指定
        wedge_idx = wedge_idx + 1;
    end
end

title('PC2_include_specific');
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);

% 保存

tifFileName = fullfile(Loading_condition_folder, 'PCA_PC2_joint_related_neuron_include_specific_neuron.tif');
print(gcf, tifFileName, '-dtiff', '-r300');

%}

%% caluculate cross correlation
%{
cuttng_offset_for_static = [start_time_each_Ex3_sep end_time_each_Ex3_sep];

[Count_spike_all_static,Task_spike_time_all_static,Mean_firing_rate_all_static,Task_spike_time_during_static_across_posture_each_trial] = Cutting_data_for_each_DI_only_static(newSpkTime,EX3_task_DI_Lineup_Trial,cuttng_offset_for_static);

Task_spike_time_during_static_across_posture_all_trial = cell(length(newSpkTime),1);

for i = 1:length(newSpkTime)
    % 各行の5トライアルを結合
    Task_spike_time_during_static_across_posture_all_trial{i} = vertcat(Task_spike_time_during_static_across_posture_each_trial{i, :});
    
    % 降順にソート
    Task_spike_time_during_static_across_posture_all_trial{i} = sort(Task_spike_time_during_static_across_posture_all_trial{i}, 'ascend');
end
%% Separate each timing

bin_size_list = [0.0005, 0.001,0.002,0.005,0.01]; % 秒単位
for b = 1:length(bin_size_list)
Ex3_cross_correlation_cutting_time = [-100/1000 100/1000];
%bin_size_each_cross = 0.002;
bin_size_each_cross = bin_size_list(b);

% ==== bin_size_each_cross をミリ秒単位に変換 ====
bin_size_ms = bin_size_each_cross * 1000;

% ==== 小数点をアンダースコアに変換してラベル作成 ====
bin_size_each_cross_label = sprintf('%.3g', bin_size_ms);  % 例: 0.5, 2, 10
bin_size_each_cross_label = strrep(bin_size_each_cross_label, '.', '_');  % "." → "_"
bin_size_each_cross_label = [bin_size_each_cross_label 'ms'];             % 単位追加
 
start_time_each_cross = Ex3_cross_correlation_cutting_time(1); % Time before stimulus onset (in seconds)
end_time_each_cross = Ex3_cross_correlation_cutting_time(2);    % Time after stimulus onset (in seconds)
time_window_each_cross = start_time_each_cross:bin_size_each_cross:end_time_each_cross;


nNeurons = length(newSpkTime);
firing_prob_for_psth = cell(nNeurons,nNeurons);
max_firing_prob = zeros(nNeurons, nNeurons);
for main_neuron = 1:nNeurons
     spike_times_data_main_neuron = Task_spike_time_during_static_across_posture_all_trial{main_neuron};
        for cross_neuron = 1:nNeurons
            spike_times_data_cross_neuron = Task_spike_time_during_static_across_posture_all_trial{cross_neuron};
            prob_psth = zeros(1, (numel(time_window_each_cross) - 1));
            num_main_spikess = length(spike_times_data_main_neuron);
                % あるbinにスパイクが出た試行数を数える
                for main_spktime = 1:num_main_spikess
                    % 0 align
                    Spktime_train = spike_times_data_cross_neuron - spike_times_data_main_neuron(main_spktime,1);
                    Spike_timing_for_main_neuron_firing_timing = Spktime_train(Spktime_train >= Ex3_cross_correlation_cutting_time(1) & Ex3_cross_correlation_cutting_time(2) >= Spktime_train);
                    % 該当binにスパイクが1つでもあるかどうか
                    prob_psth_count = histcounts(Spike_timing_for_main_neuron_firing_timing, time_window_each_cross);
                    prob_psth = prob_psth + prob_psth_count;
                end             
                    % 発火確率 = スパイクが1つ以上出た試行数 / 総試行数
                    prob_psth = prob_psth / num_main_spikess;
                    max_prob = max(prob_psth);
                    firing_prob_for_psth{main_neuron, cross_neuron} = prob_psth;
                    max_firing_prob(main_neuron, cross_neuron) = max_prob;
        end
               %main_neuron ループ終了時に表示
            fprintf('Finished processing main neuron %d\n', main_neuron);
end
disp('all neuron finish')   
% plot cross colleration
experiment3_cross_correlation_static_folder = createNamedFolder(experiment3_static_folder_select, 'cross_correlation');
experiment3_cross_correlation_atatic__across_all_pos_folder = createNamedFolder(experiment3_cross_correlation_static_folder, 'across_all_posture');
experiment3_cross_correlation_atatic__across_all_pos_bin_folder = createNamedFolder(experiment3_cross_correlation_atatic__across_all_pos_folder,bin_size_each_cross_label);

particular_R_angle_related_neuron;
labels_for_group = ["No modulation", "Hip joint angle", "Knee joint angle", "Dual joint angle", "Specific endpoint"];

% === カラー定義 ===
colorMap = [ ...
    0.2 0.2 0.2;  % 0 → 灰
    0 0 1.0;      % 1 → 青
    0 0.5 0;      % 2 → 緑
    1.0 0.2 0.2;  % 3 → 赤
    1.0 0.6 0.0]; % 4 → オレンジ

cols = 9; 
rows = 8;
plotsPerPage = rows * cols;
totalNeurons = length(newSpkTime);

skipSlots = 3;             % main plot の後に空ける個数
startCol = 1 + 1 + skipSlots;  % 1列目(main) + skip + 次
startPos = startCol;       % subplot 番号（1行目開始）

for main_neuron = 1:totalNeurons

    numPages = ceil(totalNeurons / (plotsPerPage - 1 - skipSlots));

    for page = 1:numPages
        figure;

        % ---- main_neuron を 1 行 1 列目に配置 ----
        subplot(rows, cols, 1);
        t_ms = time_window_each_cross(1:end-1) * 1000;
        bar(t_ms, firing_prob_for_psth{main_neuron, main_neuron}, ...
            'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');
        hold on;
        title(sprintf('N %d Ch %d', main_neuron, newSpkCH(main_neuron)), ...
            'FontSize', 10, 'FontWeight', 'bold', ...
            'Color', colorMap(particular_R_angle_related_neuron(main_neuron)+1,:));
        set(gca, 'LineWidth', 3, 'Box', 'on');
        xlim([-50 50]);

        % ---- ここから残りのニューロンを配置 ----
        plotIndex = startPos;
        firstNeuronIndex = (page-1)*(plotsPerPage - startPos + 1) + 1;
        lastNeuronIndex  = min(totalNeurons, page*(plotsPerPage - startPos + 1));

        for i = firstNeuronIndex:lastNeuronIndex
            if i == main_neuron, continue; end % main はスキップ

            subplot(rows, cols, plotIndex);
            t_ms = time_window_each_cross(1:end-1) * 1000;

            bar(t_ms, firing_prob_for_psth{i, main_neuron}, ...
                'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');
            hold on;

            title(sprintf('N %d Ch %d', i, newSpkCH(i)), ...
                'FontSize', 10, ...
                'Color', colorMap(particular_R_angle_related_neuron(i)+1,:));

            set(gca, 'LineWidth', 0.5, 'Box', 'on');
            xlim([-50 50]);

            plotIndex = plotIndex + 1;
            if plotIndex > rows*cols
                break;
            end
        end

        n_trials = length(Task_spike_time_during_static_across_posture_all_trial{main_neuron,1});
sgtitle(sprintf('#Neuron %d Type:%s Cross crrelation Bin %dms (n = %d)',  main_neuron, labels_for_group{particular_R_angle_related_neuron(main_neuron)+1}, bin_size_each_cross*1000,n_trials), 'FontSize', 20);

        set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
        % 保存
        tifFileName = fullfile( ...
            experiment3_cross_correlation_atatic__across_all_pos_bin_folder, ...
            sprintf('Neuron_%d_page_%d.tif', main_neuron, page));
        print(gcf, tifFileName, '-dtiff', '-r300');
        close all hidden
    end
end

end
%}

%% =====================================================
%  LASSO Decoding model analysis (10 repetitions) ramda 10000
% =====================================================
default_rng = rng;   % 現在の乱数状態を保存
rng(1000);             % シード固定
num_ramda = 10000;
%decording_parameter = 'Hip_and_Knee';
decording_parameter = 'Orientation_and_Length';
%decording_parameter = 'X_and_Y';
decording_folder = createNamedFolder(experiment3_static_folder_select, 'Decording analysis');

% XY position
H_bone_mean; 
hip_mean;
Knee_mean;
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
    labels = ["Orientation","Length"];
elseif strcmp(decording_parameter, 'X_and_Y')
    obserbed_param = [Endpoint_Xpos,Endpoint_Ypos];  % [16 x 2]
    % --- フォルダ名を自動生成 ---
    folder_name = sprintf('Lasso_%dramda_%s', num_ramda, decording_parameter);
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
        [B1,FitInfo1] = lasso(X_train, Y_train(:,1), 'Alpha', 1, 'CV', 5, 'NumLambda', num_ramda);
        idxLambdaMinMSE1 = FitInfo1.IndexMinMSE;
        B_param1 = B1(:, idxLambdaMinMSE1);
        B_param1_all_set(:,leave_out) = B_param1;

        [B2,FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha', 1, 'CV', 5, 'NumLambda', num_ramda);
        idxLambdaMinMSE2 = FitInfo2.IndexMinMSE;
        B_param2 = B2(:, idxLambdaMinMSE2);
        B_param2_all_set(:,leave_out) = B_param2;

        % --- テストデータ予測 ---
        Y_pred_param1  = X_test * B_param1 + FitInfo1.Intercept(idxLambdaMinMSE1);
        Y_pred_param2 = X_test * B_param2 + FitInfo2.Intercept(idxLambdaMinMSE2);
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

% model Zero count
zero_count_B1_sq = sum(B_param1_all_set == 0, 1);
zero_count_B2_sq = sum(B_param2_all_set == 0, 1);
zero_count_B1_sq_mean = mean(zero_count_B1_sq);
zero_count_B2_sq_mean = mean(zero_count_B2_sq);
% 
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
    xlim([60 100]); ylim([60 100]);
    xticks(60:10:100);
    yticks(60:10:100);
    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(62.5, 95, sprintf('R^2 = %.3f', R_square_param1_decording), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
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
    xlim([30 130]); ylim([30 130]);
    text(35, 120,  sprintf('R^2 = %.3f', R_square_param2_decording), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
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
    %=== FigureのサイズをA4幅に縮小 ===
    target_width = 20;     % cm （A4幅に収める）
    target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

    % === PDF保存 ===
    pdfFileName = fullfile(decording_lasso_folder, 'Mean_SD_Hip_Knee CatB.pdf');
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
    xlim([45 110]); ylim([45 110]);
    xticks(50:10:100);
    yticks(50:10:100);
        % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
        text(50, 105,  sprintf('R^2 = %.3f', R_square_param1_decording), ...
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
    xlim([90 230]); ylim([90 230]);
    xticks(100:25:225);
    yticks(100:25:225);
    text(100, 215, sprintf('R^2 = %.3f', R_square_param2_decording), ...
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
    %=== FigureのサイズをA4幅に縮小 ===
    target_width = 20;     % cm （A4幅に収める）
    target_height = 12;     % 縦は適度に調整（横幅に合わせて縮小）
    set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

    % === PDF出力用にPaperSizeを合わせる ===
    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperSize = [target_width target_height];      % 幅 × 高さ
    fig.PaperPosition = [0 0 target_width target_height]; % 余白なし

% === PDF保存 ===
emfFileName = fullfile(decording_lasso_folder, ['Mean_SD_O_length CatB.emf']);
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
   % 割合表示
    percent_val = frac(k) * 100;

    if percent_val < 0.05
        text_handles(k).String = '';      % ← 0%は表示しない
    else
        text_handles(k).String = sprintf('%.1f%%', percent_val);
    end

    text_handles(k).Color = color_reordered(k,:);
    text_handles(k).FontWeight = 'bold';
    text_handles(k).FontSize = 14;

    if param_num == 1
        pos = text_handles(k).Position;
        % ★ type=2 のラベルだけ
        if k == find(type_order == 2)
            pos(1) = pos(1) + 0.05;   
        end

        % 反映
        text_handles(k).Position = pos;
    else
        pos = text_handles(k).Position;
        if iModel==1 || iModel==5 || iModel==7 || iModel==9 || iModel==10 ||iModel==14 || iModel==15
        % ★ type=2 のラベルだけ
        if k == find(type_order == 4)
            pos(2) = pos(2) - 0.1; 
        else

        end
        elseif iModel==3 || iModel==4 || iModel==6 || iModel==8 || iModel==7
        if k == find(type_order == 4)
            pos(1) = pos(1) - 0.15; 
        else

        end 
        elseif iModel==6 || iModel==8 || iModel==7
        if k == find(type_order == 4)
            pos(1) = pos(1) - 0.07; 
        else

        end 
        elseif iModel==2
        if k == find(type_order == 1)
            pos(1) = pos(1) + 0.18; 
            pos(2) = pos(2) - 0.02; 
        elseif k == find(type_order == 2)
            pos(1) = pos(1) - 0.1; 
        elseif k == find(type_order == 4)
            pos(1) = pos(1) + 0.4; 
            pos(2) = pos(2) - 0.15; 
        else

        end 
        elseif iModel==16 
        if k == find(type_order == 1)
            pos(1) = pos(1) + 0.18; 
            pos(2) = pos(2) - 0.02; 
        elseif k == find(type_order == 4)
            pos(1) = pos(1) + 0.2; 
            pos(2) = pos(2) - 0.1; 
        else

        end 

        else 
        if k == find(type_order == 4)
            pos(2) = pos(2) + 0.07; 
        else

        end 
        end
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





%% plot slective frecency
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


%% =====================================================
%  LASSO Decoding model analysis (10 repetitions)
% =====================================================
default_rng = rng;   % 現在の乱数状態を保存
rng(255);             % シード固定

num_runs = 100;
decording_parameter = 'Hip_and_Knee';
%decording_parameter = 'Orientation_and_Length';
%decording_parameter = 'X_and_Y';
decording_folder = createNamedFolder(experiment3_static_defined_folder, 'Decording analysis');

% XY position
H_bone_mean; 
hip_mean;
Knee_mean;
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
        xlim([60 100]); ylim([60 100]);
        % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
        text(62.5, 95,  sprintf('R^2 = %.3f', R_square_param1_decording), ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
        subplot(1,2,2);
        scatter(Y_true_all(:,2), Y_pred_all(:,2), 20, 'k', 'filled'); hold on;
        xlabel('Observed knee joint angle [degree]');
        ylabel('Decoded knee joint angle [degree]');
        grid on; axis equal;
        plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);
        xlim([30 130]); ylim([30 130]);
        text(35, 120,  sprintf('R^2 = %.3f', R_square_param2_decording), ...
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
        xlim([50 110]); ylim([50 110]);
        % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
        text(55, 100, sprintf('R^2 = %.3f', R_square_param1_decording), ...
        'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
        subplot(1,2,2);
        scatter(Y_true_all(:,2), Y_pred_all(:,2), 20, 'k', 'filled'); hold on;
        xlabel('Observed length [mm]');
        ylabel('Decoded length [mm]');
        grid on; axis equal;
        plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);
        xlim([90 230]); ylim([90 230]);
        text(95, 210, sprintf('R^2 = %.3f', R_square_param2_decording), ...
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

%
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
    xlim([60 100]); ylim([60 100]);

    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(62.5, 95, sprintf('R^2 = %.3f ± %.3f\n', R2_param1_mean,  R2_param1_std), ...
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
    xlim([30 130]); ylim([30 130]);
    text(35, 120, sprintf('R^2 = %.3f ± %.3f\n', R2_param2_mean, R2_param2_std), ...
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
    grid on; axis equal;axis square;   % 見た目も正方形にする
    plot([min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         [min(Y_true_all(:,1)), max(Y_true_all(:,1))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3);
    xlim([50 110]); ylim([50 110]);
    % --- R²を図中に描画（例: x=100, y=20 の位置に表示）---
    text(55, 100, sprintf('R^2 = %.3f ± %.3f\n', R2_param1_mean,  R2_param1_std), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', [0 0 0]);
    % ==== Knee (length) ====
    subplot(1,2,2);
    errorbar(obserbed_param(:,2), param2_mean_eachPos, param2_std_eachPos, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); hold on;
    xlabel('Observed length [mm]');
    ylabel('Decoded length [mm]');
    grid on; axis equal;axis equal;axis square;   % 見た目も正方形にする
    plot([min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         [min(Y_true_all(:,2)), max(Y_true_all(:,2))], ...
         '-', 'Color', [0.5 0.5 0.5], 'LineWidth',3);
    xlim([90 230]); ylim([90 230]);
    text(95, 210, sprintf('R^2 = %.3f ± %.3f\n', R2_param2_mean, R2_param2_std), ...
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












%% Decoding model analysis (leave-one-posture-out)
%----------------------------------------------------------------------
decording_folder = createNamedFolder(experiment3_static_defined_folder, 'Decording analysis');
decording_lasso_folder = createNamedFolder(decording_folder, 'Lasso');

%XY position 
H_bone_mean; 
hip_mean;
Ankle_mean;
Endpoint_Xpos = Ankle_mean(:,1)-hip_mean(1,1);
Endpoint_Ypos = Ankle_mean(:,3)-hip_mean(1,3);
scatter(Endpoint_Xpos,Endpoint_Ypos)
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
joint_angles = [Endpoint_Xpos,Endpoint_Ypos]  % [16 x 2]
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
title(sprintf('Theta decoding (R^2 = %.3f)', R_square_knee_decording));
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

%% --- 可視化 ---
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

%% Decoding model analysis (leave-one-posture-out)
%----------------------------------------------------------------------
decording_folder = createNamedFolder(experiment3_static_differential_folder, 'Decording analysis');
decording_lasso_folder = createNamedFolder(decording_folder, 'Lasso');
MFR_sep_zscore_pos;
num_neurons = numel(MFR_sep_zscore_pos);
num_trials = 5;
num_postures = 16;

% --- 姿勢ごとのラベル（関節角度） ---
joint_angles = hip_knee_joint_angle_orignal;  % [16 x 2]

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

    [B2,FitInfo2] = lasso(X_train, Y_train(:,2), 'Alpha',1, 'CV', 5); % Knee
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
xlabel('True Hip angle');
ylabel('Predicted Hip angle');
title(sprintf('Hip decoding (R^2 = %.3f)', R_square_hip_decording));
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
xlabel('True Knee angle');
ylabel('Predicted Knee angle');
title(sprintf('Knee decoding (R^2 = %.3f)', R_square_knee_decording));
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

sgtitle('Decoding performance: True vs Predicted joint angles');
fontsize(20,'points')
set(gcf, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
saveas(gcf, fullfile(decording_lasso_folder, 'Angle_true_vs_predicted_angle.tif'));
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
saveas(gcf, fullfile(decording_lasso_folder, 'Posture_wise_true_vs_predicted_bar.tif'));

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
saveas(gcf, fullfile(decording_lasso_folder, 'Error_predict_actual.tif'));



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
