
xm=300;
ym=300;
sink.x=0.5*xm;
sink.y=0.5*ym;
sink.x=100;
sink.y=75;

n=200;
no_of_clusters=10;
p=0.1;
threshhold=xm*0.1;
Eo=0.5;
ETX=50*0.000000001;
ERX=50*0.000000001;
Efs=10e-12;
Emp=0.0013e-12;
EDA=5*0.000000001;
rmax=1000;
do=sqrt(Efs/Emp);
Et=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for h=1:1
    S(n+1).xd=sink.x;
    S(n+1).yd=sink.y;
    Et=0;
end    

for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    S(i).Rch=1
    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
    S(i).distance=distance;
    S(i).G=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    S(i).E=Eo;
    Et=Et+S(i).E;
    figure(h*10)
      plot(S(i).xd,S(i).yd,'bo');
      text(S(i).xd+1,S(i).yd-0.5,num2str(i));
      hold on;
end

plot(S(n+1).xd,S(n+1).yd,'o', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
text(S(n+1).xd+1,S(n+1).yd-0.5,num2str(n+1));
hold off ;

Stat1=modified_leach(S)
Stat2=round(S)

h=1    
r=0:rmax;


figure(1)
hold on;
plot(r,Stat1.DEAD(h+1,r+1));
plot(r,Stat2.DEAD(h+1,r+1));
title('Dead Nodes')
legend("simple Leach","Proposed algorithm")
hold off;

figure(12)
hold on;
plot(r,Stat1.ALLIVE(h+1,r+1));
plot(r,Stat2.ALLIVE(h+1,r+1));
legend("simple Leach","Proposed algorithm")
title('Live Nodes')
hold off;

figure(3)
hold on;
plot(r,Stat1.PACKETS_TO_BS(h+1,r+1));
plot(r,Stat2.PACKETS_TO_BS(h+1,r+1));
legend("simple Leach","Proposed algorithm")
title('pkts to BS')
hold off;

figure(4)
hold on;
plot(r,Stat1.PACKETS_TO_BS_PER_ROUND(h+1,r+1));
plot(r,Stat2.PACKETS_TO_BS_PER_ROUND(h+1,r+1));
title('pkts to BS per round')
legend("simple Leach","Proposed algorithm")
hold off;

figure(5)
hold on;
plot(r,Stat1.PACKETS_TO_CH(h+1,r+1));
plot(r,Stat2.PACKETS_TO_CH(h+1,r+1));
legend("simple Leach","Proposed algorithm")
title('pkts to CH')
hold off;

figure(6)
hold on;
plot(r,Stat1.THROUGHPUT(h+1,r+1));
plot(r,Stat2.THROUGHPUT(h+1,r+1));
legend("simple Leach","Proposed algorithm")
title('THROUGHPUT')
hold off;

figure(7)
hold on;
plot(r,Stat1.COUNTCHS(h+1,r+1));
plot(r,Stat2.COUNTCHS(h+1,r+1));
legend("simple Leach","Proposed algorithm")
title('COUNTCHS')
hold off;

figure(8)
hold on;
plot(r,Stat1.ENERGY(h+1,r+1));
plot(r,Stat2.ENERGY(h+1,r+1));
legend("simple Leach","Proposed algorithm")
title('Average Residual Energy') 
hold off;

