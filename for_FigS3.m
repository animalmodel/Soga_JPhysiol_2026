% For Figure S3
% Created on Mar 20 2026
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig3S_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig3S_mean_firing_rate_representative_endpoint_neuron_catA.mat']);

%% Variables in this file
% Hip_joint_angle_16_recording_positions_catA
%   Size: [16 × 1]
%   - Description: Hip joint angle at each of the 16 recording positions in Cat A
%     Each element corresponds to the hip joint angle at a specific recording position

% Knee_joint_angle_16_recording_positions_catA
%   Size: [16 × 1]
%   - Description: Knee joint angle at each of the 16 recording positions in Cat A
%     Each element corresponds to the knee joint angle at a specific recording position

% responsible_neuron_specific_endpoint_catA
%   Size: [7 × 1]
%   - Description: Neuron IDs in Cat A to be plotted in Figure S3

% specific_endpoint_representative_neuron_catA
%   Size: [7 × 1]
%   - Description: Representative neurons in Cat A that respond to specific
%   endpoints, to be plotted in Figure S3

% mean_firing_rate_specific_endpoint_catA
%   Size: [7 × 16]
%   - Description: Mean firing rates of representative neurons in Cat A across 16 recording positions
%     Each row corresponds to a neuron, and each column corresponds to a recording position

%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% Preprocessing
% Set X label hip joint angle, Y label knee joint angle
X = Hip_joint_angle_16_recording_positions_catA;
Y = Knee_joint_angle_16_recording_positions_catA;

%% Plot single endpoint responsive neurons
figure('Units','centimeters','Position',[5 5 17 23]);
tiledlayout(4,2,'TileSpacing','compact','Padding','compact');

% Plot four representative neurons for each panel
for k = 1:length(responsible_neuron_specific_endpoint_3S_catA)
    neuron_idx = responsible_neuron_specific_endpoint_3S_catA(k);
    nexttile
    hold on;
    axis equal;

    % Extract mean firing rate for plotting
    firing_rate_mean = mean_firing_rate_specific_endpoint_3S_catA(k, :);
    
    % Plot mean firing rate for 16 recording position
    scatter(X, Y, 20, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');   
  
    % Setting color scale for mean firing rate
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

    % Setting color scale tick
    if max_val >= 100
        tick_step = 20;
    elseif max_val >= 20
        tick_step = 10;
    elseif max_val >= 10
        tick_step = 2;
    elseif max_val >= 5
        tick_step = 1;
    elseif max_val >= 1
        tick_step = 0.2;
    else
        tick_step = 0.1;
    end

    % setting color bar
    colormap(viridis);
    range_max = ylim_fig(2);
    caxis(ylim_fig);
    cb = colorbar;
    cb.Ticks = 0:tick_step:range_max;
    set(cb, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8 ...
        ,'Color','k')

    % Setting title
    title(sprintf('Cat A Neuron #%d', neuron_idx), ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8, ...
        'Color','k');
    
    % Label the single endpoint responded position
    target_pos = specific_endpoint_representative_neuron_3S_catA(k);
    for j = 1:length(X)
        if j == target_pos
            txtColor = [1.0 0.6 0.0];   % Single endpoint responded position
        else
            txtColor = 'k';
        end

        % Label other recording positions
        if j == 3
            text(X(j), Y(j)+5, ...
            ['P-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
        elseif j == 9
        text(X(j), Y(j)+5, ...
            ['P-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
        elseif j == 15
        text(X(j)+2, Y(j)-4.5, ...
            ['P-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
        else
        text(X(j), Y(j)-4.5, ...
            ['P-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
        end
    end

    % Setting label
    if k == 7 
        xlabel('Hip joint angle [degree]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8, ...
        'Color','k'); 
        ylabel('Knee joint angle [degree]', ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8, ...
        'Color','k');  
    else
        xlabel('')
        ylabel('')
    end 
    xlim([20 120])
    ylim([40 140])
    xticks(20:20:120);
    yticks(40:20:140);
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
set(gcf, 'Renderer', 'painters'); 
print(gcf, fullfile(figureFolder, ...
    'FigureS3.emf'), ...
    '-dmeta', '-r600');
