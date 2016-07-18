function [evecs, evals, area] = calc_LB(shape, max_num_evals)

    if isfield(shape, 'VERT')
        max_num_evals = min(size(shape.VERT,1), max_num_evals);
    elseif isfield(shape, 'X')
        max_num_evals = min(size(shape.X,1), max_num_evals);
    else
    	error('No field for vertices found in struct shape!')
    end

    [evecs, evals, W, area] = main_mshlp('cotangent', shape, max_num_evals ); %#ok<ASGLU>
    
    evals = abs(real(evals));
    evecs = real(evecs);
end
