%documentation
%https://www.oceaninsight.com/globalassets/catalog-blocks-and-images/software-downloads-installers/javadocs-api/omnidriver/index.html?com/oceanoptics/omnidriver/spectrometer/
%Connect with spectrometers
fprintf("2")
javaaddpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\OmniDriver.jar');
%wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();
%wrapper.openAllSpectrometers();
spectrometerObj = icdevice('OceanOptics_OmniDriver.mdd');
fprintf("1")
connect(spectrometerObj);
disp(spectrometerObj)

% integration time for sensor.
integrationTime = 25000;
% Spectrometer index to use (first spectrometer by default).
spectrometerIndex = 0;
% Channel index to use (first channel by default).
channelIndex = 0;
% Enable flag.
enable = 1;

% Get number of spectrometers connected.
numOfSpectrometers = invoke(spectrometerObj, 'getNumberOfSpectrometersFound');

disp(['Found ' num2str(numOfSpectrometers) ' Ocean Optics spectrometer(s).'])

% Get spectrometer name.
spectrometerName = invoke(spectrometerObj, 'getName', spectrometerIndex);
% Get spectrometer serial number.
spectrometerSerialNumber = invoke(spectrometerObj, 'getSerialNumber', spectrometerIndex);
disp(['Model Name : ' spectrometerName])
disp(['Model S/N  : ' spectrometerSerialNumber])

% Set integration time.
invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);
% Enable correct for detector non-linearity.
invoke(spectrometerObj, 'setCorrectForDetectorNonlinearity', spectrometerIndex, channelIndex, enable);
% Enable correct for electrical dark.
invoke(spectrometerObj, 'setCorrectForElectricalDark', spectrometerIndex, channelIndex, enable);
% set the spectrometer in different trigger mode, trigger mode 1 equal
% trigger software
%invoke(spectrometerObj, 'setExternalTriggerMode', spectrometerIndex, channelIndex, 1);

if (numOfSpectrometers)~=1;
    spectrometerIndex = 1;
    %channelIndex = 1;
    % Get spectrometer name.
    spectrometerName = invoke(spectrometerObj, 'getName', spectrometerIndex);
    % Get spectrometer serial number.
    spectrometerSerialNumber = invoke(spectrometerObj, 'getSerialNumber', spectrometerIndex);
    disp(['Model Name : ' spectrometerName])
    disp(['Model S/N  : ' spectrometerSerialNumber])

    % Set integration time.
    invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);
    % Enable correct for detector non-linearity.
    invoke(spectrometerObj, 'setCorrectForDetectorNonlinearity', spectrometerIndex, channelIndex, enable);
    % Enable correct for electrical dark.
    invoke(spectrometerObj, 'setCorrectForElectricalDark', spectrometerIndex, channelIndex, enable);
    % set the spectrometer in different trigger mode, trigger mode 1 equal
    % trigger software
    %invoke(spectrometerObj, 'setExternalTriggerMode', spectrometerIndex, channelIndex, 1);
end
spectrometerIndex = 0;
figure(1)
finish = 0;
%Asignando memoria a las variables
wavelengths_1 = zeros(1, 2050);
wavelengths = zeros(1, 3650);
spectralData_1 = zeros(1, 2050);
spectralData = zeros(1, 3650);
tic  %Comenzamos a cotar el tiempo
for i = 1:1:200; %adquirimos 200 espectros
    figure(1)
    spectrometerIndex = 0;
    wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
    % Get the wavelengths of the first spectrometer and save them in a double
    % array.
    spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
    
    spectrometerIndex = 1;
    wavelengths_1 = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
        % Get the wavelengths of the first spectrometer and save them in a double
        % array.
    spectralData_1 = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
       
    data = [wavelengths, spectralData];
    %fopen() %probar fopen para ver si se guardan los archivos bien
    %save("usb2000-"+num2str(i)+".txt","data",'-ascii');
    writematrix(data,"usb2000-"+num2str(i)+".txt");
    disp(i)
    plot(wavelengths, spectralData);
    hold on
    plot(wavelengths_1, spectralData_1);
    %title('Optical Spectrum');
    %ylabel('Intensity (counts)');
    %xlabel('\lambda (nm)');
    grid on
    %axis tight
    axis([100 1200 0 2000])
    hold off
    %clear data wavelengths spectralData;
    %
end
toc   

%disconnect(spectrometerObj);

    
