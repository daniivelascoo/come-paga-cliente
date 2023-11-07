import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class Utils {
  static checkStatus(Response response) {
    if (response.statusCode >= 400) {}
  }

  static MediaType? getImageContentType(String ext) {
    var contentType;
    switch (ext.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        contentType = MediaType('image', 'jpeg');
        break;
      case 'png':
        contentType = MediaType('image', 'png');
        break;
      case 'gif':
        contentType = MediaType('image', 'gif');
        break;
      case 'bmp':
        contentType = MediaType('image', 'bmp');
        break;
      case 'webp':
        contentType = MediaType('image', 'webp');
        break;
      case 'svg':
        contentType = MediaType('image', 'svg+xml');
        break;
      case 'ico':
        contentType = MediaType('image', 'vnd.microsoft.icon');
        break;
      case 'tiff':
        contentType = MediaType('image', 'tiff');
        break;
      case 'jp2':
        contentType = MediaType('image', 'jp2');
        break;
      case 'jxr':
        contentType = MediaType('image', 'jxr');
        break;
      default:
        throw UnsupportedError('Tipo de imagen no admitido: $ext');
    }
    return contentType;
  }
}
