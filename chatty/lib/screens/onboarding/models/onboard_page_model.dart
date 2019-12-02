import 'dart:ui';

class OnboardPageModel {
  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color gradientColor4;
  final int pageNumber;
  final String imagePath;
  final String caption;
  final String subhead;
  final String description;

  OnboardPageModel(this.gradientColor1, this.gradientColor2, this.gradientColor3, this.gradientColor4, this.pageNumber, this.imagePath,
      this.caption, this.subhead, this.description);
}