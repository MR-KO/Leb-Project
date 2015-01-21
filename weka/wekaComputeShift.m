% Computes estimated clock shift by repeatedly shifting one interval to the left
% until classified as 'not shifted'

% TODO make this a function
DATASET = 'datasets/data_10_avg.csv';
CLASSIFIER = 'trees.RandomForest';
TEST_ID = 25;

% Add weka and svm libraries to the classpath
if ~wekaPathCheck
    javaaddpath('lib/weka.jar');
    javaaddpath('lib/libsvm.jar');
end

data = csvread(DATASET);
display(size(data), 'data size');

% Remove date/time etc. and set last col to class (col index 7)
features = data(:, 8:end);
classes = data(:, 7);
display(size(features), 'feature size');
display(size(classes), 'class size');

% Transform 0/1 class into not_shifted/shifted
classes = cellstr(num2str(classes));
classes = strrep(classes, '0', 'not_shifted');
classes = strrep(classes, '1', 'shifted');

% Feature names
no_features = length(features);
feature_names = strcat({'interval'}, cellstr(num2str((1:no_features)')));
feature_names{length(feature_names)+1} = 'class';

% Split into training set and test set
train = [num2cell(features), classes];

% We need samples with all possible classes in the testset, otherwise
% randomforest fails. Hence we append the trainingset and testset
test = [train ; train(TEST_ID, :)];
train(TEST_ID, :) = [];

train = matlab2weka('shift-train', feature_names, train, length(train));
test = matlab2weka('shift-test', feature_names, test);

classifier = trainWekaClassifier(train, CLASSIFIER);

predicted = wekaClassify(test, classifier);
predicted = predicted(end, :);
