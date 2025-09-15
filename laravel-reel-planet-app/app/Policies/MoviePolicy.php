<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Review;
use App\Models\Movie;

class MoviePolicy
{
    /**
     * Create a new policy instance.
     */

    public function delete(User $user, Movie $movie): bool
    {
        return $movie->reviews->contains('user_id', $user->id);
    }

    public function __construct()
    {
        //return $user->is($review->user);
    }
}
