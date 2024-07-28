% Specify the folder containing images
folderPath = 'D:/CANS_PAPER_LATEX_CODE_12th_MAY_2024/Qualitative Results/WAZIR_MODEL_IMAGES';

% Get a list of all image files in the folder
imageFiles = dir(fullfile(folderPath, '*.png')); % Change the extension as needed

% Create a NIQE model
model = niqeModel(rand(1,36), rand(36,36), [10 10], 0.25);

% Initialize an array to store NIQE values
niqeValues = zeros(length(imageFiles), 1);

% Loop through each image file
for i = 1:length(imageFiles)
    % Read the image
    imgPath = fullfile(folderPath, imageFiles(i).name);
    I = imread(imgPath);
    
    % Convert to grayscale if the image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end
    
    % Check if the image is at least 7x7 pixels
    if size(I, 1) < 7 || size(I, 2) < 7
        fprintf('Skipping %s: image is too small (%dx%d).\n', imageFiles(i).name, size(I, 1), size(I, 2));
        niqeValues(i) = NaN; % Set score to NaN for small images
        continue;
    end
    
    % Calculate NIQE using the model
    try
        score = niqe(I, model); % Calculate NIQE score
    catch ME
        fprintf('Error calculating NIQE for %s: %s\n', imageFiles(i).name, ME.message);
        score = NaN; % Set score to NaN if there's an error
    end
    
    niqeValues(i) = score;
    
    % Display the NIQE value for the current image
    fprintf('NIQE for %s: %.4f\n', imageFiles(i).name, score);
end

% Calculate the average NIQE, excluding NaN values
validNiqeValues = niqeValues(~isnan(niqeValues));
averageNIQE = mean(validNiqeValues);

if isempty(validNiqeValues)
    fprintf('Average NIQE: NaN (No valid NIQE values)\n');
else
    fprintf('Average NIQE: %.4f\n', averageNIQE);
end
