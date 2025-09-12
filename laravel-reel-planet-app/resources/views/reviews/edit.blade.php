<x-app-layout>
    <x-slot name="header">
        <h2 class="flex items-center space-x-1 font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            <a href="{{ route('review.index') }}" class="text-blue-500 hover:underline">
                {{ __('Reviews') }}
            </a>
            <span>/</span>
            {{ __('Edit Review') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-2xl mx-auto sm:px-6 lg:px-8 space-y-6">
            @include('reviews.partials.form_edit', ['review' => $review, 'movie' => $movie ?? null])
        </div>
    </div>
</x-app-layout>
