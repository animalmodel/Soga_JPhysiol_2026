% For Figure S2
% Created on Mar 20 2026 
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_FigS2_hip_and_ankle_xy_coordination_catB.mat']);
load([filePath,'data_FigS2_mean_firing_rate_catB.mat']);

%% Variables in this file
% Ankle_xy_coordination_for_16_recording_positions
%   Size: [16 × 2]
%   - Column 1: X coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Column 2: Y coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Description: Ankle joint XY coordination for each recording position
%   in Cat B

% Hip_xy_coordination_average_across_16_recording_positions
%   Size: [1 × 2]
%   - Column 1: X coordinate
%   - Column 2: Y coordinate
%   - Description: Hip joint XY coordination averaged across 16 recording
%     positions in Cat B

% Mean_firing_rate_136_neurons_in_catB_16_recording_position
%   Size: [136 × 16]
%   - Rows: Neurons (Neuron 1 to Neuron 136)
%   - Columns: Recording positions (Pos-1 to Pos-16)
%   - Description: Mean firing rate of 136 neurons at each of the 16 recording positions
%   in Cat B


%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% Color map setting
nColors = 256;
baseMap = viridis(nColors);
dataMax   = 110;      % Maximum data value (Hz)
threshold = 50;       % Threshold value for color mapping (Hz)
t = threshold / dataMax;
v = linspace(0,1,nColors);
customRange = zeros(size(v));
% --- Allocate 85% of the colormap to 0–50 Hz ---
customRange(v <= t) = ...
    (v(v<=t)/t) * 0.85;
% --- For 50–110 Hz, assign the remaining 15% nonlinearly for a smooth transition ---
gamma_high = 1.5;  % Gamma > 1 avoids end-point compression
vh = (v(v>t)-t) / (1-t);
customRange(v > t) = ...
    0.85 + (vh.^gamma_high) * 0.15;
% Interpolate the base colormap according to the custom range
newCmap = interp1(linspace(0,1,nColors), baseMap, customRange);


%% Calculate the gradient of neural activity with respect to changes in the X direction
% Initial setting
nNeuron  = length(Mean_firing_rate_136_neurons_in_catB_16_recording_position);
nPosture = 16;

% Sort recording positions by ankle X displacement (relative to hip), and align firing rates to this order.
Ankle_Xaxis = Ankle_xy_coordination_for_16_recording_positions(:,1) - Hip_xy_coordination_average_across_16_recording_positions(1,1);
[~, sortIdx_X] = sort(Ankle_Xaxis,'ascend');
FR_X = Mean_firing_rate_136_neurons_in_catB_16_recording_position(:, sortIdx_X);

% Divide the 16 recording positions into four groups and compute the gradient
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

%% Calculate the gradient of neural activity with respect to changes in the Y direction.
% Sort recording positions by ankle Y displacement (relative to hip), and align firing rates to this order.
Ankle_Yaxis = Ankle_xy_coordination_for_16_recording_positions(:,2) - Hip_xy_coordination_average_across_16_recording_positions(1,2);
[~, sortIdx_Y] = sort(Ankle_Yaxis,'ascend');

FR_Y = Mean_firing_rate_136_neurons_in_catB_16_recording_position(:, sortIdx_Y);

% Divide the 16 recording positions into four groups and compute the gradient
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

%% Plot the modulation of 136 neurons along X and Y axis
figure('Units','centimeters','Position',[5 5 17 12]);
set(gcf,'DefaultAxesFontName','Arial');
set(gcf,'DefaultTextFontName','Arial');
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

% Plot the modulation of 136 neurons along the X direction
nexttile;
axis tight;

% Plot mean firing rate
imagesc(FR_X_sorted);

% Set color map
cb1 = colormap(newCmap);
caxis([0 dataMax])
cb1 = colorbar;
cb1.FontSize = 8;
cb1.FontWeight = 'bold';
cb1.Color = 'k';   

% Set label
xlabel('Recording Position (Sorted by X axis)',...
    'FontSize',10,'FontWeight','bold','Color','k');
ylabel('Single neuron',...
    'FontSize',10,'FontWeight','bold','Color','k');
set(gca,...
    'FontSize',8,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('%d',x), sortIdx_X, 'UniformOutput', false),...
    'XTickLabelRotation',0,...
    'YTick',[],...
    'FontWeight','bold',...
    'LineWidth',1.5,...
    'YDir','normal',...
    'TickDir','out',...
    'Box','off',...
    'XColor','k',...
    'YColor','k');


% Plot the modulation of 136 neurons along the Y direction
nexttile;
axis tight;

% Plot mean firing rate
imagesc(FR_Y_sorted);

% Set color map
cb2 = colormap(newCmap);
caxis([0 dataMax])
cb2 = colorbar;
cb2.FontSize = 8;
cb2.FontWeight = 'bold';
cb2.Color = 'k';   

% Set label
xlabel('Recording Position (Sorted by Y-axis)',...
    'FontSize',10,'FontWeight','bold','Color','k');
set(gca,...
    'FontSize',8,...
    'XTick',1:nPosture,...
    'XTickLabel',arrayfun(@(x)sprintf('%d',x), sortIdx_Y, 'UniformOutput', false),...
    'XTickLabelRotation',0,...
    'YTick',[],...
    'FontWeight','bold',...
    'LineWidth',1.5,...
    'YDir','normal',...
    'TickDir','out',...
    'Box','off',...
    'XColor','k',...
    'YColor','k');

% print and save figure
save_name = fullfile(figureFolder,'FigureS2.emf');
print(gcf, save_name, '-dmeta', '-r600');