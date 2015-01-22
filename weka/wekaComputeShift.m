% Computes estimated clock shift by repeatedly shifting one interval to the left
% until classified as 'not shifted'

% TODO make this a function
DATASET = 'datasets/data_10_avg.csv';
CLASSIFIER = 'trees.RandomForest';
TEST_ID = 24;

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
classes = data(:, 7);
test_class = classes(TEST_ID, 1);

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

train_weka = matlab2weka('shift-train', feature_names, train, length(train));

classifier = trainWekaClassifier(train_weka, CLASSIFIER);

for i=0:no_features
    
    test_weka = matlab2weka('shift-test', feature_names, test);
    
    predicted = wekaClassify(test_weka, classifier);
    predicted = predicted(end, :);
    
    if predicted ~= test_class
        display(i);
        display(predicted);
        break;
    end
    
    % Shift test sample 1 interval to the left
    test = [ circshift(test(:,1:end-1),[0,-1]) test(:,end)];
    
end


