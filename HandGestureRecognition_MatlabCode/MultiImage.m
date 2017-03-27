clc;
clear all;
close all;

%Taking input for gesture recognition system through a dialog box

TrainDatabasePath = uigetdir('C:\Hand Gesture Recognition-AshutoshShrivardhanPoonam\Hand Gesture Recognition 3D\train', 'Select the train database path' );
TestDatabasePath = uigetdir('C:\Hand Gesture Recognition-AshutoshShrivardhanPoonam\Hand Gesture Recognition 3D\test','Select the test database path');
prompt = {'Enter the name of the gesture (a number between 1 to 40):'};		%Statement within dialog box
dlg_title = ('Input For Hand Gesture Recognition System');			%Title for dialog box
TestImage1 = inputdlg(prompt,dlg_title);					%Take input from dialog box
TestImage = strcat(TestDatabasePath,'\',char(TestImage1),'.mpo');		%Generate path of test image

tic								%Start timer for execution time

%To generate a matrix 'T' such that each column within it represents an image
T = [];
for i = 1 : 11
   str = int2str(i);    
   
   str = strcat(TrainDatabasePath,'\',str,'.mpo');
   img = imread(str);                                             
   %Read train image				     
   img = imresize(img,0.03);                                               	%Resizing image to 3% of its original size, keeping all its features intact
   
   bin = img_segment(img);                                                 	%Removal of background and generating an equivalent binary image(user defined function used)
   
   [irow icol] = size(bin);                                               	 %Gives the size of the 'bin' matrix (number of rows and columns in 'bin')
   temp = reshape(bin' , irow*icol , 1);                                  	 %Converts the entire 'bin' matrix into a single column matrix
   T = [T temp];                                                            %Generate a single matrix with each column representing data of respective image	
end
 
%To generate a mean matrix (single column matrix) 'm' containing mean along each row of matrix 'T'
m = mean(T,2); 
 
Train_Number = size(T,2);                                                  %Gives the number of columns in matrix 'T'
 
%To generate a covariance matrix by row-wise subtraction of elements in 'm' matrix from 'T' matrix
cov_mat = [];  
for i = 1 : Train_Number                                                    
    temp = double(T(:,i)) - m ;                                            %'double' used to convert to double precision value (64-bit) so as to cover large numbers
    cov_mat = [cov_mat temp]; 
end
 
%To generate an Eigen matrix for detailed comparison by generating Eigen values and vectors 
L = cov_mat' * cov_mat;
[V D] = eig(L);                                                            %Produces matrix of eigenvalues (D)[on main diagonal in matrix] and eigenvectors (V)[on respective columns] of matrix L, so that L*V = V*D
eig_mat = [];  
for i = 1 : size(V,2) 
    if( D(i,i)>1 )   
        eig_mat = [eig_mat V(:,i)];                                        %Separating Positive Eigen values from the Eigen Matrix (removing black color)
    end
end
 
%Combining the results of the covariance matrix 'cov_mat' and Eigen matrix 'eig_mat' into a 'ProjectedImages' matrix
 
Eigenfaces = cov_mat * eig_mat;                                            %To get combined result from covariance matrix 'cov_mat' and Eigen matrix 'eig_mat'
ProjectedImages = [];
Train_Number = size(Eigenfaces,2);
for i = 1 : Train_Number
    temp = Eigenfaces' * cov_mat(:,i);                                              
    ProjectedImages = [ProjectedImages temp];                               %To generate the projected matrix for all images(all in one matrix)
end
 
%Extracting data from test image through its matrix ProjectedTestImage
im = imread(TestImage);                                                     %Read test image
img = imresize(im,0.03);                                                    %Resizing image to 3% of its original size, keeping all its features intact
test_img = img;

bin = img_segment(test_img);                                                %Removal of background and generating an equivalent binary image

bin_test = bin;

[irow icol] = size(bin);                                                    %Similar operations performed as on train image
InImage = reshape(bin' , irow*icol , 1);                                       
Difference = double(InImage) - m;                                             
ProjectedTestImage = Eigenfaces' * Difference; 
 
%Forming a single row matrix 'euc_dist' which includes difference between final projected matrices of train and test images
euc_dist = [];
for i = 1 : Train_Number                                                    
    q = ProjectedImages(:,i);
    temp = ( norm( ProjectedTestImage - q ) )^2;
    euc_dist = [euc_dist temp];
end
 
display(euc_dist);
[euc_dist_min , Recognized_index] = min(euc_dist);                         %Minimum Euclidean Distance is stored in 'euc_dist_min' and its position is stored in 'Recognized_index'
OutputName = strcat(int2str(Recognized_index),'.mpo');                     %Create path/string for recognized image
SelectedImage = strcat(TrainDatabasePath,'\',OutputName);
SelectedImage = imread(SelectedImage);
SelectedImage = imresize(SelectedImage,0.03);

bin_selected = img_segment(SelectedImage);

%Displaying minimum Euclidean distance
str_eucdist = int2str(euc_dist_min);
str_eucdist = strcat('Minimum Euclidean Distance is : ',str_eucdist);
disp(str_eucdist);

%Displaying resultant output in text form
str_identgest = strcat(int2str(Recognized_index),'');
str_identgest = strcat('The identified gesture enclosed in the image is : ',str_identgest);
disp(str_identgest);

%Displaying test/input image
figure('Name','Input Colour,Grayscale & Binary Image With Output Colour Image','NumberTitle','off');
figure(1);
subplot(2,2,1);
imshow(test_img);
title('Test Image (Taken as input)');
 
%Displaying input image in colour,grayscale and binary form
figure(1);
subplot(2,2,2);
imshow(bin_test);
title('Binary Test/Input image');
figure(1);
subplot(2,2,3);
gray_test = rgb2gray(test_img);
imshow(gray_test);
title('Test/input Image in grayscale');
 
%Displaying binary images of input and output for comparison
figure('Name','Binary Input And Output Image Comparison','NumberTitle','off');
figure(2);
subplot(1,2,1);
imshow(bin_test);
title('Binary Test/Input image');
 
%Displaying equivalent output image in colour and binary form
figure(1);
subplot(2,2,4);
imshow(SelectedImage);
title('Equivalent/Train/Output Image');
 
figure(2);
subplot(1,2,2);
xlabel(str_eucdist);
imshow(bin_selected);
title('Binary Equivalent/Train/Output Image');

%Stop timer for execution time
ExecutionTime = toc

%Opening the respective application as per gesture and giving the respective text output
switch(Recognized_index)
 
    case 1   
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Excel 2010.lnk');
            display('The identified gesture enclosed in the image is : One');
            break;
            
    case 2    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Word 2010.lnk');
            display('The identified gesture enclosed in the image is : Two');
            break;
            
    case 3    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft PowerPoint 2010.lnk');
            display('The identified gesture enclosed in the image is : Three');
            break;
            
    case 4    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Paint.lnk');
            display('The identified gesture enclosed in the image is : Four');
            break;
            
    case 5    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\WordPad.lnk');
            display('The identified gesture enclosed in the image is : Five');
            break;
            
    case 6    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Windows Media Player.lnk');
            display('The identified gesture enclosed in the image is : Six');
            break;
             
    case 7    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Calculator.lnk');
            display('The identified gesture enclosed in the image is : Seven');
            break;
            
    case 8    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Mozilla Firefox.lnk');
            display('The identified gesture enclosed in the image is : Eight');
            break;
            
    case 9    
            system('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WordWeb.lnk');
            display('The identified gesture enclosed in the image is : Nine');
            break;
           
end
%gtext(str_eucdist);
%gtext(str_identgest);