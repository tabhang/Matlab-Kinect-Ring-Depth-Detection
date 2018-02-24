%clear all;
clc;
imaqreset;
SpineBase = 1;
   SpineMid = 2;
   Neck = 3;
   Head = 4;
   ShoulderLeft = 5;
   
   ElbowLeft = 6;
   WristLeft = 7;
   HandLeft = 8;
   ShoulderRight = 9;
   ElbowRight = 10;
   WristRight = 11;
   HandRight = 12;
   HipLeft = 13;
   KneeLeft = 14;
   AnkleLeft = 15;
   FootLeft = 16; 
   HipRight = 17;
   KneeRight = 18;
   AnkleRight = 19;
   FootRight = 20;
   SpineShoulder = 21;
   HandTipLeft = 22;
   ThumbLeft = 23;
   HandTipRight = 24;
   ThumbRight = 25;
   
   SkeletonConnectionMap = [1 2 %spine
                           2 3 % Spine to neck
                           3 4 %neck to head
                           3 5 %neck to Left shoulder
                           5 6 %left shoulder to left elbow
                           6 7 %left elbow to left wrist
                           7 8 %left wrist to left hand
                           8 22%left hand to left tip
                           8 23%left hand to left thumb
                           12 24%right hand to right tip
                           12 25 %right hand to right thumb
                           3 9 % neck to Right shoulder
                           9 10 %right shoulder to right elbow
                           10 11 %right elbow to right wrist
                           11 12 %right wrist to right hand
                           1 17 % Right Leg
                           17 18 %right hip to right knee
                           18 19 %right ankle to right knee
                           19 20 %right ankle to right foot
                           1 13 % Left Leg
                           13 14 % left hip to left knee 
                           14 15 %left knee to left ankle
                           15 16]; %left ankle to left foot
DepthVid = videoinput('kinect',2);
triggerconfig(DepthVid,'manual');
DepthVid.FramesPerTrigger = 1;
DepthVid.TriggerRepeat = inf;
srcd =getselectedsource(DepthVid);
srcd.EnableBodyTracking ='on';

Viewer = vision.DeployableVideoPlayer();
start(DepthVid);
Himg = figure;
while ishandle(Himg)
    trigger(DepthVid);
    [Depthmap, ~, depthMetaData] = getdata(DepthVid);
    imshow(Depthmap,[0 4096]);
    if sum(depthMetaData.IsBodyTracked)>0
        tracked = 1;
        
        skeletonJoints = depthMetaData.DepthJointIndices(:,:,depthMetaData.IsBodyTracked);
        hold on;
        plot(skeletonJoints(:,1),skeletonJoints(:,2),'*');
        for i = 1:23
         X1 = [depthMetaData.DepthJointIndices(SkeletonConnectionMap(i,1),1) depthMetaData.DepthJointIndices(SkeletonConnectionMap(i,2),1)];
         Y1 = [depthMetaData.DepthJointIndices(SkeletonConnectionMap(i,1),2) depthMetaData.DepthJointIndices(SkeletonConnectionMap(i,2),2)];
         line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
        end
     
        hold off;
         
    else
        tracked = 0;
    end
     
   
end
stop(DepthVid);
