figure(1)
subplot(2,1,1)
t=linspace(0, 500*25e-12, 500); 
plot(t,OSA.VarName1)

subplot(2,1,2)
data2 = OSCdata(33:end, :);
plot(data2.BCSV, data2.VarName2)