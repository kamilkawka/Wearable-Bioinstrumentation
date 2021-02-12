data = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\KawkaKamil_Respiration.csv');
figure
plot(data.time,data.voltage)
title('Respiration')
xlabel('Time (seconds)')
ylabel('Voltage (V)')