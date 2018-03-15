function varargout = debug_18(varargin)
% DEBUG_18 MATLAB code for debug_18.fig
%      DEBUG_18, by itself, creates a new DEBUG_18 or raises the existing
%      singleton*.
%
%      H = DEBUG_18 returns the handle to a new DEBUG_18 or the handle to
%      the existing singleton*.
%
%      DEBUG_18('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEBUG_18.M with the given input arguments.
%
%      DEBUG_18('Property','Value',...) creates a new DEBUG_18 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before debug_18_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to debug_18_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help debug_18

% Last Modified by GUIDE v2.5 25-Feb-2018 22:15:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @debug_18_OpeningFcn, ...
                   'gui_OutputFcn',  @debug_18_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before debug_18 is made visible.
function debug_18_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to debug_18 (see VARARGIN)

% Choose default command line output for debug_18
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes debug_18 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = debug_18_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
bt = Bluetooth('arm',1);
bt.InputBufferSize = 256;
fclose(bt);
fopen(bt);
bt;
counter      = int32(0);

last_recieve = int32(0);
curr_recieve = int32(0);
start_of_line = int32(12);
end_of_line = int32(13);
escape = int32(15);
data_array = 0:1:32;
enter_flag = int32(0);
enter_flag1 = int32(0);
enter_flag2 = int32(0); 
enter_flag3 = int32(0);
index_no = int32(0);
sign_bit =int32(0);
data = int32(0);



while 1
    curr_recieve = fread(bt,1,'int8');
    counter = counter + 1;
    if ( (last_recieve == end_of_line) && (curr_recieve == start_of_line) ) || (enter_flag == 1)
        enter_flag = 1;
        if enter_flag1 == 1
            if (curr_recieve==escape) && (enter_flag2 == 0)
                enter_flag2 = 1;
            elseif (enter_flag2 == 1) || (~(curr_recieve==escape))	
                enter_flag2 = 0;
                enter_flag3 =enter_flag3 + 1;
                switch enter_flag3
                    case 1
                    	index_no = curr_recieve;
                    	sign_bit = 0;
                    case 2
                    	sign_bit = curr_recieve;
                    case 3
                    	data = bitor(data, curr_recieve, 'int32');
                    case 4
                    	data = bitor(data, bitshift(curr_recieve, 8), 'int32');
                    case 5
                        data = bitor(data, bitshift(curr_recieve, 16), 'int32');
                    case 6
                        data = bitor(data, bitshift(curr_recieve, 24), 'int32');
                    case 7
						enter_flag = 0;
						enter_flag1 = 0;
						enter_flag3 = 0;
                        if sign_bit == 1 
							data = 0 - data;
                        end 
						data_array(index_no) = data;
						data = 0;
                end
            end
        else
        enter_flag1 = 1;
        end
    end    
    last_recieve = curr_recieve;
    
    v_1 = data_array(1)/100;
    v11 = num2str(v_1);
    set(handles.v1,'string',v11);
    
    v_2 = data_array(2)/100;
    v22 = num2str(v_2);
    set(handles.v2,'string',v22);
    
    v_3 = data_array(3)/100;
    v33 = num2str(v_3);
    set(handles.v3,'string',v33);
    
    imu = data_array(5)/10;
    imu11 = num2str(imu);
    set(handles.angleid,'string',imu11);
    
    
    imu_req = data_array(7)/10;
    imua = num2str(imu_req);
    set(handles.reqan,'string',imua);    
    
    x = data_array(8)/1000;
    s = num2str(x);
    set(handles.xid,'string',s);
    
    y = data_array(9)/1000;
    s1 = num2str(y);
    set(handles.yid,'string',s1);    
    
    req_x = data_array(20)/1000;
    s2 = num2str(req_x);
    set(handles.reqx,'string',s2);
    
    req_y = data_array(21)/1000;
    s3 = num2str(req_y);
    set(handles.reqy,'string',s3);
    
    dist = data_array(4);
    s4 = num2str(dist);
    set(handles.sick,'string',s4);
    
    from_up = data_array(19);
    if from_up == 5
        cnt = cnt+1;
        s5 = num2str(cnt);
        set(handles.re_30,'string',s5);
    end
    
    navig = data_array(22);
    s6 = num2str(navig);
    set(handles.navi,'string',s6);    
    
    
    if ( mod(counter,256) == 0 )
       drawnow
    end
end



function navi_Callback(hObject, eventdata, handles)
% hObject    handle to navi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of navi as text
%        str2double(get(hObject,'String')) returns contents of navi as a double


% --- Executes during object creation, after setting all properties.
function navi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to navi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xid_Callback(hObject, eventdata, handles)
% hObject    handle to xid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xid as text
%        str2double(get(hObject,'String')) returns contents of xid as a double


% --- Executes during object creation, after setting all properties.
function xid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yid_Callback(hObject, eventdata, handles)
% hObject    handle to yid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yid as text
%        str2double(get(hObject,'String')) returns contents of yid as a double


% --- Executes during object creation, after setting all properties.
function yid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angleid_Callback(hObject, eventdata, handles)
% hObject    handle to angleid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angleid as text
%        str2double(get(hObject,'String')) returns contents of angleid as a double


% --- Executes during object creation, after setting all properties.
function angleid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function reqx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reqx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reqy_Callback(hObject, eventdata, handles)
% hObject    handle to reqy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reqy as text
%        str2double(get(hObject,'String')) returns contents of reqy as a double


% --- Executes during object creation, after setting all properties.
function reqy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reqy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reqan_Callback(hObject, eventdata, handles)
% hObject    handle to reqan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reqan as text
%        str2double(get(hObject,'String')) returns contents of reqan as a double


% --- Executes during object creation, after setting all properties.
function reqan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reqan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sick_Callback(hObject, eventdata, handles)
% hObject    handle to sick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sick as text
%        str2double(get(hObject,'String')) returns contents of sick as a double


% --- Executes during object creation, after setting all properties.
function sick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v1_Callback(hObject, eventdata, handles)
% hObject    handle to v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v1 as text
%        str2double(get(hObject,'String')) returns contents of v1 as a double


% --- Executes during object creation, after setting all properties.
function v1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v3_Callback(hObject, eventdata, handles)
% hObject    handle to v3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v3 as text
%        str2double(get(hObject,'String')) returns contents of v3 as a double


% --- Executes during object creation, after setting all properties.
function v3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v2_Callback(hObject, eventdata, handles)
% hObject    handle to v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v2 as text
%        str2double(get(hObject,'String')) returns contents of v2 as a double


% --- Executes during object creation, after setting all properties.
function v2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function re_30_Callback(hObject, eventdata, handles)
% hObject    handle to re_30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of re_30 as text
%        str2double(get(hObject,'String')) returns contents of re_30 as a double


% --- Executes during object creation, after setting all properties.
function re_30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to re_30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
