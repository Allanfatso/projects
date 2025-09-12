@extends('layouts.app')

@section('content')
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">
            <form action="@if($review) {{ route('review.update', $review) }} @else {{ route('review.store') }} @endif" method="POST" class="w-full">
                @csrf
                @if($review)
                    @method('PUT')
                @endif

                <div>
                    <x-input-label for="message" :value="__('Message')" class="sr-only" />
                    <x-textarea-input
                        id="message"
                        name="message"
                        placeholder="{{ __('What do you think about the movie?') }}"
                        class="block w-full border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-indigo-500 dark:focus:border-indigo-600 focus:ring-indigo-500 dark:focus:ring-indigo-600 rounded-md shadow-sm"
                        :value="old('message', $review?->message ?? '')"
                    />
                    <x-input-error :messages="$errors->get('message')" class="mt-2" />
                </div>

                <div class="mt-6 flex items-center space-x-4">
                    <x-primary-button>
                        {{ __('Review') }}
                    </x-primary-button>
                    @if($review)
                        <a href="{{ route('review.index') }}" class="dark:text-gray-400 hover:underline">
                            {{ __('Cancel') }}
                        </a>
                    @endif
                </div>
            </form>
        </div>
    </div>
@endsection
