String? extractYoutubeVideoId(String url) {
  RegExp regExp1 = RegExp(
      r'^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/');
  RegExp regExp2 = RegExp(r'^[a-zA-Z0-9_-]{11}$');

  if (url.contains('youtu.be/')) {
    return url.split('youtu.be/')[1].split('?')[0];
  }

  if (url.contains('watch?v=')) {
    return url.split('watch?v=')[1].split('&')[0];
  }

  Match? match = regExp1.firstMatch(url);
  if (match != null && match.group(7) != null && match.group(7)!.length == 11) {
    return match.group(7);
  }

  if (regExp2.hasMatch(url)) {
    return url;
  }

  return null;
}
