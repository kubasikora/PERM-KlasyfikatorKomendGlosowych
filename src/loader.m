clear all
[command1, Fs1] = obcinator('../Przerobione/01-Kamil1.wav');
[command2, Fs2] = obcinator('../Przerobione/01-Kamil2.wav');
[command3, Fs3] = obcinator('../Przerobione/01-Kuba1.wav');
[command4, Fs4] = obcinator('../Przerobione/01-Kuba2.wav');

WINDOW_NUM = 32;

commands = {command1 command2 command3 command4};

for cell=commands
    command=cell{1};
    [S, F, T, P, Fc, Tc] = spectrogram(command, floor(length(command)/WINDOW_NUM), 0, [], Fs4, 'yaxis');

    ft = linspace(0,Fs4, length(F))';

    center_of_gravity = zeros(WINDOW_NUM,1);
    for i=1:WINDOW_NUM
        center_of_gravity(i) = eval_COG(ft, abs(S(:,i))); 
    end
    
    means = zeros(WINDOW_NUM, 1);
    for i=1:WINDOW_NUM
       means(i) = mean(abs(S(:,i)));
    end
    
    figure(1)
    title("Środki ciężkości komendy");
    hold on
    grid on
    grid minor
    plot(linspace(1,WINDOW_NUM, WINDOW_NUM), center_of_gravity);
    hold off
    
    figure(2)
    title("Średnia częstotliwość w danym oknie");
    hold on
    grid on
    grid minor
    plot(linspace(1,WINDOW_NUM, WINDOW_NUM), means);
       
end

