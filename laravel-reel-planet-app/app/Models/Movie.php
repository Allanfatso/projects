<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Movie extends Model
{
    //
    protected $fillable = [
        'movie_title',
        'image',
        'description',
        'genres',
        'releaseDate',
    ];

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

}
