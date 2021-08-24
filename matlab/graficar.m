
v= VideoReader('F:\\muestras_espectro\\muestras_prueba_5_agosto_780\\MVI_iso4000.mp4');

%%
noFrames = v.NumFrames;
frames = 1:noFrames;

sheet = 1;
x= xlsread('MVI_datos_5_limite_30.xlsx',sheet);
%video = read(x)    
A=x(:,1);
B= A.' ;


H=x(:,2); %Centroide x
G=x(:,3); %Centroide y

%Min=x(:,6);
%May=x(:,5);

%Diam=x(:,3);



%plot(frames,Min)
%xlabel('Frames')
%ylabel('Longitud eje menor')
%grid on

subplot(2,2,1)
plot(H,G);
xlabel('Centroid x')
ylabel('Centroid y')
grid on
title('Espacio Fase')

subplot(2,2,2)
plot(frames,G);
xlim([0 noFrames])
xlabel('Frames')
ylabel('Centroid y')
grid on
title('Movimiento en el eje Y')

subplot(2,2,3)
plot(frames,H,'.-');
xlim([0 noFrames])
xlabel('Frames')
ylabel('Centroid x')
grid on
title('Movimiento en el eje X')

subplot(2,2,4)
plot(frames,B)
xlabel('Frames')
ylabel('Area')
grid on
title('Cambio del Área')

FFT
% subplot(2,2,4)
% plot(frames, Diam)
% xlim([0 1333])
% xlabel('Frames')
% ylabel('Diámetro Equivalente')
% grid on
% title('Cambio del Diámetro')