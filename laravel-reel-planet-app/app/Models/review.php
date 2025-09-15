<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    // enable mass assignment for the message field
    // bulk insertion of data into this column is allowed.
    protected $fillable = [
        'message',
        'movie_id',
    ];

    // defining relationship.

    public function user(){
        // one-to-many relationship
        return $this->belongsTo(User::class);
    }


    public function movie()
    {
        return $this->belongsTo(Movie::class);
    }
}

// models interact directly with db and perform CRUD operations.
// They offer abstraction, simplicity and they are maintainable with code reusability.

// Laravel uses eloquent (Obejct Relational Mapping) ORM to interact with db.

// CRUD operations:
/*
Create: User::create($data) like select * from users;
Read: User::find(1); like select * from users where id = 1;
Update: $user->update(['email' => 'new@email.com']); like update users set email = '
Delete: $user->delete(); like delete from users where id = 1;
*/
