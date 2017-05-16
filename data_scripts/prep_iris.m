%##########################################################################
% this section is very dependent on the data which you load and may need a
% lot of manual changes to get another dataformat to work with the rest of the
% scripts. the following works for the iris data set.
data = importIrisData();
%types of the data, for numerical vars enter 1, 2 for strings. If the
%dataset contains strings, the discretizeData function expect a list with all
%possible values. enter 0 if data is already binned or categorical.
types = [1,1,1,1,2];
%number of bins per variable, enter 0 for strings or data that is already binned. 
nBins = [3,3,3,3,0];
%names for all the levels of variables represented by strings. 
varNames= {{'Iris-setosa', 'Iris-versicolor', 'Iris-virginica'}};
data = discretiseData(data,types,nBins,varNames);
%##########################################################################