clc
close all
clear

center = (1560+600)/2;
span = 3000;
resolution = 0.1;
ref_level = 50; %Not relevant, only helps in OSA

[SPEC_lambda, SPEC_trace] = GetSpectrumNew(center, span, resolution, ref_level);

figure(1)
plot(SPEC_lambda, SPEC_trace)
xlabel('Wavelength')
ylabel('Amplitude')