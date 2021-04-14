function R=Fuzzy(S,n) 
    F=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    %Very Low
    F([10 11 13 16 19 46 55 56 58 59 61 62 73])=0
    % Low
    F([1 2 6 7 12 14 15 17 18 20 21 22 23 24 25 26 28 29 31 32 33 34 35 37 38 40 41 43 47 48 49 50 51 52 53 57 60 63 74 75 76 77])=1
    %Med
    F([3 4 5 8 9 27 30 36 39 42 54 64 65 67 68 70 78 79 80])=2
    %High
    F([45 66 69 71 81])=3
    %Very High
    F(72)=4

    
    maxDist=0
    minDist=10000000
    maxNN=0
    minNN=10000000
    prob=1
    
    
    for i=1:1:n
        maxDist=max(maxDist,S(i).distance)
        minDist=min(minDist,S(i).distance)
        maxNN=max(maxNN,S(i).NN)
        minNN=min(minNN,S(i).NN)
    end
        
    for i=1:1:n
        energy=S(i).E
        energy=energy*2
        newEnergy=energy
        while newEnergy>=0.33
            newEnergy=newEnergy-0.33
        end
        prob=min(prob,1 - ((abs(0.165 - newEnergy))/0.165))
        energy=floor(energy/0.33)
        energy=min(energy,2)
        
        rch=S(i).Rch
        newEnergy=rch
        while newEnergy>=0.33
            newEnergy=newEnergy-0.33
        end
        prob=min(prob,1 - ((abs(0.165 - newEnergy))/0.165))
        rch=floor(rch/0.33)
        rch=min(rch,2)
        
        NN=2
        if (maxNN~=minNN)
            NN=(S(i).NN - minNN)/(maxNN - minNN)
            newEnergy=NN
            while newEnergy>=0.33
                newEnergy=newEnergy-0.33
            end
            prob=min(prob,1 - ((abs(0.165 - newEnergy))/0.165))
            NN=floor(NN/0.33)
            NN=min(NN,2)
        end
        
        dist=2
        if (maxDist~=minDist)
            dist=(S(i).distance - minDist)/(maxDist - minDist)
            newEnergy=dist
            while newEnergy>=0.33
                newEnergy=newEnergy-0.33
            end
            prob=min(prob,1 - ((abs(0.165 - newEnergy))/0.165))
            
            dist=floor(dist/0.33)
            dist=min(dist,2)
        end
        prob=prob + F(NN + 3*rch + 9*dist + 27*energy + 1)
        S(i).prob=prob
    end
    R=S
end


