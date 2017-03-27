function [imghsv] = hsv_segment(img)
   
   imghsv=img;
      
   hsv=rgb2hsv(img);
   h=hsv(:,:,1);
   s=hsv(:,:,2);
   
   [r c]=find(h<0 | h>0.25 | s<=0.05 | s>0.9);                              %Threshold values for skin colour in HSV
   numid=size(r,1);
   for x = 1 : numid
       imghsv(r(x),c(x),:)=0;                                               %Make non-skin coloured elements 'black'
   end
     
   [r,c]=size(imghsv);
   for l = 1 : r
      for m = 1 : c
         if(imghsv(l,m)~=0)
              imghsv(l,m)=255;                                              %Make skin colour elements 'white' (255 => all bits '1' in binary)
         end
      end
   end
   
end