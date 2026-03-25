% For Figure 7
% Created on Mar 20 2026
% @author:Yuta Soga

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig7_hip_and_knee_joint_catA.mat']);
load([filePath,'data_Fig7_mean_firing_rate_72_neurons_catA.mat']);
load([filePath,'data_Fig7_regression_param_72_neurons_catA.mat']);
load([filePath,'data_Fig7_hip_and_knee_joint_catB.mat']);
load([filePath,'data_Fig7_mean_firing_rate_136_neurons_catB.mat']);
load([filePath,'data_Fig7_regression_param_136_neurons_catB.mat']);

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


% Mean_firing_rate_72_neurons_in_catA_16_recording_position
%   Size: [72 × 16]
%   - Description: Mean firing rates of all recoeded neurons (72 neurons) in Cat A across 16 recording positions
%     Each row corresponds to a neuron, and each column corresponds to a recording position

% Mean_firing_rate_136_neurons_in_catB_16_recording_position
%   Size: [136 × 16]
%   - Description: Mean firing rates of all recoeded neurons (136 neurons) in Cat B across 16 recording positions
%     Each row corresponds to a neuron, and each column corresponds to a recording position


% Parameters from regression analysis
% cofficient_for_72_neurons_catA
%   Size: [72 × 4]
%     Column 1: beta0 (intercept)
%     Column 2: beta1
%     Column 3: beta2
%     Column 4: beta3
%   - Description: Regression coefficients for all recoeded neurons (72 neurons) in
%   Cat A
%     Each row corresponds to a neuron.

% All_neuron_pval_by_particular_R_for_72_neurons
%   Size: [72 × 3]
%     Column 1: significance for hip joint angle
%     Column 2: significance for knee joint angle
%     Column 3: significance for the interaction term between hip and knee joint angles
%   - Description: p-values based on partial R² for all recoeded neurons (72 neurons)
%   in Cat A
%     Each row corresponds to a neuron

% Rsq_multi_hip_knee_inter_cross_for_72_neurons
%   Size: [72 × 1]
%   - Description: R-squared values for all recoeded neurons (72 neurons) in Cat A
%     Each row corresponds to a neuron

% cofficient_for_136_neurons_catB
%   Size: [136 × 4]
%     Column 1: beta0 (intercept)
%     Column 2: beta1
%     Column 3: beta2
%     Column 4: beta3
%   - Description: Regression coefficients for all recoeded neurons (136 neurons) in
%   Cat B
%     Each row corresponds to a neuron.

% All_neuron_pval_by_particular_R_for_136_neurons_catB
%   Size: [136 × 3]
%     Column 1: significance for hip joint angle
%     Column 2: significance for knee joint angle
%     Column 3: significance for the interaction term between hip and knee joint angles
%   - Description: p-values based on partial R² for all recoeded neurons (136 neurons)
%   in Cat B
%     Each row corresponds to a neuron

% Rsq_multi_hip_knee_inter_cross_for_136_neurons_catB
%   Size: [136 × 1]
%   - Description: R-squared values for all recoeded neurons (136 neurons) in Cat B
%     Each row corresponds to a neuron

%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% preprocessing for joint angle
% Cat A
% centering 
hip_joint_angle_centering_catA = Hip_joint_angle_16_recording_positions_catA - mean(Hip_joint_angle_16_recording_positions_catA);
knee_joint_angle_centering_catA = Knee_joint_angle_16_recording_positions_catA - mean(Knee_joint_angle_16_recording_positions_catA);
% normalized hip and knee angle -1 to 1
hip_joint_angle_normalized_catA = 2 * (hip_joint_angle_centering_catA(:,1) - min(hip_joint_angle_centering_catA(:,1))) / ...
                                 (max(hip_joint_angle_centering_catA(:,1)) - min(hip_joint_angle_centering_catA(:,1))) - 1;
knee_joint_angle_normalized_catA = 2 * (knee_joint_angle_centering_catA(:,1) - min(knee_joint_angle_centering_catA(:,1))) / ...
                                  (max(knee_joint_angle_centering_catA(:,1)) - min(knee_joint_angle_centering_catA(:,1))) - 1;

