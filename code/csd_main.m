%% Init directories and files to work with
startup;

%% Choose dataset and resolution 
init_dataset;

%% Compute and save required quantities for the algorithm
precompute;

%% Get pooled descriptors 
SihksPooledMat = get_pooled_desc(DESC_TYPES.sihks, '', 'L2'); 
WksPooledMat = get_pooled_desc(DESC_TYPES.wks, 'L2', 'L2');  

%% Choose desired descriptor or combination of descriptors
%Smat = SihksPooledMat; 
%Smat = WksPooledMat;                                                        
Smat = [WksPooledMat SihksPooledMat];

Smat = normalize(Smat, 'L2', 2);
Dist = pdist2(Smat, Smat);

%% Evaluate descriptors before learning
shreceval = eval_on_shrec_modif(Dist, C)

%% Run LMNN for a number of runs
nRuns = 2;
accs = zeros(nRuns, 1);
for iter=1:nRuns
    %% Split datasets for learning
    [xTr, yTr, xTe, yTe] = define_learningset(Smat, C, TRAININGSET_RATIO); 
    [xVa, yVa, xTr, yTr] = define_learningset(xTr, yTr, VALID2TRAIN_RATIO);

    % Transpose data for LMNN
    xTr = xTr'; yTr = yTr'; xTe = xTe'; yTe = yTe'; xVa = xVa'; yVa = yVa';

    % LMNN parameter tuning
    fprintf('Searching for optimal LMNN params...\n');
    t_lmnnParams = tic;
    [Klmnn, Knn, outdim, maxiter] = findLMNNparams(xTr,yTr,xVa,yVa); 
    fprintf('Found optimal LMNN params for %d shapes in %s\n', length(yTr), format_time(toc(t_lmnnParams)));

    % Train full model
    tic;
    fprintf('Training final model...\n');
    [L, Details] = lmnnCG([xTr xVa], [yTr yVa], Klmnn, 'maxiter', maxiter, 'outdim', outdim);
    toc;

    % Test 
    [testerr, details] = knncl(L, xTr, yTr, xTe, yTe, Klmnn, 'train', 0);
    acc = 100*(1 - testerr);
    fprintf('Testing accuracy: %2.2f%%\n', acc);
    accs(iter) = acc;
end


meanAcc = mean(accs);
mknedir(DIRS.EVALUATION);
resultsFile = fullfile(DIRS.EVALUATION, ['eval_CSD_nRuns' num2str(nRuns)] );
save(resultsFile, 'accs', 'meanAcc');
fprintf('Mean accuracy after %d runs is %.2f\n', nRuns, meanAcc);

%% Plot the space of shapes
X = [xTr xVa xTe]';
GT = [yTr yVa yTe]';
figure(1)
subplot(1,2,1);
plot_spaceofshapes( X, GT, 'Shapes before learning');
subplot(1,2,2);
plot_spaceofshapes( X*L', GT, 'Shapes after learning');
