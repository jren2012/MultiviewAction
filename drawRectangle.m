function im_out = drawRectangle(im, coords, line_width)
% draw rectangle on a image
% the color of the rectangle is always red in this case
% assume a color image as input
% box_coor(1,:) is the minimum of the coordintes
% box_coor(2,:) is the maximum of the coordintes
    [height width color]=size(im);
    assert(color == 3);
    if (coords(1, 1) <1) 
        coords(1, 1) = 1;
    end
    if (coords(1, 2) <1) 
        coords(1, 2) = 1;
    end
    if (coords(2, 1) > width) 
        coords(2, 1) = width;
    end
    if (coords(2, 2) > height) 
        coords(2, 2) = height;
    end
    for l= 0:line_width-1
        current_x = coords(1, 1) + l;
        if current_x <= width && current_x >= 1
            for y = coords(1, 2) : coords(2, 2)
                im(y, current_x, :) = [255, 0, 0];
            end
        end
        current_x = coords(2, 1) + l;
        if current_x <= width && current_x >= 1
            for y = coords(1, 2) : coords(2, 2)
                im(y, current_x, :) = [255, 0, 0];
            end
        end
        current_y = coords(1, 2) + l;
        if current_y <=width && current_y >= 1
            for x = coords(1,1) : coords(2,1 )
                im(current_y, x, :) = [255, 0, 0];
            end
        end
        current_y = coords(2, 2) + l;
        if current_y <=width && current_y >= 1
            for x = coords(1,1) : coords(2,1)
                im(current_y, x, :) = [255, 0, 0];
            end
        end
    end
    im_out = im;
end