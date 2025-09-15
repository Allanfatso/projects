<?php

namespace App\Http\Controllers;

use App\Models\Movie;
use App\Models\Review;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\Request;


class ReviewController extends Controller
{
    use AuthorizesRequests;

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // show your own reviews only
        return view('reviews.index', [

            // fetches all reviews from the database and orders them by the latest for the user.

            // SELECT * FROM reviews LEFT JOIN users ON user.id = reviews.user_id ORDER BY reviews.created_at DESC;
            'reviews' => Review::with('user')->where('user_id', '=',auth()->id())->latest()->get(),
        ]);





    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
        return view('reviews.create', ['review' => null]);

    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {


        //form validation so message is always required, string.
        // 1024 characters
        // validate movie details as well



        $validated = $request->validate([
            'message' => ['required', 'string', 'max:1024'],
            'movie_title' => 'nullable|string',
            'image' => 'nullable|string',
            'description' => 'nullable|string',
            'genres' => 'nullable|string',
            'releaseDate' => 'nullable|string',

        ]);

        // store the array values individually

        // firorcreate searches model first for a row with attribute. If it exists
        // row is assigned to movie, if not together with attribute and values
        // they get assigned into the db.
        $movie = Movie::firstOrCreate(
            ['movie_title' => $validated['movie_title']],
            [
                'image' => $validated['image'],
                'description' => $validated['description'],
                'genres' => $validated['genres'],
                'releaseDate' => $validated['releaseDate'],
            ]

            );

            // goes into the reviews model
        $request->user()->reviews()->create([
            'message' => $validated['message'],
            'movie_id' => $movie->id,
        ]);





        // method defined in user model.
        // this stores the review in the database based on the user
        //$request->user()->reviews()->create($validated);

        // risk of user salvaging mass assignment vulnerability(overwriting fields)
        // laravel blocks this by default
        // we'll need to enable mass assignment in the model only for the message field
        // done in review.php model


        return redirect()->route('review.index');

    }

    /**
     * Display the specified resource.
     */
    public function show()
    {
        //

    }


    public function display()
    {
        $reviews = Movie::with(['reviews.user'])->orderByDesc('releaseDate')->get();

        return view('reviews.all_reviews', [
            'reviews' => $reviews,

        ]);
    }

    public function getAjaxReviews($id)
    {
        $movie = Movie::with(['reviews.user'])->findOrFail($id);
        $reviews = $movie->reviews->slice(1); // Get all reviews except the first one

        $html = '';
        foreach ($reviews as $review) {
            $html .= view('reviews.partials.review_card', ['review' => $review])->render();
        }

        return response()->json(['html' => $html]);
    }






    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Review $review)
    {
        $this->authorize('update', $review);



        return view('reviews.edit', [
            'review' => $review,

        ]);

    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Review $review)
    {
        //
       $this->authorize('update', $review);

       $validated =$request->validate([
            'message' => ['required', 'string', 'max:1024'],
        ]);

        $review->update($validated);

        return redirect(route('review.index'))->with('success', 'Review updated successfully');


    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Review $review)
    {
        // return redirect()->back()->with('success', 'Review deleted.');
        $movie = $review->movie;

        $this->authorize('delete', $review);
        $review->delete();
        // if no other review exists for movie, delete it
        if ($movie->reviews()->count() === 0) {
            $movie->delete();
        }

        return redirect()->back()->with('success', 'Review deleted.');
    }
}
