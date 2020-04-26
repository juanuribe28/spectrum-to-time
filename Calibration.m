function [Frequency_axis_3,Spectrum_level_3,b_,beta2_cal, beta3_cal] = Calibration(wavelength,power_spectrum,Time_step,Time_waveform,beta2)
% D=1215.5; %% ps/nm
% beta2=D/0.7846; %% ps^2
% Time_step = 20*1e-12; %% s
debug_mode=false;
beta2_range=beta2*[0.5:0.04:1.5];
beta3=0.01;
beta3_range=0;%beta3*[-1:1:1];

tt_max=0;
H_wait=waitbar1(0,'Calibrating the dispersion factor and frequency axis ...');
for iii=1:length(beta2_range)
    for kkk=1:length(beta3_range)
        PM_time = Time_waveform.';
        % PM_time = load('PM_Ave50_1.dat');
        PM_time = PM_time-min(PM_time);  %% Amplitude of the temporal waveform
        N = length(PM_time);
        % Original_Time_axis = [-(N-1)/2:(N-1)/2]*Time_step*1e9; % Time axis in ns
        Original_Time_axis = linspace(-N/2*Time_step,N/2*Time_step,N)*1e9; % Time axis in ns
        
            Bandwidth_optical = N*Time_step*1e12/(2*pi*beta2_range(iii));  %% (THz) map the whole frame to the optical spectrum
%         Bandwidth_optical=roots([(2*pi)^2*beta3_range(kkk)/2 2*pi*beta2_range(iii) -N*Time_step*1e12/2]);
%         Bandwidth_optical=max(Bandwidth_optical)*2;
        % Original_Spectrum = load('W0002.dat');
        Original_wavelength_axis = wavelength;%Original_Spectrum(:,1);  %% nm
        Original_Frequency_axis = 299792458./Original_wavelength_axis/1e3;  %% THz
        Original_Frequency_axis = Original_Frequency_axis-Original_Frequency_axis(round(length(Original_Frequency_axis)/2));
        Original_Spectrum_level =power_spectrum;%Original_Spectrum(:,2);
        
        Frequency_axis_1 = linspace(min(Original_Frequency_axis), max(Original_Frequency_axis),10000);
        Frequency_step = Frequency_axis_1(2)-Frequency_axis_1(1);
        Spectrum_level_1 = interp1(Original_Frequency_axis,Original_Spectrum_level,Frequency_axis_1,'spline','extrap');
        
        Padded_frequency_1 = [-Bandwidth_optical/2:Frequency_step:min(Frequency_axis_1)-Frequency_step];
        Padded_frequency_2 = [max(Frequency_axis_1)+Frequency_step:Frequency_step:Bandwidth_optical/2];
        N1 = length(Padded_frequency_1);
        N2 = length(Padded_frequency_2);
        Spectrum_level_2 = [ones(1,N1)*Original_Spectrum_level(1),Spectrum_level_1,ones(1,N2)*Original_Spectrum_level(1)];
        Frequency_axis_2 = [Padded_frequency_1,Frequency_axis_1,Padded_frequency_2];
        Frequency_axis_3 = linspace(-Bandwidth_optical/2,Bandwidth_optical/2,10000);

        Frequency_axis_3_beta3=Frequency_axis_3+beta3_range(kkk)*Frequency_axis_3.^2*1;
%         Frequency_axis_3_beta3=Frequency_axis_3_beta3/max(Frequency_axis_3_beta3)*max(Frequency_axis_3);
        
%         a=min(Frequency_axis_3_beta3(end),Frequency_axis_3(end));
        
        Spectrum_level_3 = interp1(Frequency_axis_2,Spectrum_level_2,Frequency_axis_3,'spline','extrap');
        Spectrum_level_3_ = interp1(Frequency_axis_3,Spectrum_level_3,Frequency_axis_3_beta3,'spline','extrap');
Spectrum_level_3_(find(Spectrum_level_3_>max(Spectrum_level_3)))=0;
        
        if debug_mode==true
