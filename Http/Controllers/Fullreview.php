<?php

namespace App\Http\Controllers;

use App\Models\Review;

class Fullreview extends Controller
{
    //
    public function readmore(Review $review)
    {
       return view('reviews.fullreview', [
            'articleTitle' => $review->movie->movie_title,
            'articleAuthor' => $review->User->name,
            'articleImage' => $review->movie->image,
            'articleCategories' => $review->movie->genres,
            'articleContent' => $review->message,
            'articleId' => $review->id,
            'subheading' => 'What is the verdict?',
            'subContent' => 'Thoughts...',
            'quote' => '...',
            'closingContent' => '...',
            'tags' => ['Review', 'Thoughts', 'Genre', 'Score', 'Screen']
        ]);
    }



}
