function [bin] = img_segment(img)
  
    imghsv = hsv_segment(img);                                              %Call user defined function for HSV segmentation
    imgcbcr = ycbcr_segment(img);                                           %Call user defined function for YCbCr segmentation
   
   [r,c,v] = size(imgcbcr);
   if(size(imghsv,1)>r)
        r = size(imghsv,1);
   end
   if(size(imghsv,2)>c)
       c = size(imghsv,2);
   end
   if(size(imghsv,3)>v)
       v = size(imghsv,3);
   end
   
   %Perform logical AND on results of HSV & YCbCr segmentation
   bin=[];
   for l = 1 : r
      for m = 1 : c
          for n = 1 : v
               bin(l,m,n) = imghsv(l,m,n) & imgcbcr(l,m,n);
          end
      end
   end
   
   bin=im2bw(bin);
   SE=strel('disk',1);
   bin=imerode(bin,SE);                                                     %To reduce noise
   bin=imfill(bin,'holes');
end