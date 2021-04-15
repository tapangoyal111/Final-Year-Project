function Stat=round(S)
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

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    S=KMean(S,n);

    h=1;
    countCHs=0;  %variable, counts the cluster head
    cluster=1;  %cluster is initialized as 1
    flag_first_dead=0; %flag tells the first node dead
    flag_half_dead=0;  %flag tells the 10th node dead
    flag_all_dead=0;  %flag tells all nodes dead
    first_dead=0;
    half_dead=0;
    all_dead=0;
    allive=n;
    %counter for bit transmitted to Bases Station and to Cluster Heads
    packets_TO_BS=0;
    packets_TO_CH=0;
    packets_TO_BS_per_round=0;

    for r=0:1:rmax
        r
        dead=0;
        packets_TO_BS_per_round=0;
        cluster=1;
        for i=1:1:n
            %checking if there is a dead node
            if (S(i).E<=0)
                %plot(S(i).xd,S(i).yd,'red .');
                S(i).E=0;
                dead=dead+1;
                if (dead==1)
                  if(flag_first_dead==0)
                     first_dead=r;
                     flag_first_dead=1;
                  end
                end
                if(dead==0.5*n)
                  if(flag_half_dead==0)
                      half_dead=r;
                      flag_half_dead=1;
                  end
                end
                if(dead==n)
                  if(flag_all_dead==0)
                      all_dead=r;
                      flag_all_dead=1;
                  end
                end

                %hold on;
            end
            if S(i).E>0
                S(i).type='N';
                S(i).Rch=min(S(i).Rch + 0.2 ,1);
                S(i).NN=0;
            end
        end

            %plot(S(n+1).xd,S(n+1).yd,'x');
            STATISTICS.DEAD(h,r+1)=dead;
            STATISTICS.ALLIVE(h,r+1)=allive-dead;


      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      % Fuzzy calculation
      % calculate S(i).prob

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        for i=1:1:n
            for j=i+1:1:n
                if i~=j
                    if sqrt((S(i).xd - S(j).xd)^2 + (S(i).yd - S(j).yd)^2)<=threshhold
                        S(i).NN=S(i).NN + 1;
                        S(j).NN=S(j).NN + 1;
                    end
                end
            end
        end


        S=Fuzzy(S,n);


        %Find CHs
        for c=1:1:no_of_clusters
            CurProb=0;
            CurId=1;
            for i=1:1:n
                if(S(i).cat==c && S(i).prob>CurProb)
                    CurId = i;
                    CurProb=S(i).prob;
                end
            end

            packets_TO_BS=packets_TO_BS+1;
            packets_TO_BS_per_round=packets_TO_BS_per_round+1;
            PACKETS_TO_BS(r+1)=packets_TO_BS;

            S(CurId).type='C';
            S(CurId).Rch=0;
            C(c).xd=S(CurId).xd;
            C(c).yd=S(CurId).yd;
            distance=sqrt( (S(CurId).xd-(S(n+1).xd) )^2 + (S(CurId).yd-(S(n+1).yd) )^2 );
            
            C(c).distance=distance;
            C(c).id=i;
            X(c)=S(i).xd;
            Y(c)=S(i).yd;
            cluster=cluster+1;

            if (distance>do)
                S(CurId).E=S(CurId).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance ));
            end
            if (distance<=do)
                S(CurId).E=S(CurId).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance ));
            end
        end

        STATISTICS.COUNTCHS(h,r+1)=countCHs;


        %Election of Associated Cluster Head for Normal Nodes
        for i=1:1:n
           if ( S(i).type=='N' && S(i).E>0 )
                if(cluster-1>=1)
                min_dis=100000000;
                min_dis_cluster=0;
                for c=1:1:cluster-1
                    temp=sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 );
                    if ( temp<min_dis )
                        min_dis=temp;
                        min_dis_cluster=c;
                    end
                 end
           %Calculating the culsterheads%
               if(min_dis_cluster~=0)    
                    min_dis;
                    if (min_dis>do)
                        S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
                    end
                    if (min_dis<=do)
                        S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
                    end

                    S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 ); 
                    packets_TO_CH=packets_TO_CH+1;
                else 
                    min_dis;
                    if (min_dis>do)
                        S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
                    end
                    if (min_dis<=do)
                        S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
                    end
                    packets_TO_BS=packets_TO_BS+1;
                    packets_TO_BS_per_round=packets_TO_BS_per_round+1;
                    PACKETS_TO_BS(r+1)=packets_TO_BS;
               end
               S(i).min_dis=min_dis;
               S(i).min_dis_cluster=min_dis_cluster;
            else
                min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
                if (min_dis>do)
                    S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
                end
                if (min_dis<=do)
                    S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
                end
                packets_TO_BS=packets_TO_BS+1;
                packets_TO_BS_per_round=packets_TO_BS_per_round+1;

                end
           end
        end


        STATISTICS.PACKETS_TO_CH(h,r+1)=packets_TO_CH;
        STATISTICS.PACKETS_TO_BS(h,r+1)=packets_TO_BS;
        STATISTICS.PACKETS_TO_BS_PER_ROUND(h,r+1)=packets_TO_BS_per_round;
        STATISTICS.THROUGHPUT(h,r+1)=STATISTICS.PACKETS_TO_BS(h,r+1)+STATISTICS.PACKETS_TO_CH(h,r+1);

         En=0;
        for i=1:n
            if S(i).E<=0
                continue;
            end
            En=En+S(i).E;
        end
        ENERGY(r+1)=En;
        STATISTICS.ENERGY(h,r+1)=En;

    end

    first_dead_LEACH(h)=first_dead
    half_dead_LEACH(h)=half_dead
    all_dead_LEACH(h)=all_dead

    

    for r=0:rmax
        STATISTICS.DEAD(h+1,r+1)=sum(STATISTICS.DEAD(:,r+1))/h;
        STATISTICS.ALLIVE(h+1,r+1)=sum(STATISTICS.ALLIVE(:,r+1))/h;
        STATISTICS.PACKETS_TO_CH(h+1,r+1)=sum(STATISTICS.PACKETS_TO_CH(:,r+1))/h;
        STATISTICS.PACKETS_TO_BS(h+1,r+1)=sum(STATISTICS.PACKETS_TO_BS(:,r+1))/h;
        STATISTICS.PACKETS_TO_BS_PER_ROUND(h+1,r+1)=sum(STATISTICS.PACKETS_TO_BS_PER_ROUND(:,r+1))/h;
        STATISTICS.THROUGHPUT(h+1,r+1)=sum(STATISTICS.THROUGHPUT(:,r+1))/h;
        STATISTICS.COUNTCHS(h+1,r+1)=sum(STATISTICS.COUNTCHS(:,r+1))/h;
        STATISTICS.ENERGY(h+1,r+1)=sum(STATISTICS.ENERGY(:,r+1))/h;
    end

    first_dead=sum(first_dead_LEACH)/h;
    half_dead=sum(half_dead_LEACH)/h;
    all_dead=sum(all_dead_LEACH)/h;

    %{
    figure(11)
    warning('OFF');
    [vx,vy]=voronoi(X(:),Y(:));
    plot(X,Y,'r+',vx,vy,'m-');
    %hold on;
    voronoi(X,Y);
    axis([10 xm 0 ym]);
    %}
    Stat=STATISTICS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
    