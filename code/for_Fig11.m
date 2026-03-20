% For Figure 11
% Created on Mar 20 2026
% @author:Yuta Soga

%% Data loading
filePath = 'data/';
load([filePath,'data_fig11_lasso_pred_catA.mat']);
load([filePath,'data_fig11_lasso_pred_catB.mat']);

%% Variables in this file
% orientation_length_catA
%   Size: [16 × 2]
%   - Column 1: Orientation (angle from the horizontal plane) of the line connecting the hip and ankle joints
%   - Column 2: Length of the limb axis (distance between hip and ankle joints)
%   - Description: Limb configuration parameters for each recording
%   position in Cat A
%     Each row corresponds to one recording position (e.g., row 1: Pos-1, row 2: Pos-2, etc.)

% predicted_orientation_length_lasso_catA
%   Size: [80 × 2]
%   - Column 1: Orientation
%   - Column 2: Length
%   - Description: Predicted orientation and length obtained from Lasso regression in Cat A
%     Each row corresponds to one trial
%     Data are organized in blocks of 5 consecutive rows per recording position,
%     with 16 recording positions in total (5 trials × 16 positions = 80 rows)

% neuron_posture_response_type_catB
%   Size: [16 × 2]
%   - Column 1: Orientation (angle from the horizontal plane) of the line connecting the hip and ankle joints
%   - Column 2: Length of the limb axis (distance between hip and ankle joints)
%   - Description: Limb configuration parameters for each recording position in Cat B
%     Each row corresponds to one recording position (e.g., row 1: Pos-1, row 2: Pos-2, etc.)

% predicted_orientation_length_lasso_catB
%   Size: [80 × 2]
%   - Column 1: Orientation
%   - Column 2: Length
%   - Description: Predicted orientation and length obtained from Lasso regression in Cat B
%     Each row corresponds to one trial
%     Data are organized in blocks of 5 consecutive rows per recording position,
%     with 16 recording positions in total (5 trials × 16 positions = 80 rows)


%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% Preprocessing
num_postures = length(orientation_length_catA);
num_trials = length(predicted_orientation_length_lasso_catA)/num_postures;

% Cat A
% Construct a matrix of true (measured) orientation and length values
orientation_length_true_value_catA = [];
for pos = 1:num_postures
    for tr = 1:num_trials
        orientation_length_true_value_catA   = [orientation_length_true_value_catA; orientation_length_catA(pos,:)]; 
    end
end

% Compute mean of true values across all samples
orientation_length_true_value_mean_all = mean(orientation_length_true_value_catA);

% Orientation
SSE_orientation_decording_catA = sum((orientation_length_true_value_catA(:,1)-predicted_orientation_length_lasso_catA(:,1)).^2);
SST_orientation_decording_catA = sum((orientation_length_true_value_catA(:,1)-orientation_length_true_value_mean_all(1,1)).^2);
R_square_orientation_decording_catA = 1-(SSE_orientation_decording_catA/SST_orientation_decording_catA);
% Length
SSE_length_decording_catA = sum((orientation_length_true_value_catA(:,2)-predicted_orientation_length_lasso_catA(:,2)).^2);
SST_length_decording_catA = sum((orientation_length_true_value_catA(:,2)-orientation_length_true_value_mean_all(1,2)).^2);
R_square_length_decording_catA = 1-(SSE_length_decording_catA/SST_length_decording_catA);

% Compute mean and standard deviation of predicted orientation and length
% for each recording position across trials
orientation_mean_value_16_recording_position_catA = zeros(num_postures, 1);
orientation_std_16_recording_position_catA  = zeros(num_postures, 1);
length_mean_value_16_recording_position_catA = zeros(num_postures, 1);
length_std_16_recording_position_catA  = zeros(num_postures, 1);

for pos = 1:num_postures
    % Extract trial indices corresponding to the current recording position
    idx_range = (pos-1)*num_trials + (1:num_trials);

    % Extract predicted values for this position
    block_orientation = predicted_orientation_length_lasso_catA(idx_range, 1);  
    block_length = predicted_orientation_length_lasso_catA(idx_range, 2);  

    % Compute mean and standard deviation across trials
    orientation_mean_value_16_recording_position_catA(pos, 1) = mean(block_orientation(:));
    orientation_std_16_recording_position_catA(pos, 1)  = std(block_orientation(:));
    length_mean_value_16_recording_position_catA(pos, 1) = mean(block_length(:));
    length_std_16_recording_position_catA(pos, 1)  = std(block_length(:));
end


