function [] = helper_status_message( str )
%HELPER_STATUS_MESSAGE prints a status message into the console and
%includes the execution time
%
% str Status message string

time = toc;
disp(strcat('t=', num2str(round(time,2),'%.2f'), 's -', str));
end

