
hw = imaqhwinfo;
vid = videoinput(hw.InstalledAdaptors{1},1); %Si no indicamos una fuente de video toma la que sea por defecto
set(vid,'TriggerRepeat',100);
vid.FrameGrabInterval = 5;
vid_src = getselectedsource(vid);
set(vid_src,'Tag','motion detection setup');
figure;
start(vid);

pause(5);

while (vid.FramesAvailable >= 2)
    data = getdata(vid,2);
    diff_im = imabsdiff(data(:,:,:,1),data(:,:,:,2));
    imshow(diff_im);
    drawnow;
    pause(0.1);
end

stop(vid);
delete(vid);
clear;
%close(gcf);