% Separate neuron by joint responded in Cat A
nNeurons_catA = length(Rsq_multi_hip_knee_inter_cross_for_72_neurons);
neuron_label_for_joint_response_catA = zeros(nNeurons_catA,1);
threshold_R = 0.4;
p_thresh = 0.001;
nPosture = 16;

% neuron_label_for_joint_response_catA(i) = 1: Hip joint responded
% neuron_label_for_joint_response_catA(i) = 2: Knee joint responded
% neuron_label_for_joint_response_catA(i) = 3: Hip and Knee joint responded
for i = 1:nNeurons_catA
    if abs(Rsq_multi_hip_knee_inter_cross_for_72_neurons(i)) > threshold_R
        if All_neuron_pval_by_particular_R_for_72_neurons(i,1) < p_thresh && ...
           All_neuron_pval_by_particular_R_for_72_neurons(i,2) < p_thresh && ...
           All_neuron_pval_by_particular_R_for_72_neurons(i,3) < p_thresh
            neuron_label_for_joint_response_catA(i) = 3;  
        elseif All_neuron_pval_by_particular_R_for_72_neurons(i,1) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,2) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,3) < p_thresh
            neuron_label_for_joint_response_catA(i) = 3; 
        elseif All_neuron_pval_by_particular_R_for_72_neurons(i,1) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,2) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,3) < p_thresh
            neuron_label_for_joint_response_catA(i) = 3;  
        elseif All_neuron_pval_by_particular_R_for_72_neurons(i,1) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,2) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,3) < p_thresh
            neuron_label_for_joint_response_catA(i) = 3; 
        elseif All_neuron_pval_by_particular_R_for_72_neurons(i,1) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,2) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,3) > p_thresh
            if abs(cofficient_for_72_neurons_catA(i,2)) < abs(cofficient_for_72_neurons_catA(i,3))
                neuron_label_for_joint_response_catA(i) = 2;  
            else
                neuron_label_for_joint_response_catA(i) = 1;  
            end
        elseif All_neuron_pval_by_particular_R_for_72_neurons(i,3) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,1) < p_thresh
            neuron_label_for_joint_response_catA(i) = 1;  
        elseif All_neuron_pval_by_particular_R_for_72_neurons(i,3) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_72_neurons(i,2) < p_thresh
            neuron_label_for_joint_response_catA(i) = 2;  
        end
    end
end

% Calculate sensitivity for hip and knee in Cat A
Hip_dir_fig7  = zeros(nNeurons_catA,1);
Knee_dir_fig7 = zeros(nNeurons_catA,1);

for i = 1:nNeurons_catA
    type_i = neuron_label_for_joint_response_catA(i);
    if ~ismember(type_i, [1,2,3])
        continue
    end
    % extract coefficients 
    beta_hip  = cofficient_for_72_neurons_catA(i,2);
    beta_knee = cofficient_for_72_neurons_catA(i,3);
    beta_int  = cofficient_for_72_neurons_catA(i,4);
    vec_all_fig7 = zeros(nPosture,2);
    % calculate gradients for each recording positions 
    for p = 1:nPosture
        H = hip_joint_angle_normalized_catA(p);
        K = knee_joint_angle_normalized_catA(p);
        s_hip_fig7  = beta_hip  + beta_int * K;
        s_knee_fig7 = beta_knee + beta_int * H;
        vec_all_fig7(p,:) = [s_hip_fig7, s_knee_fig7];
    end
    % Mean gradients across 16 recording positions
    mean_vec = mean(vec_all_fig7,1);
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;
    else
        mean_vec = [0 0];
    end
    %Compute the absolute value of each element
    Hip_dir_fig7(i)  = abs(mean_vec(1));
    Knee_dir_fig7(i)= abs(mean_vec(2));
end

%Compute r and theta
%Note that r is a unit vector and therefore equals 1
r = sqrt(Hip_dir_fig7.^2 + Knee_dir_fig7.^2);
theta = atan2(Knee_dir_fig7, Hip_dir_fig7);
[theta_sorted, order] = sort(theta);
r_plot = r;

% Slightly offset values to avoid overlap of nearby point
scale_values = [0.95, 1.00, 1.05];
for k = 1:length(order)
    idx = order(k);
    scale_idx = mod(k-1, 3) + 1;
    r_plot(idx) = r(idx) * scale_values(scale_idx);
