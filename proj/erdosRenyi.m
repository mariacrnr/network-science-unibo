function G = erdosRenyi(N, p, minW, maxW)
    % N: number of nodes
    % p: probability of edge existence between any pair of nodes
    % minW: minimum weight for edges
    % maxW: maximum weight for edges
    
    % Initialize an empty graph with n nodes
    G = zeros(N);

    % Generate edges with probability p and assign random initial weights
    for i = 1:N
        for j = (i+1):N
            if rand() < p
                % Edge exists
                weight = rand() * (maxW - minW) + minW;
                G(i, j) = weight;
                G(j, i) = weight; % For undirected graph
            end
        end
    end

end