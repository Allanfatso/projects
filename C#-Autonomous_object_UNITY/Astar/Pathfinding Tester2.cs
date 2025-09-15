using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using Unity.VisualScripting.FullSerializer;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using static UnityEditor.PlayerSettings;
using static UnityEditor.ShaderGraph.Internal.KeywordDependentCollection;

// Provides a simple way to demonstrate the a*. It also moves the agent along the path in the update under agentMove
// Class level variables for AgentMove determine speed, position to move, current pos to move to and flag to determine whether to move
//

public class PathfindingTester2 : MonoBehaviour
{
    // GUI variables
    public string text1;
    public string text2;
    public string text3;
    //Agents stops to check the environment
    bool investigating = false;
    // When the agent reacts to environment
    bool animate = true;
    // The A* manager.
    private AStarManager AStarManager = new AStarManager();
    // List of possible waypoints.
    private List<GameObject> Waypoints = new List<GameObject>();
    // List of waypoint map connections. Represents a path.
    private List<Connection> AStarPath = new List<Connection>();
    // The start and end nodes.
    [SerializeField] public GameObject start;
    [SerializeField] public GameObject end;
    // In-built transit end node for the agent.
    private GameObject bot_end;

    // User request traversal
    private bool user_request = true;




    // Debug line offset.
    Vector3 OffSet = new Vector3(0, 0.3f, 0);

    // A list of all waypoint nodes set to goal in the environment.
    private List<GameObject> WaypointGoals = new List<GameObject>();

    // Movement variables.
    private float currentSpeed = 10;
    private int currentTargetArrayIndex = 0;
    private Vector3 currentTargetPos;

    private bool agentMove = true;
   

    // Route Timer.
    private float timer = 0;

    // Distance Calculator.
    private float totalDistance = 0;
    private Vector3 lastPosition = new Vector3();

    // Animator reference.
    [SerializeField] private RobotFreeAnim robotAnim;

    // Predefined List of start Nodes
    private List<GameObject> transit = new List<GameObject>();
    private int transitIndex = 0;
    private string[] transit_comparison = {"Waypoint04", "Waypoint07", "Waypoint08"};
    private string transit_end = "Waypoint10";

    // List of environment issues
 

    private List<GameObject> Targets = new List<GameObject>();
    private string[] Targets_comparison = { "fire", "injured_animal" };
    // Tracks currently active objects of each type
    private bool activeFire = false;
    private bool activefire = false;
    private bool activeInjuredAnimal = false;
    private bool activeInjured = false;

    

    // environment spawn issues
    [SerializeField] private GameObject fire;
   
    [SerializeField] private GameObject injured_animal;

    // Environment responses
    //Extinguish
    private float projectilePower = 2000;
    private float COOLDOWN_TIME = 2;
    private float coolDown = 0;
    [SerializeField] private Rigidbody projectileRigidBody;

    // Determines Closest target.
    private GameObject closest = null;

    // Used to specify whether the agent should follow a random route
    private bool RandMove = false;

    // Used to initialize the random movement.
    private bool RandMoveStart = false;
    // for a fixed random start
    public GameObject start2;

    // Stores a target when obstacle avoidance is
    // being implemented. A temporary target.
    private Vector3 _obstacleAvoidanceTarget = new Vector3();
    public Vector3 ObstacleAvoidanceTarget
    {
        set { _obstacleAvoidanceTarget = value;}
        get { return _obstacleAvoidanceTarget; }
    }
    // True if obstacle avoidance is being implemented.
    private bool _obstacleAvoidanceTargetSet = false;
    public bool ObstacleAvoidanceTargetSet
    {
        get { return _obstacleAvoidanceTargetSet; }
    }