end

% Prepare data for plotting hip and knee sensitivity
Hip_plot_catA  = r_plot .* cos(theta);
Knee_plot_catA = r_plot .* sin(theta);

% Calculate the magnitude of modulation by 
range_row_catA = max(Mean_firing_rate_72_neurons_in_catA_16_recording_position, [], 2) - min(Mean_firing_rate_72_neurons_in_catA_16_recording_position, [], 2);

% Compute the number of neurons for each joint response category (1, 2, 3)
% and generate logical index arrays to identify neurons belonging to each category in Cat A
n1_A = sum(neuron_label_for_joint_response_catA==1);
n2_A = sum(neuron_label_for_joint_response_catA==2);
n3_A = sum(neuron_label_for_joint_response_catA==3);
idx1_A = (neuron_label_for_joint_response_catA==1);
idx2_A = (neuron_label_for_joint_response_catA==2);
idx3_A = (neuron_label_for_joint_response_catA==3);
%% Cat B
% centering 
hip_joint_angle_centering_catB = Hip_joint_angle_16_recording_positions_catB - mean(Hip_joint_angle_16_recording_positions_catB);
knee_joint_angle_centering_catB = Knee_joint_angle_16_recording_positions_catB - mean(Knee_joint_angle_16_recording_positions_catB);
% normalized hip and knee angle -1 to 1
hip_joint_angle_normalized_catB = 2 * (hip_joint_angle_centering_catB(:,1) - min(hip_joint_angle_centering_catB(:,1))) / ...
                                  (max(hip_joint_angle_centering_catB(:,1)) - min(hip_joint_angle_centering_catB(:,1))) - 1;
knee_joint_angle_normalized_catB = 2 * (knee_joint_angle_centering_catB(:,1) - min(knee_joint_angle_centering_catB(:,1))) / ...
                                   (max(knee_joint_angle_centering_catB(:,1)) - min(knee_joint_angle_centering_catB(:,1))) - 1;


% Separate neuron by joint responded in Cat A
nNeurons_catB = length(Rsq_multi_hip_knee_inter_cross_for_136_neurons_catB);
neuron_label_for_joint_response_catB = zeros(nNeurons_catB,1);

% neuron_label_for_joint_response_catB(i) = 1: Hip joint responded
% neuron_label_for_joint_response_catB(i) = 2: Knee joint responded
% neuron_label_for_joint_response_catB(i) = 3: Hip and Knee joint responded
threshold_R = 0.4;
p_thresh = 0.001;
for i = 1:nNeurons_catB
    if abs(Rsq_multi_hip_knee_inter_cross_for_136_neurons_catB(i)) > threshold_R
        if All_neuron_pval_by_particular_R_for_136_neurons_catB(i,1) < p_thresh && ...
           All_neuron_pval_by_particular_R_for_136_neurons_catB(i,2) < p_thresh && ...
           All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) < p_thresh
            neuron_label_for_joint_response_catB(i) = 3;  
        elseif All_neuron_pval_by_particular_R_for_136_neurons_catB(i,1) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,2) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) < p_thresh
            neuron_label_for_joint_response_catB(i) = 3; 
        elseif All_neuron_pval_by_particular_R_for_136_neurons_catB(i,1) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,2) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) < p_thresh
            neuron_label_for_joint_response_catB(i) = 3;  
        elseif All_neuron_pval_by_particular_R_for_136_neurons_catB(i,1) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,2) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) < p_thresh
            neuron_label_for_joint_response_catB(i) = 3; 
        elseif All_neuron_pval_by_particular_R_for_136_neurons_catB(i,1) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,2) < p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) > p_thresh
            if abs(cofficient_for_136_neurons_catB(i,2)) < abs(cofficient_for_136_neurons_catB(i,3))
                neuron_label_for_joint_response_catB(i) = 2;  
            else
                neuron_label_for_joint_response_catB(i) = 1;  
            end
        elseif All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,1) < p_thresh
            neuron_label_for_joint_response_catB(i) = 1;  
        elseif All_neuron_pval_by_particular_R_for_136_neurons_catB(i,3) > p_thresh && ...
               All_neuron_pval_by_particular_R_for_136_neurons_catB(i,2) < p_thresh
            neuron_label_for_joint_response_catB(i) = 2;  
        end
    end
