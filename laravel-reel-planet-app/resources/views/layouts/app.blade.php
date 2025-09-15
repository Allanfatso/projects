<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'Reel-planet') }}</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

        <!-- DaisyUI -->
        <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

        <!-- Orientation api -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let out = document.getElementById('output');

                function getOrientation() {
                    let _orn = screen.msOrientation || (screen.orientation ? screen.orientation.type : undefined);

                    switch (_orn) {
                        case 'portrait-primary':
                        case 'portrait-secondary':
                            console.log("Portrait mode");
                            break;
                        case 'landscape-primary':
                            console.log("This is the laptop/desktop version");
                            break;
                        case 'landscape-secondary':
                            console.log("Upside-down landscape mode");
                            break;
                        default:
                            console.log("Orientation not supported or unknown");
                    }

                    return _orn || "Not supported";
                }

                function updateOrientation() {
                    let orn = getOrientation();
                    if (out) {
                        out.textContent = `Current Orientation: ${orn}`;
                    }
                }

                updateOrientation(); // Initial check

                if (screen.orientation) {
                    screen.orientation.addEventListener("change", updateOrientation);
                } else {
                    window.addEventListener("resize", updateOrientation);
                }
            });
        </script>



        <!-- Daisy themes -->
        <link href="https://cdn.jsdelivr.net/npm/daisyui@5/themes.css" rel="stylesheet" type="text/css" />

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    <body class="font-sans antialiased">
        <div class="min-h-screen bg-gray-100 dark:bg-gray-900">
            @include('layouts.navigation')

            <!-- Page Heading -->
            @isset($header)
                <header class="bg-white dark:bg-gray-800 shadow">
                    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                        {{ $header }}
                    </div>
                </header>
            @endisset

            <!-- Page Content -->
            <!-- Replaced $slot with yield('content') -->
            <main>
                @yield('content')
                @stack('scripts')
            </main>
        </div>
    </body>
    <footer class="footer footer-center p-4 bg-orange-100 text-orange-900">
        <aside>
        <p>Copyright © 2025 - All right reserved by Allan Industries Ltd</p>
        </aside>
        <p id="output"></p>
    </footer>
</html>