    // Start is called before the first frame update
    void Start()
    {
        if (start == null || end == null)
        {
            Debug.Log("No start or end waypoints. Setting start and end...");
            //Set the waypoints for the agent to immediately start.
            return;
        }


        VisGraphWaypointManager tmpWpM = start.GetComponent<VisGraphWaypointManager>();
        if (tmpWpM == null)
        {
            Debug.Log("Start is not a waypoint.");
            return;
        }

        tmpWpM = end.GetComponent<VisGraphWaypointManager>();
        if (tmpWpM == null)
        {
            Debug.Log("End is not a waypoint.");
            return;
        }

        // Find all the waypoints in the level.
        GameObject[] GameObjectsWithWaypointTag;
        GameObjectsWithWaypointTag = GameObject.FindGameObjectsWithTag("Waypoint");
        foreach (GameObject waypoint in GameObjectsWithWaypointTag)
        {
            VisGraphWaypointManager tmpWaypointMan =
                waypoint.GetComponent<VisGraphWaypointManager>();
            if (tmpWaypointMan)
            {
                Waypoints.Add(waypoint);
            }
        }

        // Populate transit nodes
        foreach (GameObject waypoint in GameObjectsWithWaypointTag)
        {

            foreach (string comparison in transit_comparison)
            {
                if (waypoint.name == comparison && !transit.Contains(waypoint))
                {
                    // Add to transit list only if not already present
                    transit.Add(waypoint); 
                }
            }
            // Set the waypoint as the end node after initial user specified run.
            if (waypoint.name == transit_end)
            {
                bot_end = waypoint;
                start2 = bot_end;
            }

            // traverse the user_requests first
            user_request = true;

            // Find issues in the environment for bot to investigate.
            EnvironmentCheck();

            // Set the agents initial movement properties

      

        }

        



        // Go through the waypoints and create connections.
        foreach (GameObject waypoint in Waypoints)
        {
            VisGraphWaypointManager tmpWaypointMan =
                waypoint.GetComponent<VisGraphWaypointManager>();
            if (tmpWaypointMan.WaypointType == VisGraphWaypointManager.waypointPropsList.Goal)
            {
                WaypointGoals.Add(waypoint);
            }

            // Loop through a waypoints connections.
            foreach (VisGraphConnection aVisGraphConnection in tmpWaypointMan.Connections)
            {
                if (aVisGraphConnection.ToNode != null)
                {
                    Connection aConnection = new Connection();
                    aConnection.FromNode = waypoint;
                    aConnection.ToNode = aVisGraphConnection.ToNode;
                    AStarManager.AddConnection(aConnection);
                }
                else
                {
                    Debug.Log("Warning, " + waypoint.name +
                              " has a missing to node for a connection!");
                }
            }
        }
        // Run A Star...That can still run in the update.
        // AStarPath stores all the connections in the path/route to the goal/end node.
        AStarPath = AStarManager.PathfindAStar(start, end);
        if (AStarPath.Count == 0)
        {
            Debug.Log("Warning, A* did not return a path between the start and end node.");
        }
        lastPosition = transform.position;
       

    }
    // Draws debug objects in the editor and during editor play (if option set).
    void OnDrawGizmos()
    {
        // Draw path.
        foreach (Connection aConnection in AStarPath)
        {
            Gizmos.color = Color.white;
            Gizmos.DrawLine((aConnection.FromNode.transform.position + OffSet),
                (aConnection.ToNode.transform.position + OffSet));
        }
       

    }
    // print metrics on screen
    private void OnGUI()
    {
       GUI.color = Color.magenta;
       GUI.Label(new Rect(10, 10, Screen.width, Screen.height), text1);
       GUI.color = Color.red;
       GUI.Label(new Rect(10, 30, Screen.width, Screen.height), text2);
       GUI.color = Color.blue;
       GUI.Label(new Rect(10, 60, Screen.width, Screen.height), text3);

    }

    // Update is called once per frame
    void Update()
    {

        SetAnimationStateBasedOnProximity();
        Spawn_issues();
        if (agentMove)
        {
            if (user_request)
            {
                User_Targets();
                user_request = false;
                agentMove = true;
                text3 = ("Now traversing User_path!");
            }

            if (RandMove && !user_request)
            {
                RandomMove();
                text3 = ("Now traversing Random_path!");
            }
            else if (!RandMove && !user_request)
            {
                MoveToTargets();
                text3 = ("Now traversing Transit_path!");
            }

            // Decide if move to target or random move.


        }
        // triggered when the agent discovers any of the marked objects in the environment
        else if (!agentMove && investigating)
        {
            // Check if the closest object has been destroyed
            if (closest == null || closest.Equals(null))
            {
                Debug.Log("Closest target has been destroyed. Resetting...");
                closest = null;
                agentMove = true;
                investigating = false;
            }
            else if (closest.tag == "fire")
            {
                Extinguish();
            }
            else if (closest.tag == "injured_animal")
            {
                MovetoAnimal();
            }

        }
        else if (!agentMove && RandMoveStart && RandMove && !investigating)
        {
            agentMove = true;

        }
    }

