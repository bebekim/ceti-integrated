function [travel_time, angles] = calculate_eigenray_time_fast(range, source_depth, receiver_depth, c_func, surface_reflected)
    % Fast eigenray calculation with approximate angles
    
    if surface_reflected
        % Surface reflected: use image source
        total_depth = source_depth + receiver_depth;
        path_length = sqrt(range^2 + total_depth^2);
        
        % Approximate launch angle
        theta_S = atan2(range, source_depth);  % Launch angle at source
        theta_H = atan2(range, receiver_depth); % Arrival angle at hydrophone
        
        % Approximate travel time using average sound speed
        c_avg = (c_func(0) + c_func(source_depth) + c_func(receiver_depth)) / 3;
        travel_time = path_length / c_avg;
        
    else
        % Direct ray
        depth_diff = abs(receiver_depth - source_depth);
        path_length = sqrt(range^2 + depth_diff^2);
        
        % Approximate angles
        theta_S = atan2(range, depth_diff);
        theta_H = theta_S; % Approximate for direct ray
        
        % Average sound speed along approximate path
        z_mid = (source_depth + receiver_depth) / 2;
        c_avg = (c_func(source_depth) + c_func(z_mid) + c_func(receiver_depth)) / 3;
        travel_time = path_length / c_avg;
    end
    
    % Return angle data
    angles = struct();
    angles.cos_theta_S = cos(theta_S);
    angles.sin_theta_S = sin(theta_S);
    angles.sin_theta_H = sin(theta_H);
    angles.cos_theta_H = cos(theta_H);
end
