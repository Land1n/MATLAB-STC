function max_time = find_max_with_time(timeline, signal)
% find_max_with_time - находит время, соответствующее максимуму массива signal
%
% Входные параметры:
%   timeline - массив времени (вектор)
%   signal   - массив значений (вектор той же длины)
%
% Выходные параметры:
%   max_time - время, соответствующее максимальному значению signal

    if length(signal) ~= length(timeline)
        error('Массивы signal и timeline должны быть одинаковой длины!');
    end

    [~, max_idx] = max(signal);    % находим индекс максимума
    max_time = timeline(max_idx);  % время максимума
end