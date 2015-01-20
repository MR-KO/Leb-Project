%
% AIDS
% %
% function wekaRandomAidsForest(filename)
	% Aids for weka ebola
	javaclasspath('./weka/lib/weka.jar');

	% Load data
	data = csvread('data_10_avg.csv');
	classindex = 7;
	% features = data(:, classindex+1:end);

	% Separate shifted and non-shifted dataset
	not_shifted = data(data(:, classindex) == 0, :);
	shifted = data(data(:, classindex) == 1, :);

	% Separate test and train data by selecting one fgt bird with birdflu
	index = 4;
	train = data;
	train(index, :) = [];
	test = data(index, :);

	% Put class variable in the last column for crappy bullshit weka aids ebola
	temp = train(:, classindex);
	train(:, classindex) = [];
	train = [train, temp];
	train = train(:, classindex:end);

	temp = test(:, classindex);
	test(:, classindex) = [];
	test = [test, temp];
	test = test(:, classindex:end);

	datasize = size(train, 2);

	clear feature_names;

	for i = 1:datasize-1
		feature_names{i} = strcat('interval ', num2str(i));
	end

	feature_names{datasize} = 'class';

	%Convert to weka format
	classindex = datasize;
	train = matlab2weka('train', feature_names, train, classindex);
	test =  matlab2weka('test', feature_names, test);

	raf = trainWekaClassifier(train, 'trees.RandomForest');
	predicted = wekaClassify(test, raf)


	actual = test.attributeToDoubleArray(classindex - 1) %java indexes from 0
% end


% EBOLA