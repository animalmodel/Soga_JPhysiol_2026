% For Figure 8
% Created on Mar 20 2026
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig8_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig8_firing_rate_representative_endpoint_neuron_catA.mat']);
%
load([filePath,'data_Fig8-2_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig8-2_mean_firing_rate_representative_endpoint_neuron_catA.mat']);
%
load([filePath,'data_Fig8_hip_and_knee_joint_catB.mat']);
load([filePath,'data_Fig8_firing_rate_representative_endpoint_neuron_catB.mat']);

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
%   Size: [4 × 1]
%   - Description: Neuron IDs in Cat A to be plotted in Figure 8

% specific_endpoint_representative_neuron_catA
%   Size: [4 × 1]
%   - Description: Representative neurons in Cat A that respond to specific endpoints, to be plotted in Figure 8.

% firing_rate_specific_endpoint_catA
%   Size: [4 × 16]
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
% Cat A
X_catA = Hip_joint_angle_16_recording_positions_catA;
Y_catA = Knee_joint_angle_16_recording_positions_catA;
% Cat B
X_catB = Hip_joint_angle_16_recording_positions_catB;
Y_catB = Knee_joint_angle_16_recording_positions_catB;

% Plot single endpoint responsive neurons
figure('Units','centimeters','Position',[5 5 18 21]);
tiledlayout(4,3,'TileSpacing','compact','Padding','compact');

%% Cat A-1
mean_firing_rate_specific_endpoint_catA = zeros(2,16);
std_for_specific_endpoint_neuron_catA = zeros(2,16);
for i = 1:2
    mean_firing_rate_specific_endpoint_catA(i,:) = mean(firing_rate_specific_endpoint_catA{i},1);
    std_for_specific_endpoint_neuron_catA(i,:) = std(firing_rate_specific_endpoint_catA{i},[],1);
end

