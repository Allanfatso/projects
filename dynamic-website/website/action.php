<?php
        $mysqli = mysqli_connect("localhost", "2108418", "Leslieblantina@1", "db2108418");
        if (!$mysqli){
            echo "Failed to connect to MySQL: " . mysqli_connect_error();
        }
        
        if (isset($_POST['query'])){
			$inpText=$_POST['query'];
			
			$query="SELECT Film_name, Director, Lead_Actor FROM Best";
            $query.= " WHERE (Film_Name LIKE '%" . $inpText . "%') OR";
            $query.= " (Director LIKE '%" . $inpText . "%') OR";
            $query.= " (Genre LIKE '%" . $inpText. "%') OR";
            $query= " (Lead_Actor LIKE '%" .$inpText. "%')";
           
            $res1 = mysqli_query($mysqli, $sql1);
            
            
            $num_movies1 = mysqli_num_rows($res1);
        
            
            $records = $num_movies1;
            if ($records == 0){
                echo "<p class='list-group-item border-1'>No results found</p>";
            }else{
                print ("<p>$records result(s) found...</p>");
				while ($row = mysqli_fetch_assoc($res1)){
					echo "<a href='movies-search.php' class='list-group-item list-group-item-action border-1'>"
					.$row['Film_name']."</a>";
					
				}
			}
        }
    ?>