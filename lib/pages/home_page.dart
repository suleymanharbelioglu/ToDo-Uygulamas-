import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:v230/data/local_storage.dart';
import 'package:v230/helper/translation_helper.dart';
import 'package:v230/main.dart';
import 'package:v230/models/task_model.dart';
import 'package:v230/widgets/custom_search_delegate.dart';
import 'package:v230/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTask = <Task>[];
    _allTask.add(Task.create(name: "dneme", createdAt: DateTime.now()));
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (context, index) {
                var _oAnkliListeElemani = _allTask[index];
                return Dismissible(
                    key: Key(_oAnkliListeElemani.id),
                    onDismissed: (direction) {
                      _allTask.removeAt(index);
                      _localStorage.deleteTask(task: _oAnkliListeElemani);
                      setState(() {});
                    },
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text("remove_taks").tr(),
                      ],
                    ),
                    child: TaskItem(task: _oAnkliListeElemani));
              },
            )
          : Center(
              child: Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "add_task".tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                print("on submited---------------->" + value);
                Navigator.of(context).pop();
                if (value.length >= 3) {
                  DatePicker.showTimePicker(
                    locale: TranslationHelper.getDeviceLanguage(context),
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);
                      print(yeniEklenecekGorev);
                      _allTask.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDb() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTask));
    _getAllTaskFromDb();
  }
}
