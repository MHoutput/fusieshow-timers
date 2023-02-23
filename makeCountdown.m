function makeCountdown(start, increment, duration, filename)
    % Creates a GIF of a timer that counts up or down
    % If you convert the GIF to mp4 externally (for example at 
    % https://cloudconvert.com/gif-to-mp4), the file size decreases
    % significantly

    % Start: initial value of the timer
    % Increment: increase per second; use a negative value for a decrease
    % Duration: how long is the GIF, in seconds
    % Filename: string for the filename, without extension
    
    % Examples:
    % (1) Number of oil barrels left on 21-02-2023
    % (https://www.worldometers.info/oil)
    % >> makeCountdown(1411724488674, -1123.887395833333, 180, 'Oil')
    
    % (2) World population on 21-02-2023
    % (https://www.theworldcounts.com/populations/world/people)
    % >> makeCountdown(8019096947, 2.262212688581683, 180, 'Population')
    
    

    function [commaFormattedString] = CommaFormat(value)
      [integerPart, ~]=strtok(num2str(value),'.'); 
      integerPart=integerPart(end:-1:1); 
      integerPart=[sscanf(integerPart,'%c',[3,inf])' ... 
          repmat(',',ceil(length(integerPart)/3),1)]'; 
      integerPart=integerPart(:)'; 
      integerPart=deblank(integerPart(1:(end-1)));
      commaFormattedString = integerPart(end:-1:1);
    end
    
    filename = [filename,'.gif'];
    FPS = 30;
    frames = round(FPS.*duration+1,0);
    increase_per_frame = increment./FPS;
    sgn = sign(increment);
    counter_value = start;
    numdigits = round(7/6.*log10(max(abs(start), abs(start + increment.*duration)))+1,0);
    

    fig_handle=figure;
    set(fig_handle,'Position',[500 250 54.*numdigits 100],'Color',[0,0,0])
    ax_handle=axes('Color',[0,0,0]);
    xticks([]);
    yticks([]);
    box off
    text_handle = text(0.47,0.5,CommaFormat(counter_value),'FontSize',72,'FontName','Arial','HorizontalAlignment','center','VerticalAlignment','middle','Color',[1,1,1]);
    for i=1:frames
        set(text_handle,'String',CommaFormat(counter_value))
        frame = getframe(fig_handle); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        if i == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',1,'DelayTime',1./FPS); 
        else 
          imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1./FPS); 
        end 
        counter_value = counter_value + increase_per_frame;
    end
    close(fig_handle)
end