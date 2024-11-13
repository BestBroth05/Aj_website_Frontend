import 'package:guadalajarav2/extensions/str_extension.dart';

enum SocialMedia {
  facebook,
  instagram,
  linkedin,
}

extension SocialMExtencion on SocialMedia {
  String get name {
    if (this != SocialMedia.linkedin) {
      return this.toString().split('.')[1].toTitle();
    } else {
      return 'LinkedIn';
    }
  }

  String get imageURL {
    switch (this) {
      case SocialMedia.facebook:
        return 'assets/icons/fb.png';
      case SocialMedia.instagram:
        return 'assets/icons/instagram.png';
        break;
      case SocialMedia.linkedin:
        return 'assets/icons/linkedin.png';
    }
  }

  String get url {
    switch (this) {
      case SocialMedia.facebook:
      case SocialMedia.instagram:
        return 'http://www.$name.com/';
      case SocialMedia.linkedin:
        return 'http://www.$name.com/in/';
    }
  }
}
