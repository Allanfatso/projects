using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Provides a simple interface for a* and the other classes and groups things together

public class AStarManager
{
    // The a star algorithm.
    private AStar AStar = new AStar();
    // The waypoint graph.
    private Graph aGraph = new Graph();
    // The Heuristic.
    private Heuristic aHeuristic = new Heuristic();
    public AStarManager()
    {
    }
    // Add Connection.
    public void AddConnection(Connection connection)
    {
        aGraph.AddConnection(connection);
    }
    // Find path.
    public List<Connection> PathfindAStar(GameObject start, GameObject end)
    {
        return AStar.PathfindAStar(aGraph, start, end, aHeuristic);
    }
}