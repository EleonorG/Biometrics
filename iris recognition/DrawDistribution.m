GetFileHD = get_all_files('E:\Courses\495Biometrics\HW2\iriscode\Test\hd\');

    HD_O =cell2mat(GetFileHD(1));
    HD_S =cell2mat(GetFileHD(2));
    load(HD_S);
    load(HD_O);
 
  a = hd_self;
  b=zeros(size(a));

  for i=1:length(a)
     if a(i) ~= 0 && a(i)<=0.15
         b(i) = 0.1;
     end
      if a(i) ~= 0 && a(i)<=0.25 && a(i)>0.15
         b(i) = 0.2;
      end  
     if a(i) ~= 0 && a(i)<=0.35 && a(i)>0.25
         b(i) = 0.3;
   
     end
     if a(i) ~= 0 && a(i)<=0.45 && a(i)>0.35
         b(i) = 0.4;
     end
    if a(i) ~= 0 && a(i)<=0.55 && a(i)>0.45
         b(i) = 0.5;
    end
    if a(i) ~= 0 && a(i)<=0.65 && a(i)>0.55
         b(i) = 0.6;
    end
    if a(i) ~= 0 && a(i)<=0.75 && a(i)>0.65
         b(i) = 0.7;
    end
      if a(i) ~= 0 && a(i)<=0.85 && a(i)>0.75
         b(i) = 0.8;
      end
      if a(i) ~= 0 && a(i)<=0.95 && a(i)>0.85
         b(i) = 0.9;
      end
        if a(i) ~= 0 && a(i)<=1 && a(i)>0.95
         b(i) = 1;
        end
  end
  tb1 = tabulate(b)
  
  c=zeros(size(hd_oth)); 
    for i=1:length(hd_oth)
     if hd_oth(i) ~= 0 && hd_oth(i)<=0.15
         c(i) = 0.1;
     end
      if hd_oth(i) ~= 0 && hd_oth(i)<=0.25 && hd_oth(i)>0.15
         c(i) = 0.2;
      end  
     if hd_oth(i) ~= 0 && hd_oth(i)<=0.35 && hd_oth(i)>0.25
         c(i) = 0.3; 
     end
     if hd_oth(i) ~= 0 && hd_oth(i)<=0.45 && hd_oth(i)>0.35
         c(i) = 0.4;
     end
    if hd_oth(i) ~= 0 && hd_oth(i)<=0.55 && hd_oth(i)>0.45
         c(i) = 0.5;
    end
    if hd_oth(i) ~= 0 && hd_oth(i)<=0.65 && hd_oth(i)>0.55
         c(i) = 0.6;
    end
    if hd_oth(i) ~= 0 && hd_oth(i)<=0.75 && hd_oth(i)>0.65
         c(i) = 0.7;
    end
      if hd_oth(i) ~= 0 && hd_oth(i)<=0.85 && hd_oth(i)>0.75
         c(i) = 0.8;
      end
      if hd_oth(i) ~= 0 && hd_oth(i)<=0.95 && hd_oth(i)>0.85
         c(i) = 0.9;
      end
        if hd_oth(i) ~= 0 && hd_oth(i)<=1 && hd_oth(i)>0.95
         c(i) = 1;
        end
  end
  tb2 = tabulate(c)
  x1 = tb1(:,1);%hd_self
  y1 = tb1(:,2);
 
  x2 = tb2(:,1);%hd_others
  y2 = tb2(:,2);
  figure(1)
  plot(x1,y1,'y',x2,y2,'r');
  
  %-----ROC curve-----
 TMR=zeros(10);
 FMR=zeros(10);
  for j=1:10
      threshold = 0+j/10;
      L1=length(find(hd_self<threshold));
      TMR(j) = L1/length(hd_self);
      L2=length(find(hd_oth<threshold));
      FMR(j) = L2/length(hd_oth);
  end
  figure(2)
  plot(FMR,TMR);

  
  
  
  
