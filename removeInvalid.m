function [possibleEdges] = removeInvalid(possibleEdges,adjacencyMatrix)
% this function takes the list of edges and removes those that are invalid,
% i.e. adding them to the adjacency matrix would result in a cycle. 
nEdges= size(possibleEdges,1);

i=1;
while i<=nEdges
    adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=1;
    if ~checkSolution(adjacencyMatrix) 
        adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=0;
        possibleEdges(i,:)=[];
        nEdges=nEdges-1;
    else
        adjacencyMatrix(possibleEdges(i,1),possibleEdges(i,2))=0;
         i=i+1;
    end
end
