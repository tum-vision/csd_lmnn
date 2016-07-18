function [ C, groundtruth ] = read_cla( fname )
%READ_CLA Summary of this function goes here
%   Read a .cla file containing the labels for each data point of a dataset 

fp = fopen(fname,'r');

%Check file header
strTemp = fscanf(fp,'%s',1);
if ~strcmp(strTemp,'PSB')
    display('The format of your classification file is incorrect!');
    return;
end
strTemp = fscanf(fp,'%s',1);
if ~strcmp(strTemp,'1')
    display('The format of your classification file is incorrect!');
    return;
end

numCategories = fscanf(fp,'%d',1);
numTotalModels = fscanf(fp,'%d',1);

fprintf('Reading %d models from %d classes...\n', numTotalModels, numCategories);

testCategoryList.numCategories = numCategories;
testCategoryList.numTotalModels = numTotalModels;

currNumTotalModels = 0;

C = [];

for i=1:numCategories
    currNumCategories = i;
    testCategoryList.categories(currNumCategories).name = fscanf(fp,'%s',1);
    fscanf(fp,'%d',1);
    numModels = fscanf(fp,'%d',1);
    testCategoryList.categories(currNumCategories).numModels = numModels;
    for j=1:numModels
        currNumTotalModels = currNumTotalModels+1;
        testCategoryList.modelsNo(currNumTotalModels) = fscanf(fp,'%d',1)+1;
        testCategoryList.classNo(currNumTotalModels) = currNumCategories;
        C(testCategoryList.modelsNo(currNumTotalModels)) = ...
            testCategoryList.classNo(currNumTotalModels);
    end
end

if (currNumTotalModels~=numTotalModels)
    display('The format of your classification file is incorrect!');
    return;
else
    display('The format of your classification file is correct!');
end
fclose(fp);

C = C';

%%
if nargout > 1
    groundtruth.classints = C;
    groundtruth.classlabels = {testCategoryList.categories.name}';
    groundtruth.instancelabels = testCategoryList.modelsNo';
    groundtruth.clafile = fname;
end


end

