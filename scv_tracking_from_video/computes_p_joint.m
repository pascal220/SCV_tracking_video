%   File: 'computes_p_joint.m'
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

p_joint = zeros(n_bins+1, n_bins+1);

for i = 1:Nx
    cur = round(Warped(i));
    ref = round(Template(i));
    
    p_joint(cur+1, ref+1) = p_joint(cur+1, ref+1) + 1;
end

p_joint = p_joint/Nx;

% Marginals

p_ref = sum(p_joint);
p_cur = sum(p_joint');

