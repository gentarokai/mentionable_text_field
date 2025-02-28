import 'package:mentionable_text_field/model/user.dart';

class Post {
  final String caption;
  final User poster;
  final String time;

  Post({
    required this.caption,
    required this.poster,
    required this.time,
  });
}
