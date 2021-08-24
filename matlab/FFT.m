v= VideoReader('F:\\muestras_espectro\\muestras_prueba_5_agosto_780\\MVI_iso4000.mp4');
noFrames = v.NumFrames;
frames = 1:noFrames;
x= xlsread('MVI_datos_5_limite_30.xlsx',sheet);
%video = read(x)    
A=x(:,1);
%% 
figure
subplot(2,2,1)
u = A.';
y = fft(u);
y(1)=[];
plot(y,'ro')
xlabel('real')
ylabel('imag')
title('Coeficientes de Fourier')
grid on
%% 

n = length(y);



power = abs(y(1:floor(n/2))).^2; % potencia de la primera mitad de datos de transformada
maxfreq = 30;                % frecuencia máxima
freq = (1:n/2)/(n)*maxfreq;    % malla de frecuencia equitativamente espaciada   
subplot(2,2,2)
plot(freq,power)
title('transformada de fourier')
xlabel('Frecuencia (Hz)')
ylabel('Potencia')
grid on

%%
subplot(2,2,3)
l=[frames, u];
freq= 30;
L=noFrames;

F=freq*(0:L/2)/L;
h=fft(l);
p1=abs(h/L);
p2= p1(1:L/2+1)*2;
plot(F,p2)
% 
% 
% p=[frames;u];
% fft(p)
% plot(frames,p)
% p=fft(u);
% plot(frames,p)