function G = realNetwork(filename)
    data = readmatrix(filename);
    G = graph(data(:,1), data(:,2));
end

