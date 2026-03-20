% For Figure 10
% Created on Mar 20 2026
% @author:Yuta Soga

%% Data loading
filePath = 'data/';
load([filePath,'data_Fig10_neuron_posture_response_type_catA.mat']);
load([filePath,'data_Fig10_PC_loading_catA.mat']);
load([filePath,'data_Fig10_neuron_posture_response_type_catB.mat']);
load([filePath,'data_Fig10_PC_loading_catB.mat']);

%% Variables in this file
% neuron_posture_response_type_catA
%   Size: [72 × 1]
%   - Description: Labels indicating the response type of each neuron in Cat A
%     Each element corresponds to a neuron.
%     0: No modulation
%     1: Responds to hip joint angle
%     2: Responds to knee joint angle
%     3: Responds to both hip and knee joint angles
%     4: Responds to a single endpoint

% PC1_PC2_PC3_loading_for_catA
%   Size: [72 × 3]
%   - Description: PCA loadings of 72 neurons in Cat A
%     Each row corresponds to a neuron, and each column corresponds to PC1, PC2, and PC3

% neuron_posture_response_type_catB
%   Size: [136 × 1]
%   - Description: Labels indicating the response type of each neuron in
%   Cat B
%     Each element corresponds to a neuron.
%     0: No modulation
%     1: Responds to hip joint angle
%     2: Responds to knee joint angle
%     3: Responds to both hip and knee joint angles
%     4: Responds to a single endpoint

% PC1_PC2_PC3_loading_for_catB
%   Size: [136 × 3]
%   - Description: PCA loadings of 136 neurons in Cat B
%     Each row corresponds to a neuron, and each column corresponds to PC1, PC2, and PC3


%% make folder for save
currentFolder = pwd;  
figureFolder = fullfile(currentFolder, 'Figure');
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end


%% preprocessing
pcs = [1 2 3];
nPC = numel(pcs);
% Calculate normalized loading in Cat A
for i = 1:nPC
    Loading = PC1_PC2_PC3_loading_for_catA(:, pcs(i));     % loading vector
    % Squared contribution
    sq = Loading.^2;
    % Normalize (sum across all 72 neurons equals 1)
    normalized_loading_catA(:,i) = sq / sum(sq);
end

% Calculate normalized loading in Cat B
for i = 1:nPC
    Loading = PC1_PC2_PC3_loading_for_catB(:, pcs(i));     % loading vector
    % Squared contribution
    sq = Loading.^2;
    % Normalize (sum across all 72 neurons equals 1)
    normalized_loading_catB(:,i) = sq / sum(sq);
end

% Set colors for each category
colorMap = [ ...
    0.6 0.6 0.6;      % 0: No modulation for joint or single endpoint
    0.0 0.0 1.0;      % 1: Modulation for hip joint
    0.0 0.7 0.7;      % 2: Modulation for knee joint
    0.8 0.0 0.8;      % 3: Modulation for both hip and knee joints
    1.0 0.6 0.0];     % 4: Modulation for a single endpoint

% Desired plotting order of categories
desired_order = [2 1 3 4 0];


%% Plot the results of PCA loading analysis
figure;
tiledlayout(2,3,"TileSpacing","compact","Padding","compact");

% Plot Cat A PCA Results
% labels are assumed to start from 0
PC_element_percent = zeros(max(neuron_posture_response_type_catA)+1,3);

