% For Figure 4
% Created on Mar 20 2026 
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig4_hip_and_ankle_xy_coordination.mat']);
load([filePath,'data_Fig4_mean_firing_rate.mat']);

%% Variables in this file
% Ankle_xy_coordination_for_16_recording_positions
%   Size: [16 × 2]
%   - Column 1: X coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Column 2: Y coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Description: Ankle joint XY coordination for each recording position
%   in Cat A

% Hip_xy_coordination_average_across_16_recording_positions
%   Size: [1 × 2]
%   - Column 1: X coordinate
%   - Column 2: Y coordinate
%   - Description: Hip joint XY coordination averaged across 16 recording
%     positions in Cat A

% Neuron53_firing_rate_16_recording_positions
%   Size: [1 × 16]
%   - Elements: Mean firing rate at each recording position (Pos-1 to Pos-16)
%   - Description: Mean firing rate of neuron #53 across 16 recording positions
%   in Cat A

% Neuron21_firing_rate_16_recording_positions
%   Size: [1 × 16]
%   - Elements: Mean firing rate at each recording position (Pos-1 to Pos-16)
%   - Description: Mean firing rate of neuron #21 across 16 recording positions
%   in Cat A

%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% setting color map and origin

% Set hip joint position as the origin (0,0) and express ankle coordinates relative to it
Ankle_Xaxis = Ankle_xy_coordination_for_16_recording_positions(:,1) - Hip_xy_coordination_average_across_16_recording_positions(1,1);   
Ankle_Yaxis = Ankle_xy_coordination_for_16_recording_positions(:,2) - Hip_xy_coordination_average_across_16_recording_positions(1,2);

% You need to MatPlotLib "Perceptually Uniform" Colormaps tool box

% set neuron name
neuron_pair = [53 21]; 
neuron_firing_rate_index = [Neuron53_firing_rate_16_recording_positions;Neuron21_firing_rate_16_recording_positions];

%% Plot mean firing rate for neuron #53 and Neuron #21
figure('Units','centimeters','Position',[5 5 17 6]);

tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
for k = 1:2
    neuron_idx = neuron_pair(k);
    nexttile
    hold on;
    axis equal;
    % Plot mean firing rate
    firing_rate_mean = neuron_firing_rate_index(k,:);
    scatter(Ankle_Xaxis, Ankle_Yaxis, 20, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');

    % Set color scale for mean firing rate
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
 
    % Set color bar
    colormap(viridis);
    caxis(ylim_fig); 
    cb = colorbar;
    set(cb, ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',8)
    cb.Color = 'k';
    
    % Add text annotations for recording positions
    for j = 1:length(Ankle_Xaxis)
        if j == 3
            text(Ankle_Xaxis(j)+5, Ankle_Yaxis(j) + 8, ...
                ['Pos-', num2str(j)], ...
                'FontWeight','bold', ...
                'FontSize', 8, ...
                'HorizontalAlignment','center', ...
                'FontName','Arial', ...
                'Color','k');
        elseif j == 4
            text(Ankle_Xaxis(j)+9, Ankle_Yaxis(j) - 8, ...
                ['Pos-', num2str(j)], ...
                'FontWeight','bold', ...
                'FontSize', 8, ...
                'HorizontalAlignment','center', ...
                'FontName','Arial', ...
                'Color','k');
        else
            text(Ankle_Xaxis(j)+4, Ankle_Yaxis(j) - 6, ...
                ['Pos-', num2str(j)], ...
                'FontWeight','bold', ...
                'FontSize', 8, ...
                'HorizontalAlignment','center', ...
                'FontName','Arial', ...
                'Color','k');
        end
    end

    %setting label
    title(sprintf('Cat A Neuron #%d', neuron_idx), ...
    'FontWeight','bold', ...
    'FontName','Arial', ...
    'FontSize',10, ...
    'Color','k');

    xlabel('X [mm]', ...
    'FontWeight','bold', ...
    'FontName','Arial', ...
    'FontSize',8, ...
    'Color','k'); 

    ylabel('Y [mm]', ...
    'FontWeight','bold', ...
    'FontName','Arial', ...
    'FontSize',8, ...
    'Color','k');
    xlim([-50 150])
    ylim([-200 -20])
    xticks(-50:50:150);
    yticks(-200:50:-20);

    set(gca, ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',8, ...
    'LineWidth',1.5, ...
    'TickDir','out', ...
    'XColor','k', ...
    'YColor','k')

end

% print and save figure
print(gcf, fullfile(figureFolder, ...
    'Figure4.emf'), ...
    '-dmeta', '-r600');
