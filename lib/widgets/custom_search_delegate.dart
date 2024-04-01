import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v230/data/local_storage.dart';
import 'package:v230/main.dart';
import 'package:v230/models/task_model.dart';
import 'package:v230/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var _oAnkliListeElemani = filteredList[index];
              return Dismissible(
                  key: Key(_oAnkliListeElemani.id),
                  onDismissed: (direction) async {
                    filteredList.removeAt(index);
                    await locator<LocalStorage>()
                        .deleteTask(task: _oAnkliListeElemani);
                  },
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text("remove_task").tr()
                    ],
                  ),
                  child: TaskItem(task: _oAnkliListeElemani));
            },
          )
        : Center(
            child: Text("search_not_found").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
