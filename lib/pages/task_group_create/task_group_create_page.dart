import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_group.dart';
import 'package:todo_app/providers/task_group_provider.dart';

class TaskGroupCreatePage extends StatefulWidget {
  const TaskGroupCreatePage({super.key, this.task});
  final TaskGroup? task;

  @override
  State<TaskGroupCreatePage> createState() => _TaskGroupCreatePageState();
}

class _TaskGroupCreatePageState extends State<TaskGroupCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  Color selectedColor = Colors.blue; // Cor inicial

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task Group'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 20),
                Text(
                  'Select Color',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                _buildColorPicker(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () async {
          await _submitForm();
        },
        label: const Text('Add Task Group'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  TextFormField _buildTitle() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Title required';
        }
        if (value.length > 25) {
          return 'Title must be less than 25 characters';
        }
        return null;
      },
      controller: nameController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.title),
        border: UnderlineInputBorder(),
        label: Text('Title'),
        hintText: 'Enter a description for the task',
      ),
    );
  }

  Widget _buildColorPicker() {
    return GestureDetector(
      onTap: () => _showColorPickerDialog(),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: selectedColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            'Tap to select color',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final task = TaskGroup.create(
        name: nameController.text,
        color: selectedColor.value,
      );

      await context.read<TaskGroupProvider>().createTaskGroup(task);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }
}
