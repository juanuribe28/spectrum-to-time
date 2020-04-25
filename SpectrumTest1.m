clc
close all
clear all

% assuming time vector for OSC and SPEC are identical
% not able to connect with SPEC 
for i=1:100
[SPEC_trace, SPEC_trace] = GetSpectrum();
%[OSC_time, OSC_trace] = GetBLR();

% SPEC_time = 0:0.1:100;
% SPEC_trace = SPEC_time.^2;
% OSC_time = 0:0.1:100;
% OSC_trace = OSC_time.^(2)-1;

figure(1)
hold on
plot(SPEC_time, SPEC_trace)
% plot(OSC_time, OSC_trace,'r')
xlabel('Time')
ylabel('Trace')
legend('Spectrometer','OSC')
hold off

% error = OSC_trace - SPEC_trace;
% figure(2)
% plot(SPEC_time, error)

pause(5)
end