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
neuron_firing_rate_index = [mean(Neuron53_firing_rate_16_recording_positions,1);mean(Neuron21_firing_rate_16_recording_positions,1)];
neuron_firing_rate_index_std = [std(Neuron53_firing_rate_16_recording_positions,1);std(Neuron21_firing_rate_16_recording_positions,1)];

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
    scatter(Ankle_Xaxis, Ankle_Yaxis, 40, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');
    %
    firing_rate_std = neuron_firing_rate_index_std(k,:);
    scale = 50;  
    scatter(Ankle_Xaxis, Ankle_Yaxis, firing_rate_std * scale, ...
        'MarkerFaceColor', 'none', ...
        'MarkerEdgeColor', [0.5 0.5 0.5], ...
        'LineWidth', 1.5);

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
    % colormap(viridis);
    colormap(gray);
    caxis(ylim_fig); 
    cb = colorbar;
    set(cb, ...
    'FontName','Arial', ...
    'FontWeight','bold', ...
    'FontSize',8)
    cb.Color = 'k';
    
    % Add text annotations for recording positions
    for j = 1:length(Ankle_Xaxis)
        textXPos = Ankle_Xaxis(j) + 4;
        if k==1
            textYPos = Ankle_Yaxis(j) -10;
        else
            textYPos = Ankle_Yaxis(j) -12;
        end
        if j == 1
            textXPos = Ankle_Xaxis(j) + 4;
            textYPos = Ankle_Yaxis(j) +12;    
        elseif j == 2
            if k==1
                textYPos = Ankle_Yaxis(j) -16;
            end
        elseif j == 3
            textXPos = Ankle_Xaxis(j) +23;
            textYPos = Ankle_Yaxis(j) +8;
        elseif j == 4
            textXPos = Ankle_Xaxis(j) +9;
            textYPos = Ankle_Yaxis(j) -13;
        elseif j == 7
            if k==1
                textXPos = Ankle_Xaxis(j) +28;
            else
                textXPos = Ankle_Xaxis(j) +25;
            end
            textYPos = Ankle_Yaxis(j) -1;
        elseif j == 8
            if k==1
                textXPos = Ankle_Xaxis(j) +30;
            else
                textXPos = Ankle_Xaxis(j) +25;
            end
            textYPos = Ankle_Yaxis(j) -1;
        elseif j == 9
            textXPos = Ankle_Xaxis(j) -25;
            textYPos = Ankle_Yaxis(j) +0;
        elseif j == 13
            textXPos = Ankle_Xaxis(j) +20;
            textYPos = Ankle_Yaxis(j) +10;
        elseif j == 14
            textXPos = Ankle_Xaxis(j) +0;
            textYPos = Ankle_Yaxis(j) +10;
        end
        text(textXPos, textYPos, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color','k');
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
