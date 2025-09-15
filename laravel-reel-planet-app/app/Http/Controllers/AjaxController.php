<?php

namespace App\Http\Controllers;


class AjaxController extends Controller
{
    public function index() {
        $msg = "This is a simple message.";
        return response()->json(array('msg'=> $msg), 200);
     }
}
