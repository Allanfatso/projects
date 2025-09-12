<div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">
    <form id="reviewForm" action="
        @if(isset($review))
            {{ route('review.update', $review) }}
        @else
            {{ route('review.store') }}
        @endif" method="POST" class="w-full">
        @csrf

        @if(isset($review))
            @method('PUT')
        @endif

        <!-- hidden form for movie details-->
        @if(!empty($movie))
            <input type="hidden" name="movie_title" value="{{ $movie['primaryTitle'] }}">
            <input type="hidden" name="image" value="{{ $movie['primaryImage'] }}">
            <input type="hidden" name="description" value="{{ $movie['description'] }}">
            <input type="hidden" name="genres" value="{{ implode(',', $movie['genres']) }}">
            <input type="hidden" name="releaseDate" value="{{ $movie['releaseDate'] }}">
        @endif

        <div>
            <x-input-label for="message" :value="__('Message')" class="sr-only" />
            <x-textarea-input
                id="textbox"
                name="message"
                placeholder="{{ __('What do you think about the movie?') }}"
                class="block w-full border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-indigo-500 dark:focus:border-indigo-600 focus:ring-indigo-500 dark:focus:ring-indigo-600 rounded-md shadow-sm"
                :value="old('message', $review?->message)"
            />
            <x-input-error :messages="$errors->get('message')" class="mt-2" />
        </div>

        <div class="mt-6 flex items-center space-x-4">
            <x-primary-button>
                {{ __('Review') }}
            </x-primary-button>
            @if(isset($review))
                <a href="{{ route('review.index') }}" class="dark:text-gray-400 hover:underline">
                    {{ __('Cancel') }}
                </a>
            @endif
            <!-- Speech to Text Button -->
            <button id="button" type="button" class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition">
                {{ __('Speak to Write') }}
            </button>
        </div>

    </form>

    @push('scripts')
        <script>
            document.getElementById('reviewForm').addEventListener('submit', function(event) {
                // Prevent form from submitting
                event.preventDefault();

                // Get message input value
                var messageInput = document.getElementById('textbox');
                var message = messageInput.value.trim();

                // Check if message is empty
                if (message === '') {
                    alert('Please enter your review before submitting.');
                    messageInput.focus();
                } else {
                    this.submit();
                }
            });
        </script>

        <!-- Speech recognition-->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
            var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            var recognition = new SpeechRecognition();

            var textbox = $("#textbox");
            var content = '';

            recognition.continuous = true;

            recognition.onresult = function(event) {
                var current = event.resultIndex;
                var transcript = event.results[current][0].transcript;
                content += transcript + " ";
                textbox.val(content);
            };

            // Start speech-to-text when button is clicked
            $("#button").click(function(event) {
                recognition.start();
            });

            // Update content with typed input
            textbox.on('input', function() {
                content = $(this).val();
            });
        </script>
    @endpush

</div>
