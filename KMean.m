
function R=KMean(S,n)

centroid=10;

centroidArr=S(1:centroid);
round=0
while round<200
    for i=1:1:n
        dist=100000000000;
        for j=1:1:centroid
            now=(S(i).xd - (centroidArr(j).xd) )^2 + (S(i).yd-(centroidArr(j).yd) )^2;
            if dist>now
                dist=min(dist,now);
                S(i).cat=j;
            end
        end
    end
    count=[0 0 0 0 0 0 0 0 0 0];
    for j=1:1:centroid
        centroidArr(j).xd=0;
        centroidArr(j).yd=0;
    end

    for i=1:1:n
        centroidArr(S(i).cat).xd=centroidArr(S(i).cat).xd + S(i).xd;
        centroidArr(S(i).cat).yd=centroidArr(S(i).cat).yd+S(i).yd;
        count(S(i).cat)=count(S(i).cat)+1;
    end

    for j=1:1:centroid
        if count(j)>0
            centroidArr(j).xd=centroidArr(j).xd/count(j);
            centroidArr(j).yd=centroidArr(j).yd/count(j);
        end
    end
round=round+1
count
    
end
R=S
end
    
    
    
    

        
        