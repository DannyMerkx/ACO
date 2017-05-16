function [possibleEdges] = pheromoneUpdate (possibleEdges,network,decay,reward,minmax,elitist)
% this function updates the pheromones and also returns the best network
% found by the ants and its K2 score. Optional is a min and max on the
% pheromones, this created a min-max ant system.

[nRows,nCols]=size(network);

% all the edges included in the best network
update= [];
for i =1:nRows
    for j=1:nCols
        if network(i,j)==1
            update = [update;i,j];
        end
    end
end

% for an elitist ant system the global best network receives pheromones at
% each update. To do this, we just add the edges of the global best to the
% update set.
if elitist{1}==1
    updateElitist= [];
    for i =1:nRows
        for j=1:nCols
            if elitist{2}(i,j)==1
                updateElitist = [updateElitist;i,j];
            end
        end
    end
    if ~isempty(updateElitist)
    x=ismember(updateElitist,update,'rows');
        for i=1:size(x,1)
            if x == 0
                update=[update;updateElitist(i,1),updateElitist(i,2)];
            end
        end
    end
end

% update phermones, either by minmax or normal ant system rules.
if minmax~=0
    x = ismember(possibleEdges(:,1:2),update,'rows');
    
    for i=1:size(possibleEdges,1)
        if x(i)==1 && possibleEdges(i,3) < minmax(2)
            possibleEdges(i,3)=possibleEdges(i,3)+1;
        elseif x(i)==0 && possibleEdges(i,3) <minmax(1)
            possibleEdges(i,3)=minmax(1);
        elseif x(i)==0
            possibleEdges(i,3)=possibleEdges(i,3)*decay;
        end
    end
else 
    x = ismember(possibleEdges(:,1:2),update,'rows');
    for i=1:size(possibleEdges,1)
        if x(i)==1 
            possibleEdges(i,3)=possibleEdges(i,3)+reward/sum(sum(network));
        else
            possibleEdges(i,3)=possibleEdges(i,3)*decay;
        end
    end
end