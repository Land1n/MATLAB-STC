function [t, triangular] = triangular_pulse(peak_time, rise_angle, fall_angle, A, t_start, t_end, fs)
% triangular_pulse - генерация треугольного импульса с углами наклона в радианах
% Параметры:
%   peak_time - время максимума
%   rise_angle - угол наклона левого склона (0 < angle < pi/2)
%   fall_angle - угол наклона правого склона (0 < angle < pi/2)
%   A - амплитуда
%   t_start, t_end - временные границы (если пустые, вычисляются по углам)
%   fs - частота дискретизации
 
if nargin < 1 || isempty(peak_time), peak_time = 0; end
if nargin < 2 || isempty(rise_angle)
    error('Необходимо задать rise_angle или t_start');
end
if nargin < 3 || isempty(fall_angle)
    error('Необходимо задать fall_angle или t_end');
end
if nargin < 4 || isempty(A), A = 1; end
if nargin < 7 || isempty(fs), fs = 1000; end

if isempty(t_start)
    if ~(rise_angle > 0 && rise_angle < pi/2)
        error('rise_angle должен быть в интервале (0, pi/2)');
    end
    t_start = peak_time - A / tan(rise_angle);
end
if isempty(t_end)
    if ~(fall_angle > 0 && fall_angle < pi/2)
        error('fall_angle должен быть в интервале (0, pi/2)');
    end
    t_end = peak_time + A / tan(fall_angle);
end

if t_start >= t_end
    error('t_start должно быть меньше t_end');
end
if ~(t_start < peak_time && peak_time < t_end)
    error('peak_time должно быть между t_start и t_end');
end

t = linspace(t_start, t_end, fs);
triangular = zeros(size(t));

left_slope = A / (peak_time - t_start);
right_slope = A / (t_end - peak_time);

left_mask = (t >= t_start) & (t <= peak_time);
triangular(left_mask) = left_slope * (t(left_mask) - t_start);

right_mask = (t > peak_time) & (t <= t_end);
triangular(right_mask) = A - right_slope * (t(right_mask) - peak_time);
end