% Plot representative neurons for each panel
for k = 1:2
    nexttile
    hold on;
    axis equal
    neuron_idx = responsible_neuron_specific_endpoint_catA(k);
    % Extract mean firing rate for plotting
    firing_rate_mean = mean_firing_rate_specific_endpoint_catA(k,:);
    firing_rate_std  = std_for_specific_endpoint_neuron_catA(k,:);
    X_catAB = X_catA;
    Y_catAB = Y_catA;
    % Plot mean firing rate for 16 recording position
    scatter(X_catAB, Y_catAB, 40, firing_rate_mean, 'filled', 'MarkerEdgeColor', 'k');
    scale = 30;  
    scatter(X_catAB, Y_catAB, firing_rate_std * scale, ...
        'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.5 0.5 0.5], ...
        'LineWidth', 1.5);

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

    % setting color bar
    colormap(viridis);
    caxis(ylim_fig);
    cb = colorbar;
    set(cb, 'FontName','Arial', 'FontWeight','bold', 'FontSize',8, 'Color','k')
    % Setting title
    title(sprintf('Cat A Neuron #%d', neuron_idx), 'FontWeight','bold', 'FontName','Arial', 'FontSize',8, 'Color','k');

    % Label the single endpoint responded position
    target_pos = specific_endpoint_representative_neuron_catA(k,1);
    for j = 1:length(X_catAB)
        if j == target_pos
            txtColor = [1.0 0.6 0.0];   % Single endpoint responded position
        else
            txtColor = 'k';
        end

        % Label other recording positions
        textXPos = X_catAB(j)+2;
        textYPos = Y_catAB(j)-7;
        if j == 1
            textXPos = textXPos+5;
        elseif j == 3
            textXPos = X_catAB(j)+1;
            textYPos = Y_catAB(j)+4;
        elseif j == 4
            textXPos = X_catAB(j)+14;
            textYPos = Y_catAB(j);
        elseif j == 5
            textYPos = textYPos+1;
        elseif j == 6
            textYPos = textYPos+1;
        elseif j == 8
            textXPos = textXPos-2;
            if k==1, textYPos = textYPos+2.5; end
        elseif j == 9
            textXPos = X_catAB(j)+1;
            textYPos = Y_catAB(j)+5;
        elseif j == 15
            textXPos = X_catAB(j)+3;
            textYPos = Y_catAB(j)-5;
        elseif j == 10
            if k==2, textYPos = textYPos-1; end
        elseif j == 11
            if k==2, textYPos = textYPos-1; end
        elseif j == 12
            if k==2, textYPos = textYPos-1; end
        elseif j == 13
            if k==1
                textXPos = textXPos-1;
                textYPos = textYPos+2;
            end
        elseif j == 14
            textXPos = textXPos -2;
            textYPos = Y_catAB(j)+5;
        elseif j == 16
            textYPos = textYPos-1;
        end
        text(textXPos, textYPos, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    end
    set(gca, 'FontName','Arial', 'FontWeight','bold', 'FontSize',8, 'TickDir','out', 'LineWidth',1.2, 'XColor','k', 'YColor','k')
end

%% Cat A 2
% Plot four representative neurons for each panel
for k = 1:length(responsible_neuron_specific_endpoint_3S_catA)
    neuron_idx = responsible_neuron_specific_endpoint_3S_catA(k);
    nexttile
    hold on;
    axis equal;

    % Extract mean firing rate for plotting
    firing_rate_mean = mean_firing_rate_specific_endpoint_3S_catA(k, :);
    firing_rate_std  = std_firing_rate_specific_endpoint_3S_catA(k, :);
    
    % Plot mean firing rate for 16 recording position
    scatter(X_catA, Y_catA, 40, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');   
    scale = 30;  
    scatter(X_catA(firing_rate_std~=0), Y_catA(firing_rate_std~=0), firing_rate_std(firing_rate_std~=0) * scale, ...
        'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.5 0.5 0.5], 'LineWidth', 1.5); 

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
    for j = 1:length(X_catA)
        if j == target_pos
            txtColor = [1.0 0.6 0.0];   % Single endpoint responded position
        else
            txtColor = 'k';
        end

        % Label other recording positions
        textXPos = X_catA(j);
        textYPos = Y_catA(j)-8;
        if k==2 || k==3
            textYPos = Y_catA(j)-5;
        end


        if j == 1
            textXPos = X_catA(j)+11;
            textYPos = Y_catA(j)+0;
        elseif j == 3
            textXPos = X_catA(j)-10;
            textYPos = Y_catA(j)+0;
        elseif j == 9
            textYPos = Y_catA(j)+5;
        elseif j == 15
            textXPos = X_catA(j)+2;
        else
        end
        text(textXPos, textYPos, ...
            ['P-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
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


%% Cat B 1
mean_firing_rate_specific_endpoint_catB = zeros(2,16);
std_for_specific_endpoint_neuron_catB = zeros(2,16);
for i = 1:2
    mean_firing_rate_specific_endpoint_catB(i,:) = mean(firing_rate_specific_endpoint_catB{i},1);
    std_for_specific_endpoint_neuron_catB(i,:) = std(firing_rate_specific_endpoint_catB{i},[],1);
end

% Plot four representative neurons for each panel
for k = 1:2
    nexttile
    hold on;
    axis square
    neuron_idx = responsible_neuron_specific_endpoint_catB_for_fig8(k);
    % Extract mean firing rate for plotting
    firing_rate_mean = mean_firing_rate_specific_endpoint_catB(k,:);
    firing_rate_std  = std_for_specific_endpoint_neuron_catB(k,:);
    X_catAB = X_catB;
    Y_catAB = Y_catB;
    % Plot mean firing rate for 16 recording position
    scatter(X_catAB, Y_catAB, 40, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');
    scale = 30; 
    scatter(X_catAB, Y_catAB, firing_rate_std * scale, ...
        'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.5 0.5 0.5], ...
        'LineWidth', 1.5);
    %- -

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

    % setting color bar
    colormap(viridis);
    caxis(ylim_fig);
    cb = colorbar;
    set(cb, 'FontName','Arial', 'FontWeight','bold', 'FontSize',8, 'Color','k')
    title(sprintf('Cat B Neuron #%d', neuron_idx), 'FontWeight','bold', 'FontName','Arial', 'FontSize',8, 'Color','k');

    target_pos = specific_endpoint_representative_neuron_catB(k,1);
    for j = 1:length(X_catAB)
        if j == target_pos
            txtColor = [1.0 0.6 0.0];   % Single endpoint responded position
        else
            txtColor = 'k';
        end
        % Label other recording positions
        textXPos = X_catAB(j);
        textYPos = Y_catAB(j)-7;
        if j == 1
            textXPos = X_catAB(j);
            textYPos = Y_catAB(j)-8;
        elseif j == 2
            textXPos = X_catAB(j)+5;
            textYPos = Y_catAB(j)+0;
        elseif j == 5
            textXPos = X_catAB(j);
            textYPos = Y_catAB(j) +5.5;
        elseif j == 6
            textXPos = X_catAB(j) +1;
            textYPos = Y_catAB(j) +7;
        elseif j == 7
            textXPos = textXPos-3;
        elseif j == 8
            textXPos = X_catAB(j)-6.5;
            textYPos = Y_catAB(j);
        elseif j == 9
            textXPos = X_catAB(j);
            textYPos = Y_catAB(j) -7;
        elseif j == 10
            textXPos = X_catAB(j) -0.5;
            textYPos = Y_catAB(j) -5;
        elseif j == 11
            textXPos = X_catAB(j) +2;
            textYPos = Y_catAB(j) -5;
        elseif j == 13
            textXPos = textXPos-0.5;
            textYPos = textYPos+1;
        elseif j == 14
            textXPos = X_catAB(j) -2;
            textYPos = Y_catAB(j) -5;
        elseif j == 15
            textXPos = X_catAB(j);
            textYPos = Y_catAB(j) +7;
        end
        text(textXPos, textYPos, ...
            ['Pos-', num2str(j)], ...
            'FontWeight','bold', ...
            'FontSize', 8, ...
            'HorizontalAlignment','center', ...
            'FontName','Arial', ...
            'Color', txtColor);
    end

    % Setting label
    xlabel('')
    ylabel('')
    xlim([60 110])
    % xlim([40 140])
    ylim([40 140])
    xticks(60:20:100);
    % xticks(40:20:140);
    yticks(20:20:120);
    set(gca, 'FontName','Arial', 'FontWeight','bold', 'FontSize',8, 'TickDir','out', 'LineWidth',1.2, 'XColor','k', 'YColor','k')
end

%% Cat B-2
%
load([filePath,'data_Fig8-2_hip_and_knee_joint_catB.mat']);
load([filePath,'data_Fig8-2_mean_firing_rate_representative_endpoint_neuron_catB.mat']);
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
    scale = 30; 
    scatter(X_catB(firing_rate_std~=0), Y_catB(firing_rate_std~=0), firing_rate_std(firing_rate_std~=0) * scale, ...
        'MarkerFaceColor', 'none', 'MarkerEdgeColor', [0.5 0.5 0.5], ...
        'LineWidth', 1.5);
    scatter(X_catB, Y_catB, 40, firing_rate_mean, ...
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
    target_pos = specific_endpoint_representative_neuron_catB(k);
    for j = 1:length(X_catB)

        if j == target_pos
            txtColor = [1.0 0.6 0.0];    % Single endpoint responded position
        else
            txtColor = 'k';
        end

        textXPos = X_catB(j);
        textYPos = Y_catB(j) - 8;
        % Label other recording positions
        if j == 1
            textYPos = textYPos -1;
        elseif j == 2
            textXPos = X_catB(j) +5;
            textYPos = Y_catB(j) +5;
        elseif j == 5
            textYPos = Y_catB(j) +7;
        elseif j == 6
            textXPos = X_catB(j) +1;
            textYPos = Y_catB(j) +7;
        elseif j == 7
            textXPos = textXPos -1;
            textYPos = textYPos +1;
        elseif j == 8
            textXPos = X_catB(j) +5;
            textYPos = Y_catB(j) ;
        elseif j == 10
            textXPos = X_catB(j)-0.5;
            textYPos = Y_catB(j) -7;
        elseif j == 11
            textXPos = X_catB(j)+2; 
            textYPos = Y_catB(j)-7;
        elseif j == 13
            textXPos = textXPos -1;
        elseif j == 14
            textXPos = X_catB(j)-1.5;
            textYPos = Y_catB(j) -8;
        elseif j == 15
            textYPos = Y_catB(j) +8;
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
    if k == 2
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
print(gcf, fullfile(figureFolder, 'Figure8.emf'), '-dmeta', '-r600');

