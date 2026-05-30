function [path_r, path_z] = viterbi_beamsearch(E, P, B)

    [R, Z, T] = size(E);
    % logE = log(E + eps);  % Convert to log-space, avoid log(0)
     logE = E;
    log_probs = -inf(R, Z, T);
    backpointer = zeros(R, Z, T, 2);  % stores previous [r, z] per pixel

    % Initialization at t = 1
    log_probs(:,:,1) = logE(:,:,1);

    % Create uniform transition kernel (just used to define P x P window)
    halfP = floor(P/2);

    for t = 2:T
        t
        % Find top B previous states (linear indices)
        prev_probs = log_probs(:,:,t-1);
        [~, idx] = maxk(prev_probs(:), B);
        [r_inds, z_inds] = ind2sub([R, Z], idx);

        % Temporary log_prob storage for time t
        log_probs_t = -inf(R, Z);
        back_t = zeros(R, Z, 2);

        for i = 1:B
            r0 = r_inds(i);
            z0 = z_inds(i);
            prev_score = prev_probs(r0, z0);

            % Iterate over P x P neighborhood around (r0, z0)
            for dr = -halfP:halfP
                for dz = -halfP:halfP
                    r = r0 + dr;
                    z = z0 + dz;

                    if r >= 1 && r <= R && z >= 1 && z <= Z
                        score = prev_score + logE(r,z,t);  % uniform transition
                        if score > log_probs_t(r,z)
                            log_probs_t(r,z) = score;
                            back_t(r,z,:) = [r0, z0];
                        end
                    end
                end
            end
        end

        % Store results
        log_probs(:,:,t) = log_probs_t;
        backpointer(:,:,t,:)= back_t;
    end

    % Backtrack: find best final state
    [~, final_idx] = max(log_probs(:,:,T), [], 'all', 'linear');
    [r_t, z_t] = ind2sub([R, Z], final_idx);

    path_r = zeros(1, T);
    path_z = zeros(1, T);
    path_r(T) = r_t;
    path_z(T) = z_t;

    for t = T:-1:2
        prev = squeeze(backpointer(path_r(t), path_z(t), t, :));
        path_r(t-1) = prev(1);
        path_z(t-1) = prev(2);
    end
end
