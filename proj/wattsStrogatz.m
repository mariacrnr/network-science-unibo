function G = wattsStrogatz(N, k, p, minW, maxW)
    % N: number of nodes
    % k: number of neighbors for each node in the initial ring lattice
    % p: probability of edge rewiring
    % minW: minimum Weigth for edges
    % maxW: maximum Weigth for edges
    
    % Generate a regular ring lattice
    G = zeros(N);
    for i = 1:N
        for j = 1:k
            idx = mod(i + (j-1), N) + 1;
            G(i, idx) = 1;
            G(idx, i) = 1; % For undirected graph
        end
    end

    % Rewire edges with probability p and assign random Ws
    for i = 1:N
        for j = (i+1):N
            if rand() < p

                newNeighbor = randi(N);
                while newNeighbor == i || G(i, newNeighbor) == 1
                    newNeighbor = randi(N);
                end
                G(i, j) = 0;
                G(j, i) = 0;
                G(i, newNeighbor) = 1;
                G(newNeighbor, i) = 1;
                
                W = minW + (maxW - minW) * rand();
                G(i, newNeighbor) = W;
                G(newNeighbor, i) = W; % For undirected graph
            end
        end
    end
end
