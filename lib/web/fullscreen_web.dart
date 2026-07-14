import 'package:web/web.dart' as web;

void requestFullscreen() {
  final element = web.document.documentElement;
  if (element == null) return;
  if (web.document.fullscreenElement == null) {
    element.requestFullscreen();
  } else {
    web.document.exitFullscreen();
  }
}
