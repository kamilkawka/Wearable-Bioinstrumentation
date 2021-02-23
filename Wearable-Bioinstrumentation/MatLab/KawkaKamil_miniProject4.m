clear 
clc
close all
data = readtable('C:\Users\kamil\git\Wearable-Bioinstrumentation\Data\KawkaKamil_Respiration.csv');
% load pressureSensor output table 


% remove portions of the data when you were not lying on the sensor (when pressed was false)
time = data.time(logical(data.pressed));
resp = data.voltage(logical(data.pressed));

% specify plotsOn true or false
plotsOn = true;

% specify timeSteps
totalTime = 5*60;
stepTime = 300;
timeSteps = 0:stepTime:totalTime;

% initialize output table
output = array2table(nan([length(timeSteps)-1,3]),'VariableNames',{'time','rr','rr_fft'});

% loop through each window of time and run analyzeRESP to calculate RR and
% RR FFT, save respiration rates to output table
for i = 2:length(timeSteps)
    % only look at specificed portion of the time and resp signals
    startTime = timeSteps(i-1);
    endTime = timeSteps(i);
    ind = time >= startTime & time < endTime;
    timeTemp = time(ind);
    respTemp = resp(ind);
    
    % run analyzeRESP function
    [rr,rr_fft] = analyzeRESP(timeTemp,respTemp,plotsOn);
    
    % save respiration rates to output table
    output.time(i-1) = timeSteps(i);
    output.rr(i-1) = rr;
    output.rr_fft(i-1) = rr_fft;
end

% plot respiration rate over time
figure
plot(output.time,output.rr,'.-')
hold on 
plot(output.time,output.rr_fft,'.-')
title('Kamil Respiration Rate Data')
xlabel('Elapsed Time (s)')
ylabel('RR (brpm)')
legend('Kamil RR','Kamil RR FFT')
hold off



% analyzeRESP calculates respiration rate using time and frequency domain
% analyses

function [rr,rr_fft] = analyzeRESP(time,resp,plotsOn)
    % INPUTS: 
    % time: elapsed time (seconds)
    % resp: output from pressure sensor (voltage)
    % plotsOn: true for plots, false for no plots
    
    % OUTPUT:
    % rr: respiration rate (brpm) found from time domain data
    % rr_fft: respiration rate (brpm) found from frequency domain data

    % save orgiinal data
    time_raw = time;
    resp_raw = resp;

    % calculate fs
    T = mean(diff(time));
    fs = 1/T;
    resp = resp - mean(resp);

    % bandpass pass filter resp
    w1 = 0.17;
    w2 = 1;
    resp = bandpass(resp,[w1 w2],fs);

    % find peaks
    [pks, locs] = findpeaks(resp, time, 'MinPeakDistance', 1.7);
    peaks = numel(pks);
    

    % calcuate rr
    total = ((time(end)) - (time(1)));
    minute = total/60;
    rr = peaks/minute;

    % fft
    L = length(resp);
    Y = abs(fft(resp));
    P2 = (Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:(L/2))/L;

    % calcuate rrFft
    [fftpks,fftloc] = findpeaks(P1,f);
    maxX = max(fftpks);
    fftValue=0;
    for i = 1:length(fftpks)
        if (fftpks(i) == maxX)
            fftValue = fftloc(i);
        end
    end
    rr_fft = fftValue*60;
    if plotsOn
        figure % FILL IN CODE HERE to add legends, axes labels, and * for peaks
        
        subplot(3,1,1) 
        plot(time_raw,resp_raw)
        title('Sample Breathing Data')
        ylabel('Voltage (V)')
        xlabel('Elapsed Time (s)')
        
        subplot(3,1,2)
        plot(time,resp)
        xlabel('Elapsed Time (s)')
        ylabel('Filtered Voltage')
        hold on;
        plot(locs,pks,'*');
        legend('RESP','Sample RR (brpm):  20.0186')
        hold off;
        
        subplot(3,1,3)
        plot(f,P1)
        ylabel('|P1(f)|')
        xlabel('Frequency (Hz)')
        hold on;
        plot(fftValue,maxX,'*')
        legend('RESP','Sample RR FFT(brpm): 21.9739')
        hold off;
    end
end