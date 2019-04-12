clear all

COMMAND_NUM = 1;

[command1, Fs1] = obcinator(strcat('../Przerobione/0', num2str(COMMAND_NUM), '-Kamil1.wav'));
[command2, Fs2] = obcinator(strcat('../Przerobione/0', num2str(COMMAND_NUM), '-Kamil2.wav'));
[command3, Fs3] = obcinator(strcat('../Przerobione/0', num2str(COMMAND_NUM), '-Kuba1.wav'));
[command4, Fs4] = obcinator(strcat('../Przerobione/0', num2str(COMMAND_NUM), '-Kuba2.wav'));

WINDOW_NUM = 32;

commands = {command1 command2 command3 command4};

sum_cog = zeros(WINDOW_NUM,1);
sum_mean = zeros(WINDOW_NUM,1);
sum_dev = zeros(WINDOW_NUM,1);

center_of_gravity = zeros(WINDOW_NUM,1);
means = zeros(WINDOW_NUM, 1);
deviations = zeros(WINDOW_NUM, 1);

for cell=commands
    command=cell{1};
    [S, F, T, P, Fc, Tc] = spectrogram(command, floor(length(command)/WINDOW_NUM), 0, [], Fs4, 'yaxis');

    ft = linspace(0,Fs4, length(F))';

    
    for i=1:WINDOW_NUM
        center_of_gravity(i) = eval_COG(ft, abs(S(:,i))); 
        means(i) = mean(abs(S(:,i)));
        deviations(i) = std(abs(S(:,i)));
    end 
    
    sum_cog = sum_cog + center_of_gravity;
    sum_mean = sum_mean + means;
    sum_dev = sum_dev + deviations;
end

sum_cog = sum_cog/4;
sum_mean = sum_mean/4;
sum_dev = sum_dev/4;

figure(1)
title("Średni środek ciężkości komendy");
hold on
grid on
grid minor
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), sum_cog);
hold off

figure(2)
title("Średnia częstotliwość komendy");
hold on
grid on
grid minor
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), sum_mean);
hold off

figure(3)
title("Średnie odchylenie standardowe komendy");
hold on
grid on
grid minor
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), sum_dev);
hold off

save(strcat('../databases/cmd_database_cmd_', num2str(COMMAND_NUM), '.mat'), 'sum_cog', 'sum_mean', 'sum_dev');


