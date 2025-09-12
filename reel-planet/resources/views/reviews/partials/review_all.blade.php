@foreach ($reviews as $movie)
    <div class="max-w-7xl mx-auto py-12 px-6">
        <div class="grid grid-cols-1 md:grid-cols-2 md:gap-8 items-start">

            <div class="flex justify-center mb-8 md:mb-0">
                <img src="{{ $movie->image }}" class="rounded-lg shadow-lg max-w-full md:max-w-sm lg:max-w-md object-cover">
            </div>

            <div>
                <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-100 mb-4">
                    {{ e($movie->movie_title) }}
                </h2>


                @php
                    $allowedKeys = [
                        'Title' => $movie->movie_title,
                        'Description' => $movie->description,
                        'Release Date' => $movie->releaseDate,
                        'Genres' => $movie->genres,
                    ];
                @endphp

                @foreach ($allowedKeys as $key => $value)
                    @if (!empty($value))
                        <p class="text-lg leading-relaxed text-gray-700 dark:text-gray-300 mt-3">
                            <strong>{{ $key }}:</strong> {{ e($value) }}
                        </p>
                    @endif
                @endforeach


                <div class="mt-6">
                    <h3 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">Reviews</h3>

                    <div id="reviews-container-{{ $movie->id }}">
                        @if ($movie->reviews->isNotEmpty())
                            <!-- Show only the first review -->
                            @include('reviews.partials.review_card', ['review' => $movie->reviews->first()])
                        @endif
                    </div>

                    @if ($movie->reviews->count() > 1)
                        <button class="see-more-btn bg-orange-700 text-white px-4 py-2 rounded-lg mt-4" data-movie-id="{{ $movie->id }}">
                            See More
                        </button>
                    @endif

                    @if ($movie->reviews->isEmpty())
                        <p>No reviews yet.</p>
                    @endif
                </div>
            </div>
        </div>
    </div>
@endforeach

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function() {
    const seeMoreButtons = document.querySelectorAll('.see-more-btn');

    seeMoreButtons.forEach(button => {
        button.addEventListener('click', function() {
            const movieId = this.getAttribute('data-movie-id');
            const container = document.getElementById('reviews-container-' + movieId);

            fetch('/reviews/ajax/' + movieId)
                .then(response => response.json())
                .then(data => {
                    container.innerHTML += data.html;
                    this.remove(); // Removes the See More button after loading
                })
                .catch(error => console.error('Error:', error));
        });
    });
});
</script>
@endpush
