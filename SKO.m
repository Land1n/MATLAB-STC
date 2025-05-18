addpath(fullfile(pwd, 'GenerationSignal'))
addpath(fullfile(pwd, 'corr_and_conv'))

%noiseSIG = add_awgn_noise(sig,-3)
%[lags, corr_norm] = correlation(noiseSIG, timer, sig, timer)
%[max_time] = find_max_with_time(lags,corr_norm)
% Задание кодов Баркера, которые нужно обрабатывать
codes = [2,3,4,5,7,11,13];
numCodes = length(codes);

% Предварительно выделяем массив для результатов: строки - коды, столбцы - уровни шума
MassGraph = zeros(numCodes, 100);

for idx = 1:numCodes
    c = codes(idx);
    disp(['Обработка кода Баркера: ', num2str(c)]);
    
    [timer, sig] = generate_barker_code(c, 0, 1, 100, 0, 10000, 0, 1/100, 'rect');
    SkoMass = zeros(1, 100);  % для каждого уровня шума
    
    for i = 1:100
        selection = zeros(1, 1000);  % для 1000 запусков
        
        for j = 1:1000
            noiseSIG = add_awgn_noise(sig, -1 * i);
            [lags, corr_norm] = correlation(noiseSIG, timer, sig, timer);
            max_time = find_max_with_time(lags, corr_norm);
            selection(j) = max_time;
        end
        
        % Среднее и стандартное отклонение для текущего уровня шума
        % Среднее не используется, можно убрать, если не нужно
        % average = mean(selection);
        SkoMass(i) = std(selection);
    end
    
    MassGraph(idx, :) = SkoMass;  % записываем результаты для данного кода
end

% Построение графиков
colors = {'b', 'r', 'g', 'm', 'k', 'c', [0.5 0.5 0]}; % цвета для графиков

hAx = subplot(2,2,1);
hold(hAx, 'on');

hPlots = gobjects(1, numCodes); % массив для дескрипторов графиков

for k = 1:numCodes
    hPlots(k) = plot(1:100, MassGraph(k, :), 'Color', colors{k}, 'LineWidth', 1.5);
end

hold(hAx, 'off');

legendStrings = arrayfun(@(x) ['К.Б. ', num2str(x)], codes, 'UniformOutput', false);
legend(hAx, hPlots, legendStrings, 'Location', 'best');

title(hAx, 'Защищенность кодов Баркера');
xlabel(hAx, 'Уровень шума, -dB');
ylabel(hAx, 'Уровень СКО');
grid(hAx, 'on');

% Увеличиваем область графика, изменяя позицию осей:
pos = get(hAx, 'Position');
pos(1) = pos(1) + 0.05;  % сдвинуть вправо
pos(2) = pos(2) - 0.35;  % сдвинуть вниз
pos(3) = pos(3) + 0.35;  % увеличить ширину
pos(4) = pos(4) + 0.35;  % увеличить высоту
set(hAx, 'Position', pos);

