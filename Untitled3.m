close all
clear all
clc

load('OSCdata.mat');
load('OSAdata.mat');
t=linspace(0, 500*25e-12, 500);
beta2 = 130;


% New

subplot(2,1,1)
plot(OSCdata.BCSV, OSCdata.VarName2)
hold on
L=OSCdata.BCSV;
plot(L,exp(-((L-1567)/20).^2)*max( OSCdata.VarName2),'r')
plot(L,exp(-2*((L-1567)/20).^2).*OSCdata.VarName2,'r')

subplot(2,1,2)
plot(t, OSAdata.VarName1)


[Frequency_axis_3,Spectrum_level_3,b_,beta2_cal, beta3_cal] = Calibration(OSCdata.BCSV, exp(-4*((L-1567)/20).^2).*OSCdata.VarName2, t(2)-t(1), OSAdata.VarName1, beta2);