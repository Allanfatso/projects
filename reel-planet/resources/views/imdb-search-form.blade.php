<!-- resources/views/imdb-search-form.blade.php -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>IMDb Search Form</title>
</head>
<body>
    <h1>IMDb Search</h1>
    <form action="{{ route('search') }}" method="GET">
        <label for="query">Search term:</label>
        <input type="text" name="query" id="query" required>
        <button type="submit">Search</button>
    </form>
</body>
</html>
