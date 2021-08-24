
v= VideoReader('F:\\MVI_0310.mp4');


noFrames = v.NumFrames;
frames = 1:noFrames;

sheet = 1;
x= xlsread('MVI_0310_13_agost_analisisColor_total.xlsx',sheet);
%video = read(x)    
A=x(:,1);
areaTotal = A;
B= A.' ;

areaRoja=x(:,2);
areaVerde=x(:,3); 
areaAzul=x(:,4);
areaAmarilla=x(:,5);
areaNaranja=x(:,6);
radioRojo = x(:,8);
radioNaranja = x(:,9);
radioAmarillo = x(:,10);
radioVerde = x(:,11);
radioAzul = x(:,12);

%Min=x(:,6);
%May=x(:,5);

%Diam=x(:,3);
%===============================================================================================
figure
subplot(3,3,1);
plot(frames,A,'k')
xlabel('número de frames')
ylabel('Área (pixeles)')
grid on
title('Cambio de Área')
%===============================================================================================
subplot(3,3,2);
meanr = mean(areaRoja);
meanm = mean(areaNaranja);
meany = mean(areaAmarilla);
meang = mean(areaVerde);
meanb = mean(areaAzul);
plot(frames,areaRoja-meanr,'r')
hold on;
plot(frames,areaAmarilla-meany,'y')
plot(frames,areaAzul-meanb,'b')
plot(frames,areaNaranja-meanm,'m')
plot(frames,areaVerde-meang,'g')
xlabel('número de frames')
ylabel('Área (pixeles)')
grid on
title('Cambio de Área')
%===============================================================================================
subplot(3,3,3);
%A=areaTotal;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;    % malla de frecuencia equitativamente espaciada   
%semilogy(freq,power)
%plot(freq,power)
semilogy(freq,power)
title('transformada de fourier (area Total)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%plot(frames,Min)
%xlabel('Frames')
%ylabel('Longitud eje menor')
%grid on
%===============================================================================================
subplot(3,3,4);
%A=areaRoja;
A=areaRoja-meanr;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
powerr = power;
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'r')
%plot(freq,power,'r')
title('transformada de fourier (rojo)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,3,5);
%A=areaAzul;
A=areaAzul-meanb;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
powerb = power;
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'b')
%plot(freq,power,'b')
title('transformada de fourier (azul)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,3,6);
%A=areaVerde;
A=areaVerde-meang;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
powerg = power;
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'g')
%plot(freq,power,'g')
title('transformada de fourier (verde)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,3,7);
%A=areaAmarilla;
A=areaAmarilla-meany;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
powery = power;
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'y')
%plot(freq,power,'y')
title('transformada de fourier (amarillo)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,3,8);
%A=areaNaranja;
A=areaNaranja-meanm;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
powerm = power;
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'m')
%plot(freq,power,'m')
title('transformada de fourier (naranja)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on

subplot(3,3,9);
semilogy(freq,powerr,'r')
hold on
semilogy(freq,powerm,'m')
semilogy(freq,powerb,'b')
semilogy(freq,powerg,'g')
semilogy(freq,powery,'y')
title('transformada de fourier todas')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%================================ NUEVA FIGURE DE RADIOS ================
%========================================================================
figure
subplot(3,2,1);
meanradior = mean(radioRojo);
meanradioy = mean(radioAmarillo);
meanradiog = mean(radioVerde);
meanradiom = mean(radioNaranja);
meanradiob = mean(radioAzul);

plot(frames,radioRojo-meanradior,'r')
hold on
plot(frames,radioNaranja-meanradiom,'m')
plot(frames,radioAmarillo-meanradioy,'y')
plot(frames,radioVerde-meanradiog,'g')
plot(frames,radioAzul-meanradiob,'b')
xlabel('número de frames')
ylabel('Radio (pixeles)')
grid on
title('Cambio de Radio de los colores')
%=================== fft cambio de radio rojo
subplot(3,2,2);
A=radioRojo;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'r')
%plot(freq,power,'r')
title('transformada de fourier (rojo)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,2,3);
A=radioAzul;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'b')
%plot(freq,power,'b')
title('transformada de fourier (azul)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,2,4);
A=radioVerde;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'g')
%plot(freq,power,'g')
title('transformada de fourier (verde)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,2,5);
A=radioAmarillo;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'y')
%plot(freq,power,'y')
title('transformada de fourier (amarillo)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on
%===============================================================================================
subplot(3,2,6);
A=radioNaranja;
u = A.';
y = fft(u);
y(1)=[];

n = length(y);

power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                    % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;      % malla de frecuencia equitativamente espaciada   
semilogy(freq,power,'m')
%plot(freq,power,'m')
title('transformada de fourier (naranja)')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on