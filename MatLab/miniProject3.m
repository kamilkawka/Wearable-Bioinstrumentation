

clear 
clc
close all

% connect arduino
a = arduino();
sampleTime = 10;
thresh = 2.2;
livePlot = true;
pauseTime = 0.5;
% call pressureSensor function
[data] = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime);

% save pressureSensor output table to a csv in your data folder
writetable(data,'C:\Users\kamilkawka\git\wearable-bioinstrumentation\data\pressureSensorData.csv')

% plot voltage over time
figure
plot(data.time,data.voltage)

% calcuate data acqusition rate
fs = 0;

% calculate R2 using R1, Vin, and Vout
r2 = 0;

function [data] = pressureSensor(a,sampleTime,thresh,livePlot,pauseTime)
    % INPUTS: 
    % a: ardruino
    % sampleTime: time (seconds) to run function
    % thresh: voltage (volts) threshold to change LED
    % livePlot: true/false to plot voltage in real-time
    % pausetime: time (seconds) to pause between each iteration
    
    % OUTPUT:
    % data: table with time (seconds), voltage (volts), and pressed (0/1)

    i = 1;
    tic
    timeVec = [];
    voltageVec = [];
    pressedVec = [];

    if livePlot
        h = animatedline;
        time = 0;
        window = 5;
        axis([time-window,time+window,0,5])
        xlabel('Elapsed Time (seconds)')
        ylabel('Voltage (V)')
    end

    disp("Recording data...")

    while toc < sampleTime
      voltage = readVoltage(a, 'A0');
      time = toc;
      %writePWMVoltage(a, 'D3', 5-voltage);

      % turn LED on if voltage is below threshold
      if voltage <= thresh
          writeDigitalPin(a, 'D3', 1)
          pressed = true;
      else
          writeDigitalPin(a, 'D3', 0)
          pressed = false;
      end
        
      % save time, voltage, and pressed values
      timeVec(i) = time;
      voltageVec(i) = voltage;
      pressedVec(i) = pressed;

      if livePlot
          addpoints(h,time,voltage);
          drawnow
          axis([time-window,time+window,0,5])
      end

      pause(pauseTime)

      i = i + 1;
    end
    disp('Data recording stopped')
    writeDigitalPin(a, 'D3', 0) % turn LED off
    data = table(timeVec',voltageVec',pressedVec','VariableNames',{'time','voltage','pressed'});
end