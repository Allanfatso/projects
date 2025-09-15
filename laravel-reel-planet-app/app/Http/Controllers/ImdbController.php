<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;



class ImdbController extends Controller
{
     // search function
    public function search(Request $request){
        // check is query is there in the form input using request
        $query = $request->input('query');

        // if no query
        if(!$query){
            return view('imdb-search-form');
        }

        // begin curl
        $curl = curl_init();

        //api url
        $url = "https://imdb236.p.rapidapi.com/imdb/autocomplete?query=" . urlencode($query);

        // setting up curl options

        curl_setopt_array($curl, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => [
                "x-rapidapi-host: imdb236.p.rapidapi.com",
                "x-rapidapi-key: 43b25bf820msh2d843e72db90b17p143700jsn942d2b5449c1"
            ],
        ]);

        // execure curl
        $response = curl_exec($curl);
        $err = curl_error($curl);

        // check for errors
        if ($err) {
            return view('imdb-search-results', [
                'query' => $query,
                'data' => null,
                'error' => "cURL Error: " . $err
            ]);
        }

        // decode json
        $data = json_decode($response, true);

        //array to store clicked movie
        $moviesById = [];
        if(is_array($data)){
            $results = $data;
            foreach($results as $item){
                if(!empty($item['id'])){
                    $moviesById[$item['id']] = $item;
                }
            }

        }
        session(['searchResults' => $moviesById]);

        // return results
        return view('imdb-search-results', [
            'query' => $query,
            'data' => $data,
        ]);

    }

    // slideshow


    public function latestmovies(){
          //api call

          $curl = curl_init();

          curl_setopt_array($curl, [
              CURLOPT_URL => "https://imdb236.p.rapidapi.com/imdb/upcoming-releases?countryCode=US&type=MOVIE",
              CURLOPT_RETURNTRANSFER => true,
              CURLOPT_ENCODING => "",
              CURLOPT_MAXREDIRS => 10,
              CURLOPT_TIMEOUT => 30,
              CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
              CURLOPT_CUSTOMREQUEST => "GET",
              CURLOPT_HTTPHEADER => [
                  "x-rapidapi-host: imdb236.p.rapidapi.com",
                  "x-rapidapi-key: 43b25bf820msh2d843e72db90b17p143700jsn942d2b5449c1"
              ],
          ]);

          $response = curl_exec($curl);
          $err = curl_error($curl);

          curl_close($curl);

          if ($err) {
              echo "cURL Error #:" . $err;
              return;
          }

          // decode the data
          // decode json
        $data = json_decode($response, true);

        $moviesById = [];

        if(is_array($data)){
            $results = $data;
            foreach($results as $item){
                if(!empty($item['titles'])){
                    foreach($item['titles'] as $film){
                        $moviesById[$film['id']] = $film;
                    }

                }
            }

        }

        // for slide view
        session(['latestmovies' => $moviesById]);

        // for movie details view



        // return results
        return view('slideshow', [

            'data' => $moviesById,
        ]);


    }

    public function alltimemovies(){

        //api call

        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => "https://imdb236.p.rapidapi.com/imdb/top250-movies",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => [
                "x-rapidapi-host: imdb236.p.rapidapi.com",
                "x-rapidapi-key: 43b25bf820msh2d843e72db90b17p143700jsn942d2b5449c1"
            ],
        ]);

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        if ($err) {
            echo "cURL Error #:" . $err;
            return;
        }

        // decode the data
        // decode json
      $data = json_decode($response, true);

      $moviesById = [];
      $count = 0;


     if(is_array($data)){
         $results = $data;
         foreach($results as $item){
             if(!empty($item['id'])){
                 $moviesById[$item['id']] = $item;
                 $count++;

                 // stop after 50 movies
                 if ($count >= 50){
                    break;
                 }
             }
         }

     }

      // for slide view
      session(['latestmovies' => $moviesById]);

      // for movie details view



      // return results
      return view('slideshow', [

          'data' => $moviesById,
      ]);



    }

    public function alltimeshows(){

        //api call

        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => "https://imdb236.p.rapidapi.com/imdb/top250-tv",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => [
                "x-rapidapi-host: imdb236.p.rapidapi.com",
                "x-rapidapi-key: 43b25bf820msh2d843e72db90b17p143700jsn942d2b5449c1"
            ],
        ]);

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        if ($err) {
            echo "cURL Error #:" . $err;
            return;
        }

        // decode the data
        // decode json
      $data = json_decode($response, true);


      $moviesById = [];
        $count = 0;
      if(is_array($data)){
        $results = $data;
        foreach($results as $item){
            if(!empty($item['id'])){
                $moviesById[$item['id']] = $item;
                $count++;

                // stop after 50 movies
                if ($count >= 50){
                   break;
                }
            }
        }

    }

      // for slide view
      session(['latestmovies' => $moviesById]);

      // for movie details view



      // return results
      return view('slideshow', [

          'data' => $moviesById,
      ]);


    }

    public function latestshows(){
        //api call

        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => "https://imdb236.p.rapidapi.com/imdb/upcoming-releases?countryCode=US&type=TV",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => [
                "x-rapidapi-host: imdb236.p.rapidapi.com",
                "x-rapidapi-key: 43b25bf820msh2d843e72db90b17p143700jsn942d2b5449c1"
            ],
        ]);

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        if ($err) {
            echo "cURL Error #:" . $err;
            return;
        }

        // decode the data
        // decode json
      $data = json_decode($response, true);

      $moviesById = [];

      if(is_array($data)){
          $results = $data;
          foreach($results as $item){
              if(!empty($item['titles'])){
                  foreach($item['titles'] as $film){
                      $moviesById[$film['id']] = $film;
                  }

              }
          }

      }

      // for slide view
      session(['latestmovies' => $moviesById]);

      // for movie details view



      // return results
      return view('slideshow', [

          'data' => $moviesById,
      ]);


    }


    public function slide($id){
        // retrieve string from url
        $choice = $id;


        switch($choice) {
            case 'latestmovies':
                return $this->latestmovies();

            case 'latestshows':
                return $this->latestshows();

            case 'alltimemovies':
                return $this->alltimemovies();

            case 'alltimeshows':

                return $this->alltimeshows();



        }
    }

}
