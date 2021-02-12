data = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData1a.csv');
data2 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData2a.csv');
data3 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData3a.csv');
figure
plot(data.time,data.voltage)
hold on;
plot(data2.time,data2.voltage)
hold on;
plot(data3.time,data3.voltage)
hold on;
legend('Kamil Single Resistor: Vout 4.97','Two Resistors in Series: Vout 4.95','Two Resistors in Parallel: Vout 4.99')
xlabel('Elapsed Time (seconds)')
ylabel('Voltage (V)')
title('Figure 2. Changing R1')