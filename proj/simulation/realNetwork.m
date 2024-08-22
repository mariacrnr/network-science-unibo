function G = realNetwork(filename)
    data = readmatrix(filename);
    G = graph(data(:,1), data(:,2));
   
    % Generate random edge weights between 0 and 1
    randomWeights = rand(size(G.Edges, 1), 1);
    G.Edges.Weight = randomWeights;

end