% Cat B
% Construct a matrix of true (measured) orientation and length values
orientation_length_true_value_catB = [];
for pos = 1:num_postures
    for tr = 1:num_trials
        orientation_length_true_value_catB   = [orientation_length_true_value_catB; orientation_length_catB(pos,:)]; 
    end
end

% Compute mean of true values across all samples
orientation_length_true_value_mean_all = mean(orientation_length_true_value_catB);

% Orientation
SSE_orientation_decording_catB = sum((orientation_length_true_value_catB(:,1)-predicted_orientation_length_lasso_catB(:,1)).^2);
SST_orientation_decording_catB = sum((orientation_length_true_value_catB(:,1)-orientation_length_true_value_mean_all(1,1)).^2);
R_square_orientation_decording_catB = 1-(SSE_orientation_decording_catB/SST_orientation_decording_catB);

% Length
SSE_length_decording_catB = sum((orientation_length_true_value_catB(:,2)-predicted_orientation_length_lasso_catB(:,2)).^2);
SST_length_decording_catB = sum((orientation_length_true_value_catB(:,2)-orientation_length_true_value_mean_all(1,2)).^2);
R_square_length_decording_catB = 1-(SSE_length_decording_catB/SST_length_decording_catB);

% Compute mean and standard deviation of predicted orientation and length
% for each recording position across trials
orientation_mean_value_16_recording_position_catB = zeros(num_postures, 1);
orientation_std_16_recording_position_catB  = zeros(num_postures, 1);
length_mean_value_16_recording_position_catB = zeros(num_postures, 1);
length_std_16_recording_position_catB  = zeros(num_postures, 1);

for pos = 1:num_postures
        % Extract trial indices corresponding to the current recording position
        idx_range = (pos-1)*num_trials + (1:num_trials);
        % Extract predicted values for this position
        block_orientation = predicted_orientation_length_lasso_catB(idx_range, 1);  % 5×10
        block_length = predicted_orientation_length_lasso_catB(idx_range, 2);  % 5×10
         % Compute mean and standard deviation across trials
        orientation_mean_value_16_recording_position_catB(pos, 1) = mean(block_orientation(:));
        orientation_std_16_recording_position_catB(pos, 1)  = std(block_orientation(:));
        length_mean_value_16_recording_position_catB(pos, 1) = mean(block_length(:));
        length_std_16_recording_position_catB(pos, 1)  = std(block_length(:));
end

%% Plot
figure;
% Cat A Orientation
subplot(2,2,1);

% Plot data with error bars
errorbar(orientation_length_catA(:,1), ...
    orientation_mean_value_16_recording_position_catA, ...
    orientation_std_16_recording_position_catA, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3);
hold on;

% Adjust marker size of error bars
h = findobj(gca, 'Type', 'ErrorBar');
set(h, 'MarkerSize', 4.5);

