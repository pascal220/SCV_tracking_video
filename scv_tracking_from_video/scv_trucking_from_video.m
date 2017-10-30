 function [] = scv_trucking_from_video(vid_name,start_time,end_time,visualise)
    % Script for video tracking using SCV
    %
    % AUTHOR
    %   Filip Paszkiewicz
    %
    % DATE
    %   21.08.2017
    %
    % example
    vid_name = '2017-03-07_123831-16187408.mp4';
    start_time = 0;
    end_time = 140;
    visualise = false;

    %% SCV (Sum of Conditional Variance) Trucking
    % Creat a video object
    vid_obj = VideoReader(vid_name);

    % Data about the top OCT
    [CoM_top, For_vid_top] = scv_shortcut(visualise, start_time, end_time, vid_obj);

    %Data about the bottom OCT
    [CoM_bot, For_vid_bot] = scv_shortcut(visualise, start_time, end_time, vid_obj);

    fprintf('TRACKING DONE!!!\n')

    %% Frequency Analysis 
    % Set up
    Fs = vid_obj.FrameRate; % Sampling frequency
    T = 1/Fs;               % Sampling period
    L = length(CoM_top);    % Length of top dataset 
    t = (0:L-1)*T;          % Time vector

    z1 = CoM_top(:, 2);
    x = CoM_top(:, 1);
    z2 = CoM_bot(:, 2);
    y = CoM_bot(:, 1);

    z = (z1+z2)/2;
    z = z - mean(z);
    x = x - mean(x);
    y = y - mean(y);

    %%PSD/FFT stuff
    nfft = 2^13; % next larger power of 2
    fft_z = fft(z,nfft); % Fast Fourier Transform
    fft_x = fft(x,nfft); % Fast Fourier Transform
    fft_y = fft(y,nfft); % Fast Fourier Transform

    fft_z = abs(fft_z.^2); % raw power spectrum density
    fft_x = abs(fft_x.^2); % raw power spectrum density
    fft_y = abs(fft_y.^2); % raw power spectrum density

    fft_z = fft_z(1:1+nfft/2); % half-spectrum
    fft_x = fft_x(1:1+nfft/2); % half-spectrum
    fft_y = fft_y(1:1+nfft/2); % half-spectrum


    [~,k_z] = max(fft_z); % find maximum
    [~,k_x] = max(x); % find maximum
    [~,k_y] = max(y); % find maximum


    f_scale = (0:nfft/2)* Fs/nfft; % frequency scale
    as_far = 500;

     % Plotting fft
     strt = sprintf('FFT of Z. Dominant freq.: %0.3f Hz',f_scale(k_z));% dominant frequency estimat
     figure (1);
     set(gcf, 'Position', get(0,'Screensize'));
     plot(f_scale(1:as_far), fft_z(1:as_far),'-b+')
     axis('tight')
     grid('on')
     title(strt)
     xlabel('Frequency (Hz)')
 
     strt = sprintf('FFT of X. Dominant freq.: %0.3f Hz',f_scale(k_x));% dominant frequency estimate
     figure (2);
     set(gcf, 'Position', get(0,'Screensize'));
     plot(f_scale(1:as_far), fft_x(1:as_far),'-r+')
     axis('tight')
     grid('on')
     title(strt)
     xlabel('Frequency (Hz)')
 
     strt = sprintf('FFT of Y. Dominant freq.: %0.3f Hz',f_scale(k_y));% dominant frequency estimate
     figure (3)
     set(gcf, 'Position', get(0,'Screensize'));
     plot(f_scale(1:as_far), fft_y(1:as_far),'-g+')
     axis('tight')
     grid('on')
     title(strt)
     xlabel('Frequency (Hz)')
 
     % Plotting movment 
     figure (4);
     set(gcf, 'Position', get(0,'Screensize'));
     plot(t,z,'-b');
     axis('tight')
     grid('on')
     title('Vertical movement (z-axis)')
     xlabel('Time (s)')
 
     figure (5);
     set(gcf, 'Position', get(0,'Screensize'));
     plot(t,x,'-r');
     axis('tight')
     grid('on')
     title('Horizontal movement (x-axis)')
     xlabel('Time (s)')
 
     figure (6)
     set(gcf, 'Position', get(0,'Screensize'));
     plot(t,y,'-g')
     axis('tight')
     grid('on')
     title('Hotizontal movement (y-axis)')
     xlabel('Time (s)')
 
     figure (7);
     set(gcf, 'Position', get(0,'Screensize'));
     plot3(x,y,z);
     grid('on')
     title('Movement in 3D')
     xlabel('Horizontal movement (x-axis)')
     ylabel('Horizontal movement (y-axis)')
     zlabel('Vertical movement (z-axis)')
     
     saveas(figure(1), strcat( './sauvegarde/', vid_name , '_FFT of Z.png' ))
     saveas(figure(2), strcat( './sauvegarde/', vid_name , '_FFT of X.png' ))
     saveas(figure(3), strcat( './sauvegarde/', vid_name , '_FFT of Y.png' ))
     saveas(figure(4), strcat( './sauvegarde/', vid_name , '_Vertical movement (z-axis).png' ))
     saveas(figure(5), strcat( './sauvegarde/', vid_name , '_Horizontal movement (x-axis).png' ))
     saveas(figure(6), strcat( './sauvegarde/', vid_name , '_Hotizontal movement (y-axis).png' ))
     saveas(figure(7), strcat( './sauvegarde/', vid_name , '_Movement in 3D.png' ))

    fprintf('ANALYSING DONE!!!\n')
    
    %% Making our own video
    strt = char(join([vid_name(1:end-4), string('_vertical')]));
    new_vid_vertical = VideoWriter(strt,'MPEG-4');
    
    strt = char(join([vid_name(1:end-4), string('_3D')]));
    new_vid_3D = VideoWriter(strt,'MPEG-4');
    
    vid_obj.CurrentTime = start_time;
    open(new_vid_vertical)
    open(new_vid_3D)
    
    time = round((end_time-start_time)*vid_obj.FrameRate);
    [waitbar_handle, waitbar_time] = start_waitbar('Tracking', 1, time);
    
    counter = 0;
    
    while counter <= length(CoM_top)-1
        counter = counter + 1;
        waitbar_time = update_waitbar(waitbar_handle, waitbar_time, 'Tracking', counter, time);
        im =  readFrame(vid_obj);
        
        T_pos_top(1,:) = For_vid_top{counter,1};
        T_pos_top(2,:) = For_vid_top{counter,2};
        T_pos_bot(1,:) = For_vid_bot{counter,1};
        T_pos_bot(2,:) = For_vid_bot{counter,2};
        x_sum_top = CoM_top(counter,1);
        y_sum_top = CoM_top(counter,2);
        x_sum_bot = CoM_bot(counter,1);
        y_sum_bot = CoM_bot(counter,2);
       
        %***** The OCT with tracking
        figure(1);
        imshow(uint8(im)); axis image; 
        hold on
        plot(T_pos_top(1,:), T_pos_top(2,:),'g-','LineWidth',2,'MarkerSize',6)
        plot(T_pos_bot(1,:), T_pos_bot(2,:),'b-','LineWidth',2,'MarkerSize',6)
        plot(x_sum_top, y_sum_top, 'r+')
        plot(x_sum_bot, y_sum_bot, 'r+')
        F = getframe;
        hold off
        [hight_F,width_F,~] = size(F.cdata);
        crop_im_vid = F.cdata;
        
        %***** Movement in z-axis (vertical)
        figure (2);
        plot(t(1:counter),z(1:counter),'-b');
        grid('on')
        H = getframe;
        [hight_H,width_H,~] = size(H.cdata);
        
        % Vertical video
        crop_im_graf_vertical = imresize(H.cdata,[hight_F,width_F],'bicubic');
        final_form_vertical = [crop_im_vid, crop_im_graf_vertical];
        fprintf('Size of vertical video:/n')
        size(final_form_vertical)
        writeVideo(new_vid_vertical,final_form_vertical)
        
        %***** Movement in 3D
        figure (3);
        plot3(x(1:counter),y(1:counter),z(1:counter));
        grid('on')
        G = getframe;
        
        % 3D video
        crop_im_graf_3D = imresize(G.cdata,[hight_F,width_F],'bicubic');
        final_form_3D = [crop_im_vid, crop_im_graf_3D];
        fprintf('Size of 3D video:/n')
        size(final_form_3D)
        writeVideo(new_vid_3D,final_form_3D)
        
    end
    close(new_vid_vertical)
    close(new_vid_3D)
    close_waitbar(waitbar_handle);
    
    fprintf('IT IS DONE!!!\n')
end
