clc
close all
clear

% Resolution
% Span
% Center
% Linear

% assuming time vector for OSC and SPEC are identical
for i=1:100
    [SPEC_lambda, SPEC_trace] = GetSpectrumNew();
%     [OSC_time, OSC_trace] = GetBLR();
% 
%     SPEC_time = 0:0.1:100;
%     SPEC_trace = SPEC_time.^2;
%     OSC_time = 0:0.1:100;
%     OSC_trace = OSC_time.^(2)-1;

    figure(1)
%     subplot(2,1,1)
    plot(SPEC_lambda, SPEC_trace)
%     plot(OSC_time, OSC_trace,'r')
    xlabel('Wavelength')
    ylabel('Amplitude')

%     subplot(2,1,2)
%     SPEC_time = fftshift(fft(SPEC_trace));
%     f = 3e8 ./ SPEC_lambda;
%     df = f(2) - f(1);
%     time = linspace(-.5/df, .5/df, length(f));
%     plot(3e8*time*1e3,abs(SPEC_time))
%     xlim([0, 10])

%     legend('Spectrometer','OSC')
%     yDat2
% 
%     error = OSC_trace - SPEC_trace;
%     figure(2)
%     plot(SPEC_time, error)

    pause(5)
end