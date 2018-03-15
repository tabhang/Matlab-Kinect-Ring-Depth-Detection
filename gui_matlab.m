function varargout = gui_matlab(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_matlab_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_matlab_OutputFcn, ...
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

function gui_matlab_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);








function varargout = gui_matlab_OutputFcn(hObject, eventdata, handles) 
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
    
    
    nav = data_array(22);
    ff = num2str(nav);
    set(handles.navi1,'string',ff);
    
    
%     
%     if data_array(1) < 0
%         v1_value = 0 - bitand((0 - data_array(1)),511,'int32');
%     else
%         v1_value = bitand(data_array(1),511,'int32');
%     end
%     
%     if ((v1_value < 500) && (v1_value > -500))
%         ff = num2str(v1_value);
%         set(handles.v1_here,'string',ff);
%     end

   
    
    if ( mod(counter,256) == 0 )
       drawnow
    end
end



function navi1_Callback(hObject, eventdata, handles)
% hObject    handle to navi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of navi1 as text
%        str2double(get(hObject,'String')) returns contents of navi1 as a double


% --- Executes during object creation, after setting all properties.
function navi1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to navi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
