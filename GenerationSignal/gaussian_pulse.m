function [t, gaussian] = gaussian_pulse(mu, sigma, A, t_start, t_end, fs)
% gaussian_pulse - генерация гауссовского импульса
% Параметры:
%   mu - центр импульса (по умолчанию 0)
%   sigma - стандартное отклонение (ширина)
%   A - амплитуда
%   t_start, t_end - временной интервал (если пустые, по умолчанию mu ± 3*sigma)
%   fs - частота дискретизации (по умолчанию 1000)
 
if nargin < 1 || isempty(mu), mu = 0; end
if nargin < 2 || isempty(sigma), sigma = 1; end
if sigma <= 0
    error('sigma должно быть положительным.');
end
if nargin < 3 || isempty(A), A = 1; end
if nargin < 4 || isempty(t_start), t_start = mu - 3*sigma; end
if nargin < 5 || isempty(t_end), t_end = mu + 3*sigma; end
if nargin < 6 || isempty(fs), fs = 1000; end

t = linspace(t_start, t_end, floor(fs*(t_end - t_start)));
gaussian = A * exp(-((t - mu).^2) / (2*sigma^2));
end