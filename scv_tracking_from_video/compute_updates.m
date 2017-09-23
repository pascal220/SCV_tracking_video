%   File: 'compute_updates.m'
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

function  Update = compute_updates(Template, Expected, Nx)

Update = zeros(Nx, 1);

for i = 1:Nx 
    
    T = Template(i);
    
    Update(i) = T + 1 - Expected(T+1);    
        
end
