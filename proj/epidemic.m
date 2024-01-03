% Fixed Parameters 
N = 1000; % Bumber of Nodes 
Ep = 0.01; % Edge probability
minW = 0; % Mininum edge weigth value
maxW = 1; % Maximum edge weigth value

initialInfected = 5; % Number of initial infected nodes

iterations = 5; % Number of iterations of the simulation
beta = 0.3; % Infection rate
delta = 0.1; % Recovery rate

%% Network Model Topology

erdosG = graph(erdosRenyi(N, Ep, minW, maxW));
wattsG = graph(wattsStrogatz(N, Ep, minW, maxW));
realG =  realNetwork('sociopatterns-infectious.txt');

network = realG;
adjacencyM = adjacency(network);
N = numnodes(network);

% Visualize Initial Network
figure;
initialPlot = plot(network, 'NodeLabel', [], 'EdgeColor', 'r');
% initialPlot = plot(network, 'EdgeLabel', arrayfun(@(x) sprintf('%.2f', x), erdosG.Edges.Weight, UniformOutput=false), 'NodeLabel', []); % plot with edge weights
% initialPlot = plot(network, 'NodeLabel', [], 'EdgeColor', 'b'); % plot with edges without their weight
title('Initial Network Topology');

fprintf('Number of nodes in network: %d\n', numnodes(network));
fprintf('Number of edges in network: %d\n', numedges(network));

%% Infected Individuals Representation
% Boolean representation of infected individuals (0 - Susceptible 1 - Infected)

% Random subset of initial infected individuals
% initialInfectedNodes = randperm(N, initial_infected);
% infectedNodes = zeros(N, 1);
% infectedNodes(initialInfectedNodes) = 1;

% Central and with larger degree initial infected individuals
degreeCentrality = centrality(network, 'degree'); % Calculate degree centrality for each node
closenessCentrality = centrality(network, 'closeness'); % Calculate degree centrality for each node
combinedCentrality = 0.5 * degreeCentrality + 0.5 * closenessCentrality;

[~, sortedIndices] = sort(combinedCentrality, 'descend'); % Sort nodes by degre
infectedNodes = zeros(N, 1);
infectedNodes(sortedIndices(1:initialInfected)) = 1;

% Visualize Network with Infected Nodes
figure;
initialInfectedPlot = plot(network, 'NodeLabel', [], 'EdgeColor', 'b', 'LineStyle', 'none');
highlight(initialInfectedPlot, find(infectedNodes), 'NodeColor', 'r', 'Marker', 'o', 'MarkerSize', 5);
title('Initial Network Topology with Infected Nodes');

%% Epidemic Simulation

% Initialize Transmission Matrix T
transmissionM = rand(N, N) <= adjacencyM;  % Tij = 1 with probability aij, 0 otherwise

% Initialize vectors for infected individuals
currentInfected = infectedNodes;
newlyInfected = zeros(N, 1);

% Simulation Loop
for t = 1:iterations
    
    % Disease Spread
    transmissionProb = beta * (transmissionM' * currentInfected);
    newlyInfected = double(rand(N, 1) <= transmissionProb);
    
    % Update Infected Individuals
    currentInfected = currentInfected | newlyInfected;
    
    % Apply Recovery
    recovered = rand(N, 1) <= delta;
    currentInfected = currentInfected & ~recovered;
    
    % Intermediate Visualization 
    % if mod(t, 10) == 0
    figure;
    infected_plot = plot(network, 'NodeLabel', [], 'EdgeColor', 'b', 'LineStyle', 'none');
    highlight(infected_plot, find(currentInfected), 'NodeColor', 'r', 'Marker', 'o', 'MarkerSize', 5);
    title(['Network Topology at Time Step ' num2str(t)]);
    % end

end

% Final Visualization
figure;
final_infected_plot = plot(network, 'NodeLabel', [], 'EdgeColor', 'b', 'LineStyle', 'none');
highlight(final_infected_plot, find(currentInfected), 'NodeColor', 'r', 'Marker', 'o', 'MarkerSize', 5);
title('Final Network Topology with Infected Nodes');

% numIterations = 100;
% infectionHistory = zeros(numIterations, 1);
% 
% for t = 1:numIterations
%     % Disease Spread
%     transmissionMatrix = rand(N, N) < beta * G';
%     newlyInfectedNodes = (transmissionMatrix * infectedNodes) > 0;
% 
%     % Recoveries
%     recoveries = rand(N, 1) < delta;
%     infectedNodes = infectedNodes & ~recoveries;
% 
%     % Update infected nodes
%     infectedNodes = infectedNodes | newlyInfectedNodes;
% 
%     % Record infection levels
%     infectionHistory(t) = sum(infectedNodes);
% end
% 
% % Plotting the Epidemic Curve
% figure;
% plot(1:numIterations, infectionHistory, 'LineWidth', 2);
% title('Epidemic Curve');
% xlabel('Time Step');
% ylabel('Number of Infected Individuals');
% grid on;
% 
% % Visualizing the Network (using the built-in plot function)
% figure;
% plot(G, 'Layout', 'force', 'MarkerSize', 6);
% title('Network Structure');

