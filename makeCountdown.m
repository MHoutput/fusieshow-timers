function makeCountdown(start, increment, duration, filename, imagename)
    % Creates an MP4 video of a timer that counts up or down,
    % with an image in the background

    % Start: initial value of the timer
    % Increment: increase per second; use a negative value for a decrease
    % Duration: how long is the GIF, in seconds
    % Filename: string for the filename, without extension
    % Imagename (Optional): Background image for the counter
    %           If no image is passed, the counter will have a plain black
    %           background
    
    % Examples:
    % (1) Number of oil barrels left on 21-02-2023
    % (https://www.worldometers.info/oil)
    % >> makeCountdown_image(1411724488674, -1123.887395833333, 180, 'Oil', 'oilbarrels.png')
    
    % (2) World population on 21-02-2023
    % (https://www.theworldcounts.com/populations/world/people)
    % >> makeCountdown(8019096947, 2.262212688581683, 180, 'Population', 'earth.png')
    
    if nargin > 4
        background_image_flag = true;
    else
        background_image_flag = false;
    end
    
    workDir = [filename,'_images'];
    mkdir(workDir);

    function [commaFormattedString] = CommaFormat(value)
      thousands_separator = '.';
      [integerPart, ~]=strtok(num2str(value),'.'); 
      integerPart=integerPart(end:-1:1); 
      integerPart=[sscanf(integerPart,'%c',[3,inf])' ... 
          repmat(thousands_separator,ceil(length(integerPart)/3),1)]'; 
      integerPart=integerPart(:)'; 
      integerPart=deblank(integerPart(1:(end-1)));
      commaFormattedString = integerPart(end:-1:1);
    end
    
    FPS = 30;
    frames = round(FPS.*duration+1,0);
    increase_per_frame = increment./FPS;
    counter_value = start;
    numdigits = round(7/6.*log10(max(abs(start), abs(start + increment.*duration)))+1,0);
    
    expected_width = 54*numdigits;
    if background_image_flag
        image_array = imread(imagename);
        width = size(image_array,2);
        new_expected_width = 0.66*expected_width; %Personal choice, the digits extend beyond the image
        image_array_scaled = imresize(image_array, new_expected_width./width);
        new_width = size(image_array_scaled,2);
        height = size(image_array_scaled,1);
    else
        height = 125;
        new_width = expected_width;
    end
    
    %Guarantees that the width and height are multiples of 2, as required
    %by the H.264 codec used to make the MP4 video file:
    canvas_width = 2.*round(0.5.*expected_width); 
    canvas_height = 2.*round(0.5.*height); 
    
    fig_handle=figure;
    set(fig_handle,'Position',[500 250 canvas_width canvas_height],'Color',[0,0,0])
    if background_image_flag
        ax_handle=axes('Color',[0,0,0], 'Position', [0.5*(1-new_width./expected_width) 0 new_width./expected_width 1]);
        imshow(image_array)
    else
        ax_handle=axes('Color',[0,0,0], 'Position', [0 0 1 1]);
    end
    xticks([]);
    yticks([]);
    box off
    ax_tb = axtoolbar(ax_handle,{});
    ax_tb.Visible = 'off';
    text_handle = text(0.5,0.5,CommaFormat(counter_value),'FontSize',72,'FontName','Arial','HorizontalAlignment','center','VerticalAlignment','middle','Color',[1,1,1],'Units','normalized');
    for i=1:frames
        set(text_handle,'String',CommaFormat(counter_value))
        frame = getframe(fig_handle); 
        im = frame2im(frame); 
        frame_name = [sprintf('%06d',i) '.png'];
        imwrite(im,fullfile(workDir,frame_name),'png');
        counter_value = counter_value + increase_per_frame;
    end
    close(fig_handle)
    
    %Make an MP4 video
    videocodec = VideoWriter(filename,'MPEG-4');
    videocodec.Quality = 75;
    imageNames = dir(fullfile(workDir,'*.png'));
    imageNames = {imageNames.name}';
    videocodec.FrameRate = 30;
    open(videocodec)
    imageSize = size(imread(fullfile(workDir,imageNames{1})),1:2);
    for i = 1:length(imageNames)
        img = imread(fullfile(workDir,imageNames{i}));
        img_resized = imresize(img, imageSize); %Force all iamges to have the same size
        writeVideo(videocodec,img_resized)
    end
    close(videocodec)
    
    %Remove the temporary working directory with all the frames
    rmdir(workDir, 's');
end