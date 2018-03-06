
%compute template and mask of gallery
GetFile = get_all_files('E:\Courses\495Biometrics\HW2\iriscode\Test\LG2200-2008-03-11_13\');
length(GetFile)
leftcount=0;
rightcount=0;
ii=1;
for i=456:468
   
    filename=cell2mat(GetFile(i));
   
    if filename(end-2:end) == 'txt'
       
        %Decide left eye or right eye
        Eye=[];
        j=1;
        ii=1;
        leftcount=0;
        rightcount=0;
        L='eye	string	Left';
        R='eye	string	Right';
        fid=fopen(filename,'r');
        while 1
            tline = fgetl(fid);
            if tline == -1
                break;
            end
            
            if strcmp(tline,L) %0 means left
                Eye(j)=0;
                j=j+1;
            end
            if strcmp(tline,R) %1 means right
                Eye(j)=1;
                j=j+1;
            end
        end
        fclose(fid);
    end
    if filename(end-3:end)=='tiff'
        if leftcount<2 || rightcount<2  %consider 2 left eye images and 2 right eye images of one person in gallery
            if Eye(ii)==0 && leftcount<2
                [template1, mask1] = createiristemplate(filename);
                a = strcat(filename(70:76),sprintf('%dTemp.mat',ii)); %filename of template eg."02463d1Temp"means the Template of the first image of person 02463
                b = strcat(filename(70:76),sprintf('%dMask.mat',ii));
                save(['E:\Courses\495Biometrics\HW2\iriscode\Test\left\',a],'template1');
                save(['E:\Courses\495Biometrics\HW2\iriscode\Test\left\',b],'mask1');
                leftcount=leftcount+1;
            end
            if Eye(ii)==1 && rightcount<2
                [template1, mask1] = createiristemplate(filename);
                a = strcat(filename(70:76),sprintf('%dTemp.mat',ii));
                b = strcat(filename(70:76),sprintf('%dMask.mat',ii));
                save(['E:\Courses\495Biometrics\HW2\iriscode\Test\right\',a],'template1');
                save(['E:\Courses\495Biometrics\HW2\iriscode\Test\right\',b],'mask1');
                rightcount=rightcount+1;
            end
            ii=ii+1;
        end
                
    end
end
