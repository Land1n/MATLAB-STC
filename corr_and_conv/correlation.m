function [lags, corr_norm] = correlation(firstSignal, timeline1, secondSignal, timeline2)
% correlation - вычисляет кросс-корреляцию двух сигналов с временным сдвигом
%
% Входные параметры:
%   firstSignal  - первый сигнал (вектор)
%   timeline1    - временная ось первого сигнала (вектор, монотонно возрастающий)
%   secondSignal - второй сигнал (вектор)
%   timeline2    - временная ось второго сигнала (вектор, монотонно возрастающий)
%
% Выходные параметры:
%   lags        - ось временных задержек (в секундах)
%   corr_norm   - нормированная кросс-корреляция (максимум = 1)

    if ~all(diff(timeline1) > 0) || ~all(diff(timeline2) > 0)
        error('Временные оси должны быть строго возрастающими!');
    end

    % Общий диапазон перекрытия по времени
    min_t = max(timeline1(1), timeline2(1));
    max_t = min(timeline1(end), timeline2(end));

    if min_t >= max_t
        error('Сигналы не перекрываются по времени!');
    end

    % Общая временная ось с минимальной длиной из двух сигналов
    nPoints = min(length(timeline1), length(timeline2));
    common_time = linspace(min_t, max_t, nPoints);

    % Интерполяция сигналов на общую временную ось
    aligned_signal1 = interp1(timeline1, firstSignal, common_time, 'linear', 0);
    aligned_signal2 = interp1(timeline2, secondSignal, common_time, 'linear', 0);

    % Вычисление кросс-корреляции
    corr_res = xcorr(aligned_signal1, aligned_signal2, 'none');

    % Нормировка на максимум
    max_val = max(abs(corr_res));
    if max_val ~= 0
        corr_norm = corr_res / max_val;
    else
        corr_norm = corr_res;
    end

    % Ось задержек
    dt = common_time(2) - common_time(1);
    lags = (-(length(aligned_signal2)-1):(length(aligned_signal1)-1)) * dt;
end
