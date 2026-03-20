% For Figure 2D
% Created on Mar 20 2026 
% @author:Yuta Soga

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig2D_hindlimb_xy_coordination.mat']);

%% Variables in this file
% Hip_xy_coordination_average_across_16_recording_positions
%   Size: [1 × 2]
%   - Column 1: X coordinate
%   - Column 2: Y coordinate
%   - Description: Hip joint XY coordination averaged across 16 recording
%     positions in Cat A

% Ilium_xy_coordination_average_across_16_recording_positions
%   Size: [1 × 2]
%   - Column 1: X coordinate
%   - Column 2: Y coordinate
%   - Description: Ilium XY coordination averaged across 16 recording
%     positions in Cat A

% Knee_xy_coordination_for_16_recording_positions
%   Size: [16 × 2]
%   - Column 1: X coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Column 2: Y coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Description: Knee joint XY coordination for each recording position
%   in Cat A

% Ankle_xy_coordination_for_16_recording_positions
%   Size: [16 × 2]
%   - Column 1: X coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Column 2: Y coordinate for each recording position (row 1: Pos-1, row2:Pos-2....)
%   - Description: Ankle joint XY coordination for each recording position
%   in Cat A
%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% setting color map and origin
% color map for recording positions
fullJet = turbo(256);               
idx = round(linspace(1, 256, 16)); 
colors = fullJet(idx, :);

% The hip joint position is used as the origin (0,0)
hip_origin = Hip_xy_coordination_average_across_16_recording_positions; 


%% Plot
figure;
hold on;
grid on;
axis equal;

% plot xy coordination for hindlimb
for i = 1:16
    ankle = Ankle_xy_coordination_for_16_recording_positions(i,:) - hip_origin;
    knee  = Knee_xy_coordination_for_16_recording_positions(i,:)  - hip_origin;
    hip   = Hip_xy_coordination_average_across_16_recording_positions  - hip_origin;   
    ilium = Ilium_xy_coordination_average_across_16_recording_positions - hip_origin;
    coords = [ankle; knee; hip; ilium];

    % plot links
    plot(coords(:,1), coords(:,2), ':', 'Color', colors(i,:), 'LineWidth', 1.25);
    % plot ankle markers
    plot(coords(1,1), coords(1,2), 'o', ...
        'MarkerEdgeColor', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 2.5, ...
        'LineWidth', 2);
end

% plot ilium marker
plot(ilium(1,1), ilium(1,2), 'o', ...
'MarkerEdgeColor',[0 0 0], ... 
'MarkerFaceColor', [0 0 0], ...
'MarkerSize', 2.5, ...
'LineWidth', 2);

% plot hip marker
plot(hip(1,1), hip(1,2), 'o', ...
'MarkerEdgeColor',[0 0 0], ...
'MarkerFaceColor', [0 0 0], ...
'MarkerSize', 2.5, ...
'LineWidth', 2);

% Add text annotations for recording position at ankle position 
for i = 1:16
    hip_origin = Hip_xy_coordination_average_across_16_recording_positions;  
    ankle = Ankle_xy_coordination_for_16_recording_positions(i,:) - hip_origin;
    knee  = Knee_xy_coordination_for_16_recording_positions(i,:)  - hip_origin;
    hip   = Hip_xy_coordination_average_across_16_recording_positions  - hip_origin;   
    ilium = Ilium_xy_coordination_average_across_16_recording_positions - hip_origin;
    coords = [ankle; knee; hip; ilium];
    if i == 6
        % Ajust Pos-6 label
        text(coords(1,1)-18, coords(1,2)-18, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 8, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color', [0 0 0]);
    else
        % Ajust Pos label
        text(coords(1,1)-18, coords(1,2)+2, sprintf('Pos-%d', i), ...
            'FontWeight','bold','FontSize', 8, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
    end
end

% Add text annotations for ilium
text(ilium(1,1)-8, ilium(1,2)+4, 'Ilium','FontWeight','bold', ...
            'FontSize', 8, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);
% Add text annotations for hip joint position
text(hip(1,1)+6, hip(1,2)-3, 'Hip joint Position','FontWeight','bold', ...
            'FontSize', 8, 'FontName', 'Arial',...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'Color',[0 0 0]);

% label settings
pbaspect([1 1 1]);
xlim([-90 150])
ylim([-220 20])
xlabel('X [mm]', 'Color','k','FontWeight','bold','FontSize',8,'FontName','Arial'); 
ylabel('Y [mm]', 'Color','k','FontWeight','bold','FontSize',8,'FontName','Arial');
set(gca, 'FontSize', 8, 'FontName', 'Arial', 'FontWeight', 'bold');
ax = gca;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
box off;
ax.TickDir = 'out';
ax.TickLength = [0.02 0.02];
ax.XMinorTick = 'on';     
ax.YMinorTick = 'on';    
ax.LineWidth = 1;      
set(gca,...
    'FontSize',8,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'XColor','k',...
    'YColor','k');

% define size for figure
set(gcf, 'Units', 'centimeters', 'Position', [5, 5, 7, 7]);
% print and save figure
emfFileName = fullfile(figureFolder, 'Figure2D.emf');
print(gcf, emfFileName, '-dmeta');