function [adjacencyMatrix,k2score] = localSearch(adjacencyMatrix,k2score,data,prefSimple)



while true
netSize=sum(sum(adjacencyMatrix));
K2=[];
count=1;
for i=1:size(adjacencyMatrix,1)
    for j=1:size(adjacencyMatrix,1)
        if adjacencyMatrix(i,j)==1
            globalK2 = sum(k2score)/netSize;
            adjacencyMatrix(i,j)=0;
            tempk2 = k2score;
            tempk2(j) = calclogK2(data,adjacencyMatrix,j);
            temp = sum(tempk2)/netSize+1;
            if connected(adjacencyMatrix) &&  temp >= globalK2
                K2(count,1) = i;
                K2(count,2) = j;
                K2(count,3) = abs(abs(temp)-abs(globalK2));
                count=count+1;
            end
            adjacencyMatrix(i,j)=1;
            
        end               
    end
end

if ~isempty(K2)
[m,index] = max(K2(:,3));
adjacencyMatrix(K2(index,1),K2(index,2))=0;
k2score = tempk2;
else
    break
end
end
for i=1:size(adjacencyMatrix)
    k2score(i)= calclogK2(data,adjacencyMatrix,i);
end
k2score= sum(k2score)/sum(sum(adjacencyMatrix));