    private void MoveToTargets()
    {
        EnvironmentCheck();
        bool res = ObstacleAvoidance(8, 8, 6, 1, 0);
        if (res)
        {
            return;
        }

        // falsify user start/end requests
        user_request = false;
        // Identify interests in the environent
        EnvironmentCheck();
       
        // Timer and distance.
        Vector3 tmpDir = lastPosition - transform.position;
        float tmpDistance = tmpDir.magnitude;
        totalDistance += tmpDistance;
        //Debug.Log("distance: " + TotalDistance);
        lastPosition = transform.position;
       
        timer += Time.deltaTime;
        // Set the current target.
        currentTargetPos = AStarPath[currentTargetArrayIndex].ToNode.transform.position;
        // Clear y to avoid up/down movement. Assumes flat surface.
        currentTargetPos.y = transform.position.y;
      
        // Get a vector to the target position.
        Vector3 direction = currentTargetPos - transform.position;
        // Calculate the length of the relative position vector
        float distance = direction.magnitude;
        // Face in the right direction.


        direction.y = 0;

       

       

        if (direction.magnitude > 0)
        {
            Quaternion rotation = Quaternion.LookRotation(direction, Vector3.up);
            transform.rotation = rotation;
        }

        // Calculate If the agent senses a disturbance / an issue
        if (closest != null)
            {

            Vector3 tmp_target_distance = closest.transform.position - transform.position;
            float target_distance = tmp_target_distance.magnitude;
            if (target_distance <= 20.0f)
            {
                agentMove = false;
                investigating = true;

            }
        }
       
        // Calculate the normalised direction to the target from a game object.
        Vector3 normDirection = direction / distance;
        // Move the game object.
        transform.position = transform.position + normDirection * currentSpeed * Time.deltaTime;
        // Check if close to current target.
        if (distance < 1)
        {
            // Close to target, so move to the next target in the list (if there is one).
            currentTargetArrayIndex++;

            if (currentTargetArrayIndex == AStarPath.Count)
            {
                // The A* agent has reached the goal location.
                // Decide what it should do next.
                // For example, it could plan a route back to the start and then stop.
                // Output timer and distance information.
                Debug.Log("Time: " + timer);
                Debug.Log("Distance: " + totalDistance);
                text1 = $"Agent has taken {timer.ToString()} to complete route";
                text2 = $"Total distance travelled is {totalDistance.ToString()}";
                totalDistance = 0;
                timer = 0;
                // Check if the current target is the start node. If yes, then stop.
                if (AStarPath[(currentTargetArrayIndex - 1)].ToNode.Equals(start) == true)
                {
                    // Change goal to something new in transit.
                    if (transitIndex < transit.Count)
                    {
                        //Transit points are start positions. End is fixed
                        start = transit[transitIndex];
                        end = bot_end;
                        
                        transitIndex++;

                        // Not back at start, so plan path back to the start.
                        AStarPath = AStarManager.PathfindAStar(start, end);
                        currentTargetArrayIndex = 0;
                        
                    }
                    else
                    {
                        agentMove = false;
                        text3 = ("All patroll routes traversed, switching to random routes...");
                        RandMoveStart = true;
                        RandMove = true;
                        currentTargetArrayIndex = 0;
                    }

                    return;
                }
                // Not back at start, so plan path back to the start.
                AStarPath = AStarManager.PathfindAStar(end, start);
                currentTargetArrayIndex = 0;
               

            }
        }


    }