for selectPC = 1:3
    labels = neuron_posture_response_type_catA;

    % Compute group-wise sums of normalized loadings
    group_sums_all = zeros(max(labels)+1,1);
    for lbl = 0:max(labels)
        group_sums_all(lbl+1) = sum(normalized_loading_catA(labels == lbl,selectPC));
    end

    % Convert to percentage
    PC_element_percent(:,selectPC) = group_sums_all * 100;

    % Reorder categories in clockwise order
    group_sums = group_sums_all(fliplr(desired_order)+1);
    pieColors  = colorMap(fliplr(desired_order)+1,:);

    % --- Plot pie chart ---
    nexttile;
    pie(group_sums);
    colormap(pieColors);

    % Retrieve patch and text objects
    patches = flipud(findobj(gca,'Type','patch'));
    texts   = flipud(findobj(gca,'Type','text'));

    for k = 1:length(group_sums)
        percent_val = group_sums(k) * 100;

        % Display percentage label (hide if zero)
        if percent_val == 0
            texts(k).String = '';
        else
            texts(k).String = sprintf('%.1f%%', percent_val);
        end

        % Set text appearance
        texts(k).Color = [0.9 0.9 0.9];
        texts(k).FontWeight = 'bold';
        texts(k).FontSize = 8;
        texts(k).FontName = 'Arial';

        % Compute center angle of each pie slice
        verts = patches(k).Vertices;
        centerAngle = atan2(mean(verts(:,2)), mean(verts(:,1)));

        % Manually adjusted radial and angular offsets to avoid label overlap
        if selectPC == 1
            r_adjust = [0.4 0.35 0.3 0.6 0.2];
            angle_adjust = [-deg2rad(25) -deg2rad(5) -deg2rad(5) deg2rad(15) 0];
        elseif selectPC == 2
            r_adjust = [0.4 0.3 0.3 0.3 0.7];
            angle_adjust = [-deg2rad(15) deg2rad(10) -deg2rad(10) deg2rad(3) -deg2rad(10)];
        else
            r_adjust = [0.4 0.35 0.4 0.5 0.7];
            angle_adjust = [-deg2rad(15) deg2rad(15) deg2rad(10) deg2rad(10) -deg2rad(5)];
        end

        % Update label position
        r = r_adjust(k);
        a = centerAngle + angle_adjust(k);
        texts(k).Position = [r*cos(a), r*sin(a), 0];
    end

    % Add title and adjust position slightly downward
    titleHandle = title(sprintf('PC%d', selectPC), ...
        'FontName','Arial','FontSize',10,'FontWeight','bold','Color','k');
    titlePos = titleHandle.Position;
    titleHandle.Position = [titlePos(1), titlePos(2)-0.2, titlePos(3)];
end


% Plot Cat B PCA Results
% labels are assumed to start from 0
PC_element_percent = zeros(max(neuron_posture_response_type_catB)+1,3);

for selectPC = 1:3
    labels = neuron_posture_response_type_catB;

    % Compute group-wise sums of normalized loadings
    group_sums_all = zeros(max(labels)+1,1);
    for lbl = 0:max(labels)
        group_sums_all(lbl+1) = sum(normalized_loading_catB(labels == lbl,selectPC));
    end

    % Convert to percentage
    PC_element_percent(:,selectPC) = group_sums_all * 100;

    % Reorder categories in clockwise order
    group_sums = group_sums_all(fliplr(desired_order)+1);
    pieColors  = colorMap(fliplr(desired_order)+1,:);

    % --- Plot pie chart ---
    nexttile;
    pie(group_sums);
    colormap(pieColors);

    % Retrieve patch and text objects
    patches = flipud(findobj(gca,'Type','patch'));
    texts   = flipud(findobj(gca,'Type','text'));

    for k = 1:length(group_sums)
        percent_val = group_sums(k) * 100;

        % Display percentage label (hide if zero)
        if percent_val == 0
            texts(k).String = '';
        else
            texts(k).String = sprintf('%.1f%%', percent_val);
        end

        % Set text appearance
        texts(k).Color = [0.9 0.9 0.9];
        texts(k).FontWeight = 'bold';
        texts(k).FontSize = 8;
        texts(k).FontName = 'Arial';

        % Compute center angle of each pie slice
        verts = patches(k).Vertices;
        centerAngle = atan2(mean(verts(:,2)), mean(verts(:,1)));

        % Manually adjusted radial and angular offsets to avoid label overlap
        if selectPC == 1
            r_adjust = [0.3 0.6 0.3 0.25 0.7];
            angle_adjust = [-deg2rad(10) deg2rad(25) deg2rad(10) deg2rad(15) -deg2rad(5)];
        elseif selectPC == 2
            r_adjust = [0.2 0.5 0.5 0.6 0.2];
            angle_adjust = [-deg2rad(10) deg2rad(10) -deg2rad(10) deg2rad(3) -deg2rad(5)];
        else
            r_adjust = [0.2 0.25 0.4 0.45 0.7];
            angle_adjust = [-deg2rad(15) deg2rad(5) deg2rad(10) deg2rad(10) -deg2rad(5)];
        end

        % Update label position
        r = r_adjust(k);
        a = centerAngle + angle_adjust(k);
        texts(k).Position = [r*cos(a), r*sin(a), 0];
    end

    % Add title and adjust position slightly downward
    titleHandle = title(sprintf('PC%d', selectPC), ...
        'FontName','Arial','FontSize',10,'FontWeight','bold','Color','k');
    titlePos = titleHandle.Position;
    titleHandle.Position = [titlePos(1), titlePos(2)-0.25, titlePos(3)];
end

% Setting figure
set(gcf,'Units','centimeters');
set(gcf,'Position',[2 2 12 8]);  
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[12 8]);
set(gcf,'PaperPosition',[0 0 12 8]);
set(gcf,'PaperPositionMode','manual');

% Print and save figure
export_path = fullfile(figureFolder, 'Figure10.emf');
print(gcf, export_path, '-dmeta', '-r600');