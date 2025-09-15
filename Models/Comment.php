<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    //

    use Softdeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = ['user_id', 'post_id', 'parent_id',
    'body'];

    public function user(){
        // one-to-many relationship
        return $this->belongsTo(User::class);
    }

    public function replies(){
        // this should be seperate model and table.
        return $this->hasMany(Comment::class, 'parent_id');
    }


}
