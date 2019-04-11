[command1, Fs1] = obcinator('../Przerobione/01-Kamil1.wav');
[command2, Fs2] = obcinator('../Przerobione/01-Kamil2.wav');
[command3, Fs3] = obcinator('../Przerobione/01-Kuba1.wav');
[command4, Fs4] = obcinator('../Przerobione/01-Kuba2.wav');

WINDOW_NUM = 32;

[S, F, T, P, Fc, Tc] = spectrogram(command1, round(length(command1)/WINDOW_NUM), 0, [], Fs1, 'yaxis');
[S, F, T, P, Fc, Tc] = spectrogram(command2, round(length(command2)/WINDOW_NUM), 0, [], Fs2, 'yaxis');
[S, F, T, P, Fc, Tc] = spectrogram(command3, round(length(command3)/WINDOW_NUM), 0, [], Fs3, 'yaxis');
[S, F, T, P, Fc, Tc] = spectrogram(command3, round(length(command4)/WINDOW_NUM), 0, [], Fs4, 'yaxis');

ft = (0:Fs4/512:Fs4)';
figure(1)
plot(ft, abs(S(:,10)));

figure(2)
spectrogram(command4, round(length(command4)/WINDOW_NUM), 0, [], Fs4, 'yaxis');

sr = zeros(WINDOW_NUM,1);
for i=1:WINDOW_NUM
    sr(i) = srodekciezkosci(ft, abs(S(:,i))); 
end
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), sr);


