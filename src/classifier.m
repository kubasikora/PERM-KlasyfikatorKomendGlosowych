COMMAND_COUNT = 3;
TEST_NUM = 4;
WINDOW_NUM = 32;
THRESHOLD = 3.0;

%% ladowanie komendy do porownania
[command, Fs] = obcinator(strcat('../Test/test', num2str(TEST_NUM), '.wav'));

%% inicjalizacja zmiennych
test_cog = zeros(WINDOW_NUM,1);
test_mean = zeros(WINDOW_NUM,1);
test_dev = zeros(WINDOW_NUM,1);

center_of_gravity = zeros(WINDOW_NUM,1);
means = zeros(WINDOW_NUM, 1);
deviations = zeros(WINDOW_NUM, 1);

err_cog = zeros(COMMAND_COUNT,1);
err_mean = zeros(COMMAND_COUNT,1);
err_dev = zeros(COMMAND_COUNT,1);

%% policzenie charakterystyk
[S, F, T, P, Fc, Tc] = spectrogram(command, floor(length(command)/WINDOW_NUM), 0, [], Fs, 'yaxis');

ft = linspace(0,Fs, length(F))';

for i=1:WINDOW_NUM
    center_of_gravity(i) = eval_COG(ft, abs(S(:,i))); 
    means(i) = mean(abs(S(:,i)));
    deviations(i) = std(abs(S(:,i)));
end 

test_cog = test_cog + center_of_gravity;
test_mean = test_mean + means;
test_dev = test_dev + deviations;

%% normalizacja
test_cog = test_cog / max(test_cog);
test_mean = test_mean / max(test_mean);
test_dev = test_dev / max(test_dev);

%% porownanie z wzorcowymi komendami
for j = 1:COMMAND_COUNT
    load(strcat('../databases/cmd_database_cmd_', num2str(j), '.mat'), 'sum_cog', 'sum_mean', 'sum_dev');
    for k = 1:WINDOW_NUM
        err_cog(j) = err_cog(j) + (sum_cog(k) - test_cog(k))^2;
        err_mean(j) = err_mean(j) + (sum_mean(k) - test_mean(k))^2;
        err_dev(j) = err_dev(j) + (sum_dev(k) - test_dev(k))^2;
    end
end

% przechowanie indeksow komend, dla ktorych blad jest najmniejszy
eval = zeros(3,1);

[min_val_cog, eval(1)] = min(err_cog);
[min_val_mean, eval(2)] = min(err_mean);
[min_val_dev, eval(3)] = min(err_dev);

if min_val_cog > THRESHOLD 
    eval(1) = 0;
end

if min_val_mean > THRESHOLD 
    eval(1) = 0;
end
if min_val_dev > THRESHOLD 
    eval(1) = 0;
end

% zliczanie wystapien i wyluskanie maksymalnej liczby powtorzen
[a,b]=hist(eval,unique(eval));
[max_eval, ind_eval] = max(a);
if (max_eval >= 2)
    if outcome == 0
        disp('Nieznana komenda!')
    else
        outcome = b(ind_eval);
        disp(strcat('Rozpoznano komende: ', num2str(outcome)));
    end
else
    disp('Nie udalo sie rozpoznac komendy!');
end

%% rysowanie wykresow
figure(4)
title("Średni środek ciężkości komendy");
hold on
grid on
grid minor
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), test_cog);
hold off

figure(5)
title("Średnia częstotliwość komendy");
hold on
grid on
grid minor
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), test_mean);
hold off

figure(6)
title("Średnie odchylenie standardowe komendy");
hold on
grid on
grid minor
plot(linspace(1,WINDOW_NUM, WINDOW_NUM), test_dev);
hold off