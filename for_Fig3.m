% For Figure 3
% Created on Mar 20 2026 
% @author:Yuta Soga

%% Requirements
% This code uses a perceptually uniform colormap ("viridis") from Matplotlib.
% The colormap is not included in standard MATLAB and requires an external function (e.g., viridis.m).


%% Data loading
filePath = 'data/';
load([filePath,'data_Fig3A_Pos1_ankle_speed_xy.mat']);
load([filePath,'data_Fig3BC_firing_rate.mat']);

%% Variables in this file
% ankle_speed_xy_in_Pos1_30ms
%   Size: [5 × T]
%   - T: number of time points (from -10 s to +25 s relative to the recording position onset)
%   - Description: Magnitude of ankle velocity (combined X and Y components, mm/s)
%     for 5 trials at Pos-1 in Cat A

% time_ankle_speed_during_Pos1_30ms
%   Size: [1 × T]
%   - T: number of time points (from -10 s to +25 s relative to the recording position onset)
%   - Description: Time vector corresponding to ankle velocity


% firing_timing_neuron21_during_Pos1
%   Size: [1 × 5] cell array
%   - Each cell contains spike times (in seconds) of neuron 21 for a single trial
%   - Time range: from -20 s to +20 s relative to the onset of the recording position
%   - Description: Spike timing of neuron 21 across 5 trials at Pos-1 in
%   Cat A

% firing_rate_72_neurons_during_Pos1
%   Size: [72 × T]
%   - Rows: neurons (n = 72)
%   - Columns: time points (from -20 s to +20 s relative to the recording position onset)
%   - Description: Firing rates of 72 neurons at Pos-1, computed with a bin width of 50 ms

% time_for_psth_50ms
%   Size: [1 × T]
%   - T: number of time points, spanning from -20 s to +20 s relative to the onset of the recording position
%   - Description: Time vector for PSTH (firing rate), with a bin width of 50 ms
%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

%% Compute mean and standard deviation of combined XY speed
% Mean
Vxy_mean  = mean(ankle_speed_xy_in_Pos1_30ms,  1, 'omitnan');
% STD
Vxy_std   = std(ankle_speed_xy_in_Pos1_30ms, 0, 1, 'omitnan');  


%% Color map setting
nColors = 256;
baseMap = viridis(nColors);
dataMax   = 180;      % Maximum data value (Hz)
threshold = 50;       % Threshold value for color mapping (Hz)
t = threshold / dataMax;
v = linspace(0,1,nColors);
customRange = zeros(size(v));
% --- Allocate 85% of the colormap to 0–50 Hz ---
customRange(v <= t) = ...
    (v(v<=t)/t) * 0.85;
% --- For 50–180 Hz, assign the remaining 15% nonlinearly for a smooth transition ---
gamma_high = 1.5;  % Gamma > 1 avoids end-point compression
vh = (v(v>t)-t) / (1-t);
customRange(v > t) = ...
    0.85 + (vh.^gamma_high) * 0.15;
% Interpolate the base colormap according to the custom range
newCmap = interp1(linspace(0,1,nColors), baseMap, customRange);


%% Plot 
figure('Units','centimeters','Position',[5 5 14 13.5]);

% Plot Figure 3A: Ankle speed during Pos-1 in Cat A
axA = axes('Position',[0.4, 0.67, 4.5/14, 4/13.5]);
hold(axA,'on'); 
grid(axA,'off');

% Plot STD
validIdx = ~isnan(Vxy_mean) & ~isnan(Vxy_std);
X_fill = time_ankle_speed_during_Pos1_30ms(validIdx);
Y_fill = [Vxy_mean(validIdx)-Vxy_std(validIdx), fliplr(Vxy_mean(validIdx)+Vxy_std(validIdx))];
fill([X_fill, fliplr(X_fill)], Y_fill, [0.3 0.3 0.3], 'FaceAlpha',0.3, 'EdgeColor','none');

% Plot mean
plot(axA, time_ankle_speed_during_Pos1_30ms, Vxy_mean, 'k', 'LineWidth',2.5);

% Plot onset line and offset line
h1 = xline(axA,0, 'Color',[0.2 0.2 0.2], 'LineStyle',':', 'LineWidth',1.2);
h2 = xline(axA,15,'Color',[0.2 0.2 0.2], 'LineStyle',':', 'LineWidth',1.2);
uistack(h1,'top')
uistack(h2,'top')

% Set axis labels and add text annotations
xlabel(axA,'Time [s]','FontSize',9.5,'FontWeight','bold','FontName','Arial','Color','k');
ylabel(axA,'Speed of ankle [mm/s]','FontSize',9.5,'FontWeight','bold','FontName','Arial','Color','k');
title(axA,'Cat A Pos-1','FontSize',9.5,'FontWeight','bold','FontName','Arial','Color','k');
text(0.4,0.285,...
    sprintf('bin = %.0f ms', 0.03*1000),...
    'Units','normalized',...
    'FontSize',8,...
    'FontWeight','bold',...
    'FontName','Arial',...
    'VerticalAlignment','top',...
    'Color','k');
