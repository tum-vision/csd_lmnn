descType = DESC_TYPES.wks;
descParams = get_desc_params(descType);

SHAPES = get_files(DIRS.EVECS);
DESC_DIR = fullfile(DIRS.DESC, descType);
mknedir(DESC_DIR);


t_all = tic;
fprintf('\n\nComputing %s descriptors for set of shapes...\n', descType);

    parfor i=1:length(SHAPES)

        [~, shapename] = fileparts(SHAPES{i});
        
        savefile  = fullfile(DESC_DIR, [shapename '.mat']);
        if exist(savefile, 'file'),
             fprintf('File %s already exists, skipping\n', shapename);
             continue;
        end         
               
        fprintf('Computing %s for shape %s\n', descType, shapename);  
        M = load(SHAPES{i}, 'evecs', 'evals');  
        
        D = struct;
        D.desc = compute_pdesc(descType, M.evecs, M.evals, descParams); 
        D.descType = descType;
        D.descParams = descParams;
        parsave(savefile, D);

    end

fprintf('\nElapsed time:   %s\n', format_time(toc(t_all))); 