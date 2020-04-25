function [OSC_Time, OSC_Trace] = GetBLR()
%########## PRE-SETUP
if (0==exist('scope'))
        if (0==exist('g1'))
            delete(instrfindall)
        end  
    N = 1;
    Num_Averages = 1;
    iterations=1;
    PauseAmount=0;
    DISTER=[];
    PeakSPAN = 6; %was 25
    Pos = [];
    TimeD = [];
    % Digitizer_vendor_ethernet='agilent';
    Ethernet_address='tekscope-536165.lmumain.edu::inst0';
    Ethernet_address='mso54-c011196.lmumain.edu::inst0';
    Ethernet_address='oneghzscope.local::inst0';
    Digitizer_vendor_ethernet='ni';
    %Ethernet_address='c600419-70kc.lmumain.edu::inst0';
    %Ethernet_address='10.5.96.138';
    %(Referenc Channel)
    %(Data Channel)
    channel_2=1; %<= USE THIS 
    Trig_channel=1;    %SET THE TRIG CHANNEL

    datastartnum=1;
    Record_length=1e3;
    SAMP_RATE=25e9;   
    C=sprintf('TCPIP::%s::INSTR',Ethernet_address);
    scope = visa(Digitizer_vendor_ethernet,C);
    FRAMES = 10000;
    scope.InputBufferSize = Record_length*FRAMES;
    fopen(scope);
end
%A = query(scope,'COMMAND?')
%####################SETUP 
fprintf(scope,sprintf('SELECT:CH%g on',Trig_channel));
fprintf(scope,sprintf('SELECT:CH%g on',channel_2));
fprintf(scope,sprintf('DATA:SOURCE CH%g',channel_2));
fprintf(scope,sprintf('HORIZONTAL:RECORDLENGTH %g',Record_length));
fprintf(scope,sprintf('HORIZONTAL:MODE:SAMPLERATE %g',SAMP_RATE));
fprintf(scope,'DATA:START %g',datastartnum);
fprintf(scope,['DATA:STOP ' num2str(Record_length)]);
fprintf(scope,sprintf('HORIZONTAL:RECORDLENGTH %g',Record_length));
fprintf(scope,'DATA:WIDTH 1');
fprintf(scope,'DATA:ENC RIB');
fprintf(scope,'ACQUIRE:STATE STOP');
fprintf(scope,'ACQUIRE:MODE SAMPLE');
%fprintf(scope,'ACQUIRE:MODE AVERAGE');

fprintf(scope,'ACQUIRE:SAMPLINGMODE rt');
%fprintf(scope,'ACQUIRE:NUMAVG? rt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TURN ON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AVERAGING
%fprintf(scope,'ACQUIRE:NUMAVG %g',Num_Averages);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HERE 

% fprintf(scope,sprintf('HORizontal:FASTframe:STATE ON'));
% fprintf(scope,sprintf('HORizontal:FASTframe:COUNt %g',FRAMES));

%fprintf(scope,'ACQUIRE:STOPAFTER SEQuence');
%fprintf(scope,'ACQUIRE:STOPAFTER RUNstop');
fprintf(scope,'ACQUIRE:STATE RUN');
fprintf(scope,'ACQUIRE:STATE STOP');

%############POST CAPTURE / BINBLOCK STUFF
% fprintf(scope,sprintf('SELECT:CH%g on',channel));
% fprintf(scope,sprintf('DATA:SOURCE CH%g',channel));
% xmult = str2num(query(scope,'WFMP:XINCR?'));
% fprintf(scope,'CURVE?'); 
% OSC_Trace = (binblockread(scope,'int8'));
% OSC_Trace=OSC_Trace-min(OSC_Trace);
% OSC_Trace=OSC_Trace/max(OSC_Trace);
% OSC_Time= linspace(0,length(OSC_Trace)*xmult,length(OSC_Trace));
% BLR_Trace=OSC_Trace';

fprintf(scope,sprintf('SELECT:CH%g on',channel_2));
fprintf(scope,sprintf('DATA:SOURCE CH%g',channel_2));
xmult = str2num(query(scope,'WFMP:XINCR?'));
fprintf(scope,'CURVE?');
OSC_Trace = (binblockread(scope,'int8'));
OSC_Trace=OSC_Trace-min(OSC_Trace);
OSC_Trace=OSC_Trace/max(OSC_Trace);
OSC_Time = linspace(0,length(OSC_Trace)*xmult,length(OSC_Trace));
OSC_Trace = OSC_Trace';

end