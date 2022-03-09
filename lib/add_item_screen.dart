import 'package:flutter/material.dart';
import 'package:start/store/todo_list.dart';

import 'constants.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController _desEditController = TextEditingController();
  TodoList _todoList = TodoList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description:'),
            const SizedBox(height: 10,),
            TextField(
              controller: _desEditController,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.redAccent.withOpacity(0.7),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  if(_desEditController.text.isNotEmpty){
                    print('count: ${_todoList.todos.length}');
                    _todoList.addTodo(_desEditController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ),

          ],
        ),
      ),
    );
  }

}