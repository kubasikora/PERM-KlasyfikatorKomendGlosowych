function [command, Fs] = obcinator(path)
[command, Fs] = audioread(path);
%OBCINATOR Summary of this function goes here
%   Detailed explanation goes here
EPS = 0.0039;

for i=1:length(command)
   if(abs(command(i)) > EPS)
       command = command(i:end);
       break
   end
end

for i=length(command):-1:1
   if(abs(command(i)) > EPS)
       command = command(1:i);
       break
   end
end

end

