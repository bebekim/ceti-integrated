function path_data = create_simplified_path(range, source_depth, receiver_depth, surface_reflected)
    % Create simplified path data for sound speed derivative
    
    if surface_reflected
        % Two segments: source to surface, surface to receiver
        z_path = [source_depth, 0, receiver_depth];
    else
        % Direct path
        z_path = [source_depth, receiver_depth];
    end
    
    path_data = struct();
    path_data.z_path = z_path;
    path_data.total_range = range;
    path_data.surface_reflected = surface_reflected;
end
