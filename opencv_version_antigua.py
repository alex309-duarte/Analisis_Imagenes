
import cv2
import numpy as np
import openpyxl
import math as mt

wb = openpyxl.Workbook() #Abrimos el archivo de Excel

path = "F:/MVI_0310.mp4"

print('Analizando video'+path)
print("Your OpenCV version is: " + cv2.__version__)
fgbg = cv2.BackgroundSubtractorMOG2()
#preparando documento excel para guardar los datos
wb = openpyxl.Workbook()
hoja = wb.active
# Crea la fila del encabezado con los títulos
hoja.append(('Area', 'centroide_x', 'centroide_y', 'radio','area_anillo','areaMayor','difer_areas'))

video = cv2.VideoCapture(path)
for k in range(int(video.get(cv2.CAP_PROP_FRAME_COUNT))):
    video.set(cv2.CAP_PROP_POS_FRAMES,k); #colocamos el número de frame que deseamos leer
    ret, frame = video.read() #Leemos el frame
    print(video.get(cv2.CAP_PROP_FRAME_HEIGHT),video.get(cv2.CAP_PROP_FRAME_WIDTH),video.get(cv2.CAP_PROP_FRAME_COUNT))
    #=================================================== Mostrar imágen Original ==================================
    #image = cv2.resize(frame,(960,540))
    #cv2.imshow('image_original',image)
    # solo para el primer videoo ====================================
    #for m in range(int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))):
     #   for n in range (int(video.get(cv2.CAP_PROP_FRAME_WIDTH))):
      #      if(m>1020):
       #         frame[m][n] = 20
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    #gray = cv2.bitwise_not(gray)
    #print('valor del pixel',frame[0][0])
    ret, grayMain = cv2.threshold(gray,40,255,cv2.THRESH_BINARY)
    imageGray = cv2.resize(grayMain,(960,540))
    cv2.imshow('image_gray',imageGray)
    #gray = cv2.bitwise_not(gray)

    th2 = cv2.adaptiveThreshold(gray,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv2.THRESH_BINARY_INV,19,3)
    #i,th2 = cv2.threshold(gray,50,255,cv2.THRESH_BINARY)
    imageGray = cv2.resize(th2,(960,540))
    cv2.imshow('image',imageGray)
    #th2 = cv2.bitwise_not(th2)
    #============================================ comparando imágenes ==================================
    combine = cv2.addWeighted(cv2.resize(th2,(960,540)),0.5,cv2.resize(gray,(960,540)),0.5,0.5)
    #cv2.imshow("combinacion imágen normal en blanco y negro contra imágen procesada",combine)
    #cv2.imwrite("primer_video_detectada_imgray.png", combine)
    #regionsprops
    contours,hierarchy = cv2.findContours(th2, cv2.CHAIN_APPROX_NONE, 2)
    contoursMain, hierarchy = cv2.findContours(grayMain, cv2.CHAIN_APPROX_NONE, 2)
    array = [0 for i in range( len(contours))]
    #print(len(contours))
    array[0] = 0
    maxNum = 0
    indice = 0
    indiceMain = 0
    for i in range( len(contours)-1):
        #print(cv2.contourArea(contours[i]))
        array[i] = cv2.contourArea(contours[i])
        if array[i]> maxNum:
            maxNum = array[i]
            indice = i;

    print("mayor valor en "+str(indice)+" con valor "+str(array[indice]))
    cv2.drawContours(frame, contours, -1, (0, 255, 0), 3)
    #cv2.drawContours(frame, contours, 1, (0, 255, 0), 3)
    mask = np.zeros(th2.shape,np.uint8)
    ## ???=========================??????????
    cv2.drawContours(mask,[contours[indice]],0,255,-1)
    pixelpoints = np.transpose(np.nonzero(mask))
    #cv2.imshow("hey",gray)
    rightmost = [0,0]
    matriz = [np.uint8(0)]*(int(video.get(cv2.CAP_PROP_FRAME_HEIGHT)))
    for i in range(int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))):
        matriz[i] = ([np.uint8(0)]*int(video.get(cv2.CAP_PROP_FRAME_WIDTH)))
    matrizC = [np.uint8(0)] * (int(video.get(cv2.CAP_PROP_FRAME_HEIGHT)))
    for i in range(int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))):
        matrizC[i] = ([np.uint8(0)] * int(video.get(cv2.CAP_PROP_FRAME_WIDTH)))
    print(len(matriz),len(matriz[0]))
    numDatos = 0;
    areaTotal = 0;
    for i in range( len(contours)-1):
        if array[i]>10:
            mask = np.zeros(th2.shape, np.uint8)
            cv2.drawContours(mask, [contours[i]], 0, 255, -1)
            pixelpoints = np.transpose(np.nonzero(mask))
            numDatos+=1
            cnt= contours[i]
            #leftmost = tuple(cnt[cnt[:, :, 0].argmin()][0])
            right= tuple(cnt[cnt[:, :, 0].argmax()][0])
            #topmost = tuple(cnt[cnt[:, :, 1].argmin()][0])
            #bottommost = tuple(cnt[cnt[:, :, 1].argmax()][0])
            rightmost[0] +=right[0]
            rightmost[1] += right[1]
            areaTotal +=array[i]
            for j in range( int(array[i])):
                matriz[pixelpoints[j,0]][pixelpoints[j,1]] = np.uint8(255);
    #generando matriz del contorno de la Imágen
    arrayMain = [0 for i in range(len(contoursMain))]
    for i in range( len(contoursMain)):
        #print(cv2.contourArea(contours[i]))
        arrayMain[i] = cv2.contourArea(contoursMain[i])
        if arrayMain[i]> maxNum:
            maxNum = arrayMain[i]
            indiceMain = i;
    mask = np.zeros(grayMain.shape, np.uint8)
    cv2.drawContours(mask, [contoursMain[indiceMain]], 0, 255, -1)
    pixelpoints = np.transpose(np.nonzero(mask))


    cv2.drawContours(frame, contoursMain, indiceMain, (0,0,255), 3)

    for j in range(int(arrayMain[indiceMain])):
        matrizC[pixelpoints[j, 0]][pixelpoints[j, 1]] = np.uint8(255);
    for i in range(int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))):
        for j in range(int(video.get(cv2.CAP_PROP_FRAME_WIDTH))):
            #matriz[i][j]=matrizC[i][j]
            matriz[i][j] = matrizC[i][j]-matriz[i][j]
    if numDatos > 20:
        radio = mt.sqrt(mt.pow((rightmost[0]/numDatos)-960,2)+ mt.pow((rightmost[1]/numDatos)-540,2))
    else:
        radio = 1;
    a = np.uint8(matriz)
    a = cv2.resize(a,(960,540))
    combine = cv2.addWeighted(cv2.resize(gray,(960,540)),0.5,cv2.resize(a,(960,540)),0.5,0.5)
    frame = cv2.resize(frame, (960, 540))
    cv2.imshow("hey",frame)
    m = cv2.moments(th2)
    x = m['m10']/m['m00']
    y = m['m01']/m['m00']
    print('x=',x, 'y=',y,'num datos ',numDatos,'left','comentado','right',rightmost,'radio ',radio,'area',areaTotal,'area_mayor',arrayMain[indiceMain])
    # se dividen ls coordenadas del centro entre dos porque estamos reescalando la imágen, esto con propositos visuales
    cv2.circle(combine, (int(x/2),int(y/2)), int((array[indice]-areaTotal)/100000), 255, 5)
    cv2.imshow('out',combine)
    #cv2.imwrite("primer_video_area_detectada.png",combine)
    hoja.insert_rows(k+2)
    hoja.append((areaTotal,x,y,radio,array[indice],arrayMain[indiceMain],arrayMain[indiceMain]-areaTotal))
    print('guardando datos en fila ',k)
    wb.save('MVI_0310_13_agost(1).xlsx')
    cv2.waitKey(2)
    #time.sleep(2)
cv2.destroyAllWindows()
