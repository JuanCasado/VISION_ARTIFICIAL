
% https://es.mathworks.com/help/vision/examples/face-detection-and-tracking-using-the-klt-algorithm.html

if exist('vid','var')
    stop(vid);
    delete(vid);
end
clear all;
close all;
%%
figure_frame = figure('Name','frame');

hw = imaqhwinfo;
vid = videoinput(hw.InstalledAdaptors{1},1);
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat', Inf);
set(vid,'ReturnedColorspace', 'rgb'); 
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');

start(vid);
pause(10);

faceDetector = vision.CascadeObjectDetector();
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

initialized = false;

while (vid.FramesAvailable >= 1)
    frame = getsnapshot(vid);
    
    bbox = step(faceDetector, frame);
    points = [];
    for i = 1:size(bbox, 1)
        points{i} = detectMinEigenFeatures(rgb2gray(frame), 'ROI', bbox(i,:));
    end
    
    if ~initialized
        if size(points,2) > 0
            points_to_track = points{1}.Location;
            initialize(pointTracker, points_to_track, frame);
            initialized = true;
            old_points = points_to_track;
        end
    else
        [traked_points, isFound] = step(pointTracker, frame);
        visiblePoints = traked_points(isFound, :);
        correct_box = 0;
        if size(visiblePoints, 1) >= 10
            best_points_in = 0;
            for i = 1:size(bbox, 1)
                new_best_points_in = 0;
                for j = 1:size(visiblePoints,1)
                    box  = bbox(i,:);
                    point = visiblePoints(j,:);
                    point_x = point(1);
                    point_y = point(2);
                    box_t = box(1);
                    box_b = box(1)+box(2);
                    box_l = box(3);
                    box_r = box(3)+box(4);
                    if (point_x > box_l) && (point_x < box_r) && (point_y > box_t) && (point_y < box_b)
                        new_best_points_in = new_best_points_in + 1;
                    end
                end
                if new_best_points_in > best_points_in
                    best_points_in = new_best_points_in;
                    correct_box = i;
                end
            end
            if correct_box ~=0
                frame = insertShape(frame, 'Rectangle', bbox(correct_box, :), 'Color', 'green');
                frame = insertMarker(frame, visiblePoints, '+', 'Color', 'white');
            end
        end
        for i = 1:size(bbox, 1)
            if i ~= correct_box
                frame = insertShape(frame, 'Rectangle', bbox(i, :), 'Color', 'red');
            end
        end
    end
    
    figure(figure_frame);
    imshow(frame);
    hold on
    hold off
    drawnow;
end

%%
if exist('vid','var')
    stop(vid);
    delete(vid);
end
clear all;
close all;






