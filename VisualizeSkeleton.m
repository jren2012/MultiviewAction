% // Assuming a pixel resolution of 320x240
% // x_meters = (x_pixelcoord - 160) * NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 * z_meters;
% // y_meters = (y_pixelcoord - 120) * NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 * z_meters;
% #define NUI_CAMERA_DEPTH_IMAGE_TO_SKELETON_MULTIPLIER_320x240 (NUI_CAMERA_DEPTH_NOMINAL_INVERSE_FOCAL_LENGTH_IN_PIXELS)
% 
% // Assuming a pixel resolution of 320x240
% // x_pixelcoord = (x_meters) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / z_meters + 160;
% // y_pixelcoord = (y_meters) * NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 / z_meters + 120;
% #define NUI_CAMERA_SKELETON_TO_DEPTH_IMAGE_MULTIPLIER_320x240 (NUI_CAMERA_DEPTH_NOMINAL_FOCAL_LENGTH_IN_PIXELS)

path = 'view_2\';
txts = dir([path '*.txt']);
skeleton_obj = [];
for i = 1:length(txts)
    disp(['processing file: ' num2str(i)]);
    txt1 = fopen([path txts(i).name]);
    line = fgetl(txt1);
    if(line == -1)
        continue;
    end
    metric_coords = zeros(20,4);
    for j = 1:20
        line = fgetl(txt1);
        metric_coords(j,:) = sscanf(line,'%f,%f,%f,%f');
    end
    fclose(txt1);
    pixel_coords = zeros(20,3);
    pixel_coords(:,1) = int16(metric_coords(:,1) .* 285.63 ./ metric_coords(:,3) + 160);
    pixel_coords(:,2) = int16(metric_coords(:,2) .* 285.63 ./ metric_coords(:,3) + 120);
    pixel_coords(:,2) = 240 - pixel_coords(:,2);
    
    rgb_name = [txts(i).name(1:end-22) '*rgb.jpg'];
    depth_name = [txts(i).name(1:end-22) '*depth.png'];
    map_name = [txts(i).name(1:end-22) '*maprgbd.png'];
    idx = find(txts(i).name == '_');
    framenum = str2double(txts(i).name(idx(1)+1:idx(2)-1));
    tmp = dir([path map_name]);
    mapimage = imread([path tmp(1).name]);
    skeleton_obj(end+1).mapimage = tmp(1).name;
    tmp = dir([path rgb_name]);
    rgbimage = imread([path tmp(1).name]);
    skeleton_obj(end).rgbimage = tmp(1).name;
    tmp = dir([path depth_name]);
    depthimage = imread([path tmp(1).name]);
    skeleton_obj(end).depthimage = tmp(1).name;
    
    rgb_coords = zeros(20,3);
    rgb_coords(:,3) = metric_coords(:,4);
    pixel_coords(pixel_coords(:,2)>240,2) = 240;
    pixel_coords(pixel_coords(:,1)>320,1) = 320;
    pixel_coords(pixel_coords(:,2)<1,2) = 1;
    pixel_coords(pixel_coords(:,1)<1,1) = 1;
    for j = 1:20
        rgb_coords(j,2) = mapimage(pixel_coords(j,2),pixel_coords(j,1),2);
        rgb_coords(j,1) = mapimage(pixel_coords(j,2),pixel_coords(j,1),3);
    end
    %imshow(rgbimage);
    %imshow(depthimage,[]);
    %hold on;
    %plot(rgb_coords(:,1),rgb_coords(:,2),'ro');
    %plot(pixel_coords(:,1),240-pixel_coords(:,2),'ro');
    %pause(0.1);
    skeleton_obj(end).rgb_coords = rgb_coords;
    skeleton_obj(end).depth_coords = pixel_coords;
    skeleton_obj(end).framenum = framenum;
end
save('skeletons_view2','skeleton_obj');