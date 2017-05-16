function out = combinations(varargin)
% COMBINATIONS  Returns all combinations of a set of vectors
% 
% C = COMBINATIONS(V1, V2, V3, ...Vn) returns the set of combinations
%   formed by taking the first element from  vector V1, the second
%   element from vector V2, the third from vector V3, and so on. 
%   Empty vectors are ignored in the calculation of the output 
%   (though a warning is issued). 
%
%    C is a KxN matrix, where K is the total number of combinations,
%    and N is the number of (non-empty) input vectors. 
%
%    V1, V2, ... Vn can be either numeric or cell arrays. If they are all 
%    numeric arrays, then C is a KxN numeric matrix. If any of the vectors
%    is a cell array, then C is a KxN cell matrix. 
%
% C = COMBINATIONS(V1, V2, V3, ...Vn, CLASSNAME) specifies that all
%    the  numeric vectors have numeric type CLASSNAME (e.g., 'int8',
%    'single'). If the output C is a numeric matrix, it will be of 
%    type CLASSNAME as well. By default, CLASSNAME is 'double'.
%
% This implementation is optimized for situations where the input 
% consists of many small vectors or a few very large vectors, for two
% reasons:
% 1) The algorithm used to generate the combinations does not use 
%    intermediate matrices, and 
% 2) When CLASSNAME is specified, there is no internal conversion from
%    DOUBLE -- the specified numeric datatype is used throughout.
%
% Examples:
%
% % Inputs are all numeric arrays
% c = combinations(1:5, 1:2)  
% c = combinations(1:5, 1:2, 'int8') % specify the numeric type
% c  = combinations(0:1,0:1,0:1,0:1,0:1,0:1,0:1,0:1,0:1,'int8');
%
% % Inputs are both numeric and cell arrays
% c = combinations({'aa','bb'}, 1:3)
% % specify the type of the numeric vectors
% c = combinations({'aa','bb'}, 1:3, 'int8')
%
% % Inputs are all cell arrays
% c  = combinations({'aa','bb'}, {[1 2] [4 5 6]}, {'zz','yy'})
% c  = combinations({'aa','bb'}, {[1 2] [4 5 6]}, [true false])
%
% % If inputs vectors have different numeric types, and you want to
% % preserve these types in the output, convert them to cell arrays:
% v1 = single(1:5); v2 = int8(1:2); 
% c = combinations( num2cell(v1), num2cell(v2) )
%
% % If you want combinations of character arrays, first convert them 
% % to explicit numeric arrays:
% c = combinations( double('abcd'), double('xyz') );
% % then convert back to character arrays
% char(c) 

% Gautam Vallabha (Gautam.Vallabha@mathworks.com)

if ischar(varargin{end})
    numericClass = varargin{end};
    try
        zeros(0,0,numericClass);
    catch  %#ok<CTCH>
        error('combinations:InvalidClass', ...
            ['String should be the name of a numeric data type ' ...
             '(<a href="matlab:doc datatypes">doc datatypes</a>)']);
    end
    varargin(end) = [];
else
    numericClass = 'double';
end


% Check the input arguments; empty lists are marked
% for later excision 
markForDelete = [];
for i=1:length(varargin)
    if isempty(varargin{i})
        markForDelete(end+1) = i; %#ok<AGROW>
        continue;
    end
    if ~(isnumeric(varargin{i}) || iscell(varargin{i}) || islogical(varargin{i}) || ischar(varargin{i}))
       error('combinations:InvalidArgument', ...
           'Parameters should be numeric vectors or cell arrays');
    end        
    if (numel(varargin{i}) ~= max(size(varargin{i})))
        error('combinations:InvalidArgument', ...
           'All arrays should be uni-dimensional');
     end
end

% Excise the empty lists
if numel(markForDelete) > 0
    for i=1:length(markForDelete)
        warning('combinations:EmptyArgument', 'Input #%d is an empty vector', markForDelete(i));
    end
    varargin(markForDelete) = [];
end


% Handle edge cases 
if numel(varargin) == 0
    out = []; 
    return;
elseif numel(varargin)  == 1
    % Need to handle this explicitly, since NDGRID(v) is 
    % implicitly treated as NDGRID(v,v)
    out = varargin{1}(:);
    return;
end

% Remember which ones are cell arrays
markAsCellArray = [];
celldata = {};
for i=1:length(varargin)
    if iscell(varargin{i})
        markAsCellArray(end+1) = i; %#ok<AGROW>
        celldata{end+1} = varargin{i}; %#ok<AGROW>
        varargin{i} = 1:numel(celldata{end});
    end
end

%% generate the combinations
numVars = numel(varargin);

% Method 1 -- using NDGRId
% v = cell(1,numVars);
% [v{:}] = ndgrid(varargin{:});
% numRows = numel(v{1});
% out2 = zeros(numRows, numVars, numericClass);
% for i=1:numVars
%     out2(:,i) = v{i}(:);
% end

% Method 2 -- using REPMAT
% This is asymptotically much faster
% and uses a lot less memory

sz = cellfun(@numel, varargin);
numRows = prod(sz);
out = zeros(numRows, numVars, numericClass);
for i=1:numVars
    % rotate the vector into the i'th dimension
    arr = permute(varargin{i}(:), [2:i 1 i+1:numVars]);
    % the repmat replicates the vector into all the other dimensions
    % and the reshape flattens it 
    temp_sz = sz;
    temp_sz(i) = 1;
    out(:,i) = reshape(repmat(arr, temp_sz), [numRows 1]);
end

%% Expand back into the cellarrays
if isempty(markAsCellArray)
    return;
end

cellout = num2cell(out);
for i=1:length(markAsCellArray)
    idx = markAsCellArray(i);
    cellout(:,idx) = celldata{i}(out(:,idx));
end
out = cellout;
