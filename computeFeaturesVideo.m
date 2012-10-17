function fea = computeFeaturesVideo(video_name)
    video_obj = mmreader(video_name);
    num_frames = video_obj.NumberOfFrames;
    vid_height = video_obj.Height;
    vid_width = video_obj.Width;
    % Preallocate movie structure.
    mov(1:num_frames) = ...
    struct('cdata', zeros(vid_height, vid_width, 3, 'uint8'),...
           'colormap', []);
    for k =1:num_frames 
        mov(k).cdata = read(video_obj, k);
    end
    b_frame = 40;
    imshow(mov(b_frame).cdata)
    figure
    imshow(mov(b_frame + 2).cdata)
    figure
    [Vx, Vy, reliab] = optFlowLk(rgb2gray(mov(b_frame).cdata), ...
                                 rgb2gray(mov(b_frame + 2).cdata), ...
                                 3, [], 1, 3e-6, 1);                             
end
