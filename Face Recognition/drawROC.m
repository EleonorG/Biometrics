
  load('data.mat');
   
 %-----------genuine and imposter curve---------------
  figure(1)
  h1 = histogram(conf_self/200);
  hold on;
  h2 = histogram(conf_oth/200);
  axis([0 1 0 180]);
  set(h2,'EdgeColor','yellow');
  title('genuine and imposter distribution');
  legend([h1,h2],'genuine','imposter');
  
  %-----------------ROC curve------------------------
 TMR=zeros(10);
 FMR=zeros(10);
  for j=1:20
      threshold = 0+j/20;
      L1=length(find(conf_self/200<threshold));
      TMR(j) = L1/length(conf_self);
      L2=length(find(conf_oth/200<threshold));
      FMR(j) = L2/length(conf_oth);
  end
  figure(2)
  ROC = plot(FMR,TMR,'r');
  title('ROC Curve');
  set(ROC,'LineWidth',1);
 %------------------------CMC curve------------------
load('CMCrank.mat');
count = 0;
L = length(rank);
y2=zeros(1,L); 

for i=1:L  
    for k=1:L
       if rank(i)<=k
          count= count+1;
       end
    end
    y2(i) = count/L;
    count = 0;
end
 figure(3)
  CMC = plot(1:L,y2,'r');
  axis([1 36 0 1]);
  title('CMC Curve');
  set(CMC,'LineWidth',1);
  
  
