%   File: 'tracking_scv.m'
%
%   Author(s):  Rogerio Richa
%   Created on: 2011
% 
%   (C) Copyright 2006-2011 Johns Hopkins University (JHU), All Rights
%   Reserved.
% 
% --- begin cisst license - do not edit ---
% 
% This software is provided "as is" under an open source license, with
% no warranty.  The complete license can be found in license.txt and
% http://www.cisst.org/cisst/license.txt.
% 
% --- end cisst license ---


function [H, Expected, Ix_t, Iy_t, Warped, p_joint] = tracking_scv(ICur_gray, H, Expected, Template, n_bins, size_bin, Nx, size_template_x, size_template_y, Ix_t, Iy_t, epsilon, maxIters)

% Runs for a maximum number of 'maxIters' iterations
for iters = 1:maxIters
    
    % Computes warped image
    Warped_original = warp(double(ICur_gray), H, size_template_x*2, size_template_y*2);
    
    % Quantization
    Warped = round(Warped_original./size_bin); 
    
    % Computes gradient
    [Ix, Iy] = gradient(Warped);

    % Image difference
    di = Warped(:) - Expected;
    
    % Jacobian
    J = jacobian(Ix+Ix_t, Iy+Iy_t, Nx, size_template_x*2, size_template_y*2);
    
    % Update
    d = -2*pinv(J)*(di);
    A = [d(5),d(3),d(1); d(4),-d(5)-d(6),d(2); d(7),d(8),d(6)];
    H = H*expm(A);
    
    if sum(abs(d)) < epsilon
        break;
    end
end

% Computes joint intensity distribution
computes_p_joint;

% Computes expected grayscale values for expected image
find_expected_grayscale;

% Updates expected image 
Update = compute_updates(Template, expected_grayscale, Nx);
Expected = Template - Update;

% .. and its gradient
[Ix_t, Iy_t] = gradient(reshape(Expected, 2*size_template_y, 2*size_template_x));
                
% iters

return