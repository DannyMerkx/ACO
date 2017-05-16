function [discrdata] = discretiseData(data,types,nBins,varNames);
% this function discretises data by binning it, and converting strings to
% categorical numbers. 
[nrows,ncols]= size(data);

count=1;
for i=1:ncols
    if types(i)==1
        for j=1:nrows
            temp(j,1)=data{j,i};
        end
        range = max(temp)-min(temp);
        edges = min(temp)+((0:nBins(i))* range/nBins(i));
        % hack, matlab discretise functions works improperly as i've
        % noticed that the last bin does NOT include the right edge.
        edges(size(edges,2))= edges(size(edges,2))+ 0.0000000000001;
        discrdata(:,i) = discretize(temp,edges);
    elseif types(i)==2
        temp= varNames{count};
        nNames = size(temp,2);
        for k=1:nNames
            for j=1:nrows
                if strcmp(data{j,i},temp{k})
                    discrdata(j,i)=k;
                end
            end
        end
    else 
        for j=1:nrows
        discrdata(j,i)=data{j,i};
        end
    end
end
