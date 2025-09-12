@extends('layouts.app')

@section('header')

    <h2 class="flex items-center space-x-2 font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
        <a href="{{route('review.index')}}" class="text-blue-500 hover:underline">
            {{__('Review')}}
        </a>
    </h2>

@endsection

@section('content')
    <div class="py-12">
        <div class="max-w-2xl mx-auto sm:px-6 lg:px-8 space-y-6">

            <div class="mt-6 bg-white shadow-sm rounded-lg divide-y dark:bg-gray-700 dark:divide-gray-500">
                @foreach($reviews as $review)
                    @include('reviews.partials.review', ['review' => $review])
                @endforeach
            </div>
        </div>
    </div>
@endsection
