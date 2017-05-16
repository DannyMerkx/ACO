function [desirability] = calcDesirability (possibleEdges, adjacencyMatrix)
% this function calculates the least invalidated future moves heuristic.
% this is done by going through all the moves, hypothetically making those
% moves and checking how many of the other moves have now become
% inpossible. The higher this score, the less desirable a move becomes.
nEdges= size(possibleEdges,1);
% desirability starts at one, as a move always invalidates at least itself
desirability= ones(nEdges,1);

%check for each node if it has parents  or children  this can
%be used to skip some cyclicity checks.
hasParents=zeros(size(adjacencyMatrix,1),1);
hasChildren=zeros(size(adjacencyMatrix,1),1);
for i=1:size(adjacencyMatrix,1)
    hasParents(i)=sum(adjacencyMatrix(:,i));
    hasChildren(i)=sum(adjacencyMatrix(i,:));
end

for i=1:nEdges    
    adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=1;
    tempPossibleEdges = possibleEdges;
    tempPossibleEdges(i,:)=[];
    for j=1:nEdges-1      
        % for efficiency, if the outgoing node has no parents or the incoming node has no
        % children adding the edge cannot create a cycle. 
        if hasParents(tempPossibleEdges(j,1))~=0 || hasChildren(tempPossibleEdges(j,2))~=0
            adjacencyMatrix(tempPossibleEdges(j,1),tempPossibleEdges(j,2))=1;        
            if ~checkSolution(adjacencyMatrix) 
                desirability(i)=desirability(i)+1;
            end
            adjacencyMatrix(tempPossibleEdges(j,1),tempPossibleEdges(j,2))=0;
        end
    end
    adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=0;
end


