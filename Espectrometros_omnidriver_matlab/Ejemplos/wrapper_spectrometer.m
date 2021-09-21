figure
%se debe inicializar primero el programa en "Inicializar"
h.SetVelParams(0, 0.1, 1, 1);  % canal, vel_min(1mm/s), acel(5mm/s/s), velmax(1mm/s)
% Get the wavelengths of the first spectrometer and save them in a double
wavelengths = wrapper.getWavelengths(0);
wavelengths_1 = wrapper.getWavelengths(1);
%figure(1)
X0=5;% 1cm, 1cm, 1cm
h.SetAbsMovePos(0,X0);       
h.MoveAbsolute(0,1==0);
tic
for i = 1:1:numMuestras;
   
    %spectrometerIndex = 0;
    % array.
    spectralData(:,i) = wrapper.getSpectrum(0);
    %spectrometerIndex = 1;
    % Get the spectrum as double array -- double[]
    % array.
    spectralData_1(:,i) = wrapper.getSpectrum(1);
    fprintf("%d\n",i)
    desplegar(wavelengths,wavelengths_1,spectralData(:,i),spectralData_1(:,i))
    %save("usb2000-"+num2str(i)+".txt","data",'-ascii');
    %writematrix(data,"sb2000-"+num2str(i)+".txt");
    if i == 100;
        X0=4;% 1cm, 1cm, 1cm
        h.SetAbsMovePos(0,X0);       
        h.MoveAbsolute(0,1==0);
    end
    %clear data data_1 fid spectralData_1 spectralData;
    %
end
toc

tic
for i = 1:1:numMuestras;
    data_1 = [wavelengths_1, spectralData_1(:,i)];
    writematrix(data_1,"hr4000/hr4000-"+num2str(i)+".txt"); %probar fopen para ver si se guardan los archivos bien
    %fprintf(fid,'%.4f  %.4f\n',data_1(:,1),data_1(:,2));
    %fclose(fid);
    
    data = [wavelengths, spectralData(:,i)];
    writematrix(data,"usb2000/usb2000-"+num2str(i)+".txt"); %probar fopen para ver si se guardan los archivos bien
    %fprintf(fid,'%.4f  %.4f\n',data(:,1),data(:,2));
    %fclose(fid);
    
end
disp('archivos guardados')
toc

function desplegar(wavelengths,wavelengths_1,spectralData,spectralData_1)
    
    plot(wavelengths, spectralData);
    hold on
    plot(wavelengths_1, spectralData_1);
    %title('Optical Spectrum');
    %ylabel('Intensity (counts)');
    %xlabel('\lambda (nm)');
    %grid on
    %axis tight
    axis([100 1200 0 3000])
    hold off
    drawnow
end