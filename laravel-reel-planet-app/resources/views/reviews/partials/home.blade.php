<div class="carousel carousel-end rounded-box">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @php
        $slideRoutes = [
            'latestmovies' => route('entertainment.reels', ['id' => 'latestmovies']),
            'latestshows' => route('entertainment.reels', ['id' => 'latestshows']),
            'alltimemovies' => route('entertainment.reels', ['id' => 'alltimemovies']),
            'alltimeshows' => route('entertainment.reels', ['id' => 'alltimeshows']),
            'all_user_reviews' => route('review.display', ['reviews' => 'user.reviews']),
            ];
    @endphp

    <div class="carousel-item">
      <img src="{{ asset('images/new_films.jpg')}}" alt="new films" />
    </div>
    <div class="carousel-item">
      <img
        src="{{ asset('images/new_shows.jpg')}}"
        alt="new shows" />
    </div>
    <div class="carousel-item">
      <img
        src="{{ asset('images/all_times_best_film.jpg')}}"
        alt="All time best films" />
    </div>
    <div class="carousel-item">
      <img
        src="{{ asset('images/all_times_best_shows.jpg')}}"
        alt="All time best shows" />
    </div>
    <div class="carousel-item">
      <img src="{{ asset('images/reviews.jpg')}}" alt="All reviews" />
    </div>

    <footer class="footer footer-center p-4 bg-orange-100 text-orange-900">
        <aside>
        <p>Copyright © 2025 - All right reserved by Allan Industries Ltd</p>
        </aside>
    </footer>
</div>
