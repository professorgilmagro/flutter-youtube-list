import 'package:flutter/material.dart';
import 'package:ytf_app/services/api.dart';

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  snapshot.data[index],
                  style: TextStyle(color: Colors.black87),
                ),
                leading: Icon(Icons.play_arrow),
                onTap: () {
                  close(context, snapshot.data[index]);
                },
              );
            },
          );
        });
  }

  Future<List> suggestions(String search) async {
    final List data = await Api.instance.getSuggestData(search);
    return data[1].map((item) {
      return item[0];
    }).toList();
  }
}
