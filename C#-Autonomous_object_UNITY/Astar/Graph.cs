using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//This represents the actual waypoint graph. A* will use this to determine connections from waypoint nodes.
public class Graph
{
    // A list of graph connections.
    private List<Connection> WaypointConnections = new List<Connection>();
    public Graph()
    {
    }
    // Add connection.
    public void AddConnection(Connection aConnection)
    {
        WaypointConnections.Add(aConnection);
    }
    // Get the connections from a node to the nodes it is connected to.
    public List<Connection> GetConnections(GameObject FromNode)
    {
        List<Connection> TmpConnections = new List<Connection>();
        foreach (Connection aConnection in WaypointConnections)
        {
            if (aConnection.FromNode.Equals(FromNode))
            {
                TmpConnections.Add(aConnection);
            }
        }
        return TmpConnections;
    }
}