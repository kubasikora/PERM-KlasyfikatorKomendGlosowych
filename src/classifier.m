COMMAND_COUNT = 3;
TEST_NUM = 1;
WINDOW_NUM = 32;

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