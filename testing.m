clc;
imaqreset;

vid = videoinput('kinect', 2);
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;
vid.TriggerRepeat = inf;
triggerconfig(vid,'manual');

start(vid);

i = 1;
j = 1;

view = vision.VideoPlayer();
filtered = vision.VideoPlayer();
vv = vision.VideoPlayer();

run = true;

valmin = 0;
valmax =0;
k = 0;

img_req = zeros(130,177);
img_req = uint16(img_req);

prev_img = zeros(130,177);
prev_img = uint16(prev_img);

cen_poi = zeros(1,2);
radius_poi = 0;

cen_ring = zeros(1,2);
radius_ring = 0;

while run
    trigger(vid);
    [img, ~, ~] = getdata(vid);
    img1 = imadjust(img);
    img2 = imcrop(img1,[181 85 176 129]);
    img2 = medfilt2(img2);
    for i = 1:130
        for j = 1:177   
            if ((img2(i,j)) > 27500) && ((img2(i,j)) <32000)
                img_req(i,j) = img2(i,j);
            else 
                img_req(i,j) = 0;
            end
        end
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    se = strel('disk',40);
    img_ring = imclose(img_req,se);
    
    img_ring = im2bw(img_ring,0.4);
    img_ring =  imfill(img_ring,'holes');
    [cen_ring, radius_ring] = imfindcircles(img_poi,[40 50],'ObjectPolarity','bright','Sensitivity',0.95);
    rc = isempty(cen_ring);
    if rc == 0
        ring_x = cen_ring(1,1);
        ring_y = cen_ring(1,2);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    img_poi = im2bw(img_req,0.4);
    [cen_poi, radius_poi] = imfindcircles(img_poi,[7 9],'ObjectPolarity','bright','Sensitivity',0.95);
    pc = isempty(cen_poi);
    cen_poi;
    if pc == 0 
        clc;
        poi_x = cen_poi(1,1);
        poi_y = cen_poi(1,2);
        
        disp(' Shuttlecock went through ');
        if (poi_x < ring_x) && (poi_y < ring_y)
            disp(' top - left');
        elseif (poi_x > ring_x) && (poi_y > ring_y)
            disp(' bottom - right');
        elseif (poi_x > ring_x) && (poi_y < ring_y)
            disp(' top - left')
        elseif (poi_x < ring_x) && (poi_y > ring_y)
            disp(' bottom - right')
        end
        
        dist = sqrt((ring_x - poi_x)*(ring_x - poi_x) - (ring_y - poi_y)*(ring_y - poi_y));
        if dist < (radius_ring - 5)
            disp(' Successful Throw !!!  :) ');
        else
            dist_ax = abs(poi_x - ring_x);
            dist_ax = 9.1*dist_ax;    % mm mai hai
            theta = atand(dist_ax/4200); %degree mai hai
            disp(' Unsuccessful throw :( ')
            disp(' Rotate bot by : ')
            disp(theta);
            
        end
    end
     
    step(vv, img1);
    step(view, img_ring);
    step(filtered, img_poi);
    run = isOpen(view) && isOpen(filtered);
end
delete(vid);
