import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v230/data/local_storage.dart';
import 'package:v230/main.dart';
import 'package:v230/models/task_model.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompeted = !widget.task.isCompeted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: widget.task.isCompeted ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
        title: widget.task.isCompeted
            ? Text(
                widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                controller: _taskNameController,
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.length >= 3) {
                    widget.task.name = value;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat("hh:mm a").format(widget.task.createdAt),
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
