import 'package:flutter/material.dart';
import 'package:mentionable_text_field/model/post.dart';
import 'package:mentionable_text_field/post/post_text.dart';

class PostListView extends StatelessWidget {
  const PostListView({
    super.key,
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (posts.isEmpty) {
            return Center(
              child: Text('No users'),
            );
          }
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 投稿者
                Text(
                  posts[index].poster.userName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 投稿内容
                PostText(text: posts[index].caption),
              ],
            ),
          ));
        },
        itemCount: posts.length,
      ),
    );
  }
}
