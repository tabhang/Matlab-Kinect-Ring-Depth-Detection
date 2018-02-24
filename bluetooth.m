%clear;
clc;
%gui_matlab;
bt = Bluetooth('arm',1);
fclose(bt);
fopen(bt);
bt;
delay_value = int32(0);
last_recieve = int32(0);
curr_recieve = int32(0);
start_of_line = int32(12);
end_of_line = int32(13);
escape = int32(15);
error = int32(18);
data_array = 0:1:32;
enter_flag = int32(0); 
enter_flag1 = int32(0);
enter_flag2 = int32(0); 
enter_flag3 = int32(0);
index_no = int32(0);
sign_bit =int32(0);
data = int32(0);
while true
    curr_recieve = fread(bt,1,'int8');
    %disp(curr_recieve);
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
delay_value = bitand(data_array(21),255,'int32');
disp(delay_value);
%ff = num2str(delay_value);
%set(handles.delay_here,'string',ff);
end