function [lambda,yDat2] = GetSpectrum()
    delete(instrfindall)
    g1 = visa('agilent','GPIB0::1::INSTR');
    set(g1,'InputBufferSize',1000000);              % Standard is 512 ASCII signs that transfers
    set(g1,'OutputBufferSize',1000000);
    set(g1,'Timeout',240);
    fopen(g1);

    START=str2num(query( g1, ':SENSe:WAVelength:STARt?'));
    STOP=str2num(query( g1, ':SENSe:WAVelength:STOP?'));

%     handles.swe = ':SENSe:WAVelength:STOP 1550NM';
    
    fprintf(g1, ':INITiate');
    fprintf(g1, ':TRACE:Y? TRA');
    yDat2 = str2num(fscanf(g1));
    yDat2 = yDat2.';
% 
%     FIRST=yDat2(1);

    lambda=linspace(START,STOP,length(yDat2));
end



% f=3e8./(lambda);
% f=linspace(f(end),f(1),length(f));
% df=f(2)-f(1);
% t=linspace(-0.5/df,0.5/df,length(f));

% yDat2= 10.^(yDat2/10);
% yDat2GainIFFT = abs(fftshift(ifft(yDat2Gain)));
% FFTyDat2Shifted = fftshift(fft(yDat2GainIFFT));

%dlmwrite('test.csv',N,'delimiter',',','-append');
%plot(,)

%dlmwrite('Traces.csv',f./10^(12),'delimiter',',','-append');
%dlmwrite('Traces.csv',yDat2Gain','delimiter',',','-append');

% time = f./10^(12);
% trace = yDat2Gain;