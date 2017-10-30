function frames = get_frames_from_dir( directory, start_time, end_time)

% AUTHOR
    %   Filip Paszkiewicz
    %
    % DATE
    %   21.08.2017

file_name = directory;

% Creat a VideoReader 
vidObj = VideoReader(file_name);

% Loop through video to make images out of frames
vidObj.CurrentTime = start_time;
ii = 1;

frames = zeros(vidObj.Height,vidObj.Width);

while  vidObj.CurrentTime <= end_time
   img = readFrame(vidObj);
   if size(img,3) ~= 1
       frames(:,:,ii) = rgb2gray(im2double(img));
   else
       frames(:,:,ii) = img;
   end
   
   ii = ii+1;
end

end