    private void User_Targets()
    {
        EnvironmentCheck();
        bool res = ObstacleAvoidance(8, 8, 6, 1, 0);
        if (res)
        {
            return;
        }
        user_request = true;
        // Timer and distance.
        Vector3 tmpDir = lastPosition - transform.position;
        float tmpDistance = tmpDir.magnitude;
        totalDistance += tmpDistance;
        //Debug.Log("distance: " + TotalDistance);
        lastPosition = transform.position;
        timer += Time.deltaTime;
        // Set the current target.
        currentTargetPos = AStarPath[currentTargetArrayIndex].ToNode.transform.position;
        // Clear y to avoid up/down movement. Assumes flat surface.
        currentTargetPos.y = transform.position.y;
        // Get a vector to the target position.
        Vector3 direction = currentTargetPos - transform.position;
        // Calculate the length of the relative position vector
        float distance = direction.magnitude;
        // Face in the right direction.


        direction.y = 0;

        if (direction.magnitude > 0)
        {
            Quaternion rotation = Quaternion.LookRotation(direction, Vector3.up);
            transform.rotation = rotation;
        }

        // Calculate If the agent senses a disturbance / an issue
        if (closest != null)
        {

            Vector3 tmp_target_distance = closest.transform.position - transform.position;
            float target_distance = tmp_target_distance.magnitude;
            if (target_distance <= 20.0f)
            {
                agentMove = false;
                investigating = true;

            }
        }

        // Calculate the normalised direction to the target from a game object.
        Vector3 normDirection = direction / distance;
        // Move the game object.
        transform.position = transform.position + normDirection * currentSpeed * Time.deltaTime;

        // Check if close to current target.
        if (distance < 1)
        {
            // Close to target, so move to the next target in the list (if there is one).
            currentTargetArrayIndex++;
            if (currentTargetArrayIndex == AStarPath.Count)
            {
                // The A* agent has reached the goal location.
                // Decide what it should do next.
                // For example, it could plan a route back to the start and then stop.
                // Output timer and distance information.
                Debug.Log("Time: " + timer);
                Debug.Log("Distance: " + totalDistance);
                text1 = $"Agent has taken{timer.ToString()} to complete route";
                text2 = $"Total distance travelled is {totalDistance.ToString()}";
                totalDistance = 0;
                timer = 0;
                // Check if the current target is the start node. If yes, then stop.
                if (AStarPath[(currentTargetArrayIndex - 1)].ToNode.Equals(start) == true)
                {
                    agentMove = false;
                    Debug.Log("Agent Stopped.");
                    return;
                }
                // Not back at start, so plan path back to the start.
                AStarPath = AStarManager.PathfindAStar(end, start);
                currentTargetArrayIndex = 0;
               

            }
        }
    }

