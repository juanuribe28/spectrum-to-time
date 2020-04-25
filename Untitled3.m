close all
clear all
clc

load('OSCdata.mat');
load('OSAdata.mat');
t=linspace(0, 500*25e-12, 500);
beta2 = 70;

plot(OSCdata.BCSV, OSCdata.VarName2)

[Frequency_axis_3,Spectrum_level_3,b_,beta2_cal, beta3_cal] = Calibration(OSCdata.BCSV, OSCdata.VarName2, t(2)-t(1), OSAdata.VarName1, beta2)