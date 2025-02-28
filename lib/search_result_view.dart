import 'package:flutter/material.dart';
import 'package:mentionable_text_field/model/user.dart';

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
