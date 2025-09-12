@extends('layouts.app')

@section('header')
    <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
        {{ __('Explore') }}
    </h2>
@endsection

@section('content')
    <!-- Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100 text-center font-bold">
                    {{ __("Explore") }}
                </div>
            </div>
        </div>
    </div>

    <!-- Main-->
    <div class="transition-opacity opacity-100 duration-750 lg:grow starting:opacity-0">
      <main class="flex flex-col w-full max-w-4xl mx-auto gap-4">
        <!-- Heading -->
        <section class="relative w-full overflow-hidden rounded-lg">
          <div
            class="relative bg-cover bg-center flex items-center justify-center p-6"
            style="background-image: url('{{ asset('images/shelf.jpg') }}');"
          >
            <!-- Dark -->
            <div class="absolute inset-0 bg-black/40"></div>

            <!-- Content container -->
            <div class="relative text-center max-w-sm text-white z-10">
              <h2 class="text-xl font-bold">Your Gateway to the Best Movies &amp; TV</h2>
              <p class="mt-2">
                Explore new releases, discover timeless classics,
                and share reviews with the world.
              </p>
            </div>
          </div>

          <div
            class="absolute inset-0 rounded-lg
                   shadow-[inset_0px_0px_0px_1px_rgba(26,26,0,0.16)]
                   dark:shadow-[inset_0px_0px_0px_1px_#fffaed2d]"
          ></div>
        </section>

        <!-- Slideshow -->
        @php
          $slideRoutes = [
              'latestmovies' => route('entertainment.reels', ['id' => 'latestmovies']),
              'latestshows' => route('entertainment.reels', ['id' => 'latestshows']),
              'alltimemovies' => route('entertainment.reels', ['id' => 'alltimemovies']),
              'alltimeshows' => route('entertainment.reels', ['id' => 'alltimeshows']),
              'all_user_reviews' => route('review.display', ['reviews' => 'user.reviews']),
          ];
        @endphp

        <section
          x-data="{
              slides: [
                  {
                      imgSrc: '{{ asset('images/new_films.jpg') }}',
                      imgAlt: 'Upcoming movies',
                      title: 'Upcoming films',
                      url_data: '{{ $slideRoutes['latestmovies'] }}'
                  },
                  {
                      imgSrc: '{{ asset('images/new_shows.jpg') }}',
                      imgAlt: 'Upcoming Shows.',
                      title: 'Upcoming tv-shows',
                      url_data: '{{ $slideRoutes['latestshows'] }}'
                  },
                  {
                      imgSrc: '{{ asset('images/all_times_best_film.jpg') }}',
                      imgAlt: 'All time best movies',
                      title: 'All-time best movies',
                      url_data: '{{ $slideRoutes['alltimemovies'] }}'
                  },
                  {
                      imgSrc: '{{ asset('images/all_times_best_shows.jpg') }}',
                      imgAlt: 'All-time best tv-shows',
                      title: 'All-time best tv-shows',
                      url_data: '{{ $slideRoutes['alltimeshows'] }}'
                  },
                  {
                      imgSrc: '{{ asset('images/reviews.jpg') }}',
                      imgAlt: 'All user reviews',
                      title: 'Explore the reviews',
                      url_data: '{{ $slideRoutes['all_user_reviews'] }}'
                  },
              ],
              currentSlideIndex: 1,
              previous() {
                  if (this.currentSlideIndex > 1) {
                      this.currentSlideIndex = this.currentSlideIndex - 1
                  } else {
                      this.currentSlideIndex = this.slides.length
                  }
              },
              next() {
                  if (this.currentSlideIndex < this.slides.length) {
                      this.currentSlideIndex = this.currentSlideIndex + 1
                  } else {
                      this.currentSlideIndex = 1
                  }
              },
          }"
          class="relative w-full overflow-hidden rounded-lg aspect-video"
        >
          <!-- previous button -->
          <button
            type="button"
            class="absolute left-5 top-1/2 z-20 flex rounded-full -translate-y-1/2 items-center justify-center bg-white/40 p-2 text-neutral-600 transition hover:bg-white/60 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:outline-offset-0 dark:bg-neutral-950/40 dark:text-neutral-300 dark:hover:bg-neutral-950/60 dark:focus-visible:outline-white"
            aria-label="previous slide"
            x-on:click="previous()"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              stroke="currentColor"
              fill="none"
              stroke-width="3"
              class="size-5 md:size-6 pr-0.5"
              aria-hidden="true"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
            </svg>
          </button>

          <!-- next button -->
          <button
            type="button"
            class="absolute right-5 top-1/2 z-20 flex rounded-full -translate-y-1/2 items-center justify-center bg-white/40 p-2 text-neutral-600 transition hover:bg-white/60 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:outline-offset-0 dark:bg-neutral-950/40 dark:text-neutral-300 dark:hover:bg-neutral-950/60 dark:focus-visible:outline-white"
            aria-label="next slide"
            x-on:click="next()"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              stroke="currentColor"
              fill="none"
              stroke-width="3"
              class="size-5 md:size-6 pl-0.5"
              aria-hidden="true"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
          </button>

          <!-- slides -->
          <div class="relative w-full h-full">
            <template x-for="(slide, index) in slides" :key="index">
              <div
                x-cloak
                x-show="currentSlideIndex == index + 1"
                class="absolute inset-0"
                x-transition.opacity.duration.1000ms
              >
                <!-- Title and description -->
                <div
                  class="lg:px-32 lg:py-14 absolute inset-0 z-10 flex flex-col items-center justify-end gap-2
                         bg-linear-to-t from-neutral-950/85 to-transparent px-16 py-12 text-center"
                >
                  <h4 class="w-full lg:w-[80%] text-balance font-bold text-white">
                    <a
                      :href="slide.url_data"
                      class="hover:text-orange-500 transition-colors duration-300"
                      x-text="slide.title"
                    ></a>
                  </h4>
                  <p
                    class="lg:w-1/2 w-full text-pretty text-sm text-neutral-300"
                    x-text="slide.description"
                    x-bind:id="'slide' + (index + 1) + 'Description'"
                  ></p>
                </div>
                <img
                  class="absolute w-full h-full inset-0 object-cover text-neutral-600 dark:text-neutral-300"
                  x-bind:src="slide.imgSrc"
                  x-bind:alt="slide.imgAlt"
                />
              </div>
            </template>
          </div>
        </section>
      </main>
    </div>


    @if (Route::has('login'))
      <div class="h-14.5 hidden lg:block"></div>
    @endif
@endsection
