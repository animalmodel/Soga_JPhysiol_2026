% For Figure 9
% Created on Mar 20 2026
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., cividis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig9_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig9_PC1_PC2_PC3_score_catA.mat']);
load([filePath,'data_Fig9_hip_and_knee_joint_catB.mat']);
load([filePath,'data_Fig9_PC1_PC2_PC3_score_catB.mat']);

%% Variables in this file
% Joint angle
% Cat A
% Hip_joint_angle_16_recording_positions_catA
%   Size: [16 × 1]
%   - Description: Hip joint angle at each of the 16 recording positions in Cat A
%     Each element corresponds to the hip joint angle at a specific recording position

% Knee_joint_angle_16_recording_positions_catA
%   Size: [16 × 1]
%   - Description: Knee joint angle at each of the 16 recording positions in Cat A
%     Each element corresponds to the knee joint angle at a specific recording position

% Cat B
% Hip_joint_angle_16_recording_positions_catB
%   Size: [16 × 1]
%   - Description: Hip joint angle at each of the 16 recording positions in Cat B
%     Each element corresponds to the hip joint angle at a specific recording position

% Knee_joint_angle_16_recording_positions_catB
%   Size: [16 × 1]
%   - Description: Knee joint angle at each of the 16 recording positions in Cat B
%     Each element corresponds to the knee joint angle at a specific recording position

% Parameter for PCA
% Cat A
% PC1_PC2_PC3_explained_value_catA
%   Size: [1 × 3]
%   - Description: Explained variance ratios of PC1, PC2, and PC3 in Cat A
%     Each element corresponds to the proportion of variance explained by each principal component

% PC1_PC2_PC3_score_catA
%   Size: [16 × 3]
%   - Description: PCA scores for the 16 recording positions in Cat A
%     Each row corresponds to a recording position, and each column corresponds to PC1, PC2, and PC3.

% Cat B
% PC1_PC2_PC3_explained_value_catB
%   Size: [1 × 3]
%   - Description: Explained variance ratios of PC1, PC2, and PC3 in Cat B
%     Each element corresponds to the proportion of variance explained by each principal component

% PC1_PC2_PC3_score_catB
%   Size: [16 × 3]
%   - Description: PCA scores for the 16 recording positions in Cat B
%     Each row corresponds to a recording position, and each column corresponds to PC1, PC2, and PC3.

%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% Plot Figure 9A (Cat A PCA score space) 

% --- View angle settings ---
az_angle_catA = 45;   % azimuth angle
el_angle_catA = 20;   % elevation angle

% Extract joint angles 
X_catA = Hip_joint_angle_16_recording_positions_catA;
Y_CatA = Knee_joint_angle_16_recording_positions_catA;

% Sort indices based on joint angles
[~, sortIdx_X] = sort(X_catA, 'ascend'); % hip joint
[~, sortIdx_Y] = sort(Y_CatA, 'ascend'); % knee joint

% Divide 16 postures into two groups (8 points each)
base_groups_2_catA = [repmat(1,1,8), repmat(2,1,8)];

% (A) Grouping based on sorted hip joint angles
group_logic_X_catA = zeros(1,16);
group_logic_X_catA(sortIdx_X) = base_groups_2_catA;

% (B) Grouping based on sorted knee joint angles
group_logic_Y_catA = zeros(1,16);
group_logic_Y_catA(sortIdx_Y) = base_groups_2_catA;

% Store grouping patterns
groups_to_plot_catA = {group_logic_X_catA, group_logic_Y_catA};

% Figure settings
fig = figure('Units', 'centimeters', 'Position', [2, 2, 13, 8]);
tlo = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% --- Marker styles for groups ---
marker_styles = {'o', '^'};

% --- Panel titles ---
panel_labels = {'Cat A', 'Cat A'};

% Colormap setting for 16 recording positions
try
    colors = cividis(16);
