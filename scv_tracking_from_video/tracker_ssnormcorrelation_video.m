function [ out ] = tracker_ssnormcorrelation_video(settings,vid_obj,start_time,end_time)
%
% FUNCTION
%   TRACKER_SSNORMCORRELATION performs normalized cross-correlation on a
%   scale-space to adjust the bounding box and centroid of a given template
%
% USAGE
%   OUT = TRACKER_SSNORMCORRELATION(SETTINGS).
%
% INPUT
%   SETTINGS: A structure containing all the tracking settings and the
%   images.
%
% OUTPUT
%   OUT: A structure containing the background, the tracked regions, the
%   centroids, and the contours.
%
% AUTHOR
%   Christos Bergeles
%   Filip Paszkiewicz    
%
% DATE
%   21.08.2017

  global debug;

  if nargin < 1
      error('TRACKER_SSNORMCORRELATION: SETTINGS structure is required.');
  end
  
  vid_obj.CurrentTime = start_time;
  time = round((end_time-start_time)*vid_obj.FrameRate);
%   images = settings.images;

  % Construct the scale space
  sigma = 1;
  ss_template = cell(settings.scale_space, 1);
  ss_A        = cell(settings.scale_space, 1);
  ss_template{1} = settings.template;
  
  for i = 2:settings.scale_space
    h              = fspecial('gaussian', [3*i 3*i], i*sigma);
    ss_template{i} = imfilter(settings.template, h);
  end
  
  % Find the normalised cross-correlation
  xbegin = settings.template_box(1); % 1;
  xend   = settings.template_box(2); % im_dims(2);
  ybegin = settings.template_box(3); % 1;
  yend   = settings.template_box(4); % im_dims(1);
  
  [waitbar_handle, waitbar_time] = start_waitbar('Tracking', 1, time);
  i = 0;
  
  while(vid_obj.CurrentTime <= 10)

    i = i + 1;  

    waitbar_time = update_waitbar(waitbar_handle, waitbar_time, 'Tracking', i, time);

%     frame = get_image_data_from_struct(images, i, settings);
    frame = rgb2gray(readFrame(vid_obj));
    frame = imcrop(frame, settings.roi);
    frame = imfilter(frame, fspecial('gaussian'));
    ss_A{1} = frame;
    
    for j = 2:settings.scale_space
      h              = fspecial('gaussian', [3*j 3*j], j*sigma);
      ss_A{j}        = imfilter(frame, h);
    end
    
    for k = settings.scale_space:-1:1

      % Resize window
      distances = [k*2, (ybegin - 1) + 5, abs(yend - size(frame, 1)) + 5, (xbegin - 1) + 5, abs(xend - size(frame, 2)) + 5];
      wind = min(distances);
      
      ybegin = ybegin - wind;      
      yend   = yend + wind;      
      xbegin = xbegin - wind;   
      xend   = xend + wind;
      
      if ybegin<0.01 || yend<0.01 || xbegin<0.01 || xend<0.01
          fprintf('Something went wrong!\n')
          return
      end
      
      c = normxcorr2(ss_template{k}, ss_A{k}(ybegin:yend, xbegin:xend));
      [~, imax] = max(abs(c(:)));
      [ypeak, xpeak] = ind2sub(size(c), imax);

      % Offset found by correlation
      offset = [(xpeak - size(ss_template{k}, 2))
                (ypeak - size(ss_template{k}, 1))];
      xbegin = offset(1) + xbegin;
      xend   = size(ss_template{k}, 2) + xbegin - 1;
      ybegin = offset(2) + ybegin;
      yend   = size(ss_template{k}, 1) + ybegin - 1;

    end
    
    out.contour{i} = [xbegin xend xend xbegin xbegin;
                      ybegin ybegin yend yend ybegin];
    out.centroid{i} = [(xend + xbegin); (yend + ybegin)]/2;
    
    if mod(i, 10) == 0
        % Show the extracted object
        if ~exist('segmentation_figure', 'var')
            segmentation_figure = figure;
        end
        figure(segmentation_figure);
        imshow(frame);
        hold on;
        plot(out.centroid{i}(1), out.centroid{i}(2), '+w');
        plot_rectangle(out.contour{i}([1 3 2 6]), 'w');
        title('Detected object');
        hold off;
        pause(0.2);
    end
  end

  close_waitbar(waitbar_handle);
  fprintf('WE are done!\n')  
end