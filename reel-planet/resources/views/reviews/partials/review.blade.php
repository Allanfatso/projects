

<div class="p-6 flex space-x-2">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-600 dark:text-gray-400 -scale-x-100" fill="none" viewBox="0 0 24 24"
        stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round"
            d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
    </svg>

    <div class="flex-1">
        <div class="flex justify-between items-center">
            <div>
                <span class="text-gray-800 dark:text-gray-200">{{ $review->user->name }}</span>
                <small class="ml-2 text-sm text-gray-600 dark:text-gray-400">{{ $review->created_at->diffForHumans() }}</small>
                <small class="ml-2 text-sm text-gray-600 dark:text-gray-400"><x-local-time-ago :value="$review->created_at" /></small>
                @if ($review->created_at->ne($review->updated_at)) <!-- ne() is not equal -->
                <!--  check if the review has been edited or if it is the original -->
                    <small class="text-sm text-gray-600 dark:text-gray-500"> &middot; edited</small>
                @endif


            </div>

            @if (Auth::id() === $review->user->id)
            <x-dropdown align="right" width="48">
                <x-slot name="trigger">
                    <button>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                            <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" />
                        </svg>
                    </button>
                </x-slot>

                <x-slot name="content">
                    <x-dropdown-link href="{{ route('review.edit', $review) }}">{{ __('Edit') }}</x-dropdown-link>

                    <form action="{{ route('review.destroy', $review) }}" method="POST">
                        @method('DELETE')
                        @csrf
                        <button type="submit" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                            {{ __('Delete') }}
                        </button>
                    </form>
                </x-slot>
            </x-dropdown>
            @endif

        </div>
        <p class="mt-4 text-lg text-gray-900 dark:text-gray-200">{{ $review->message }}</p>
    </div>
</div>


