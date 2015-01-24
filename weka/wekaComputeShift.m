% Computes estimated clock shift by repeatedly shifting one interval to the left
% until classified as 'not shifted'

%function shift = wekaComputeShift(dataset, classifier, feature_subset, test_id)


% TODO make this a function
DATASET = 'datasets/data_6_avg.csv';
CLASSIFIER = 'trees.RandomForest';
FEATURES = [];
TEST_ID = 17;

% Add weka and svm libraries to the classpath
if ~wekaPathCheck
    javaaddpath('lib/weka.jar');
    javaaddpath('lib/libsvm.jar');
end

data = csvread(DATASET);

display('Computing shift of ');
display(data(TEST_ID, 1:7));

% Remove date/time etc. and set last col to class (col index 7)
features = data(:, 8:end);
no_features = size(features, 2);
% Apply feature subset
if isempty(FEATURES)
    FEATURES = 1:length(features); 
end
features_subset = features(:, FEATURES);
classes = data(:, 7);
test_class = classes(TEST_ID, 1);

% Transform 0/1 class into not_shifted/shifted
classes = cellstr(num2str(classes));
classes = strrep(classes, '0', 'not_shifted');
classes = strrep(classes, '1', 'shifted');

% Feature names
no_features_subset = size(features_subset, 2);
feature_names = strcat({'interval'}, cellstr(num2str((1:no_features_subset)')));
feature_names{length(feature_names)+1} = 'class';

% Split into training set and test set
train = [num2cell(features_subset), classes];

train(TEST_ID, :) = [];

train_weka = matlab2weka('shift-train', feature_names, train, size(train, 2));

classifier = trainWekaClassifier(train_weka, CLASSIFIER);

test_features = features(TEST_ID, :);

for i=0:no_features
    
    % Shift test sample 1 interval to the left
    test_features = circshift(test_features, [0, -1]);
    
    test_features_subset = test_features(:, FEATURES);
    
    % We need samples with all possible classes in the testset, otherwise
    % randomforest fails. Hence we append the trainingset and testset
    test = [train ; num2cell(test_features_subset) classes(TEST_ID)];
    
    test_weka = matlab2weka('shift-test', feature_names, test);
    
    predicted = wekaClassify(test_weka, classifier);
    predicted = predicted(end, :);
    
    if predicted ~= test_class
        display(i);
        display(predicted);
        break;
    end
    
end


