function isValid = checkSolution(network)
% this function takes an adjacency matrix and checks whether it is
% a valid network structure, i.e. whether it is an acyclic network. A net
% A is acyclic if for A^(1:netsize) all diagonals are 0.
networkSize= size(network,1);
isValid = true;
tempNetwork = network;
for i=2:networkSize
   tempNetwork = tempNetwork*network; 
   if trace(tempNetwork) ~=0
       isValid=false;
       break
   end
end