    private void RandomMove()
    {
        start = GameObject.Find("Waypoint01");     

        EnvironmentCheck();
        bool res = ObstacleAvoidance(8, 8, 6, 1, 0);
        if (res)
        {
            return;
        }
        user_request = false;
        if (RandMoveStart)
        {
            // Not back at start, so plan path back to the start.
            end = transit[Random.Range(0, transit.Count)];
            AStarPath = AStarManager.PathfindAStar(start, end);
            currentTargetArrayIndex = 0;


            RandMoveStart = false;
        }

        // Timer and distance.
        Vector3 tmpDir = lastPosition - transform.position;
        float tmpDistance = tmpDir.magnitude;
        totalDistance += tmpDistance;
        //Debug.Log("distance: " + TotalDistance);
        lastPosition = transform.position;
        timer += Time.deltaTime;
        // Set the current target.
        currentTargetPos = AStarPath[currentTargetArrayIndex].ToNode.transform.position;
        // Clear y to avoid up/down movement. Assumes flat surface.
        currentTargetPos.y = transform.position.y;
        // Get a vector to the target position.
        Vector3 direction = currentTargetPos - transform.position;
        // Calculate the length of the relative position vector
        float distance = direction.magnitude;
        // Face in the right direction.

      

        direction.y = 0;

        // Set walking or rolling animation based on distance to start or end nodes

        if (direction.magnitude > 0)
        {
            Quaternion rotation = Quaternion.LookRotation(direction, Vector3.up);
            transform.rotation = rotation;
        }

        // Calculate If the agent senses a disturbance / an issue
        if (closest != null)
        {

            Vector3 tmp_target_distance = closest.transform.position - transform.position;
            float target_distance = tmp_target_distance.magnitude;
            if (target_distance <= 18.0f)
            {
                agentMove = false;
                investigating = true;

            }
        }

        // Calculate the normalised direction to the target from a game object.
        Vector3 normDirection = direction / distance;
        // Move the game object.
        transform.position = transform.position + normDirection * currentSpeed * Time.deltaTime;

        // Check if close to current target.
        if (distance < 1)
        {
            // Close to target, so move to the next target in the list (if there is one).
            currentTargetArrayIndex++;

            if (currentTargetArrayIndex == AStarPath.Count)
            {
                // The A* agent has reached the goal location.
                // Decide what it should do next.
                // For example, it could plan a route back to the start and then stop.
                // Output timer and distance information.
                Debug.Log("Time: " + timer);
                Debug.Log("Distance: " + totalDistance);
                text1 = $"Agent has taken{timer.ToString()} to complete route";
                text2 = $"Total distance travelled is {totalDistance.ToString()}";
                totalDistance = 0;
                timer = 0;
                // Check if the current target is the start node. If yes, then stop.
                if (AStarPath[(currentTargetArrayIndex - 1)].ToNode.Equals(start) == true)
                {

                    // Not back at start, so plan path back to the start.
                    end = Waypoints[Random.Range(0, Waypoints.Count)];
                    if (end == start)
                    {
                        start = start2;
                        
                    }

                    AStarPath = AStarManager.PathfindAStar(start, end);
                    currentTargetArrayIndex = 0;

                    return;
                }

                // Not back at start, so plan path back to the start.
                AStarPath = AStarManager.PathfindAStar(end, start);
                currentTargetArrayIndex = 0;
                
            }
        }
    }

    // Define the local function for setting animation based on proximity
    void SetAnimationStateBasedOnProximity()
    {
        if (agentMove == false && animate == true)
        {
            robotAnim.SetAlert(true);
            robotAnim.SetSearching(true);
        }
        else if (agentMove == false)
        {
            robotAnim.SetAlert(false);
            robotAnim.SetSearching(false);
        }
        else if (agentMove == true)
        {
            robotAnim.SetAlert(true);
            robotAnim.SetSearching(true);
        }
    }

    void MovetoAnimal()
    {
        SetAnimationStateBasedOnProximity();
        animate = true;
       
        if (closest != null)
        {
            // Moves towards the animal object
            Vector3 direction = closest.transform.position - transform.position;
            // distance to animal
            float distance = direction.magnitude;
            Vector3 norm_direction = direction / distance;

            float current_speed = 5f;
            transform.position = transform.position + norm_direction * current_speed * Time.deltaTime;

            // Check if the object has reached the target
            if (distance <= 2f)
            {
                
                Destroy(closest);
            }
        }
        activeInjured = false;
        text2 = "Injured Animal rescued!";

    }

    void Extinguish()
    {
        SetAnimationStateBasedOnProximity();
        animate = true;
        bool res = ObstacleAvoidance(8, 8, 6, 1, 0);
        if (res)
        {
            return;
        }

        if (closest != null)
        {
            // Moves towards the fire object
            Vector3 direction = closest.transform.position - transform.position;

            // Calculate the halfway point from fire.
            float targetDistance = 10f;
            float distance = direction.magnitude;

            if (distance > targetDistance)
            {
                Vector3 norm_direction = direction / distance;
                float current_speed = 5f;
                transform.position += norm_direction * current_speed * Time.deltaTime;
            }
            else
            {
                animate = false;
                // Stop the agent 
                // Execute the projectile script
                if (coolDown <= 0)
                {
                    coolDown = COOLDOWN_TIME;

                    // Instantiate the projectile. 
                    Rigidbody aInstance = Instantiate(projectileRigidBody, transform.position, transform.rotation) as Rigidbody;

                    // Add force towards the fire object
                    Vector3 forward = (closest.transform.position - transform.position).normalized;
                    aInstance.AddForce(forward * projectilePower);

                    // Destroy the projectile after 2 seconds
                    Destroy(aInstance.gameObject, 2);
                   
                }
                else
                {
                    coolDown -= Time.deltaTime;
                }

                text2 = "Fire extinguished!";
                activefire = false;
           
            }
        }
    }