%             close all
            
            figure(2)
            plot(Frequency_axis_3,Spectrum_level_3*0.58)
            hold on
            plot(Frequency_axis_3,Spectrum_level_3_*0.58,'r')
            
            xlabel('Frequency')
            ylabel('Intensity(a.u.)')
            title('Absorption Spectrum from OSA')
        end
        
        Orig_Spectrum_fft = fftshift(fft(Spectrum_level_3));
        N_3 = length(Orig_Spectrum_fft);
        n = 1:N_3;
        filter_Spectrum = exp(-(n-N_3/2).^2/2/8^2)';
        Orig_Spectrum_fft = Orig_Spectrum_fft;%.*filter_Spectrum;
        Ref_Spectrum = Spectrum_level_3;%abs(ifft(ifftshift(Orig_Spectrum_fft)));
        
        if debug_mode==true
            
            figure(2)
            plot(abs(Ref_Spectrum))
            title('Envelope of the optical spectrum')
        end
        
        %%
        Time_axis_1 = linspace(min(Original_Time_axis),max(Original_Time_axis),10000);
        PM_time_1 = interp1(Original_Time_axis,PM_time,Time_axis_1,'spline','extrap');
        
        PM_time_fft_0 = fftshift(fft(PM_time_1));
        N = length(PM_time_fft_0);
        n = 1:N;
        filter_time = exp(-(n-N/2).^2/2/25^2)';
        PM_time_fft = PM_time_fft_0;%.*filter_time;
        
        Ref_time = PM_time_1;%ifft(ifftshift(PM_time_fft));
        
        if debug_mode==true
            
            figure(4)
            plot(abs(Ref_time),'b')
            hold on
            plot(PM_time_1,'r--')
            legend('Envelope of the temporal waveform','Original temporal waveform')
        end
        
        if debug_mode==true
            
            figure(5)
            plot(Frequency_axis_3,Ref_Spectrum/max(Ref_Spectrum),'r')
            hold on
            plot(Frequency_axis_3,Ref_time/max(Ref_time),'b')
            legend('Envelope of the optical spectrum','Envelope of the temporal waveform')
        end
        
        
        PM_time_1 =PM_time_1/max(PM_time_1);
        % PM_time_1 = fliplr(PM_time_1);
        
        Spectrum_level_3=Spectrum_level_3/max(Spectrum_level_3);
        
        ST=500;
        SHIFT_range=-ST:ST;
        for jj=1:length(SHIFT_range)%length(Spectrum_level_3)%U_range
            %                 keyboard
            tt(jj,iii,kkk)=abs(Spectrum_level_3)*(circshift(abs(PM_time_1),[0 SHIFT_range(jj)])).'/sqrt(sum(abs(Spectrum_level_3).^2))/sqrt(sum(abs(PM_time_1).^2));
            if (tt(jj,iii,kkk)>tt_max)
                tt_max=tt(jj,iii,kkk);
                calibrated_PM_TIME_1=circshift(abs(PM_time_1),[0 SHIFT_range(jj)]);
                Frequency_axis_3_cal=Frequency_axis_3;
                beta2_cal=beta2_range(iii);
                beta3_cal=beta3_range(kkk);
                b_=SHIFT_range(jj);
                
            end
            total=length(beta2_range)*length(SHIFT_range);
            current=jj+(iii-1)*length(SHIFT_range);
            if floor(current/1000)==current/1000
                
                waitbar1(current/total)
            end
            if(0)
                figure(10)
                plot(Frequency_axis_3,((circshift(abs(PM_time_1),[0 jj]))),'b','LineWidth',2)
                hold on
                plot(Frequency_axis_3,Spectrum_level_3/max(Spectrum_level_3),'r','LineWidth',2)
                
                xlabel('Wavelength(nm)','Fontname', 'Times New Roman','Fontsize',24,'FontWeight','bold')
                ylabel('Intensity(a.u.)','Fontname', 'Times New Roman','Fontsize',24,'FontWeight','bold')
                set(gca,'FontName','Times New Roman','FontSize',20, 'FontWeight', 'bold');
                pause(0.001)
                hold off
            end
        end
    end
end
close(H_wait)
% [a_AC b_]=max(tt);
% PM_time_new=circshift(PM_time_1,[ 0 b_]);%
b_=round(length(Time_waveform)/length(Spectrum_level_3)*b_);

if 1%debug_mode==true
    
    figure(10)
    plot(Frequency_axis_3,(calibrated_PM_TIME_1),'b','LineWidth',2)
    hold on
    plot(Frequency_axis_3,Spectrum_level_3/max(Spectrum_level_3),'r','LineWidth',2)
    
    xlabel('Wavelength(nm)','Fontname', 'Times New Roman','Fontsize',24,'FontWeight','bold')
    ylabel('Intensity(a.u.)','Fontname', 'Times New Roman','Fontsize',24,'FontWeight','bold')
    set(gca,'FontName','Times New Roman','FontSize',20, 'FontWeight', 'bold');
    
    %     xlim([1526,1536])
    
    %keyboard
end

