import 'package:flutter/material.dart';
import 'package:medisecure/services/tests_service.dart';
import 'package:medisecure/views/dashboard/side_menu/side_menu.dart';
import 'package:provider/provider.dart';


class Tests extends StatefulWidget {
  const Tests({super.key});

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
   final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var testsServices = context.watch<TestServices>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tests'),
      ),
      drawer: SideMenu(),
      body: testsServices.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {},
              child: ListView.builder(
                itemCount: testsServices.tests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(testsServices.tests[index].title),
                    subtitle: Text(testsServices.tests[index].description),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        testsServices.deleteTest(testsServices.tests[index].id);
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Test'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Test Name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Test Description',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      testsServices.addTest(
                        titleController.text,
                        descriptionController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

}