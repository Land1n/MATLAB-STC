function [t, pulse] = rectangular_pulse(start_time, duration, A, t_start, t_end, fs)
% rectangular_pulse - генерация прямоугольного импульса
% Параметры:
%   start_time - начало импульса
%   duration - длительность импульса
%   A - амплитуда
%   t_start, t_end - временной интервал (если пустые, по умолчанию start_time ± 10*duration)
%   fs - частота дискретизации
 
if nargin < 1 || isempty(start_time), start_time = 0; end
if nargin < 2 || isempty(duration), duration = 1; end
if nargin < 3 || isempty(A), A = 1; end
if nargin < 4 || isempty(t_start), t_start = start_time - 10*duration; end
if nargin < 5 || isempty(t_end), t_end = start_time + 10*duration; end
if nargin < 6 || isempty(fs), fs = 1000; end

t = linspace(t_start, t_end, floor((t_end - t_start)*fs));
pulse = zeros(size(t));
pulse(t >= start_time & t <= (start_time + duration)) = A;
end
