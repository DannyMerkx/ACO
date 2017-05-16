% path to project folder
addpath (genpath('C:\Users\Beheerder\Documents\Computational Neuroscience\Theoretical Foundations\ACO'))
reward=30;
iterations=50;
params=[1,1,1;0,1,1;1,1,0;1,40,1];

for i=1:size(params,1)
    for j=1:5
    [k2Progress,k2BestProgress,bestNet]= main(data(1:3000,:),params(i,:),0,0,reward,iterations);
    k2(j)={k2Progress};
    k2best(j)={k2BestProgress};
    net(j)={bestNet};
    end
    Results{i}={k2,k2best,net};
end

for i=1:size(params,1)
    for j=1:5
    [k2Progress,k2BestProgress,bestNet]= main(data(1:3000,:),params(i,:),0,1,reward,iterations);
    k2(j)={k2Progress};
    k2best(j)={k2BestProgress};
    net(j)={bestNet};
    end
    Results_elitist{i}={k2,k2best,net};
end

for i=1:size(params,1)
    for j=1:5
    [k2Progress,k2BestProgress,bestNet]= main(data(1:3000,:),params(i,:),1,reward,iterations);
    k2(j)={k2Progress};
    k2best(j)={k2BestProgress};
    net(j)={bestNet};
    end
    Results_minmax{i}={k2,k2best,net};
end

for i=1:size(params,1)
    for j=1:5
    [k2Progress,k2BestProgress,bestNet]= main(data(1:3000,:),params(i,:),1,reward,iterations);
    k2(j)={k2Progress};
    k2best(j)={k2BestProgress};
    net(j)={bestNet};
    end
    Results_elitist_minmax{i}={k2,k2best,net};
end

for j=1:4
    for i=1:5
        k2Max(i,j)= max(Results{j}{1}{i});
    end
    max_(j) = max(k2Max(:,j));
    avg_(j) = mean(k2Max(:,j));
end


for j=1:4
    for i=1:5
        k2Max_elitist(i,j)= max(Results_elitist{j}{1}{i});
    end
    max_elitist(j)=max(k2Max_elitist(:,j));
    avg_elitist(j) = mean(k2Max_elitist(:,j));
end

for j=1:4
    for i=1:5
        k2Max_minmax(i,j)= max(Results_minmax{j}{1}{i});
    end
    max_minmax(j)=max(k2Max_minmax(:,j));
    avg_minmax(j) = mean(k2Max_minmax(:,j));
end

for j=1:4
    for i=1:5
        k2Max_elitist_minmax(i,j)= max(Results_elitist_minmax{j}{1}{i});
    end
    max_elitist_minmax(j)= max(k2Max_elitist_minmax(:,j));
    avg_elitist_minmax(j) = mean(k2Max_elitist_minmax(:,j));
end