    void EnvironmentCheck()
    {

        // Populate targets nodes. Tie it with the user input, the press of a button
        // Which triggers the bot to react.
        // Clears the Targets list to reset it each time the function is called.
        Targets.Clear();

        foreach (string tag in Targets_comparison)
        {
            // Find all GameObjects with the current tag
            GameObject[] GameObjectsWithTag = GameObject.FindGameObjectsWithTag(tag);

            // Add each GameObject to the Targets list if not already present
            foreach (GameObject target in GameObjectsWithTag)
            {
                if (!Targets.Contains(target))
                {
                    Targets.Add(target);
                }
            }
        }

        closest = FindClosest();

        if (closest != null)
        {
            // Display direction to target.
            Vector3 direction = closest.transform.position - transform.position;
            // Determine the distance of the vector.
            float distance = direction.magnitude;
            Debug.Log("Closest target distance: " + distance);
        }
        else
        {
            Debug.Log("No targets found.");
        }
        
    }

    private GameObject FindClosest()
    {
        GameObject closest = null;
        float distanceSqr = Mathf.Infinity;
        foreach (GameObject target in Targets)
        {
            if (target != null)
            {
                // Get a vector to the gameobject.
                Vector3 direction = target.transform.position - transform.position;
                // Determine the distance squared of the vector.
                float tmpDistanceSqr = direction.sqrMagnitude;
                if (tmpDistanceSqr < distanceSqr)
                {
                    closest = target;
                    distanceSqr = tmpDistanceSqr;
                }
            }
        }
        return closest;
    }


