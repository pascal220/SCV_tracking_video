%   File: 'find_expected_grayscale.m'
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

expected_grayscale = zeros(1,n_bins+1);

for column = 1:n_bins+1
    
    expected_grayscale(column) = (1:n_bins+1)*(p_joint(:,column)./p_ref(column));
    
end
