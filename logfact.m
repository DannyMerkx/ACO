function [fact] = logfact(x)
% custom function to calculate the log of a factorial (i.e. sum of incrementing
% integer list).
fact=0;
if x >= 1
    for i=1:x
        fact= fact+log(i) ;
    end
else 
    fact =1;
end