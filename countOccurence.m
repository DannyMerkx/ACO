function [count] = countOccurence(data, nodes, nodeAssignments)
% given data, a list of nodes and their assignments, this function counts
% how many times this combination of assignments occurs in the data.
count=0;
for j=1:size(data,1)
    isObservation= true;
    for i=1:size(nodes,2)
        if ~(data(j,nodes(i)) == nodeAssignments(i))
            isObservation=false;
        end
    end
    if isObservation == true
        count = count+1;
    end
end
        