function [k2Progress,k2BestProgress,bestNet]= main(data,params,minmaxSystem,eliteSystem,reward,nIterations)

% number of ants
nAnts = 4;
% in params, the values indicate the weights of the least invalidated
% moves heuristic, the pheromones and the k2 score respectively.

% number of nodes in the net
nNodes=size(data,2);
% initialise the empty adjacency matrix
adjacencyMatrix = zeros(nNodes,nNodes);
% make the list of all possible edges. This list also keeps track of the
% pheromones on each edge.
possibleEdges = [];
for i=1:nNodes
    for j=1:nNodes
           possibleEdges=[possibleEdges;[i,j,1]];
    end
end

% the lines above create all possible edges, we need an initial pruning
% round to remove edges from a node to itself
possibleEdges= removeInvalid(possibleEdges,adjacencyMatrix);
% initialise the desirability list
desirability = ones(size(possibleEdges,1),1);
%optional min-max and elitist ant system. set to 0 to use the normal ant
%system.
if minmaxSystem ==1   
    minmax=[1,100];
else
    minmax=[];
end
if eliteSystem==1
    elitist{1}=1;
    elitist{2}=adjacencyMatrix;
else 
    elitist{1}=0;
    elitist{2}=adjacencyMatrix;
end
% if prefSimple is true the K2 score is divided by the number of edges as a
% penalty to more complex networks.
prefSimple = true;

decay =0.95;
bestNet= adjacencyMatrix;
bestK2Score=-999999;
k2Progress=[];
k2BestProgress=[];

for j=1:nIterations
    j
    parfor i=1:nAnts
        [networks{i},k2score(i)]=runAnt(data,params,desirability,adjacencyMatrix,possibleEdges,prefSimple);
    end
    if elitist{1}==1
        elitist{2}=bestNet;
    end 
    [k2score,k2bestIndex]=max(k2score);
    
    Net= networks{k2bestIndex};   
    [Net,k2score]=localSearch(Net,k2score,data,prefSimple);
    [possibleEdges] = pheromoneUpdate (possibleEdges,Net,decay,reward,minmax,elitist);    
    
    if k2score >= bestK2Score
        bestK2Score=k2score;
        bestNet=Net;
    end
    k2Progress=[k2Progress,k2score];
    k2BestProgress=[k2BestProgress,bestK2Score];
end

plot(k2Progress)