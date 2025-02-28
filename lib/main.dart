import 'package:flutter/material.dart';
import 'package:fluttertagger/fluttertagger.dart';
import 'package:mentionable_text_field/custom_text.dart';
import 'package:mentionable_text_field/post.dart';
import 'package:mentionable_text_field/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Mention Demo',
      home: const MentionScreen(),
    );
  }
}

class MentionScreen extends StatefulWidget {
  const MentionScreen({super.key});

  @override
  State<MentionScreen> createState() => _MentionScreenState();
}

class _MentionScreenState extends State<MentionScreen> {
  final _controller = FlutterTaggerController();
  final FocusNode _focusNode = FocusNode();
  final List<User> users = [
    User(id: '1', userName: 'Alice'),
    User(id: '2', userName: 'Bob'),
    User(id: '3', userName: 'Charlie'),
    User(id: '4', userName: 'David'),
  ];
  List<User> searchResults = [];
  List<Post> posts = [];

  void _onSearch(String query, String triggerCharacter) {
    if (triggerCharacter == '@') {
      setState(() {
        searchResults = users
            .where((user) =>
                user.userName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _onUserSelected(User user) {
    _controller.addTag(
      id: user.id,
      name: user.userName,
    );
    setState(() {
      searchResults.clear();
    });
  }

  void _onSubmit(String caption) {
    if (caption.isEmpty) return;

    final post = Post(
      caption: caption,
      poster: User(id: '111', userName: 'John Smith'),
      time: DateTime.now().toString(),
    );
    print('submit: $post');

    posts.add(post);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('User Mention Demo')),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
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
                          Text(
                            posts[index].poster.userName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomText(text: posts[index].caption),
                        ],
                      ),
                    ));
                  },
                  itemCount: posts.length,
                ),
              ),
              FlutterTagger(
                controller: _controller,
                onSearch: _onSearch,
                triggerCharacterAndStyles: const {
                  '@': TextStyle(color: Colors.blueAccent),
                },
                overlay: SearchResultView(
                  searchResults: searchResults,
                  onUserSelected: _onUserSelected,
                ),
                builder: (context, textFieldKey) {
                  return TextField(
                      key: textFieldKey,
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        labelText: 'コメントを入力',
                        border: OutlineInputBorder(),
                      ),
                      // onEditingComplete: () => _onSubmit,
                      onSubmitted: (value) {
                        _onSubmit(value);
                        _controller.clear();
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultView extends StatelessWidget {
  final List<User> searchResults;
  final Function(User) onUserSelected;

  const SearchResultView({
    super.key,
    required this.searchResults,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return searchResults.isNotEmpty
        ? Container(
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              children: searchResults
                  .map(
                    (user) => ListTile(
                      title: Text('@${user.userName}'),
                      subtitle: Text(user.id),
                      onTap: () => onUserSelected(user),
                    ),
                  )
                  .toList(),
            ),
          )
        : SizedBox.shrink();
  }
}