catch
    colors = [linspace(0,0.9,16)', linspace(0.1,0.8,16)', linspace(0.3,0.5,16)'];
end

% Plot each panel
for i = 1:2
    nexttile;
    hold on;

    current_group = groups_to_plot_catA{i};

    % Scatter plot for each posture
    for j = 1:16
        m_idx = current_group(j);

        scatter3(PC1_PC2_PC3_score_catA(j,1), ...
                 PC1_PC2_PC3_score_catA(j,2), ...
                 PC1_PC2_PC3_score_catA(j,3), ...
                 25, ...
                 'Marker', marker_styles{m_idx}, ...
                 'MarkerFaceColor', colors(j,:), ...
                 'MarkerEdgeColor', [0.1 0.1 0.1], ...
                 'LineWidth', 0.8);

        % Add posture labels (P1–P16) with manual offsets
        if j == 1 || j == 2
            offset = [-0.15, 0.05, 0];
        elseif j == 3
            offset = [-0.3, -0.3, -0.25];
        elseif j == 4
            offset = [-0.15, 0, -0.1];
        elseif j == 6 || j == 7 || j == 8
            offset = [-1, 0, 0.1];
        elseif j == 9
            offset = [-0.05, -0.40, -0.2];
        elseif j == 10
            offset = [-0.5, -0.8, -0.2];
        elseif j == 11
            offset = [-2.3, -0.25, -0.48];
        elseif j == 12
            offset = [-1, 0, 0.15];
        elseif j == 14
            offset = [-2.05, -0.135, -0.2];
        elseif j == 15
            offset = [-2.15, -0.15, -0.5];
        elseif j == 16
            offset = [-1.35, 0.15, 0];
        else
            offset = [-0.4, -0.65, -0.2];
        end

        text(PC1_PC2_PC3_score_catA(j,1)+offset(1), ...
             PC1_PC2_PC3_score_catA(j,2)+offset(2), ...
             PC1_PC2_PC3_score_catA(j,3)+offset(3), ...
             ['  P' num2str(j)], ...
             'FontSize', 8, ...
             'FontWeight', 'bold', ...
             'Color', [0 0 0], ...
             'Clipping', 'off');
    end

    % Axis settings
    grid on; box on; axis tight;
    ax = gca;
    ax.FontSize = 8;
    ax.FontWeight = 'bold';
    ax.TickDir = 'out';
    ax.LineWidth = 1.2;
    ax.FontName = 'Arial';
    ax.XColor = [0 0 0];
    ax.YColor = [0 0 0];
    ax.ZColor = [0 0 0];
    ax.GridColor = [0 0 0];
    ax.GridAlpha = 0.1;
    ax.GridLineStyle = '-';

    % Axis labels (only for first panel)
    if i == 1
        xlabel(['PC1 (' num2str(PC1_PC2_PC3_explained_value_catA(1),'%.1f') '%)'], ...
            'FontSize', 8, 'FontName','Arial', 'FontWeight','bold');

        ylabel(['PC2 (' num2str(PC1_PC2_PC3_explained_value_catA(2),'%.1f') '%)'], ...
            'FontSize', 8, 'FontName','Arial', 'FontWeight','bold');

        zlabel(['PC3 (' num2str(PC1_PC2_PC3_explained_value_catA(3),'%.1f') '%)'], ...
            'FontSize', 8, 'FontName','Arial', 'FontWeight','bold');
    end

    % Title
    title(panel_labels{i}, 'FontSize', 12, 'FontName', 'Arial', 'FontWeight','bold');

    % Set view angle
    view(az_angle_catA, el_angle_catA);

    % Add colorbar (right panel only) 
    if i == 2
        colormap(gca, colors);
        cb = colorbar;
        cb.FontSize = 9;
        cb.LineWidth = 1;

        cb.Ticks = 1:16;
        cb.TickLabels = 1:16;
        caxis([1 16]);
    end
end

% Print and save figure
export_path = fullfile(figureFolder, 'Figure9A.emf');
set(gcf, 'PaperUnits', 'centimeters', ...
         'PaperPosition', [0 0 13 8]);
set(gcf, 'Renderer', 'painters'); 
print(gcf, export_path, '-dmeta'); 

%% Plot Figure 9B (Cat B PCA score space)

% --- View angle settings ---
az_angle = 50;   % azimuth angle
el_angle = 30;   % elevation angle

% --- Extract joint angles ---
X_catB = Hip_joint_angle_16_recording_positions_catB;
Y_catB = Knee_joint_angle_16_recording_positions_catB;

% --- Sort indices based on joint angles ---
[~, sortIdx_X] = sort(X_catB, 'ascend'); % hip joint
[~, sortIdx_Y] = sort(Y_catB, 'ascend'); % knee joint

% --- Divide 16 postures into two groups (8 points each) ---
base_groups_2_catB = [repmat(1,1,8), repmat(2,1,8)];

% (A) Grouping based on sorted hip joint angles
group_logic_X_catB = zeros(1,16);
group_logic_X_catB(sortIdx_X) = base_groups_2_catB;

% (B) Grouping based on sorted knee joint angles
group_logic_Y_catB = zeros(1,16);
group_logic_Y_catB(sortIdx_Y) = base_groups_2_catB;

% Store grouping patterns
groups_to_plot_catB = {group_logic_X_catB, group_logic_Y_catB};

% Figure settings
fig = figure('Units', 'centimeters', 'Position', [2, 2, 13, 8]);
tlo = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Marker styles for groups
marker_styles = {'o', '^'};

% Panel titles
panel_labels = {'Cat B', 'Cat B'};

% Colormap setting for 16 recording positions
try
    colors = cividis(16);
catch
    colors = [linspace(0,0.9,16)', linspace(0.1,0.8,16)', linspace(0.3,0.5,16)'];
end

% Plot each panel
for i = 1:2
    nexttile;
    hold on;

    current_group = groups_to_plot_catB{i};

    % Scatter plot for each posture
    for j = 1:16
        m_idx = current_group(j);

        scatter3(PC1_PC2_PC3_score_catB(j,1), ...
                 PC1_PC2_PC3_score_catB(j,2), ...
                 PC1_PC2_PC3_score_catB(j,3), ...
                 25, ...
                 'Marker', marker_styles{m_idx}, ...
                 'MarkerFaceColor', colors(j,:), ...
                 'MarkerEdgeColor', [0.1 0.1 0.1], ...
                 'LineWidth', 0.8);

        % Add posture labels (P1–P16) with manual offsets
        if j == 1
            offset = [-0.05, -0.05, 0];
        elseif j == 3 || j == 8
            offset = [-0.42, -0.46, 0.2];
        elseif j == 4
            offset = [-0.1, -0.1, 0.15];
        elseif j == 5
            offset = [-0.1, -0.1, 0.1];
        elseif j == 7 || j == 10
            offset = [-0.22, -0.26, -0.15];
        elseif j == 12
            offset = [-0.4, -0.5, -0.15];
        elseif j == 11 || j == 14
            offset = [-0.7, -0.7, 0.0275];
        elseif j == 15 || j == 16
            offset = [-0.05, -0.05, 0];
        else
            offset = [-0.22, -0.26, 0.2];
        end

        text(PC1_PC2_PC3_score_catB(j,1)+offset(1), ...
             PC1_PC2_PC3_score_catB(j,2)+offset(2), ...
             PC1_PC2_PC3_score_catB(j,3)+offset(3), ...
             ['  P' num2str(j)], ...
             'FontSize', 8, ...
             'FontWeight', 'bold', ...
             'Color', [0 0 0], ...
             'Clipping', 'off');
    end

    % Axis settings
    grid on; box on; axis tight;
    ax = gca;
    ax.FontSize = 8;
    ax.FontWeight = 'bold';
    ax.TickDir = 'out';
    ax.LineWidth = 1.2;
    ax.FontName = 'Arial';
    ax.XColor = [0 0 0];
    ax.YColor = [0 0 0];
    ax.ZColor = [0 0 0];
    ax.GridColor = [0 0 0];
    ax.GridAlpha = 0.1;
    ax.GridLineStyle = '-';

    % Axis limits
    zlim([-1.25 1.25]);

    % Axis labels (only for first panel)
    if i == 1
        xlabel(['PC1 (' num2str(PC1_PC2_PC3_explained_value_catB(1),'%.1f') '%)'], ...
            'FontSize', 8, 'FontName','Arial', 'FontWeight','bold');

        ylabel(['PC2 (' num2str(PC1_PC2_PC3_explained_value_catB(2),'%.1f') '%)'], ...
            'FontSize', 8, 'FontName','Arial', 'FontWeight','bold');

        zlabel(['PC3 (' num2str(PC1_PC2_PC3_explained_value_catB(3),'%.1f') '%)'], ...
            'FontSize', 8, 'FontName','Arial', 'FontWeight','bold');
    end

    % Title
    title(panel_labels{i}, 'FontSize', 12, 'FontName', 'Arial', 'FontWeight','bold');

    % Set view angle
    view(az_angle, el_angle);

    % Add colorbar (right panel only)
    if i == 2
        colormap(gca, colors);
        cb = colorbar;
        cb.FontSize = 9;
        cb.LineWidth = 1;

        cb.Ticks = 1:16;
        cb.TickLabels = 1:16;
        caxis([1 16]);
    end
end

% Print and save figure
export_path = fullfile(figureFolder, 'Figure9B.emf');
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 13 8]);
set(gcf, 'Renderer', 'painters');  
print(gcf, export_path, '-dmeta'); 




