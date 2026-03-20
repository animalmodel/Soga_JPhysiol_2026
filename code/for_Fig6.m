% For Figure 6
% Created on Mar 20 2026 
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig6_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig6_mean_firing_rate_representative_neuron_catA.mat']);
load([filePath,'data_Fig6_regression_param_representative_neuron_catA.mat']);
load([filePath,'data_Fig6_hip_and_knee_joint_catB.mat']);
load([filePath,'data_Fig6_mean_firing_rate_representative_neuron_catB.mat']);
load([filePath,'data_Fig6_regression_param_representative_neuron_catB.mat']);

%% Variables in this file
% Joint angle data
% Hip_joint_angle_16_recording_positions_catA
%   Size: [16 × 1]
%   - Description: Hip joint angle at each of the 16 recording positions in Cat A
%     Each element corresponds to the hip joint angle at a specific recording position

% Knee_joint_angle_16_recording_positions_catA
%   Size: [16 × 1]
%   - Description: Knee joint angle at each of the 16 recording positions in Cat A
%     Each element corresponds to the knee joint angle at a specific recording position

% Hip_joint_angle_16_recording_positions_catB
%   Size: [16 × 1]
%   - Description: Hip joint angle at each of the 16 recording positions in
%   Cat B. Each element corresponds to the hip joint angle at a specific recording position

% Knee_joint_angle_16_recording_positions_catB
%   Size: [16 × 1]
%   - Description: Knee joint angle at each of the 16 recording positions
%   in Cat B. Each element corresponds to the knee joint angle at a specific recording position

% Data for plotted neuron
% responsible_neuron_catA
%   Size: [3 × 1]
%   - Description: Neuron IDs in Cat A to be plotted in Figure 6

% mean_firing_rate_for_partial_R2_rep_neuron_catA
%   Size: [3 × 16]
%   - Description: Mean firing rates of representative neurons in Cat A across 16 recording positions
%     Each row corresponds to a neuron, and each column corresponds to a recording position

% responsible_neuron_catB
%   Size: [2 × 1]
%   - Description: Neuron IDs in Cat B to be plotted in Figure 6

% mean_firing_rate_for_partial_R2_rep_neuron_catB
%   Size: [2 × 16]
%   - Description: Mean firing rates of representative neurons in Cat B across 16 recording positions
%     Each row corresponds to a neuron, and each column corresponds to a recording position

% Parameters from regression analysis
% cofficient_for_representative_neuron_catA
%   Size: [3 × 4]
%     Column 1: beta0 (intercept)
%     Column 2: beta1
%     Column 3: beta2
%     Column 4: beta3
%   - Description: Regression coefficients for representative neurons in
%   Cat A
%     Each row corresponds to a neuron.

% p_value_for_partial_R2_rep_neuron_catA
%   Size: [3 × 3]
%     Column 1: significance for hip joint angle
%     Column 2: significance for knee joint angle
%     Column 3: significance for the interaction term between hip and knee joint angles
%   - Description: p-values based on partial R² for representative neurons
%   in Cat A
%     Each row corresponds to a neuron.
%     Note: This variable is not used for plotting but is provided because the values are reported in the figure legend

% R_square_for_representative_neuron_catA
%   Size: [3 × 1]
%   - Description: R-squared values for representative neurons in Cat A
%     Each row corresponds to a neuron
%     Note: This variable is not used for plotting but is provided because the values are reported in the figure legend

% cofficient_for_representative_neuron_catB
%   Size: [2 × 4]
%     Column 1: beta0 (intercept)
%     Column 2: beta1
%     Column 3: beta2
%     Column 4: beta3
%   - Description: Regression coefficients for representative neurons in
%   Cat B
%     Each row corresponds to a neuron

% p_value_for_partial_R2_rep_neuron_catB
%   Size: [2 × 3]
%     Column 1: significance for hip joint angle
%     Column 2: significance for knee joint angle
%     Column 3: significance for the interaction term between hip and knee joint angles
%   - Description: p-values based on partial R² for representative neurons
%   in Cat B
%     Each row corresponds to a neuron.
%     Note: This variable is not used for plotting but is provided because the values are reported in the figure legend

% R_square_for_representative_neuron_catB
%   Size: [2 × 1]
%   - Description: R-squared values for representative neurons in Cat B
%     Each row corresponds to a neuron.
%     Note: This variable is not used for plotting but is provided because the values are reported in the figure legend

