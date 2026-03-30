clc; clear; close all;

% Tham số diode
Is = 1e-16;          % Dòng ngược bão hòa (A)
n  = 2;              % Hệ số phát xạ
T  = 300;            % Nhiệt độ (K)

% Hằng số vật lý
k = 1.380649e-23;    % Hằng số Boltzmann
q = 1.602176634e-19; % Điện tích electron
Vt = k*T/q;          % Điện áp nhiệt (~25.85 mV ở 300K)

% Điện áp quét
Vd = linspace(0, 2, 1000);

% Phương trình diode Shockley
Id = Is .* (exp(Vd./(n*Vt)) - 1);

% Vẽ đồ thị
figure;
plot(Vd, Id, 'LineWidth', 1.5);
grid on;
xlabel('Điện áp diode V_{D} (V)', 'Interpreter', 'tex');
ylabel('Dòng điện diode I_{D} (mA)', 'Interpreter', 'tex');
title('Đặc tuyến I-V lý tưởng của diode');