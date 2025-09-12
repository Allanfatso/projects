using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[System.Serializable] //makes it all(class) visible in the inspector
public class VisGraphConnection
{

    [SerializeField] private GameObject toNode;
    //what the code below does is it returns the private toNode whenever the ToNode is called. it is a getter method.
    public GameObject ToNode{
        get
        {
            return toNode; 

        }
    }
}

  //The class only provides a visual representation of the waypoint graph