%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% preprocessing for joint angle
% Cat A
% Centaring and normaling
% centering 
hip_joint_angle_centering_catA = Hip_joint_angle_16_recording_positions_catA-mean(Hip_joint_angle_16_recording_positions_catA);
knee_joint_angle_centering_catA = Knee_joint_angle_16_recording_positions_catA-mean(Knee_joint_angle_16_recording_positions_catA);
% normalized hip and knee angle -1 to 1
hip_joint_angle_normalized_catA = 2 * (hip_joint_angle_centering_catA(:,1) - min(hip_joint_angle_centering_catA(:,1))) / (max(hip_joint_angle_centering_catA(:,1)) - min(hip_joint_angle_centering_catA(:,1))) - 1;
knee_joint_angle_normalized_catA = 2 * (knee_joint_angle_centering_catA(:,1) - min(knee_joint_angle_centering_catA(:,1))) / (max(knee_joint_angle_centering_catA(:,1)) - min(knee_joint_angle_centering_catA(:,1))) - 1;

% make data point for surface
hip_range_catA  = linspace(min(hip_joint_angle_normalized_catA(:,1)), max(hip_joint_angle_normalized_catA(:,1)), 20);
knee_range_catA = linspace(min(knee_joint_angle_normalized_catA(:,1)), max(knee_joint_angle_normalized_catA(:,1)), 20);
[Hip_coff_catA, Knee_coff_catA] = meshgrid(hip_range_catA, knee_range_catA);

% Cat B
% Centaring and normaling
% centering 
hip_joint_angle_centering_catB = Hip_joint_angle_16_recording_positions_catB-mean(Hip_joint_angle_16_recording_positions_catB);
knee_joint_angle_centering_catB = Knee_joint_angle_16_recording_positions_catB-mean(Knee_joint_angle_16_recording_positions_catB);
% normalized hip and knee angle -1 to 1
hip_joint_angle_normalized_catB = 2 * (hip_joint_angle_centering_catB(:,1) - min(hip_joint_angle_centering_catB(:,1))) / (max(hip_joint_angle_centering_catB(:,1)) - min(hip_joint_angle_centering_catB(:,1))) - 1;
knee_joint_angle_normalized_catB = 2 * (knee_joint_angle_centering_catB(:,1) - min(knee_joint_angle_centering_catB(:,1))) / (max(knee_joint_angle_centering_catB(:,1)) - min(knee_joint_angle_centering_catB(:,1))) - 1;

% make data point for surface
hip_range_catB  = linspace(min(hip_joint_angle_normalized_catB(:,1)), max(hip_joint_angle_normalized_catB(:,1)), 20);
knee_range_catB = linspace(min(knee_joint_angle_normalized_catB(:,1)), max(knee_joint_angle_normalized_catB(:,1)), 20);
[Hip_coff_catB, Knee_coff_catB] = meshgrid(hip_range_catB, knee_range_catB);

%% Plot colormap of firing rates in joint angle space
figure('Units','centimeters','Position',[5 5 15 17],'Color','w');
tiledlayout(3,2,'TileSpacing','compact','Padding','loose'); 

