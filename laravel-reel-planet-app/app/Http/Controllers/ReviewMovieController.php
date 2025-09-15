<?php

namespace App\Http\Controllers;



class ReviewMovieController extends Controller
{

    // search function
    public function show($id){
        // Retrieve array from session
        //  $storedMovies = session('latestmovies', []);

        $storedMovies = session('searchResults', []);
        $latestmovies = session('latestmovies', []);

        $movie = [];




        // check if movie id is there
        if ((isset($storedMovies[$id]))){
            // return blade of the movie details
            $movie = $storedMovies[$id];
        } elseif (isset($latestmovies[$id])){
            $movie = $latestmovies[$id];



        }else if ((!isset($storedMovies[$id])) && (!isset($latestmovies[$id]))){
            abort(404, 'Movie not found or session expired');
        }


        // return blade of the movie details
        return view('movie-details', [
            'movie' => $movie,
            'review' => null
        ]);


    }

}
