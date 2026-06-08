% For Figure S4
% Created on Mar 20 2026
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_FigS4_hip_and_knee_joint_catB.mat']);
load([filePath,'data_FigS4_mean_firing_rate_representative_endpoint_neuron_catB.mat']);

%% Variables in this file
% Hip_joint_angle_16_recording_positions_catB
%   Size: [16 × 1]
%   - Description: Hip joint angle at each of the 16 recording positions in Cat B
%     Each element corresponds to the hip joint angle at a specific recording position

% Knee_joint_angle_16_recording_positions_catB
%   Size: [16 × 1]
%   - Description: Knee joint angle at each of the 16 recording positions in Cat B
%     Each element corresponds to the knee joint angle at a specific recording position

% responsible_neuron_specific_endpoint_S4_catB
%   Size: [7 × 1]
%   - Description: Neuron IDs in Cat B to be plotted in Figure S4

% specific_endpoint_representative_neuron_4S_catB
%   Size: [7 × 1]
%   - Description: Representative neurons in Cat B that respond to specific
%   endpoints, to be plotted in Figure S4

% mean_firing_rate_specific_endpoint_4S_catB
%   Size: [7 × 16]
%   - Description: Mean firing rates of representative neurons in Cat B across 16 recording positions
%     Each row corresponds to a neuron, and each column corresponds to a recording position

%% make folder for save
currentFolder = pwd;
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% Preprocessing
% Set X label hip joint angle, Y label knee joint angle
X = Hip_joint_angle_16_recording_positions_catB;
Y = Knee_joint_angle_16_recording_positions_catB;

%% Plot single endpoint responsive neurons
figure('Units','centimeters','Position',[5 5 17 23]);
tiledlayout(4,2,'TileSpacing','compact','Padding','compact');

% Plot four representative neurons for each panel
for k = 1:length(responsible_neuron_specific_endpoint_S4_catB)
    neuron_idx = responsible_neuron_specific_endpoint_S4_catB(k);
    nexttile
    hold on;
    axis equal
    axis square
    pbaspect([1 1 1])

    % Extract mean firing rate for plotting
    firing_rate_mean = firing_rate_specific_endpoint_catB(k,:);
    firing_rate_std  = std_firing_rate_specific_endpoint_catB(k, :);
    %
    scale = 50;  % 
    scatter(X(firing_rate_std~=0), Y(firing_rate_std~=0), firing_rate_std(firing_rate_std~=0) * scale, ...
        'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.5 0.5 0.5], ...
        'LineWidth', 1.5); 
    scatter(X, Y, 40, firing_rate_mean, ...
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
    elseif max_val >= 40
        tick_step = 10;
    elseif max_val >= 20
        tick_step = 5;
    elseif max_val >= 10
        tick_step = 2;
    elseif max_val >= 5
        tick_step = 1;
    elseif max_val >= 1
        tick_step = 0.5;
    else
        tick_step = 0.1;
    end

    % setting color bar
    colormap(viridis);
    caxis(ylim_fig);
    cb = colorbar;
    range_max = ylim_fig(2);
    cb.Ticks = 0:tick_step:range_max;
    set(cb, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8 ...
        ,'Color','k')

    % Setting title
    title(sprintf('Cat B Neuron #%d', neuron_idx), ...
        'FontWeight','bold', ...
        'FontName','Arial', ...
        'FontSize',8 ...
        ,'Color','k');

    % Label the single endpoint responded position
    % target_pos = specific_endpoint_representative_neuron_4S_catB(k);
    target_pos = specific_endpoint_representative_neuron_catB(k);
    for j = 1:length(X)

        if j == target_pos
            txtColor = [1.0 0.6 0.0];    % Single endpoint responded position
        else
            txtColor = 'k';
        end

        textXPos = X(j);
        textYPos = Y(j) - 8;
        % Label other recording positions
        if j == 1
            textYPos = textYPos -1;
        elseif j == 2
            textXPos = X(j) +5;
            textYPos = Y(j) +5;
        elseif j == 5
            textYPos = Y(j) +7;
        elseif j == 6
            textXPos = X(j) +1;
            textYPos = Y(j) +7;
        elseif j == 7
            textXPos = textXPos -1;
            textYPos = textYPos +1;
        elseif j == 8
            textXPos = X(j) +5;
            textYPos = Y(j) ;
        elseif j == 10
            textXPos = X(j)-0.5;
            textYPos = Y(j) -7;
        elseif j == 11
            textXPos = X(j)+2; 
            textYPos = Y(j)-7;
        elseif j == 13
            textXPos = textXPos -1;
        elseif j == 14
            textXPos = X(j)-1.5;
            textYPos = Y(j) -8;
        elseif j == 15
            textYPos = Y(j) +8;
        end
        text(textXPos, textYPos, ...
            ['P-', num2str(j)], ...
            'FontWeight', 'bold',...
            'FontSize', 8, ...
            'HorizontalAlignment', 'center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    end

    % Setting label
    if k == 3
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
    xlim([60 110])
    ylim([40 140])
    ax = gca;
    ax.XTick = 60:20:100;
    ax.YTick = 20:20:120;
    set(gca, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8, ...
        'LineWidth',1.5, ...
        'TickDir','out', ...
        'XColor','k', ...
        'YColor','k')
end

% Print and save figure
set(gcf, 'Renderer', 'painters');
print(gcf, fullfile(figureFolder, ...
    'FigureS4B.emf'), ...
    '-dmeta', '-r600');