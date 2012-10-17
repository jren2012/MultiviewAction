function getJoints(a, s, e)
%% load video
    filepath = 'e:\data\MSRDailyAction\';
    video_name = strcat(filepath, sprintf('a%02d_s%02d_e%02d_rgb.avi', a, s, e));
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
%% process skeleton
    load skeletons
    skeleton = skeleton_all{a,s,e};

    HIP =1;
    SPINE=2;
    NECK = 3;
    HEAD = 4;
    SHOULDER_LEFT = 5;
    ELBOW_LEFT = 6;
    WRIST_LEFT = 7;
    HAND_LEFT= 8;
    SHOULDER_RIGHT = 9;
    ELBOW_RIGHT = 10;
    WRIST_RIGHT = 11;
    HAND_RIGHT= 12;    
    HIP_LEFT = 13;
    ANKLE_LEFT = 14;    
    KNEE_LEFT = 15;
    FOOT_LEFT = 16;
    HIP_RIGHT = 17;
    KNEE_RIGHT = 18;
    ANKLE_RIGHT = 19;
    FOOT_RIGHT = 20;    
    LEFT_ARMS = [ELBOW_LEFT, WRIST_LEFT, SHOULDER_LEFT, HAND_LEFT];
    RIGHT_ARMS = [ELBOW_RIGHT, WRIST_RIGHT, SHOULDER_RIGHT, HAND_RIGHT];
    TORSOS = [HIP_LEFT, HIP_RIGHT, SHOULDER_LEFT, SHOULDER_RIGHT, ...
              SPINE];
    LEFT_LEGS = [KNEE_LEFT, ANKLE_LEFT, HIP_LEFT, FOOT_LEFT];
    RIGHT_LEGS = [KNEE_RIGHT, ANKLE_RIGHT, HIP_RIGHT, FOOT_RIGHT];
    HEAD_JOINTS = [HEAD, NECK, SHOULDER_LEFT, SHOULDER_RIGHT];
    num_frame_skeleton = size(skeleton,1);
    assert(abs(num_frame_skeleton - num_frames)<2, ...
           ['the number of frames of the skeleton and the video ' ...
            'should be same']);
    num_frames = min(num_frame_skeleton, num_frames);
    num_joint  = size(skeleton, 2);
    for f = 1:num_frames
        skeleton(f,2:2:num_joint,3) = skeleton(f,2:2:num_joint,3)* ...
            0.01;
        skeleton_absolute = reshape(skeleton(f,2:2:num_joint,:), ...
                                    [num_joint/2,size(skeleton, ...
                                                      3)]);
        skeleton_absolute(:, 1) = int32(skeleton_absolute(:, 1) * ...
                                        vid_width);
        skeleton_absolute(:, 2) = int32(skeleton_absolute(:, 2) * ...
                                        vid_height);
        box_coor = getBoundingBox(skeleton_absolute(LEFT_ARMS, :));
        %mov(f).cdata = drawRectangle(mov(f).cdata, box_coor, 1);
        box_coor = getBoundingBox(skeleton_absolute(RIGHT_ARMS, :));
        mov(f).cdata = drawRectangle(mov(f).cdata, box_coor, 1);
        box_coor = getBoundingBox(skeleton_absolute(LEFT_LEGS, :));
        %mov(f).cdata = drawRectangle(mov(f).cdata, box_coor, 1);
        box_coor = getBoundingBox(skeleton_absolute(RIGHT_LEGS, :));
        %mov(f).cdata = drawRectangle(mov(f).cdata, box_coor, 1);
        box_coor = getBoundingBox(skeleton_absolute(TORSOS, :));
        %mov(f).cdata = drawRectangle(mov(f).cdata, box_coor, 1);
        box_coor = getBoundingBox(skeleton_absolute(HEAD_JOINTS, :));
        mov(f).cdata = drawRectangle(mov(f).cdata, box_coor, 1);
    end
    % Size a figure based on the video's width and height.
    hf = figure;
    set(hf, 'position', [150 150 vid_width vid_height])
    % Play back the movie once at the video's frame rate.
    movie(hf, mov, 1, video_obj.FrameRate);
end

function box_coor = getBoundingBox(corrds)
% coords: each row is the coordinates of the points
% box_coor(1,:) is the minimum of the coordintes
% box_coor(2,:) is the maximum of the coordintes
    box_coor(1, :) = min(corrds);
    box_coor(2, :) = max(corrds);
end
