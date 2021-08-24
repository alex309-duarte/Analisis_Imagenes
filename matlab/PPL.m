classdef PPL
    methods (Static)
        function results = myimfcn(im,x)

        if(size(im,3)==3)
            % Convierte RGB a grayscale y escoge la mitad derecha de la imagen
            imgray = rgb2gray(im);
            [rows, columns, numberOfColorChannels] = size(imgray);
            %middleColumn = int32(columns/2)
            %rightHalf=imgray(:, middleColumn+1:end, :);
            rightHalf=imgray;

        else
            imgray = im;
            [rows, columns, numberOfColorChannels] = size(imgray);
            middleColumn = int32(columns/2)
            rightHalf=imgray(:, middleColumn+1:end, :);
        end

        imgray = imadjust(imgray,[0.05 0.7]);
        bw = imbinarize(rightHalf,0.15);

        results.imgray = imgray;
        results.bw = bw;

        %Calculando las propiedades, genera una estructura
        properties = regionprops('table',bw,imgray,'Area','PixelList', 'Eccentricity', 'EquivDiameter', 'EulerNumber', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Perimeter', 'Centroid','MaxIntensity','MinIntensity');
        %Convirtiendo la estructura a tabla y almacenando en S
        S = properties;
        %Tabulando en la ventana de resultados,
        results.properties = S;
        
        %Max = properties.MaxIntensity;
        %Min = properties.MinIntensity;
        %difIntensidad = max(Max)-min(Min);
        %Obteniendo el tamaño de la tabla,
        B = size(S);
        %Busca el valor máximo de la columna "Area" (que es la que nos interesa)
        %Almacena el valor máximo y el indice que ocupa en la tabla
        [V,I] = max([S.Area]);

        %Convertimos la tabla a un arreglo y almacenamos. De esta forma nos será
        %más facil seleccionar toda la fila donde se encuentra el valor máximo
        %sm = table2array(S);
        sm = [properties.Area,properties.Eccentricity,properties.EquivDiameter, properties.EulerNumber, properties.MajorAxisLength, properties.MinorAxisLength, properties.Orientation, properties.Perimeter, properties.Centroid];
        %Pedimos que lea el archivo donde se almacenan los datos
        %K = xlsread('properties.xlsx');
        %Pedimos que almacene el rango de información que está escrita
        %[o h] = size(K);
        %Para escribir los datos de una nueva imagen nos interesa conocer el número
        %de filas ya escritas, es decir, la variable 'o'. Después le sumamos 1
        %y almacenamos en x, esta será la fila donde se escribirán los nuevos
        %datos.
        %x = o+1;
        

        %Escogemos que siempre escriba en la hoja 1 del excel.
        sheet = 1;
        %Definimos el rango, y lo pasamos a string para poder introducirlo
        %en la funcion xlswrite
        Rango = string(x);
        %Escribimos los datos:
        %Sobreescribe el archivo properties.xlsx
        %Escribimos toda la fila donde se encuentra el valor máximo de área del
        %arreglo.
        %Escribimos en la hoja 1 y en la siguiente fila desocupada.
        if length(I) == 0
            sm = [0,0,0, 0, 0, 0, 0, 0, 0,0];
            I = 1;
        else
            center1 = sm(I,9:10);
            %rad = mean([sm(I,5) sm(I,6)],2)/2;
            %fprintf("*************")
            %properties.Centroid
            %fprintf("_______________")
            %center1 = properties.Centroid;

            majorAxis = cat(1,properties.MajorAxisLength);
            minorAxis = cat(1,properties.MinorAxisLength);

            rad = mean([sm(I,5) sm(I,6)],2)/2;
            imshow(imgray)
            hold on 
            center = cat(1,properties.Centroid);
            %viscircles(center1,rad+500)
            %plot(center(:,1),center(:,2),'bo','MarkerSize',20)
            plot(sm(I,9),sm(I,10),'bo','MarkerSize',rad)
            %plot(center(:,1),center(:,2),'b*')

            %Graficar los pixeles que detecta
            m = properties.PixelList;  %properties.Area regresa el número de
                                        %pixeles detectados
            for i=1:1:length(m)
               p = cell2mat(m(i));
               plot(p(:,1),p(:,2))
            end
            hold off
            savefig(strcat("frame_",Rango)); %linea que guarda la imágen con
                                                %los objetos super puestos
        end
        xlswrite('properties_4000_rec.xlsx', sm(I,:), sheet , Rango )
        fprintf('%d\n',x);
        %xlswrite('properties.xlsx', sm(I,:), sheet)
        %fprintf("*************");
        
                        
        end        
    end
end

%--------------------------------------------------------------------------
