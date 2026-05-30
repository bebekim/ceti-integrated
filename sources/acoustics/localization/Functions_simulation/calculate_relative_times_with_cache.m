function [s1r1, s21, s2r2, eigenray_cache] = calculate_relative_times_with_cache(r1, r2, zS, h1, h2, c_func)
    % Calculate travel times and cache eigenray data for Jacobian
     % r1=r_true(pos); r2=r_true(pos); zS=z_true(pos); h1=h1_actual; h2=h2_actual; 
    % Preallocate cache structure
    eigenray_cache = struct();
    eigenray_cache.angles = struct();
    eigenray_cache.sound_speeds = struct();
    eigenray_cache.paths = struct();
    
    % Sound speeds at key points
    eigenray_cache.sound_speeds.c_S = c_func(zS);
    eigenray_cache.sound_speeds.c_H1 = c_func(h1);
    eigenray_cache.sound_speeds.c_H2 = c_func(h2);
    
    % Calculate eigenrays with simplified angle estimation
    [t1_dir, angles_1d] = calculate_eigenray_time_fast(r1, zS, h1, c_func, false);
    [t1_refl, angles_1r] = calculate_eigenray_time_fast(r1, zS, h1, c_func, true);
    [t2_dir, angles_2d] = calculate_eigenray_time_fast(r2, zS, h2, c_func, false);
    [t2_refl, angles_2r] = calculate_eigenray_time_fast(r2, zS, h2, c_func, true);
    
    % Store angles
    eigenray_cache.angles.cos_theta_S1_dir = angles_1d.cos_theta_S;
    eigenray_cache.angles.sin_theta_S1_dir = angles_1d.sin_theta_S;
    eigenray_cache.angles.sin_theta_H1_dir = angles_1d.sin_theta_H;
    eigenray_cache.angles.cos_theta_H1_dir = angles_1d.cos_theta_H;
    
    eigenray_cache.angles.cos_theta_S1_refl = angles_1r.cos_theta_S;
    eigenray_cache.angles.sin_theta_S1_refl = angles_1r.sin_theta_S;
    eigenray_cache.angles.sin_theta_H1_refl = angles_1r.sin_theta_H;
    eigenray_cache.angles.cos_theta_H1_refl = angles_1r.cos_theta_H;
    
    eigenray_cache.angles.cos_theta_S2_dir = angles_2d.cos_theta_S;
    eigenray_cache.angles.sin_theta_S2_dir = angles_2d.sin_theta_S;
    eigenray_cache.angles.sin_theta_H2_dir = angles_2d.sin_theta_H;
    eigenray_cache.angles.cos_theta_H2_dir = angles_2d.cos_theta_H;
    
    eigenray_cache.angles.cos_theta_S2_refl = angles_2r.cos_theta_S;
    eigenray_cache.angles.sin_theta_S2_refl = angles_2r.sin_theta_S;
    eigenray_cache.angles.sin_theta_H2_refl = angles_2r.sin_theta_H;
    eigenray_cache.angles.cos_theta_H2_refl = angles_2r.cos_theta_H;
    
    % Store simplified path data for sound speed derivatives
    eigenray_cache.paths.H1_dir = create_simplified_path(r1, zS, h1, false);
    eigenray_cache.paths.H1_refl = create_simplified_path(r1, zS, h1, true);
    eigenray_cache.paths.H2_dir = create_simplified_path(r2, zS, h2, false);
    eigenray_cache.paths.H2_refl = create_simplified_path(r2, zS, h2, true);
    
    % Calculate TDOAs
    s1r1 = t1_refl - t1_dir;
    s21 = t2_dir - t1_dir;
    s2r2 = t2_refl - t2_dir;
end
