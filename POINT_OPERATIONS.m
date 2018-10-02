%%CONTRAST
con = imread('hippo.jpg'); %%YOU CAN CHANGE IMAGE HERE
gray_con=rgb2gray(con);
[M_CON,N_CON]=size(gray_con);
new_con=zeros(M_CON,N_CON,'uint8');
for i=1:M_CON
   for j=1:N_CON
       new_con(i,j)=round(gray_con(i,j)*1.5);
       if new_con(i,j) >255
          new_con(i,j)=255; 
       end
   end
end

%%BRIGHTNESS
bright = imread('hippo.jpg');
gray_bright=rgb2gray(bright);
[M_BRIGHT,N_BRIGHT]=size(gray_bright);
new_bright=zeros(M_BRIGHT,N_BRIGHT,'uint8');
for i=1:M_BRIGHT
    for j=1:N_BRIGHT
        new_bright(i,j)=round(gray_bright(i,j)+10);
        if new_bright(i,j)>255
            new_bright(i,j)=255;
        end
    end
end

%%INVERTING
invert = imread('hippo.jpg');
gray_invert=rgb2gray(invert);
INVERT_MAX=max(gray_invert(:));
[M_INVERT,N_INVERT]=size(gray_invert);
new_invert=zeros(M_BRIGHT,N_BRIGHT,'uint8');
for i=1:M_INVERT
    for j=1:N_INVERT
        new_invert(i,j)=INVERT_MAX-gray_invert(i,j);
    end
end

%%THRESHOLD
thres = imread('hippo.jpg');
gray_thres=rgb2gray(thres);
mean= round((max(gray_thres(:))- min(gray_thres(:)))/2);
[M_THRES,N_THRES]=size(gray_thres);
new_thres=zeros(M_THRES,N_THRES,'uint8');
for i=1:M_THRES
 for j=1:N_THRES
    if gray_thres(i,j) < mean
    new_thres(i,j)=0;
    else
    new_thres(i,j)=255;
    end
 end
end

%%AUTOMATIC
auto = imread('hippo.jpg');
double_auto=double(rgb2gray(auto));
gray_auto=rgb2gray(auto);
[M_AUTO,N_AUTO]=size(double_auto);
new_auto=zeros(M_AUTO,N_AUTO,'uint8');
AUTO_LOW=min(double_auto(:));
AUTO_HIGH=max(double_auto(:));
for i=1:M_AUTO
    for j=1:N_AUTO
        new_auto(i,j)=round((double_auto(i,j)-AUTO_LOW)*(255/(AUTO_HIGH-AUTO_LOW)));
    end
end

%%MODIFIED
modified = imread('hippo.jpg');
double_auto=double(rgb2gray(auto));
gray_modified=rgb2gray(modified);
[M_MODIFIED,N_MODIFIED]=size(gray_modified);
new_modified=zeros(M_MODIFIED,N_MODIFIED,'uint8');
A_MIN=0;
A_MAX=255;
E=zeros(A_MIN+3,A_MAX+1);  %COUNT PIXELS 
for i=1:M_MODIFIED
   for j=1:N_MODIFIED
    for c=A_MIN:A_MAX   
        if c==gray_modified(i,j)
            n=E(A_MIN+1,c+1);
            n=n+1;
            E(A_MIN+1,c+1)=n;
            break;
        end 
    end    
   end
end
b=0;    %%CUMULATIVE
   for j=1:A_MAX+1
       E(A_MIN+2,j)=E(A_MIN+1,j);
       E(A_MIN+2,j)=E(A_MIN+2,j)+b; 
       b=E(A_MIN+2,j);
   end
   
q=0.005;
for j=1:A_MAX+1
   if E(A_MIN+2,j) >= M_MODIFIED*N_MODIFIED*q;
       MODIFIED_LOW=j;
       MODIFIED_LOW=MODIFIED_LOW-1; %if MODIFILED_LOW pixel is 1,it have to -1 because inital value is 1 not 0  
       break
   end
end

for j=A_MAX+1:-1:1
   if E(A_MIN+2,j) <= M_MODIFIED*N_MODIFIED*(1-q);
       MODIFIED_HIGH=j;
       MODIFIED_HIGH=MODIFIED_HIGH-1; %if MODIFILED_HIGH pixel is 1,it have to -1 because inital value is 1 not 0  
       break
   end
end

for i=1:M_MODIFIED
 for j=1:N_MODIFIED
   if gray_modified(i,j)<= MODIFIED_LOW
       new_modified(i,j)=A_MIN;
   elseif gray_modified(i,j) >= MODIFIED_HIGH
       new_modified(i,j)=A_MAX;
   else
       new_modified(i,j)=round((gray_modified(i,j)-MODIFIED_LOW)*((A_MAX-A_MIN)/(MODIFIED_HIGH-MODIFIED_LOW)));
   end
 end
end

figure
subplot(2,3,1)
imshow(gray_con)
title('NORMAL PICTURE');
subplot(2,3,4)
imhist(gray_con)


subplot(2,3,2)
imshow(new_con)
title('CONTRAST');
subplot(2,3,5)
imhist(new_con)


subplot(2,3,3)
imshow(new_bright)
title('BRIGHTNESS');
subplot(2,3,6)
imhist(new_bright)

figure

subplot(2,3,1)
imshow(gray_con)
title('NORMAL PICTURE');
subplot(2,3,4)
imhist(gray_con)


subplot(2,3,2)
imshow(new_invert)
title('INVERTING');
subplot(2,3,5)
imhist(new_invert)


subplot(2,3,3)
imshow(new_thres)
title('THRESHOLD');
subplot(2,3,6)
imhist(new_thres)

figure

subplot(2,3,1)
imshow(gray_con)
title('NORMAL PICTURE');
subplot(2,3,4)
imhist(gray_con)


subplot(2,3,2)
imshow(new_auto)
title('AUTO CONTRAST');
subplot(2,3,5)
imhist(new_auto)


subplot(2,3,3)
imshow(new_modified)
title('MODIFIED CONTRAST');
subplot(2,3,6)
imhist(new_modified)