end

% Calculate sensitivity for hip and knee in Cat B
Hip_dir_fig7  = zeros(nNeurons_catB,1);
Knee_dir_fig7 = zeros(nNeurons_catB,1);

for i = 1:nNeurons_catB
    type_i = neuron_label_for_joint_response_catB(i);
    if ~ismember(type_i, [1,2,3])
        continue
    end
    % extract coefficients 
    beta_hip  = cofficient_for_136_neurons_catB(i,2);
    beta_knee = cofficient_for_136_neurons_catB(i,3);
    beta_int  = cofficient_for_136_neurons_catB(i,4);
    vec_all_fig7 = zeros(nPosture,2);
    for p = 1:nPosture
        % Calculate gradients for each recording positions 
        H = hip_joint_angle_normalized_catB(p);
        K = knee_joint_angle_normalized_catB(p);
        s_hip_fig7  = beta_hip  + beta_int * K;
        s_knee_fig7 = beta_knee + beta_int * H;
        vec_all_fig7(p,:) = [s_hip_fig7, s_knee_fig7];
    end
    % Mean gradients across 16 recording positions
    mean_vec = mean(vec_all_fig7,1);
    mag = norm(mean_vec);
    if mag > 0
        mean_vec = mean_vec / mag;
    else
        mean_vec = [0 0];
    end
    %Compute the absolute value of each element
    Hip_dir_fig7(i)  = abs(mean_vec(1));
    Knee_dir_fig7(i)= abs(mean_vec(2));
end

%Compute r and theta
%Note that r is a unit vector and therefore equals 1
r = sqrt(Hip_dir_fig7.^2 + Knee_dir_fig7.^2);
theta = atan2(Knee_dir_fig7, Hip_dir_fig7);
[theta_sorted, order_catB] = sort(theta);
r_plot = r;

%Compute r and theta
%Note that r is a unit vector and therefore equals 1
scale_values = [0.95, 1.00, 1.05];
for k = 1:length(order_catB)
    idx = order_catB(k);
    scale_idx = mod(k-1, 3) + 1;
    r_plot(idx) = r(idx) * scale_values(scale_idx);
end

% Prepare data for plotting hip and knee sensitivity
Hip_plot_catB  = r_plot .* cos(theta);
Knee_plot_catB = r_plot .* sin(theta);

% Calculate the magnitude of modulation by 
range_row_catB = max(Mean_firing_rate_136_neurons_in_catB_16_recording_position, [], 2) - min(Mean_firing_rate_136_neurons_in_catB_16_recording_position, [], 2);

% Compute the number of neurons for each joint response category (1, 2, 3)
% and generate logical index arrays to identify neurons belonging to each category in Cat B
n1_B = sum(neuron_label_for_joint_response_catB==1);
n2_B = sum(neuron_label_for_joint_response_catB==2);
n3_B = sum(neuron_label_for_joint_response_catB==3);
idx1_B = (neuron_label_for_joint_response_catB==1);
idx2_B = (neuron_label_for_joint_response_catB==2);
idx3_B = (neuron_label_for_joint_response_catB==3);
%% Plot
figure('Units','centimeters','Position',[5 5 16 16],'Color','w');
t = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
set(groot,'defaultAxesFontName','Arial');
set(groot,'defaultTextFontName','Arial');

% set color for each element
color_hip   = [0.0 0.0 1.0];
color_knee  = [0.0 0.7 0.7];
color_both  = [0.8 0.0 0.8];

% Plot Cat A data
% Plot hip and knee sensitivity in Cat A
nexttile; hold on;
h1 = scatter(Hip_plot_catA(idx1_A),Knee_plot_catA(idx1_A),25,'o','MarkerFaceColor',color_hip,'MarkerEdgeColor','k');
h2 = scatter(Hip_plot_catA(idx2_A),Knee_plot_catA(idx2_A),25,'s','MarkerFaceColor',color_knee,'MarkerEdgeColor','k');
h3 = scatter(Hip_plot_catA(idx3_A),Knee_plot_catA(idx3_A),25,'^','MarkerFaceColor',color_both,'MarkerEdgeColor','k');
% Setting title and legend for pannel 1
title('Cat A','FontName','Arial','FontWeight','bold','Color','k');
legend([h1 h2 h3], {sprintf('Hip (n=%d)',n1_A), sprintf('Knee (n=%d)',n2_A), sprintf('Both (n=%d)',n3_A)}, ...
       'Location','southwest','FontSize',8,'FontName','Arial','FontWeight','bold','TextColor','k');

