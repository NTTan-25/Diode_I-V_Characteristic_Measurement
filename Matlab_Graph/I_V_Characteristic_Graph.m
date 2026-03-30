clc; clear;

port = "COM7"; % Thay đổi cổng COM
baud = 115200;

s = serialport(port, baud);
configureTerminator(s, "CR/LF");
s.Timeout = 1;

flush(s);

fprintf("Đã mở cổng: %s\n", port);
fprintf("Đang chờ dữ liệu gửi đến từ STM32...\n");

% Chờ đến khi có dữ liệu đầu tiên
while s.NumBytesAvailable == 0
    pause(0.05);
end

fprintf("Đã nhận được dữ liệu, bắt đầu đọc...\n");

pwmData  = [];
vOutData = [];
vDData   = [];
iDData   = [];

while true
    line = readline(s);
    line = strtrim(line);

    disp(line);

    if line == ""
        continue;
    end

    if line == "END"
        break;
    end

    parts = split(line, ",");

    if numel(parts) ~= 4
        continue;
    end

    pw   = str2double(strtrim(parts(1)));
    vo   = str2double(strtrim(parts(2)));
    vd   = str2double(strtrim(parts(3)));
    idma = str2double(strtrim(parts(4)));

    if any(isnan([pw vo vd idma]))
        continue;
    end

    pwmData(end+1)  = pw;
    vOutData(end+1) = vo;
    vDData(end+1)   = vd;
    iDData(end+1)   = idma;
end

clear s;

T = table(pwmData', vOutData', vDData', iDData', ...
    'VariableNames', {'PWM','V_out','V_d','I_d_mA'});

disp(T);

writetable(T, 'diode_iv.csv');

figure; 
plot(T.V_d, T.I_d_mA, 'o-');
grid on;
xlabel('Điện áp Diode V_{D}(V)');
ylabel('Dòng điện Diodde I_{D}(mA)');
title('Đặc tuyến I-V của Diode');