for row = 1:3
    % Plot firing rate in Cat A
    if row <= length(responsible_neuron_catA)
        n = responsible_neuron_catA(row);
        nexttile((row-1)*2 + 1); hold on;

        % Extract coefficient in Cat A
        beta = cofficient_for_representative_neuron_catA(row,:);

        % Compute firing rate predictions from the regression model in Cat A
        F_model = beta(1) + beta(2)*Hip_coff_catA + beta(3)*Knee_coff_catA + beta(4)*(Hip_coff_catA .* Knee_coff_catA);
        
        % Plot firing rate predictions from the regression model in Cat A
        h = pcolor(Hip_coff_catA, Knee_coff_catA, F_model);

        % Plot mean firing rate in Cat A
        scatter(hip_joint_angle_normalized_catA(:,1), knee_joint_angle_normalized_catA(:,1), 20, mean_firing_rate_for_partial_R2_rep_neuron_catA(row,:), ...
                'filled','MarkerEdgeColor',[0.6 0.6 0.6],'LineWidth',0.75); 

        title(['CatA Neuron #' num2str(n)], 'FontName','Arial', 'FontSize',10, 'Color','k', 'FontWeight','bold');
        

       % Set color scale for mean firing rate
        max_val = max(mean_firing_rate_for_partial_R2_rep_neuron_catA(row,:),[],'all');
        if max_val > 100
            clim = [0 150];
        elseif max_val > 10
            clim = [0 ceil(max_val/20)*20];
        elseif max_val > 5
            clim = [0 ceil(max_val/5)*5];
        else
            clim = [0 ceil(max_val)];
        end

        % set color map
        set(h,'EdgeColor','none');
        colormap(viridis);
        caxis(clim); 
        c = colorbar;
        c.FontName   = 'Arial';
        c.FontWeight = 'bold';
        c.FontSize   = 8;
        c.Color = 'k'; 
       
        % Label setting
        axis([-1.1 1.1 -1.1 1.1]); axis square;
        xticks([-1 -0.5 0 0.5 1]); yticks([-1 -0.5 0 0.5 1]);
        grid on;
        ax = gca;
        ax.FontName   = 'Arial';
        ax.FontWeight = 'bold';
        ax.FontSize   = 8;
        ax.LineWidth  = 1.5;
        ax.TickDir    = 'out';
        ax.Box        = 'off';
        ax.XTickLabelRotation = 0;
        ax.XLabel.Units = 'normalized';
        ax.YLabel.Units = 'normalized';
        ax.XColor = 'k';
        ax.YColor = 'k';

        % Make label in last pannel
        if row == 3
            ax.XLabel.String = {'Normalized', 'hip joint angle'};
            ax.YLabel.String = {'Normalized', 'knee joint angle'};
            ax.XLabel.Position(2) = ax.XLabel.Position(2) ; 
            ax.YLabel.Position(1) = ax.YLabel.Position(1) ;  
            ax.XLabel.FontName   = 'Arial';
            ax.XLabel.FontSize   = 9;
            ax.XLabel.FontWeight = 'bold';
            ax.XLabel.Color      = 'k';
            ax.YLabel.FontName   = 'Arial';
            ax.YLabel.FontSize   = 9;
            ax.YLabel.FontWeight = 'bold';
            ax.YLabel.Color      = 'k';
        else
            ax.XLabel.String = '';
            ax.YLabel.String = '';
        end
    end

    % Plot firing rate in Cat B
    if row <= length(responsible_neuron_catB)
        n = responsible_neuron_catB(row);
        nexttile((row-1)*2 + 2); hold on;
        
        % Extract coefficient in Cat B
        beta = cofficient_for_representative_neuron_catB(row,:);

        % Compute firing rate predictions from the regression model in Cat B
        F_model = beta(1) + beta(2)*Hip_coff_catB + beta(3)*Knee_coff_catB + beta(4)*(Hip_coff_catB .* Knee_coff_catB);
       
        % Plot firing rate predictions from the regression model in Cat B        
        h = pcolor(Hip_coff_catB, Knee_coff_catB, F_model);
       
        % Plot mean firing rate in Cat B
        scatter(hip_joint_angle_normalized_catB(:,1), knee_joint_angle_normalized_catB(:,1), 20, mean_firing_rate_for_partial_R2_rep_neuron_catB(row,:), ...
                'filled','MarkerEdgeColor',[0.6 0.6 0.6],'LineWidth',0.75);
           
        title(['CatB Neuron #' num2str(n)], 'FontName','Arial', 'FontSize',10, 'Color','k', 'FontWeight','bold');

        % Set color scale for mean firing rate
        max_val = max(mean_firing_rate_for_partial_R2_rep_neuron_catB(row,:),[],'all');
        if max_val > 100
            clim = [0 150];
        elseif max_val > 10
            clim = [0 ceil(max_val/20)*20];
        elseif max_val > 5
            clim = [0 ceil(max_val/5)*5];
        else
            clim = [0 ceil(max_val)];
        end

         % set color map
        set(h, 'EdgeColor', 'none');
        colormap(viridis);
        caxis(clim);
        c = colorbar;
        c.FontName   = 'Arial';
        c.FontWeight = 'bold';
        c.FontSize   = 8;
        c.Color = 'k';

        % Label setting
        axis([-1.1 1.1 -1.1 1.1]); axis square;
        xticks([-1 -0.5 0 0.5 1]); yticks([-1 -0.5 0 0.5 1]);
        grid on;
        ax = gca;
        ax.FontName   = 'Arial';
        ax.FontWeight = 'bold';
        ax.FontSize   = 8;
        ax.LineWidth  = 1.5;
        ax.TickDir    = 'out';
        ax.Box        = 'off';
        ax.XTickLabelRotation = 0;
        ax.XLabel.Units = 'normalized';
        ax.YLabel.Units = 'normalized';
        ax.XColor = 'k';
        ax.YColor = 'k';
    end
end


% print and save figure
emfFileName = fullfile(figureFolder, 'Figure6.emf');
print(gcf, emfFileName, '-dmeta', '-r600');
