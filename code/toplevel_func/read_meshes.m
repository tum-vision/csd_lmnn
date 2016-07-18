
MESHES = get_files(DIRS.MESHES, '*.obj');
mknedir(DIRS.SHAPES);
t_all = tic;
fprintf('Reading meshes...\n');

    parfor i=1:length(MESHES)

       meshfile = MESHES{i}; 
       [~,meshname] = fileparts(MESHES{i});

       if isstrnumeric(meshname)   
            shapefile = [sprintf('%04d', str2double(meshname)) '.mat'];
       else          
           shapefile = [meshname '.mat'];
       end

       savefile  = fullfile(DIRS.SHAPES, shapefile);
       if exist(savefile, 'file'),
            fprintf('File %s already exists, skipping\n', shapefile);
            continue;
       end

       fprintf('Reading mesh %s\n', meshname);     
       M = struct;
       tic;
       [M.VERT, M.TRIV] = read_mesh(meshfile); 

        if size(M.VERT,1) == 3
            M.VERT = M.VERT';
        end

        if size(M.TRIV,1) == 3
            M.TRIV = M.TRIV';
        end
     
        parsave(savefile, M); % Now save    
        toc;
    end

fprintf('\nElapsed time:   %s\n', format_time(toc(t_all))); 


