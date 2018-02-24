%clear all;
clc;
imaqreset;
previous_state =0;
current_state = 0;
transmit_flag_x = 0;
transmit_flag_z = 0;
transmit_flag_gesture = 0;

n =1;

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
        
        skeletonJoints = depthMetaData.JointPositions(:,:,depthMetaData.IsBodyTracked);
        
        if n == 1 
        a = skeletonJoints(17,:)
        n= n+1;
        end
        
        change = a-skeletonJoints(17,:);
        if 0.2<change(1) && change(1)<0.5 
            disp('x+ve');
            disp(change(1,1))
            transmit_flag_x = 1;
            %fwrite(bt,int8(['T',transmit_flag]));
        elseif 0.5<change(1) && change(1)<0.8 
            disp('x+ve>');
            disp(change(1,1))
            transmit_flag_x = 2;
            %fwrite(bt,int8(['T',transmit_flag]));
        elseif 0.8<change(1) && change(1)<1.1 
            disp('x+ve>>');
            disp(change(1,1))
            transmit_flag_x = 3;
            %fwrite(bt,int8(['T',transmit_flag]));
        elseif 0.0<change(1) && change(1)<0.2 
            disp('no change');
            disp(change(1,1))
            transmit_flag_x = 0;
        elseif -1.4<change(1) && change(1)<-1.0 
            disp('x-ve>>');
            disp(change(1,1))
            transmit_flag_x = 6;
            %fwrite(bt,int8(['T',transmit_flag]));
        elseif -1.0<change(1) && change(1)<-0.6 
            disp('x-ve>');
            disp(change(1,1))
            transmit_flag_x = 5;
            %fwrite(bt,int8(['T',transmit_flag]));
        elseif -0.6<change(1) && change(1)<-0.2 
            disp('x-ve');
            disp(change(1,1))
            transmit_flag_x = 4;
        elseif -0.2<change(1) && change(1)<0.0 
            disp('no change');
            disp(change(1,1))
            transmit_flag_x = 0;
            %fwrite(bt,int8(['T',transmit_flag]));
        %else disp('no change/out of bounds');

        end
         if 0.2<change(3) && change(3)<0.5 
            disp('z-ve');
            disp(change(1,3))
            transmit_flag_z = 4;
            %fwrite(bt,int8(['T',transmit_flag]));
         elseif 0.5<change(3) && change(3)<0.8 
            disp('z-ve>');
            disp(change(1,3))
            transmit_flag_z = 5;
            %fwrite(bt,int8(['T',transmit_flag]));
         elseif 0.8<change(3) && change(3)<1.1 
            disp('z-ve>>');
            disp(change(1,3))
            transmit_flag_z = 6;
            %fwrite(bt,int8(['T',transmit_flag]));
         elseif 0.0<change(3) && change(3)<0.2 
            disp('no change');
            disp(change(1,3))
            transmit_flag_z = 0;   
         elseif  -1.4<change(3) && change(3)<-1.0
            disp('z+ve>>');
            disp(change(1,3))
            transmit_flag_z = 3;
            %fwrite(bt,int8(['T',transmit_flag]));
         elseif -1.0<change(3) && change(3)<-0.6 
            disp('z+ve>');
            disp(change(1,3))
            transmit_flag_z = 2;
            %fwrite(bt,int8(['T',transmit_flag]));
         elseif -0.6<change(3) && change(3)<-0.2
            disp('z+ve');
            disp(change(1,3))
            transmit_flag_z = 1;
         elseif -0.2<change(3) && change(3)<0.0 
            disp('change');
            disp(change(1,3))
            transmit_flag_z = 0;
            %fwrite(bt,int8(['T',transmit_flag]));
          end

        S = depthMetaData.HandRightState(depthMetaData.IsBodyTracked);
            if depthMetaData.HandRightState(depthMetaData.IsBodyTracked) == 2
               previous_state = depthMetaData.HandRightState(depthMetaData.IsBodyTracked);
           end
            if depthMetaData.HandRightState(depthMetaData.IsBodyTracked) == 3
               current_state = depthMetaData.HandRightState(depthMetaData.IsBodyTracked);
            end
             if previous_state == 2 && current_state == 3
                   k = previous_state - current_state;
                   if k == -1 && n == 2
                     transmit_flag_gesture = 8;
                     n = n+1;
                     %fwrite(bt,int8(['T',transmit_flag]));
                   end
             end
           disp('T')
           disp(transmit_flag_x)
           disp(transmit_flag_z)
           disp(transmit_flag_gesture)
%           fwrite(bt,int8(['T',transmit_flag_x,transmit_flag_z,transmit_flag_gesture]));
              
    else
        tracked = 0;
    end
     
   
end
stop(DepthVid);
