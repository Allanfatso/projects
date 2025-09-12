
@extends('layouts.app')


@section('header')
    <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">
        Explore 2025"
    </h1>
@endsection


@section('content')
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-6">
        <!-- If there's an error, display in red -->
        @if (!empty($error))
            <p class="text-red-600 font-semibold mb-4">
                Error: {{ $error }}
            </p>
        @else
            <!-- Check if data is valid and not empty -->
            @if (!$data || !is_array($data) || empty($data))
                <p class="text-gray-700 dark:text-gray-300">There was an issue processing your request.</p>
            @else

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    @php
                        $films = session('latestmovies', []);
                    @endphp
                    @foreach ($films as $item)
                        @php

                            $movieId     = $item['id']            ?? '';
                            $title       = $item['primaryTitle']  ?? 'Untitled';
                            $description = $item['description']   ?? 'No description.';
                            $image       = $item['primaryImage']  ?? null;
                            $releaseDate = $item['releaseDate']   ?? 'Unknown';
                            $genresArr   = $item['genres']        ?? [];
                            $genres      = is_array($genresArr) ? implode(', ', $genresArr) : '';
                            $rating      = $item['averageRating'] ?? 'N/A';
                        @endphp

                        <!-- Each movie entry card -->
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-4">
                            @if ($image)
                                <a href="{{ route('movie.details', ['id' => $movieId]) }}">
                                    <!-- Responsive image -->
                                    <img
                                        src="{{ $image }}"
                                        alt="{{ e($title) }}"
                                        class="w-full h-auto rounded-md"

                                    >
                                </a>
                            @endif

                            <div class="mt-3">
                                <a href="{{ route('movie.details', ['id' => $movieId]) }}">
                                    <h2 class="text-lg font-semibold text-gray-800 dark:text-gray-100">
                                        {{ e($title) }}
                                    </h2>
                                </a>
                                <p class="text-gray-700 dark:text-gray-300 mt-1">
                                    <strong>Description:</strong> {{ e($description) }}
                                </p>
                                <p class="text-gray-700 dark:text-gray-300 mt-1">
                                    <strong>Release Date:</strong> {{ e($releaseDate) }}
                                </p>
                                <p class="text-gray-700 dark:text-gray-300 mt-1">
                                    <strong>Genres:</strong> {{ e($genres) }}
                                </p>
                                <p class="text-gray-700 dark:text-gray-300 mt-1">
                                    <strong>IMDb Rating:</strong> {{ e($rating) }}
                                </p>
                            </div>
                        </div>
                    @endforeach
                </div>
            @endif
        @endif


        <div class="mt-6">
            <a
                href="{{ route('search') }}"
                class="text-blue-500 hover:text-blue-700 underline"
            >
                Home
            </a>
        </div>
    </div>
@endsection
