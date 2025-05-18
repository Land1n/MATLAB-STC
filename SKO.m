cb13 = [1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];

sig = zeros(size(t));
period_sample_count = floor(length(t)/c);

for i = 1:c
    start_idx = (i-1)*period_sample_count + 1;
    end_idx = i*period_sample_count;
    if end_idx > length(t)
        end_idx = length(t);
    end
    sig(start_idx:end_idx) = cb3(i);
end
add_awgn_noise(sig,-3)
figure('Position',[100 100 1200 600]);
subplot(2,2,1);
plot(t, sig, 'LineWidth', 1.5);
title(['Код Баркера ', num2str(c)]);
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;