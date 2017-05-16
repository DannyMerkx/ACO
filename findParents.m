function [parents] = findParents(adjacencyMatrix)
% this function finds the parents of each node and returns them in a cell
% array. 
parents={};
for i=1:size(adjacencyMatrix,1);
    temp = [];
    for j=1:size(adjacencyMatrix,1);
        if adjacencyMatrix(j,i) == 1
        temp = [temp,j];
        end
    end
    parents{i}=temp;
end