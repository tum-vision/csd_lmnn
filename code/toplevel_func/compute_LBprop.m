

SHAPES = get_files(DIRS.SHAPES);
mknedir(DIRS.EVECS);
t_all = tic;
fprintf('\n\nComputing LB properties...\n');

    parfor i=1:length(SHAPES)
        
        [~,shapename] = fileparts(SHAPES{i}); 
       
        savefile  = fullfile(DIRS.EVECS, [shapename '.mat']);
        if exist(savefile, 'file'),
             fprintf('File %s already exists, skipping\n', shapename);
             continue;
        end   
       
        M = load(SHAPES{i});       
        N = struct;
        tic;
        fprintf('Computing LB for shape %s\n', SHAPES{i}); 
        
        if strfind(CUR.DATASET, 'SHREC14')
            if CUR.IS_SYNTHETIC
                M.VERT = M.VERT * SHAPE_SCALING.SYNTHETIC;
            else 
                M.VERT = M.VERT * SHAPE_SCALING.REAL;
            end
        end
        
        [N.evecs, N.evals, N.S] = calc_LB(M, MAX_NUM_EVECS);
        parsave(savefile, N);
        toc;
    end


fprintf('\nElapsed time:   %s\n', format_time(toc(t_all))); 


