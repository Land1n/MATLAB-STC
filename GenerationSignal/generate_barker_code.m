function [t, signal] = generate_barker_code(length_code, start_time, amplitude, frequency, phase, sample_rate, t_start, t_end, mode)
% generate_barker_code - генерация сигнала с кодом Баркера заданной длины
% Поддерживаемые длины: 2,3,4,5,7,11,13
% Параметры:
%   mode - 'pm' (фазовая модуляция, по умолчанию) или 'rect' (прямоугольный сигнал)
%
% Возвращает:
%   t - временная ось
%   signal - сигнал с кодом Баркера
 
if nargin < 1, error('Требуется длина кода Баркера'); end
if nargin < 2 || isempty(start_time), start_time = 0; end
if nargin < 3 || isempty(amplitude), amplitude = 1; end
if nargin < 4 || isempty(frequency), frequency = 100; end
if nargin < 5 || isempty(phase), phase = 0; end
if nargin < 6 || isempty(sample_rate), sample_rate = 10000; end
if nargin < 9 || isempty(mode), mode = 'pm'; end

barker_sequences = containers.Map( ...
    {2,3,4,5,7,11,13}, ...
    {[1,-1],[1,1,-1],[1,1,1,-1],[1,1,1,-1,1],[1,1,1,-1,-1,1,-1], ...
    [1,1,1,-1,-1,-1,1,-1,-1,1,-1],[1,1,1,1,1,-1,-1,1,1,-1,1,-1,1]});

if ~isKey(barker_sequences, length_code)
    error(['Неподдерживаемая длина кода Баркера: ', num2str(length_code), ...
        '. Допустимые длины: 2,3,4,5,7,11,13']);
end
 
sequence = barker_sequences(length_code);
period = 1 / frequency;
duration = period * length_code;

if nargin < 7 || isempty(t_start), t_start = 0; end
if nargin < 8 || isempty(t_end), t_end = duration; end

t = linspace(0, duration, floor(sample_rate * duration));

switch mode
    case 'pm'  % фазовая модуляция (исходный вариант)
        harmonic1 = amplitude * sin(2*pi*frequency*t + phase);
        harmonic2 = amplitude * sin(2*pi*frequency*t + phase + pi);
        signal = harmonic1;
        for i = 0:length_code-1
            start_seg = i * period;
            end_seg = start_seg + period;
            idx = (t >= start_seg) & (t < end_seg);
            if sequence(i+1) == 1
                signal(idx) = harmonic2(idx);
            end
        end

    case 'rect'  % прямоугольный код Баркера
        signal = zeros(size(t));
        for i = 0:length_code-1
            start_seg = i * period;
            end_seg = start_seg + period;
            idx = (t >= start_seg) & (t < end_seg);
            signal(idx) = amplitude * sequence(i+1);
        end

    otherwise
        error('Неизвестный режим генерации сигнала. Используйте ''pm'' или ''rect''.');
end

end