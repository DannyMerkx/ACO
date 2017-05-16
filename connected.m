function [bool] = connected(adjacencyMatrix)
% this function checks if the network is connected, i.e. all nodes (of the
% equivalent undirected graph)are reachable from all other nodes in a finite 
% number of steps. 
x=adjacencyMatrix;
x=x+x';
y=x;
z=x;
for i=1:size(x,1)
    y=y*x;
    z=z+y;
end

bool=~ismember(0,z);