% Plot modulation magnitude in Cat A
nexttile; hold on;
colormap(gca, flipud(gray));
% Plot magnitude
scatter(Hip_plot_catA(idx1_A),Knee_plot_catA(idx1_A),25,range_row_catA(idx1_A),'o','filled');
scatter(Hip_plot_catA(idx2_A),Knee_plot_catA(idx2_A),25,range_row_catA(idx2_A),'s','filled');
scatter(Hip_plot_catA(idx3_A),Knee_plot_catA(idx3_A),25,range_row_catA(idx3_A),'^','filled');
% Setting label for pannel 2
title('Cat A','FontName','Arial','FontWeight','bold','Color','k');
cb = colorbar;
caxis([0 50]);
cb.Ticks = 0:10:50;
cb.FontName = 'Arial';
cb.FontWeight = 'bold';
cb.FontSize = 10;
cb.Color = 'k';
cb.TickDirection = 'out';


% Plot Cat B data
% Plot hip and knee sensitivity in Cat B
nexttile; hold on;
h1 = scatter(Hip_plot_catB(idx1_B),Knee_plot_catB(idx1_B),25,'o','MarkerFaceColor',color_hip,'MarkerEdgeColor','k');
h2 = scatter(Hip_plot_catB(idx2_B),Knee_plot_catB(idx2_B),25,'s','MarkerFaceColor',color_knee,'MarkerEdgeColor','k');
h3 = scatter(Hip_plot_catB(idx3_B),Knee_plot_catB(idx3_B),25,'^','MarkerFaceColor',color_both,'MarkerEdgeColor','k');
% Setting title and legend for pannel 3
title('Cat B','FontName','Arial','FontWeight','bold','Color','k');
legend([h1 h2 h3], {sprintf('Hip (n=%d)',n1_B), sprintf('Knee (n=%d)',n2_B), sprintf('Both (n=%d)',n3_B)}, ...
       'Location','southwest','FontSize',8,'FontName','Arial','FontWeight','bold','TextColor','k');

% Plot modulation magnitude in Cat B
nexttile; hold on;
% Plot magnitude
scatter(Hip_plot_catB(idx1_B),Knee_plot_catB(idx1_B),25,range_row_catB(idx1_B),'o','filled');
scatter(Hip_plot_catB(idx2_B),Knee_plot_catB(idx2_B),25,range_row_catB(idx2_B),'s','filled');
scatter(Hip_plot_catB(idx3_B),Knee_plot_catB(idx3_B),25,range_row_catB(idx3_B),'^','filled');

% Setting label for pannel 4
colormap(gca, flipud(gray));
title('Cat B','FontName','Arial','FontWeight','bold','Color','k');
cb = colorbar;
caxis([0 50]);
cb.Ticks = 0:10:50;
cb.FontName = 'Arial';
cb.FontWeight = 'bold';
cb.FontSize = 10;
cb.Color = 'k';
cb.TickDirection = 'out';

% Setting label for all pannel
all_axes = findobj(t,'Type','axes');
set(all_axes, 'XLim',[-0.05 1.25], 'YLim',[-0.05 1.25], 'Box','on', 'GridLineStyle','-', ...
    'XGrid','on', 'YGrid','on', 'XTick',[], 'YTick',[], 'PlotBoxAspectRatio',[1 1 1], ...
    'FontName','Arial','FontWeight','bold','FontSize',10,'LineWidth',1.2);
xlabel(all_axes, 'Hip sensitivity', 'FontName','Arial','FontWeight','bold','Color','k','FontSize',10);
ylabel(all_axes, 'Knee sensitivity', 'FontName','Arial','FontWeight','bold','Color','k','FontSize',10);

% print and save figure
fname = fullfile(figureFolder, 'Figure7.emf');
exportgraphics(gcf,fname,'Resolution',600);