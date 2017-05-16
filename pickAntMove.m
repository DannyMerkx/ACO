function [move] = pickAntMove (params,desirability,possibleEdges,adjacencyMatrix,data,k2Score)
    % this function decides which edge the ant picks.
    
    %calculate k2score of each edge if it were added to the graph
    for i = 1:size(possibleEdges,1)
        adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=1;
        K2(i) =calclogK2(data, adjacencyMatrix,possibleEdges(i,2))-k2Score(possibleEdges(i,2));
        adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=0;   
    end
    
    % normalise the k2 and pheromones. If values for all
    % edges are the same the score for each one should be 1(otherwise the ant
    % cannot pick a move due to cumsum of the probabilities being 0).
    if max(K2)~=min(K2)
        K2=(K2-min(K2))/(max(K2)-min(K2));
    else 
        K2(:)=1;
    end
    
    pheromones= possibleEdges(:,3);
    if max(pheromones)~=min(pheromones)
        pheromones=(pheromones-min(pheromones))/(max(pheromones)-min(pheromones));   
    else 
        pheromones(:)=1;
    end
    
    % combine the 3 scores. We divide for desirability as a higher
    % score makes the move less desirable. 
    moveProb=zeros(size(possibleEdges,1),1);
    for i = 1:size(possibleEdges,1)
        moveProb(i)= ((params(1)/desirability(i))+(pheromones(i)*params(2))+(K2(i)*params(3)));
    end
    
    %+ (K2(i)*params(3))
    
    % create a cumsum that adds to 1. This is used to select a move in
    % combination with a random nr between 0 and 1
%     randomnr = rand;
%     if randomnr > 0.8
%         [x,move]= max(moveProb);
%     else
%     
    moveProb=cumsum(moveProb/ sum(moveProb));
   
    randomnr= rand;
    move=0;
    for i =1:size(moveProb,1)
        if randomnr <= moveProb(i)
            move = i;
            break
        end
    end
%     end
%     
    if move == 0 
        x='kankerkutteringtyfuskutzooi'
    end
    