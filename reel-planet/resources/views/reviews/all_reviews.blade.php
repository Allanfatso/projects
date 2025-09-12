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
        <!--
        <div class="max-w-2xl mx-auto sm:px-6 lg:px-8 space-y-6">
            <a href="{{ route('review.create') }}" class="underline underline-offset-2 dark:text-gray-300">
                {{ __('Add Review') }}
            </a>
        </div>
    -->
        <div>

            @include('reviews.partials.review_all', ['reviews' => $reviews])

        </div>


    </div>
@endsection
