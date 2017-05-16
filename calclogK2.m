function [k2score] = calclogK2(data, adjacencyMatrix,node)
% this function calculates the decomposable k2 score, e.g. only the 
% k2 score of the node that got a new parent is recalculated.

% get a list of the nodes parents
parents = findParents(adjacencyMatrix);

for i = 1:size(data,2)
    nAssignments(i)=size(unique(data(:,i)),1);
end

% this gets a list of all the possible assignments to a nodes parent
% nodes. We need both the number of possible assignments and the
% assignments to calculate k2.
nAssignmentsParents = assignmentsToParents (parents, nAssignments,data);

% Naming of variables gets a bit messy here. The K2 formula as seen in Korb
% & Nicholsons book bayesian artificial intelligence has 3 products, I
% have named intermediate results Inner , Middle and OuterProd
% respectively. 

    % no scoring for parentless nodes
    if ~(parents{node}==0)
    MiddleProd=0;
    %loop over all assignments for the parents of node k
    for j=1:size(nAssignmentsParents{node},2)
        % count the number of times the assignment j to the parent nodes is
        % present in the data
        jassignmentToParents = countOccurence(data,parents{node},nAssignmentsParents{node}(j,:));
        
        InnerMostProd=0;
        % loop over all assignments possible to node k
        for l = 1: nAssignments(node)
            % count how many times assignment l to node k is present in the
            % data in combination with assignment j to the parents of node
            % k.
            lassignmentToNode = countOccurence(data,[parents{node},node],[nAssignmentsParents{node}(j,:),l]);
            % the product of this count over all assignments to node k
            InnerMostProd = InnerMostProd+logfact(lassignmentToNode);
        end
        temp= (logfact(nAssignments(node)-1)-logfact(jassignmentToParents+nAssignments(node)-1))+InnerMostProd;
        MiddleProd= MiddleProd+temp;
    end
        k2score=MiddleProd;
    
    else 
        k2score=0;
    end
    
   % the K2 as calculated here is a K2 score proportional to a uniform
   % prior. 


