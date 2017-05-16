function [network,k2Score] = runAnt (data,params,desirability,adjacencyMatrix,possibleEdges,prefSimple)

k2Score =zeros(size(adjacencyMatrix,1),1);

while(size(possibleEdges,1)>0)  
    % have the ant pick a move
    if (size(possibleEdges,1)>1)
        index = pickAntMove(params,desirability,possibleEdges,adjacencyMatrix,data,k2Score);
        move = possibleEdges (index,:);
    else 
        index = 1;
        move = possibleEdges(index,:);
    end
        
    % if the network is not yet connected, any move picked by the ant will
    % be accepted. Once it is connected it will only accept moves that
    % further improve the k2 score. 
    if connected(adjacencyMatrix)
        netsize=sum(sum(adjacencyMatrix));
        adjacencyMatrix(move(1),move(2))=1;        
        tempk2 = k2Score;
        tempk2(move(2)) = calclogK2(data,adjacencyMatrix,move(2));
        tempk2 = sum(tempk2)/netsize+1;        
        if  tempk2 < sum(k2Score)/netsize
            adjacencyMatrix(move(1),move(2))=0;
           
        end
    else
        adjacencyMatrix(move(1),move(2))=1;
    end   
    % fill the move in in the adjacency matrix  calculate the new
    % networks k2 score and remove the move from the possible edges
    %k2score = calclogK2(data,adjacencyMatrix,prefSimple);
    possibleEdges(index,:)=[];
    k2Score(move(2))= calclogK2(data,adjacencyMatrix,move(2));
    % update the possible edges and desirability.
    possibleEdges= removeInvalid(possibleEdges,adjacencyMatrix);
    desirability = calcDesirability(possibleEdges,adjacencyMatrix);
    
end

if prefSimple == true
    k2Score=sum(k2Score)/sum(sum(adjacencyMatrix));
else 
    k2Score=sum(k2Score);
end

network= adjacencyMatrix;
