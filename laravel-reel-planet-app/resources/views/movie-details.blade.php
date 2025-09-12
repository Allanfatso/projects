@extends('layouts.app')

@section('header')
    <h1 class="text-2xl font-bold text-gray-800 dark:text-gray-100">
         "{{ $movie['primaryTitle'] ?? 'Movie' }}"
    </h1>
@endsection

@section('content')
    @php
        $allowedKeys = [
            'description' => 'Description',
            'releaseDate' => 'Release Date',
            'contentRating' => 'Age Rating',
            'genres' => 'Genres',
            'averageRating' => 'IMDb Score',
            'runtimeMinutes' => 'Runtime',
            'budget' => 'Budget',
            'grossWorldwide' => 'Gross Worldwide',
        ];
    @endphp

    <div class="max-w-7xl mx-auto py-12 px-6">
        <div class="grid grid-cols-1 md:grid-cols-2 md:gap-8 items-start">
            <!-- Left Column-->
            <div class="flex justify-center mb-8 md:mb-0">
                @if(!empty($movie['primaryImage']))
                    <img
                        src="{{ $movie['primaryImage'] }}"
                        alt="{{ e($movie['primaryTitle']) }}"
                        class="rounded-lg shadow-lg max-w-full md:max-w-sm lg:max-w-md object-cover"
                    >
                @endif
            </div>

            <!-- Right Column -->
            <div>
                <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-100 mb-4">
                    {{ e($movie['primaryTitle'] ?? 'Unknown Title') }}
                </h2>

                @foreach ($allowedKeys as $key => $label)
                    @if (!empty($movie[$key]))
                        <p class="text-lg leading-relaxed text-gray-700 dark:text-gray-300 mt-3">
                            <strong>{{ $label }}:</strong>
                            @if (is_array($movie[$key]))
                                {{ implode(', ', $movie[$key]) }}
                            @else
                                {{ e($movie[$key]) }}
                            @endif
                        </p>
                    @endif
                @endforeach
                <!-- Review movie-->
                <div class="py-12">
                    <div class="max-w-2xl mx-auto sm:px-6 lg:px-8 space-y-6">
                        @include('reviews.partials.form', ['movie' => $movie])
                    </div>
                </div>


            </div>
        </div>
    </div>



@endsection
