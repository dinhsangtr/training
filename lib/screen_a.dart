import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:start/store/todo.dart';
import 'package:mobx/mobx.dart';
import 'package:start/store/todo_list.dart';

import 'constants.dart';

class ScreenA extends StatefulWidget {
  const ScreenA({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ScreenA> {
  TodoList _todoList = TodoList();

  @override
  void initState() {
    _todoList.initTodos(); //create 10 item
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: _buildListView(),
        floatingActionButton: _buildAddButton(),
      ),
    );
  }

  //
  _showAlertDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item!'),
        content: const Text('Do you want to delete this item'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              await _todoList.removeTodosAt(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  //Body:
  Widget _buildListView() {
    return Observer(
      builder: (_) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(height: 1.0),
        itemCount: _todoList.todos.length,
        itemBuilder: (context, index) => ListTile(
          onLongPress: () => _showAlertDialog(index),
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.check_box_outlined),
          ),
          title: Text(
            _todoList.todos[index].description,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _todoList.todos[index].description,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.arrow_forward_ios, size: 15),
          ),
        ),
      ),
    );
  }

  //Floating Action Button
  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () => _todoList.addTodo('des'),//Navigator.pushNamed(context, '/home/additem'),
      backgroundColor: primaryColor,
      elevation: 0.0,
      tooltip: 'add',
      child: const Icon(Icons.add),
    );
  }
}
