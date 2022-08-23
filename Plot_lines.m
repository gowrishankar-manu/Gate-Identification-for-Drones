function Plot_lines(image,Lines)
    imshow(image);
    hold on

    max_len = 0;
    for k = 1:length(Lines)
        xy = [Lines(k).point1; Lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

        % plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

        % determine the endpoints of the longest line segment 
        len = norm(Lines(k).point1 - Lines(k).point2);
        if len > max_len
            max_len = len;
            xy_long = xy;
        end
    end

    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
end

