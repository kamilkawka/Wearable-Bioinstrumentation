data = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData.csv');
data2 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData2.csv');
data3 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData3.csv');
data4 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData4.csv');
data5 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData5.csv');
data6 = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\pressureSensorData6.csv');
figure
plot(data.time,data.voltage)
hold on;
plot(data2.time,data2.voltage)
hold on;
plot(data3.time,data3.voltage)
hold on;
plot(data4.time,data4.voltage)
hold on;
plot(data5.time,data5.voltage)
hold on;
plot(data6.time,data6.voltage)
legend('No Object, Sample 1: R2 2.26e4','No Object, Sample 2: R2 1.67e4','Object 1, Sample 1: R2 692','Object 1, Sample 2: R2 643','Object 2, Sample 1: R2 120','Object 2, Sample 2: R2 97.5')
