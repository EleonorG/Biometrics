
GetFileLeft = get_all_files('E:\Courses\495Biometrics\HW2\iriscode\Test\left\');
GetFileRight = get_all_files('E:\Courses\495Biometrics\HW2\iriscode\Test\right\');
GetFileProbe = get_all_files('E:\Courses\495Biometrics\HW2\iriscode\Test\LG4000-2010-04-27_29\');
hd_self=[];
hd_oth=[];
x=1;
y=1;
leftcount=0;
rightcount=0;
ii=1;  
for i=1:35
   
    filenameP=cell2mat(GetFileProbe(i));

    if filenameP(end-2:end) == 'txt'
       
        %Decide left eye or right eye
        Eye=[]; %record the eyes in images are left eye or right eye
        j=1;
        ii=1;
        leftcount=0;
        rightcount=0;
        L='eye	string	Left';
        R='eye	string	Right';
        fid=fopen(filenameP,'r');
        while 1
            tline = fgetl(fid);
            if tline == -1
                break;
            end
            
            if strcmp(tline,L) %0 means left eye
                Eye(j)=0;
                j=j+1;
            end
            if strcmp(tline,R) %1 means right eye
                Eye(j)=1;
                j=j+1;
            end
        end
        fclose(fid);
    end
    if filenameP(end-3:end)=='tiff'
        if leftcount<2 || rightcount<2   %choose 2 left eye images and 2 right eye images of one person as probe
            if Eye(ii)==0 && leftcount<2
                [template2, mask2] = createiristemplate(filenameP);
%                 a = strcat(filenameP(end-14:end-5),'Temp.mat');
%                 b = strcat(filenameP(end-14:end-5),'Mask.mat');
%                 save([strcat(filenameP(1:end-15),'left\'),a],'template2');
%                 save([strcat(filenameP(1:end-15),'left\'),b],'mask2');
                leftcount=leftcount+1;
                 for n=1:2:length(GetFileLeft)-1
                     filenameLM=cell2mat(GetFileLeft(n));
                     filenameLT=cell2mat(GetFileLeft(n+1));
                     load(filenameLM);    %load left eye's template in gallery (as template1)
                     load(filenameLT);    %load left eye's mask in gallery (as mask1)
                    if filenameP(70:76)==filenameLM(48:54)
                        hd_self(x) = gethammingdistance(template1, mask1, template2, mask2, 10);  %if the eye images are from the same person (probe is true)
                        x=x+1;
                    else
                        hd_oth(y) = gethammingdistance(template1, mask1, template2, mask2, 10);    %if the eye images are not from the same person 
                        y=y+1;
                    end
                    
                 end
            end
            if Eye(ii)==1 && rightcount<2
                [template2, mask2] = createiristemplate(filenameP);
%                 a = strcat(filenameP(end-14:end-5),'Temp.mat');
%                 b = strcat(filenameP(end-14:end-5),'Mask.mat');
%                 save([strcat(filenameP(1:end-15),'right\'),a],'template2');
%                 save([strcat(filenameP(1:end-15),'right\'),b],'mask2');
                rightcount=rightcount+1;
                 for n=1:2:length(GetFileRight)-1
                     filenameRM=cell2mat(GetFileRight(n));
                     filenameRT=cell2mat(GetFileRight(n+1));
                     load(filenameRM);   %load right eye's template in gallery (as template1)
                     load(filenameRT);    %load right eye's template in gallery (as mask1)
                    if filenameP(70:76)==filenameRM(49:55)
                        hd_self(x) = gethammingdistance(template1, mask1, template2, mask2, 10);
                        x=x+1;
                    else
                        hd_oth(y) = gethammingdistance(template1, mask1, template2, mask2, 10);
                        y=y+1;
                    end
                  
                 end
            end
            ii=ii+1;
        end

    end
end
 save(['E:\Courses\495Biometrics\HW2\iriscode\Test\hd\','hd_self'],'hd_self');
 save(['E:\Courses\495Biometrics\HW2\iriscode\Test\hd\','hd_others'],'hd_oth');
 
 
 