    // user_input for spawning objects
    void Spawn_issues()
    {

        // Check if the user presses the spacebar to spawn a fire
        if (Input.GetKeyDown(KeyCode.Space) && activefire == false)
        {
            //Only spawn if there is no fire on the scene
            Vector3 spawnPosition = GetRandomGroundPosition();
            activeFire = Instantiate(fire, spawnPosition, Quaternion.identity);
            Debug.Log("Fire spawned at: " + spawnPosition);
            activefire = true;
        }

        // Check if the user presses the enter key to spawn an injured animal
        if (Input.GetKeyDown(KeyCode.LeftControl) && activeInjured == false)
        {
            // Only spawn an injured animal if there's no active injured animal in the scene
            Vector3 spawnPosition = GetRandomGroundPosition();
            activeInjuredAnimal = Instantiate(injured_animal, spawnPosition, Quaternion.identity);
            Debug.Log("Injured animal spawned at: " + spawnPosition);
            activeInjured = true;
        }

    }
    // For a random position on the ground
    Vector3 GetRandomGroundPosition()
    {
        // Ground bounds based on its dimensions
        float X = 100f; 
        float Z = 100f; 
        float Y = 0.9f; 
        // Ground scales from -2 to 2 so divide by 2
        float randomX = Random.Range(-X / 2, X / 2);
        float randomZ = Random.Range(-Z / 2, Z / 2);

        return new Vector3(randomX, Y, randomZ);
    }
    // obstacle avoidance
    private bool ObstacleAvoidance(float avoidDistance, float lookAhead, float lookAheadWhiskers,
                                                float lookAheadHeightOffset, float lookAheadForwardOffset)
    {
        // Calculate enitity position.
        Vector3 EntityPosition = transform.position;
        EntityPosition.y += lookAheadHeightOffset;

        // Calculate the forward collision ray vector.
        RaycastHit hitForward;
        bool bHitForward = Physics.Raycast(EntityPosition,
        transform.TransformDirection(Vector3.forward), out hitForward, lookAhead);

        // Calculate the right forward collision ray vector.
        Quaternion spreadAngle = Quaternion.AngleAxis(15, new Vector3(0, 1, 0));
        Vector3 newRightVector = spreadAngle * transform.TransformDirection(Vector3.forward);
        RaycastHit hitForwardRight;
        bool bHitForwardRight = Physics.Raycast(EntityPosition, newRightVector, out hitForwardRight, lookAheadWhiskers);

        // Calculate the left forward collision ray vector.
        spreadAngle = Quaternion.AngleAxis(-15, new Vector3(0, 1, 0));
        Vector3 newLeftVector = spreadAngle * transform.TransformDirection(Vector3.forward);
        RaycastHit hitForwardLeft;
        bool bHitForwardLeft = Physics.Raycast(EntityPosition, newLeftVector, out hitForwardLeft, lookAheadWhiskers);

        if (bHitForward)
            Debug.DrawRay(EntityPosition, transform.TransformDirection(Vector3.forward) * hitForward.distance, Color.red);
        else
            Debug.DrawRay(EntityPosition, transform.TransformDirection(Vector3.forward) * lookAhead, Color.yellow);
        if (bHitForwardRight)
            Debug.DrawRay(EntityPosition, newRightVector * hitForwardRight.distance, Color.red);
        else
            Debug.DrawRay(EntityPosition, newRightVector * lookAheadWhiskers, Color.yellow);
        if (bHitForwardLeft)
            Debug.DrawRay(EntityPosition, newLeftVector * hitForwardLeft.distance, Color.red);
        else
            Debug.DrawRay(EntityPosition, newLeftVector * lookAheadWhiskers, Color.yellow);

        Vector3 ForwardAvoidanceTarget = new Vector3(0, 0, 0);

        if (bHitForward)
        {
            // Calculate new target.
            Vector3 newTarget = hitForward.point + (hitForward.normal * avoidDistance);
            newTarget.y = transform.position.y;
            ForwardAvoidanceTarget = newTarget;
        }
        // Check if Whiskers hit a target - right.
        Vector3 RightAvoidanceTarget = new Vector3(0, 0, 0);
        if (bHitForwardRight)
        {
            // Calculate new target.
            Vector3 newTarget = hitForwardRight.point + (hitForwardRight.normal * avoidDistance);
            newTarget.y = transform.position.y;
            RightAvoidanceTarget = newTarget;
        }
        // Check if Whiskers hit a target - right.
        Vector3 LeftAvoidanceTarget = new Vector3(0, 0, 0);
        if (bHitForwardLeft)
        {
            // Calculate new target.
            Vector3 newTarget = hitForwardLeft.point + (hitForwardLeft.normal * avoidDistance);
            newTarget.y = transform.position.y;
            LeftAvoidanceTarget = newTarget;
        }

        // Obstacle Avoidance Algorithm.
        if (bHitForward || bHitForwardRight ||
            bHitForwardLeft || ObstacleAvoidanceTargetSet == true)
        {
            if (bHitForward)
            {
                ObstacleAvoidanceTarget = ForwardAvoidanceTarget;
                _obstacleAvoidanceTargetSet = true;
            }
            else
            {
                if (bHitForwardRight && ObstacleAvoidanceTargetSet == false)
                {
                    ObstacleAvoidanceTarget = RightAvoidanceTarget;
                    _obstacleAvoidanceTargetSet = true;
                }
                else if (bHitForwardLeft && ObstacleAvoidanceTargetSet == false)
                {
                    ObstacleAvoidanceTarget = LeftAvoidanceTarget;
                    _obstacleAvoidanceTargetSet = true;
                }
            }
            
            // Do Movement. 
            Vector3 vecToTarget = ObstacleAvoidanceTarget - transform.position;
            float distanceToTarget = vecToTarget.magnitude;

            // Calculate the normalised direction to the target from a game object.
            Vector3 normDirection = vecToTarget / distanceToTarget;

            // Move the game object.
            transform.position = transform.position + normDirection * currentSpeed * Time.deltaTime;

            if (distanceToTarget < 0.5f)
            {
                _obstacleAvoidanceTargetSet = false;
                Debug.Log("Close to ObstacleAvoidance target - Target cleared");
            }

            return true;
        }
        else
        {
            // No obstacle avoidance - Call Seek.
            return false;
        }


    }

}







