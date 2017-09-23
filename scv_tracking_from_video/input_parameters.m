%   File: 'input_parameters.m'
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


% Image dataset parameters
path_to_images = 'C:\Users\Filip\OneDrive\UCL\PhD{MRes}_thesis\Matlab\scv_trucking_from_video\121319-3997712_images\';
file_name = '';
image_format = '.png';
length_number = 8; % size of number characters in image name
nb_first_image = 1;
nb_last_image = 216;

% Storage directory
path_to_save = './sauvegarde/';
file_name_save = 'tracked_';

% Position of reference image on first frame
pos = [900 80];

% Select reference image size (in pixels, MUST BE PAIR)
size_template_x = 200; 
size_template_y = 150; 

% Number of histogram bins
n_bins = 64;

% Maximum number of iterations
maxIters = 30;

% Threshold for breaking optimization loop
epsilon = 0.01;