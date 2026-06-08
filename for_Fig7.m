% For Figure 7
% Created on Mar 20 2026
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig7_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig7_firing_rate_representative_endpoint_neuron_catA.mat']);
load([filePath,'data_Fig7_hip_and_knee_joint_catB.mat']);
load([filePath,'data_Fig7_firing_rate_representative_endpoint_neuron_catB.mat']);
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

%% Calculate mean firing rate and std
% Cat A
mean_firing_rate_specific_endpoint_catA = zeros(2,16);
std_for_specific_endpoint_neuron_catA = zeros(2,16);
for i = 1:2
    mean_firing_rate_specific_endpoint_catA(i,:) = mean(firing_rate_specific_endpoint_catA{i},1);
    std_for_specific_endpoint_neuron_catA(i,:) = std(firing_rate_specific_endpoint_catA{i},[],1);
end

% Cat B
mean_firing_rate_specific_endpoint_catB = zeros(2,16);
std_for_specific_endpoint_neuron_catB = zeros(2,16);
for i = 1:2
    mean_firing_rate_specific_endpoint_catB(i,:) = mean(firing_rate_specific_endpoint_catB{i},1);
    std_for_specific_endpoint_neuron_catB(i,:) = std(firing_rate_specific_endpoint_catB{i},[],1);
end
%% Plot single endpoint responsive neurons
figure('Units','centimeters','Position',[5 5 17 16]);
tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

% Plot four representative neurons for each panel
for k = 1:4
    nexttile
    hold on;
    if(k<=2)
        axis equal
        neuron_idx = responsible_neuron_specific_endpoint_catA(k);
        % Extract mean firing rate for plotting
        firing_rate_mean = mean_firing_rate_specific_endpoint_catA(k,:);
        firing_rate_std  = std_for_specific_endpoint_neuron_catA(k,:);
        X_catAB = X_catA;
        Y_catAB = Y_catA;

    else
        axis square
        % neuron_idx = responsible_neuron_specific_endpoint_catB(k);
        neuron_idx = responsible_neuron_specific_endpoint_catB_for_fig8(k-2);
        % Extract mean firing rate for plotting
        firing_rate_mean = mean_firing_rate_specific_endpoint_catB(k-2,:);
        firing_rate_std  = std_for_specific_endpoint_neuron_catB(k-2,:);
        X_catAB = X_catB;
        Y_catAB = Y_catB;
    end
    % Plot mean firing rate for 16 recording position
    scatter(X_catAB, Y_catAB, 40, firing_rate_mean, ...
        'filled', 'MarkerEdgeColor', 'k');
    %
    scale = 50;  % 
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
    set(cb, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8, ...
        'Color','k')

    % Setting title
    if(k<=2)
        title(sprintf('Cat A Neuron #%d', neuron_idx), ...
            'FontWeight','bold', ...
            'FontName','Arial', ...
            'FontSize',8, ...
            'Color','k');
    else
        title(sprintf('Cat B Neuron #%d', neuron_idx), ...
            'FontWeight','bold', ...
            'FontName','Arial', ...
            'FontSize',8, ...
            'Color','k');
    end

    % Label the single endpoint responded position
    if(k<=2)
        target_pos = specific_endpoint_representative_neuron_catA(k,1);
    else
        target_pos = specific_endpoint_representative_neuron_catB(k-2,1);
    end
    for j = 1:length(X_catAB)
        if j == target_pos
            txtColor = [1.0 0.6 0.0];   % Single endpoint responded position
        else
            txtColor = 'k';
        end

        % Label other recording positions
        if(k<=2) % Cat A
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
        else % Cat B
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
    if(k<=2)
        xlim([20 120])
        ylim([40 140])
        xticks(20:20:120);
        yticks(40:20:140);
    else
        xlim([60 110])
        ylim([40 140])
        xticks(60:20:100);
        yticks(20:20:120);
    end
    set(gca, ...
        'FontName','Arial', ...
        'FontWeight','bold', ...
        'FontSize',8, ...
        'TickDir','out', ...
        'LineWidth',1.2, ...
        'XColor','k', ...
        'YColor','k')
end

% Print and save figure
print(gcf, fullfile(figureFolder, ...
    'Figure7.emf'), ...
    '-dmeta', '-r600');

