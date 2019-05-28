%% ROLLING GUIDANCE FILTER

% A method from the paper Rolling Guidance Filter
% by Qi Zhang et al.

%%
% Combining small structure removal and edge recovery
% INPUT: I - the original input image
%        w - size of the slide window
%        sigma_s - spatial weight
%        sigma_r - range weight
% OUTPUT:an output image
%%

function [output] = rolling_guidance(I, w, sigma_s, sigma_r, iteration) 
    output = I.*0;
    
    for i = 1:iteration
        G = output;
        output = joint_bilateral(I, w, G, sigma_s, sigma_r);
    end

end

%%
% Combining small structure removal and edge recovery
% INPUT: image - the original input image
%        width - size of the slide window
%        G - rolling guidance
%        sigma_s - spatial weight
%        sigma_r - range weight
% OUTPUT:an output image
%%

function [J_new] = joint_bilateral(image, width, G, sigma_s, sigma_r) 
    J_new = image.*0;
    
    [pi, pj] = meshgrid(-width:width, -width:width);
    closeness = exp(-(pi.^2 + pj.^2) / (2 * sigma_s^2));

    for channel = 1:3
        cur_channel = image(:, :, channel);
        J_t = G(:, :, channel);
        [r, c] = size(cur_channel);
        for i = 1:r
            for j = 1:c
                %create a widow
                i_min = max(i-width, 1);
                i_max = min(i+width, r);
                j_min = max(j-width, 1);
                j_max = min(j+width, c);
                I_q = cur_channel(i_min:i_max, j_min:j_max);
                
                

                removal =closeness((i_min:i_max)-i+width+1, (j_min:j_max)-j+width+1);
                recover = exp(-(J_t(i_min:i_max, j_min:j_max)-J_t(i, j)).^2 / (2*sigma_r^2));
                H = recover .* removal .* I_q;

                Kp = sum(removal.*recover);
                cur_channel(i, j) = sum(H) / Kp;
            end
        end
        J_new(:, :, channel) = cur_channel;
    end
end