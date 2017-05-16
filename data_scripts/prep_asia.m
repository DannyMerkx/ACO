N=8;
dag = zeros(N,N);

varNames= {'asia','tub','smoke','lung','bronc','either','xray','dysp'};

for i=1:N
    eval([varNames{i} '= i;']);    
end

parents = {{'tub','asia'},{'lung','smoke'},{'bronc','smoke'},{'either','lung'},{'either','tub'},...
    {'xray','either'},{'dysp','bronc'},{'dysp','either'}};

for i=1:size (parents,2)
    dag(eval(parents{i}{2}),eval(parents{i}{1}))=1;
end

discrete_nodes = 1:N;
node_sizes = [2,2,2,2,2,2,2,2];

bnet = mk_bnet(dag, node_sizes);


x= [0.01, 0.99];


bnet.CPD{eval('asia')}= tabular_CPD(bnet, eval('asia'), [x(:,1),x(:,2)]);

x=[ 0.05, 0.95
   0.01, 0.99];

bnet.CPD{eval('tub')}= tabular_CPD(bnet, eval('tub'), [x(:,1),x(:,2)]);


x=[0.5, 0.5];


bnet.CPD{eval('smoke')}= tabular_CPD(bnet, eval('smoke'), [x(:,1),x(:,2)]);



  x=[0.1, 0.9
  0.01, 0.99];

bnet.CPD{eval('lung')}= tabular_CPD(bnet, eval('lung'), [x(:,1),x(:,2)]);



  x=[0.6, 0.4
 0.3, 0.7];

bnet.CPD{eval('bronc')}= tabular_CPD(bnet, eval('bronc'), [x(:,1),x(:,2)]);



  x=[ 1.0, 0.0
   1.0, 0.0
 1.0, 0.0
  0.0, 1.0];
  
  bnet.CPD{eval('either')}= tabular_CPD(bnet, eval('either'), [x(:,1),x(:,2)]);


 x=[0.98, 0.02
   0.05, 0.95];
bnet.CPD{eval('xray')}= tabular_CPD(bnet, eval('xray'), [x(:,1),x(:,2)]);



  x=[0.9, 0.1
  0.7, 0.3
  0.8, 0.2
   0.1, 0.9];
  
  bnet.CPD{eval('dysp')}= tabular_CPD(bnet, eval('dysp'), [x(:,1),x(:,2)]);

  for i=1:10000
    data(i,:)= cell2mat(sample_bnet(bnet))';
  end

  