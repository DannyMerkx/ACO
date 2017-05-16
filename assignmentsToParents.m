function [nAssignmentsParents] = assignmentsToParents (parents, nAssignments,data)
% this function returns all possible joint assignments to a nodes parents,
% which is necessary to calculate K2.

for i= 1:size(data,2)
    if ~isempty(parents{i})
       for a=1:size(parents{i},2)
           x{1}(a)= nAssignments(parents{i}(a));
       end
       AssignmentsParents(i)=x;
    else 
       AssignmentsParents(i)={0};
    end
end

% create a vector for each parent containing its possible assignments
% and then find all combinations of these vectors.
for i =1:size(AssignmentsParents,2)
    if ~(AssignmentsParents{i} == 0)
        for j =1:size(AssignmentsParents{i},2)
            for k=1:AssignmentsParents{i}(j)
                vec(k) =k;
            end
            vecs(j)={vec};
        end
        
        nAssignmentsParents{i}=combinations(vecs{:});
    else
        nAssignmentsParents{i}=0;
    end
end
