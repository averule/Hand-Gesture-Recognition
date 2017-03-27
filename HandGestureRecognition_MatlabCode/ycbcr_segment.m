function [imgcbcr] = ycbcr_segment(img)

   imgcbcr=img;                                                             %Image from the previous segmentation
   ycbcr=rgb2ycbcr(imgcbcr);
   cb=ycbcr(:,:,2);
   cr=ycbcr(:,:,3);
     
   [r c] = find(cb<=77 | cb >=131 | cr<=121 | cr>=160);                     %Threshold for skin colour in YCbCr
   numid = size(r,1);
   for x = 1 : numid
     imgcbcr(r(x),c(x),:) = 0;                                              %Make non-skin coloured elements 'black'
   end
    
   [r,c]=size(imgcbcr);
   for l=1 : r
      for m=1 : c
         if(imgcbcr(l,m)~=0)
            imgcbcr(l,m)=255;                                               %Make skin colour elements 'white' (255 => all bits '1' in binary)
         end
      end
   end
   
   imgcbcr=imfill(imgcbcr,'holes');
   
end   