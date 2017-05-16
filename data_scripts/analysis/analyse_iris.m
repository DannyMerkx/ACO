load('C:\Users\Beheerder\Documents\Computational Neuroscience\Theoretical Foundations\data scripts\iris_results')
for i = 1:4
    for j=1:20
        x1(i,j)= max(Results{i}{1}{j});
    end
end

for i = 1:4
    for j=1:20
        x2(i,j)= max(Results_elitist{i}{1}{j});
    end
end

for i = 1:4
    for j=1:20
        x3(i,j)= max(Results_minmax{i}{1}{j});
    end
end

for i = 1:4
    for j=1:20
        x4(i,j)= max(Results_elitist_minmax{i}{1}{j});
    end
end

x= [x1;x2;x3;x4];

xx=[];
xy=zeros(2,320);
for i=1:16
    xx=[xx,x(i,:)];
    if i<5
       xy(1,((i-1)*20)+1:i*20)=1;
    elseif i>4 && i<9 
       xy(1,((i-1)*20)+1:i*20)=2;
    elseif i>8 && i<13
        xy(1,((i-1)*20)+1:i*20)=3;
    else 
        xy(1,((i-1)*20)+1:i*20)=4;
    end
    
    if mod(i,4)==0
        xy(2,((i-1)*20)+1:i*20)=4;
    elseif mod(i,3)==0
       xy(2,((i-1)*20)+1:i*20)=3;
    elseif mod(i,2)==0
       xy(2,((i-1)*20)+1:i*20)=2;
    else 
        xy(2,((i-1)*20)+1:i*20)=1;
    end
end

y=kruskalwallis(xx,xy(1,:));
z=kruskalwallis(xx,xy(2,:));

