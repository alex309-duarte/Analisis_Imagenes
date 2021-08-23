
import cv2
import numpy as np
import openpyxl
import math as mt
import numpy as np

wb = openpyxl.Workbook() #Abrimos el archivo de Excel

path = "F:/MVI_0310.mp4"

print('Analizando video '+path)
fgbg = cv2.BackgroundSubtractorMOG2()
#preparando documento excel para guardar los datos
wb = openpyxl.Workbook()
hoja = wb.active
# Crea la fila del encabezado con los títulos
hoja.append(('Area', 'centroide_x', 'centroide_y', 'radio','area_anillo_negativa','areaMayor','difer_areas'))

video = cv2.VideoCapture(path)
for k in range(int(video.get(cv2.CAP_PROP_FRAME_COUNT))):
    video.set(cv2.CAP_PROP_POS_FRAMES,k); #colocamos el número de frame que deseamos leer
    ret, frame = video.read() #Leemos el frame
    #print(video.get(cv2.CAP_PROP_FRAME_HEIGHT),video.get(cv2.CAP_PROP_FRAME_WIDTH),video.get(cv2.CAP_PROP_FRAME_COUNT))
    #=================================================== Mostrar imágen Original ==================================
    #Convertimos la imágen a blanco y negro
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    #Limpiamos la imagen, localizando la zona que queremos leer
    ret, grayMain = cv2.threshold(gray,20,255,cv2.THRESH_BINARY)
    imageGray = cv2.resize(grayMain,(960,540))
    cv2.imshow('image_gray',imageGray)
    #
    th2 = cv2.adaptiveThreshold(gray,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv2.THRESH_BINARY_INV,33,5)
    # se dividen ls coordenadas del centro entre dos porque estamos reescalando la imágen, esto con propositos visuales
    imageGray = cv2.resize(th2,(960,540))
    cv2.imshow('image',imageGray)
    #============================================ comparando imágenes ==================================
    combine = cv2.addWeighted(cv2.resize(th2,(960,540)),0.5,cv2.resize(gray,(960,540)),0.5,0.5)
    #regionsprops, buscamos las propiedades de la imagen porcesada th2
    contours,hierarchy = cv2.findContours(th2, cv2.CHAIN_APPROX_NONE, 2)
    contoursMain, hierarchy = cv2.findContours(grayMain, cv2.CHAIN_APPROX_NONE, 2)
    areaTotalnegativa = 0
    maxNum = 0
    indice = 0
    indiceMain = 0
    xm = 0
    ym = 0
    #for i in range(int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))):
     #   for j in range(int(video.get(cv2.CAP_PROP_FRAME_WIDTH))):
      #      if th2[i][j]>50:
       #         areaTotalnegativa +=1
    areaTotalnegativa = np.sum(th2 == 255)
    #Guardamos las coordenadas de los puntos en la variable coordenadas de la siguiente forma
    #coordenadas[rightX,rightY,leftX,leftY,TopX,TopY,BottomX,BottomY]
    coordenadas = [0,0,0,0,0,0,0,0]
    numDatos = 0;
    areaTotal = 0;
    #cv2.drawContours(frame, contours, -1, (0, 0, 0), -1)
    for c in contours:
        areaTotal += cv2.contourArea(c)
        if cv2.contourArea(c)>50:
            numDatos+=1
            M = cv2.moments(c)
            if (M["m00"] == 0): M["m00"] = 1
            xm += (M["m10"] / M["m00"])
            ym += (M['m01'] / M['m00'])
            cv2.drawContours(frame, [c], 0, (0, 0, 0), -1)
            #left = tuple(c[c[:, :, 0].argmin()][0])
            #right= tuple(c[c[:, :, 0].argmax()][0])
            #top = tuple(c[c[:, :, 1].argmin()][0])
            #bottom = tuple(c[c[:, :, 1].argmax()][0])
            #coordenadas[0] +=right[0]
            #coordenadas[1] += right[1]
            #coordenadas[2] += left[0]
            #coordenadas[3] += left[1]
            #coordenadas[4] += top[0]
            #coordenadas[5] += top[1]
            #coordenadas[6] += bottom[0]
            #coordenadas[7] += bottom[1]


    #generando matriz del contorno de la Imágen
    arrayMain = [0 for i in range(len(contoursMain))]
    for i in range(len(contoursMain)):
        arrayMain[i] = cv2.contourArea(contoursMain[i])
        if arrayMain[i] > maxNum:
            maxNum = arrayMain[i]
            indiceMain = i;

    cv2.drawContours(frame, contoursMain, indiceMain, (0,0,255), 3)


    m = cv2.moments(contoursMain[indiceMain])
    x = m['m10']/m['m00']
    y = m['m01']/m['m00']
    cv2.circle(frame, (int(x), int(y)), 10, (255,255,255), -1)
    print('x=', x, 'y=', y)
    x1 = (xm/numDatos)
    y1 = (ym/numDatos)
    frame = cv2.resize(frame, (960, 540))
    cv2.imshow("hey", frame)
    #x1 = ((coordenadas[0]+coordenadas[2]+coordenadas[4]+coordenadas[6])/(numDatos*4))
    #y1 = ((coordenadas[1]+coordenadas[3]+coordenadas[5]+coordenadas[7])/(numDatos*4))
    if numDatos > 20:
        radio = mt.sqrt(mt.pow(x1-x,2)+ mt.pow(y1-y,2))
    else:
        radio = 1;
    print('left',areaTotalnegativa,'right',coordenadas,'radio ',radio,'area',areaTotal,'area_mayor',arrayMain[indiceMain])
    hoja.insert_rows(k+2)
    hoja.append((areaTotal,x,y,radio,areaTotalnegativa,arrayMain[indiceMain],arrayMain[indiceMain]-areaTotal))
    print('guardando datos en fila ',k)
    wb.save('MVI_0310_12_agost(prueba_50_20-12).xlsx')
    cv2.waitKey(1)

cv2.destroyAllWindows()

# closing all open windows
