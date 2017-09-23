function  [CoM_sum , For_vid] = scv_shortcut(visualise, start_time, end_time, vid_obj)
% Creating a video object and setting the start time
vid_obj.CurrentTime = start_time;
im =  rgb2gray(readFrame(vid_obj)); % Fetching the first frame 

% Choose a region you want to be trucked
[Template, rect] = imcrop(im);

n_bins = 128; % Number of histogram bins
maxIters = 30; % Maximum number of iterations per one SCV algorithm iteration
epsilon = 0.01; % Threshold for breaking optimization loop

% Position of reference image on first frame
pos = [round(rect(1) + (rect(3)/2)), round(rect(2) + (rect(4)/2))];

% Selects reference image (Template)
size_template_x = (round(rect(3))/2);
size_template_y = (round(rect(4))/2); 

% Setting the chosen part of the image as a template
Template = double(Template);
H = [ 1 0 pos(1)-size_template_x; 0 1 pos(2)-size_template_y; 0 0 1];
    
% Initializing SCV parameters
size_bin = 256 / n_bins;
Nx = numel(Template);
expected_grayscale = 1:n_bins+1;

% Initializing expected image T_hat
Template = round(Template./size_bin);
[Ix_t, Iy_t] = gradient(Template);
Expected = Template(:);

time = round((end_time-start_time)*vid_obj.FrameRate);
[waitbar_handle, waitbar_time] = start_waitbar('Tracking', 1, time);
counter = 0;
CoM_sum = zeros(round(time*3/4),2);
For_vid = cell(round(time*3/4),2);

% SCV on Video
while vid_obj.CurrentTime <= end_time
    
    counter = counter + 1;   
    waitbar_time = update_waitbar(waitbar_handle, waitbar_time, 'Tracking', counter, time);
    
    % Loads image
    ICur_gray = rgb2gray(readFrame(vid_obj));
    
    % Tracking
    [H, Expected, Ix_t, Iy_t, Warped, p_joint] = tracking_scv(ICur_gray, H, Expected, Template(:), n_bins, size_bin, Nx, size_template_x, size_template_y, Ix_t, Iy_t, epsilon, maxIters);
   
    T_pos = H*[0 2*size_template_x 2*size_template_x 0 0; 0 0 2*size_template_y  2*size_template_y 0; ones(1,5)];
    T_pos(1,:) = T_pos(1,:)./T_pos(3,:);
    T_pos(2,:) = T_pos(2,:)./T_pos(3,:);
    
    x_sum = sum(T_pos(1,1:4))/4;
    y_sum = sum(T_pos(2,1:4))/4;
    
    CoM_sum(counter,:) = [x_sum y_sum];
    For_vid{counter,1} = T_pos(1,:);
    For_vid{counter,2} = T_pos(2,:);
    
    % Display
    if visualise
        figure(1) ; clf ;
        imshow(uint8(ICur_gray)); axis image ; % Main image
        hold on

        plot(T_pos(1,:), T_pos(2,:),'g-','LineWidth',2,'MarkerSize',6)% Box
        hold on
        plot(x_sum, y_sum, 'r+') % Centre of the box
        drawnow
        
    end
end
close_waitbar(waitbar_handle);
close all;

end