% Axis labels
xlabel('Observed orientation [degree]', 'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);
hY = ylabel('Decoded orientation [degree]', ...
    'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);

% Adjust ylabel position manually
pos = get(hY, 'Position');
pos(1) = pos(1) - 8;
pos(2) = pos(2) - 12;
set(hY, 'Position', pos);

% Title
title('Cat A','FontName','Arial','FontSize',12,'FontWeight','bold','Color',[0 0 0]);

% Reference line (y = x)
plot([min(orientation_length_catA(:,1)), max(orientation_length_catA(:,1))], ...
     [min(orientation_length_catA(:,1)), max(orientation_length_catA(:,1))], ...
     '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 2);

% Axis settings
grid on; axis equal;
xlim([20 120]); ylim([20 120]);
xticks(20:20:120);
yticks(20:20:120);

% Display R² value
text(27, 110, sprintf('R^2 = %.3f', R_square_orientation_decording_catA), ...
    'FontSize', 10, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);

% Style axes 
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 10;
ax.FontName = 'Arial';
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XTickLabelRotation = 0;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
ax.YMinorTick = 'off';
ax.LineWidth = 2;
box off;

% Cat A Length 
subplot(2,2,2);
% Plot data with error bars 
errorbar(orientation_length_catA(:,2), ...
    length_mean_value_16_recording_position_catA, ...
    length_std_16_recording_position_catA, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3); 
hold on;

% Adjust marker size of error bars
h = findobj(gca, 'Type', 'ErrorBar');
set(h, 'MarkerSize', 4.5);

% Axis labels and title 
xlabel('Observed length [mm]', 'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);
ylabel('Decoded length [mm]', 'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);
title('Cat A','FontName','Arial','FontSize',12,'FontWeight','bold','Color',[0 0 0]);

% Reference line (y = x) 
plot([min(orientation_length_catA(:,2)), max(orientation_length_catA(:,2))], ...
     [min(orientation_length_catA(:,2)), max(orientation_length_catA(:,2))], ...
     '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);

% Axis settings
grid on; axis equal;
xlim([65 205]); ylim([65 205]);
xticks(50:25:200);
yticks(50:25:200);

% Display R² value
text(75, 190, sprintf('R^2 = %.3f', R_square_length_decording_catA), ...
    'FontSize', 10, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);

% Style axes 
bx = gca; 
bx.FontWeight = 'bold';
bx.FontSize = 10;
bx.FontName = 'Arial';
bx.XTickLabelRotation = 0;
bx.XColor = [0 0 0];
bx.YColor = [0 0 0];
bx.TickDir = 'out';
bx.TickLength = [0.02 0.02];
bx.YMinorTick = 'off';
bx.LineWidth = 2;
box off;


% Cat B Orientation
subplot(2,2,3);

% --- Plot data with error bars ---
errorbar(orientation_length_catB(:,1), ...
    orientation_mean_value_16_recording_position_catB, ...
    orientation_std_16_recording_position_catB, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3);
hold on;

% Adjust marker size of error bars
h = findobj(gca, 'Type', 'ErrorBar');
set(h, 'MarkerSize', 4.5);

% Axis labels
xlabel('Observed orientation [degree]', 'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);
hY = ylabel('Decoded orientation [degree]', ...
    'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);

% Adjust ylabel position manually
pos = get(hY, 'Position');
pos(1) = pos(1) - 12;
pos(2) = pos(2) - 3;
set(hY, 'Position', pos);

% Title
title('Cat B','FontName','Arial','FontSize',12,'FontWeight','bold','Color',[0 0 0]);

% Reference line (y = x) 
plot([min(orientation_length_catB(:,1)), max(orientation_length_catB(:,1))], ...
     [min(orientation_length_catB(:,1)), max(orientation_length_catB(:,1))], ...
     '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 2);

% Axis settings 
grid on; axis equal;
xlim([45 110]); ylim([45 110]);
xticks(50:10:100);
yticks(50:10:100);

% Display R² value 
text(50, 105, sprintf('R^2 = %.3f', R_square_orientation_decording_catB), ...
    'FontSize', 10, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);

% Style axes
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 10;
ax.FontName = 'Arial';
ax.XTickLabelRotation = 0;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
ax.YMinorTick = 'off';
ax.LineWidth = 2;
box off;


% Cat B Length 
subplot(2,2,4);

% Plot data with error bars
errorbar(orientation_length_catB(:,2), ...
    length_mean_value_16_recording_position_catB, ...
    length_std_16_recording_position_catB, 'o', ...
    'Color', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1, 'CapSize', 3);
hold on;

% Adjust marker size of error bars
h = findobj(gca, 'Type', 'ErrorBar');
set(h, 'MarkerSize', 4.5);

% Axis labels
xlabel('Observed length [mm]', 'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);
ylabel('Decoded length [mm]', 'FontName', 'Arial', 'FontSize', 8, 'Color', [0 0 0]);

% Title
title('Cat B','FontName','Arial','FontSize',12,'FontWeight','bold','Color',[0 0 0]);

% Reference line (y = x)
plot([min(orientation_length_catB(:,2)), max(orientation_length_catB(:,2))], ...
     [min(orientation_length_catB(:,2)), max(orientation_length_catB(:,2))], ...
     '-', 'Color', [0.5 0.5 0.5], 'LineWidth',2);

% Axis settings
grid on; axis equal;
xlim([90 230]); ylim([90 230]);
xticks(100:25:225);
yticks(100:25:225);

% Display R² value
text(100, 215, sprintf('R^2 = %.3f', R_square_length_decording_catB), ...
    'FontSize', 10, 'FontWeight', 'bold','FontName', 'Arial', 'Color', [0 0 0]);

% Style axes
bx = gca;
bx.FontWeight = 'bold';
bx.FontSize = 10;
bx.FontName = 'Arial';
bx.XTickLabelRotation = 0;
bx.XColor = [0 0 0];
bx.YColor = [0 0 0];
bx.TickDir = 'out';
bx.TickLength = [0.02 0.02];
bx.YMinorTick = 'off';
bx.LineWidth = 2;
box off;


% Figure size and export settings =
% Set figure size (fit within A4 width)
target_width = 15;   % cm
target_height = 15;  % cm
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, target_width, target_height]);

% Match paper size for PDF export (no margins)
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [target_width target_height];
fig.PaperPosition = [0 0 target_width target_height];

% Print and save figure
emfFileName = fullfile(figureFolder, 'Figure11.emf');
print(fig, emfFileName, '-dmeta');
