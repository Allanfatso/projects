
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <title>Laravel</title>

            <!-- Fonts -->
            <link rel="preconnect" href="https://fonts.bunny.net">
            <link href="https://fonts.bunny.net/css?family=instrument-sans:400,500,600" rel="stylesheet" />

            <!-- Styles / Scripts -->
            @if (file_exists(public_path('build/manifest.json')) || file_exists(public_path('hot')))
                @vite(['resources/css/app.css', 'resources/js/app.js'])
            @else

            @endif
        </head>
        <body class="bg-[#FDFDFC] dark:bg-[#0a0a0a] text-[#1b1b18] flex p-6 lg:p-8 items-center lg:justify-center min-h-screen flex-col">

            <header class="w-full lg:max-w-4xl max-w-[335px] text-sm mb-6 not-has-[nav]:hidden">
                @if (Route::has('login'))
                    <nav class="flex items-center justify-end gap-4">
                        @auth
                            <a href="{{ url('/dashboard') }}" class="inline-block px-5 py-1.5 text-white font-medium rounded-lg transition-all
                            bg-[#BF360C] hover:bg-[#E64A19] shadow-md">Explore</a>
                        @else
                            <a href="{{ route('login') }}" class="inline-block px-5 py-1.5 text-white font-medium rounded-lg transition-all
                            bg-[#FF7043] hover:bg-[#FF8A65] shadow-md">Log in</a>
                            @if (Route::has('register'))
                                <a href="{{ route('register') }}" class="inline-block px-5 py-1.5 text-white font-medium rounded-lg transition-all
                                bg-[#BF360C] hover:bg-[#E64A19] shadow-md">Register</a>
                            @endif
                        @endauth
                    </nav>
                @endif
            </header>

            <div
            class="hero min-h-screen"
            style="background-image: url('{{ asset('images/all_movs.jpg') }}');">
            <div class="hero-overlay bg-opacity-60"></div>
            <div class="hero-content text-neutral-content text-center">
              <div class="max-w-md">
                <h1 class="mb-5 text-5xl font-bold">Welcome</h1>
                <p class="mb-5">
                    ReelPlanet. The home of quality entertainment and reviews.
                </p>
                <a href="{{ url('/dashboard') }}" class="inline-block px-5 py-1.5 text-white font-medium rounded-lg transition-all
                bg-[#FF7043] hover:bg-[#FF8A65] shadow-md">Discover</a>
              </div>
            </div>
          </div>
            <!-- Extra spacing if logged in -->
            @if (Route::has('login'))
                <div class="h-14.5 hidden lg:block"></div>
            @endif



        </body>
        <footer class="footer footer-center p-4 bg-orange-100 text-orange-900">
            <aside>
            <p>Copyright © 2025 - All right reserved by Allan Industries Ltd</p>
            <p>Hero welcome page picture by Freepik</p>
            </aside>
        </footer>
</html>

