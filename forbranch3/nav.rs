use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};

// 1. Define the state to track inside the Priority Queue min-heap
#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
    cost: usize,
    position: usize,
}

// Implement custom ordering so BinaryHeap behaves as a min-heap instead of a max-heap
impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        // Notice the flipped order here: we want the lowest cost first
        other.cost.cmp(&self.cost)
            .then_with(|| self.position.cmp(&other.position))
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

// 2. Define our Edge structure representing a road connection
#[derive(Clone, Debug)]
struct Edge {
    node: usize,
    cost: usize,
}

// 3. The Pathfinding Function (Dijkstra's Algorithm)
fn find_shortest_path(
    graph: &Vec<Vec<Edge>>, 
    start: usize, 
    goal: usize
) -> Option<(Vec<usize>, usize)> {
    // Distances map: initialized to usize::MAX (infinity)
    let mut distances: Vec<usize> = (0..graph.len()).map(|_| usize::MAX).collect();
    
    // came_from map: tracks the node we travelled from to reach the current node
    let mut came_from: HashMap<usize, usize> = HashMap::new();
    
    let mut heap = BinaryHeap::new();

    // Initialize start node
    distances[start] = 0;
    heap.push(State { cost: 0, position: start });

    // Main search loop
    while let Some(State { cost, position }) = heap.pop() {
        // If we reached the target, reconstruct and return the route
        if position == goal {
            let mut path = vec![goal];
            let mut current = goal;
            while let Some(&prev) = came_from.get(&current) {
                path.push(prev);
                current = prev;
            }
            path.reverse();
            return Some((path, cost));
        }

        // If we found a better path already to this node, skip processing
        if cost > distances[position] {
            continue;
        }

        // Check neighboring connections
        for edge in &graph[position] {
            let next_state = State { 
                cost: cost + edge.cost, 
                position: edge.node 
            };

            // If this new path is shorter, record it and add it to the queue
            if next_state.cost < distances[edge.node] {
                heap.push(next_state);
                distances[edge.node] = next_state.cost;
                came_from.insert(edge.node, position);
            }
        }
    }

    None // Goal is unreachable
}

fn main() {
    // 4. Set up a mock road network graph map
    // Let node IDs represent cities: 0: Delhi, 1: Jaipur, 2: Agra, 3: Gwalior, 4: Lucknow
    let city_names = vec!["Delhi", "Jaipur", "Agra", "Gwalior", "Lucknow"];
    
    let mut graph: Vec<Vec<Edge>> = vec![vec![]; 5];

    // Connections out of Delhi (0)
    graph[0].push(Edge { node: 1, cost: 5 });  // Delhi -> Jaipur (Cost 5)
    graph[0].push(Edge { node: 2, cost: 2 });  // Delhi -> Agra   (Cost 2)

    // Connections out of Jaipur (1)
    graph[1].push(Edge { node: 3, cost: 4 });  // Jaipur -> Gwalior (Cost 4)

    // Connections out of Agra (2)
    graph[2].push(Edge { node: 1, cost: 2 });  // Agra -> Jaipur   (Cost 2)
    graph[2].push(Edge { node: 4, cost: 7 });  // Agra -> Lucknow  (Cost 7)

    // Connections out of Gwalior (3)
    graph[3].push(Edge { node: 4, cost: 3 });  // Gwalior -> Lucknow (Cost 3)

    // Run the navigation engine from Delhi (0) to Lucknow (4)
    let start_node = 0;
    let goal_node = 4;

    println!("Calculating best route from {} to {}...", city_names[start_node], city_names[goal_node]);

    match find_shortest_path(&graph, start_node, goal_node) {
        Some((path, total_cost)) => {
            let named_path: Vec<&str> = path.iter().map(|&id| city_names[id]).collect();
            println!("✅ Route Found!");
            println!("📍 Optimized Path: {:?}", named_path.join(" -> "));
            println!("⏱️ Total Travel Cost: {} units", total_cost);
        }
        None => println!("❌ No valid path found between those locations."),
    }
}