xlim([-5 20]);
xticks([-5 0 5 10 15 20]);
yticks('auto');   
axA.FontSize = 9.5; axA.FontWeight='bold'; axA.FontName='Arial';
axA.TickDir='out'; axA.LineWidth=1.5;
axA.XColor = 'k';
axA.YColor = 'k';


% Plot Figure 3B: Raster plot for neuron #21 during Pos-1 in Cat A
ax1 = axes('Position',[0.1 0.1 0.4 0.4]);  % 下半分
hold(ax1,'on');

% Plot firing rate (bin 50 ms)
b = bar(ax1, time_for_psth_50ms(1:end-1), firing_rate_72_neurons_during_Pos1(21,:), 'BarWidth',1);
b.FaceColor = [0.6 0.6 0.6]; b.EdgeColor = [0.6 0.6 0.6];

% Plot spike timing for 5 trials
for task = 1:length(firing_timing_neuron21_during_Pos1)
    spk = firing_timing_neuron21_during_Pos1{task};
    y = (120 - 5*5 + task*5) * ones(size(spk));
    plot(ax1, spk, y, 'k.', 'MarkerSize',3);
end

% Add text annotations
text(0.225,0.835,...
    'Raster plot for five trials (n=5)',...
    'Units','normalized',...
    'FontSize',8,...
    'FontWeight','bold',...
    'FontName','Arial',...
    'VerticalAlignment','top',...
    'HorizontalAlignment','left',...
    'Color','k');
text(0.6,0.425,...
    'bin = 50 ms',...
    'Units','normalized',...
    'FontSize',8,...
    'FontWeight','bold',...
    'FontName','Arial',...
    'VerticalAlignment','top',...
    'HorizontalAlignment','left',...
    'Color','k');

% Label settings
xlim(ax1,[-5 20]); ylim(ax1,[0 120]);
ax1.FontSize = 10; ax1.FontWeight='bold'; ax1.FontName='Arial';
ax1.TickDir='out'; ax1.LineWidth=1.5; box(ax1,'off'); ax1.Layer='top';
xline(ax1,0, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.5);
xline(ax1,15, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.5);
xlabel(ax1,'Time [s]','FontSize',10,'FontWeight','bold','FontName','Arial','Color','k');
ylabel(ax1,'Firing rate [Hz]','FontSize',10,'FontWeight','bold','FontName','Arial','Color','k');
title(ax1,'Cat A Pos-1','FontWeight','bold','FontSize',10,'FontName','Arial','Color','k');


% Plot Figure 3C: Firing rate for 72 neurons during Pos-1 in Cat A
ax2 = axes('Position',[0.625 0.1 0.375 0.4]);  % 下半分

% Plot firing rate for 72 neurons
imagesc(ax2, time_for_psth_50ms(1:end-1), 1:size(firing_rate_72_neurons_during_Pos1,1), firing_rate_72_neurons_during_Pos1);
caxis(ax2,[0 180]); colormap(ax2,newCmap);

% Label setting
set(ax2, 'YDir', 'normal');  % 上が大きく
xlim(ax2,[-5 20]); ylim(ax2,[0.5 size(firing_rate_72_neurons_during_Pos1,1)+0.5]);
ax2.FontSize=10; ax2.FontWeight='bold'; ax2.FontName='Arial';
ax2.TickDir='out'; ax2.LineWidth=1.5; box(ax2,'off');
yticks(ax2,[20 40 60]); yticklabels(ax2,{'20','40','60'});
xticks(ax2,[-5 0 5 10 15 20]);
ax2.XMinorTick='off'; ax2.YMinorTick='on';
xline(ax2,0, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5);
xline(ax2,15, ':', 'Color', [0.7 0.7 0.7], 'LineWidth', 1.5);
title(ax2,'Cat A Pos-1', 'FontWeight','bold','FontSize',10,'FontName','Arial');
xlabel(ax2,'Time [s]','FontSize',10,'FontWeight','bold','FontName','Arial','Color','k');
ylabel(ax2,{'Electrode ID of the','single neuron'},...
       'FontSize',10,'FontWeight','bold','FontName','Arial','Color','k');
ax2.XColor = 'k';
ax2.YColor = 'k';

% Set color bar
cb = colorbar(ax2);
cb.Ticks = [0 50 100 150 180];
cb.FontSize = 10; cb.FontWeight='bold'; cb.FontName='Arial';
cb.Label.String = 'Firing rate [Hz]';
cb.Label.FontSize=10; cb.Label.FontWeight='bold'; cb.Label.FontName='Arial';
cb.Color = 'k';
cb.Label.Color = 'k';

% print and save figure
saveNameEMF = fullfile(figureFolder, 'Figure3.emf');
print(gcf, saveNameEMF, '-dmeta');


