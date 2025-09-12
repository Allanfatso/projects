<div class="max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow-sm dark:bg-gray-800 dark:border-gray-700 mb-4">
    <h5 class="mb-2 text-xl font-bold tracking-tight text-gray-900 dark:text-white">
        Review by: {{ $review->user->name }}
    </h5>
    <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
        {{ $review->message }}
    </p>
    <a href="
    @if(isset($review))
        {{ route('read.more', $review) }}
    @else
        {{ route('read.none') }}
    @endif" class="inline-flex items-center px-3 py-2 text-sm font-medium text-center text-white bg-orange-700 rounded-lg hover:bg-orange-800 focus:ring-4 focus:outline-none focus:ring-orange-300 dark:bg-orange-600 dark:hover:bg-orange-700 dark:focus:ring-orange-800">
        Read more
        <svg class="rtl:rotate-180 w-3.5 h-3.5 ms-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
        </svg>
    </a>
</div>
