@extends('layouts.app')

@section('content')
<div class="max-w-screen-xl mx-auto p-5 sm:p-10 md:p-16 relative">
    <div class="bg-cover bg-center text-center overflow-hidden"
        style="min-height: 500px; background-image: url('{{ $articleImage ?? 'https://via.placeholder.com/1200x675' }}')"
        title="{{ $articleTitle }}">
    </div>
    <div class="max-w-3xl mx-auto">
        <div class="mt-3 bg-white rounded-b lg:rounded-b-none lg:rounded-r flex flex-col justify-between leading-normal">
            <div class="bg-white relative top-0 -mt-32 p-5 sm:p-10">
                <h1 class="text-gray-900 font-bold text-3xl mb-2">{{ $articleTitle }}</h1>
                <p class="text-gray-700 text-xs mt-2">
                    Written By:
                    <a href="#" class="text-indigo-600 font-medium hover:text-gray-900 transition duration-500 ease-in-out">
                        {{ $articleAuthor }}
                    </a> In

                    <a href="#" class="text-xs text-indigo-600 font-medium hover:text-gray-900 transition duration-500 ease-in-out">
                        {{ $articleCategories }}
                    </a>
                </p>

                <p class="text-base leading-8 my-5">
                    {{ $articleContent }}
                </p>

                <h3 class="text-2xl font-bold my-5">#1. {{ $subheading }}</h3>

                <p class="text-base leading-8 my-5">
                    {{ $subContent }}
                </p>

                <blockquote class="border-l-4 text-base italic leading-8 my-5 p-5 text-indigo-600">
                    {{ $quote }}
                </blockquote>

                <p class="text-base leading-8 my-5">
                    {{ $closingContent }}
                </p>

                @foreach($tags as $tag)
                    <a href="#" class="text-xs text-indigo-600 font-medium hover:text-gray-900 transition duration-500 ease-in-out">
                        #{{ $tag }}
                    </a>@if(!$loop->last), @endif
                @endforeach

            </div>
        </div>
        <!-- New comment section container -->
        <div class="mt-10 border border-gray-200 bg-gray-50 p-6 rounded-lg shadow-md">
            <h2 class="text-xl font-bold mb-4">Discussions</h2>
            <div id="cusdis_thread"
                data-host="https://cusdis.com"
                data-app-id="653d9be1-8439-4202-94d6-0ff119449e3b"
                data-page-id="{{ $articleId }}"
                data-page-url="{{ url()->current() }}"
                data-page-title="{{ $articleTitle }}">
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
    <script async defer src="https://cusdis.com/js/cusdis.es.js"></script>
@endpush
