<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Model;

class Posts extends Model
{
    use SoftDeletes;
    protected $dates = ['deleted_at'];

    /*
        mass assignable attributes
    */
    protected $fillable = ['title', 'body', 'image'];

    //
    public function user(){
        // one-to-many relationship
        return $this->belongsTo(User::class);
    }

    public function comments()
    {
        // one-to-may relationship between user and review
        // allows for easy access to all reviews by a user with $user->reviews
        return $this->hasMany(Comment::class)
        ->whereNull('parent_id');
    }


}
