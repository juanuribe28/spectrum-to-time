function [lambda,yDat2] = GetSpectrumNew(center, span, resolution, ref_level)
    delete(instrfindall)
    g1 = visa('agilent','GPIB0::1::INSTR');
    set(g1,'InputBufferSize',1000000);              % Standard is 512 ASCII signs that transfers
    set(g1,'OutputBufferSize',1000000);
    set(g1,'Timeout',240);
    fopen(g1);
    
    fprintf(g1, ':DISPlay:TRACe:Y1:SPACing LINear');   
    fprintf(g1, ':SENSe:WAVelength:CENTER %dNM', center);
    fprintf(g1, ':SENSe:WAVelength:SPAN %dNM', span);
    fprintf(g1, ':SENSE:BANDWIDTH:RESOLUTION %dNM', resolution);
    fprintf(g1, ':DISPlay:TRACe:Y1:RLevel %dNW', ref_level);
    
    START=str2num(query( g1, ':SENSe:WAVelength:STARt?'));
    STOP=str2num(query( g1, ':SENSe:WAVelength:STOP?'));
 
    fprintf(g1, ':INITiate');
    fprintf(g1, ':TRACE:Y? TRA');
    yDat2 = str2num(fscanf(g1));
    yDat2 = yDat2.';

    lambda=linspace(START,STOP,length(yDat2));
end