<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ReviewController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ImdbController;
use App\Http\Controllers\ReviewMovieController;
use App\Http\Controllers\Fullreview;
use App\Http\Controllers\VideoController;



Route::get('/', function () {
    return view('welcome');
})->name("root.home");

Route::get('/reel/{id}', [ImdbController::class, 'slide'])
    ->name('entertainment.reels');

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
        // Search route
    Route::get('/search', [ImdbController::class, 'search'])->name('search');
    Route::get('/movie_details/{id}', [ReviewMovieController::class, 'show'])->name('movie.details');
        // {id} is passed to show() function.

});


// readmore route may not need to have user auth for reviewed movies.

Route::get('reviews/ajax/fullreview/{review}', [Fullreview::class, 'readmore'])
    ->name('read.more');

// ajax
Route::get('reviews/ajax/{id}', [ReviewController::class, 'getAjaxReviews'])
    ->name('review.ajax');

// return null
route::get('/null', function(){
    return view('welcome');
})->name('read.none');

Route::get('reviews/{reviews}', [ReviewController::class, 'display'])
    ->name('review.display');


// multiple routes below for index, create and store.
Route::resource('review', ReviewController::class)
    ->only(['index', 'create', 'store', 'edit', 'update', 'destroy'])
    ->middleware(['auth', 'verified']);



require __DIR__.'/auth.php';
