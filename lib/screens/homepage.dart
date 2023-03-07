import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> listOfNotes = [];

  Widget _buildNote(int index) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(listOfNotes[index].title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${listOfNotes[index].descrip}'),
              const SizedBox(height: 20),
              Text(
                'Created on: ${DateFormat('yyyy-MM-dd – kk:mm:a').format(listOfNotes[index].time)}',
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                listOfNotes[index].title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  listOfNotes.removeAt(index);
                });
              },
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildPopUpDialog(BuildContext ctx) {
    String title = "";
    String descrip = "";
    return AlertDialog(
      title: const Text('Add a Note'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration:
                  const InputDecoration(hintText: 'Enter the Description'),
              onChanged: (value) => descrip = value,
            )
          ]),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {
                Note newNote =
                    Note(time: DateTime.now(), title: title, descrip: descrip);
                listOfNotes.add(newNote);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Submit')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: listOfNotes.isEmpty
          ? const Center(child: Text('No Notes found :('))
          : ListView.builder(
              itemCount: listOfNotes.length,
              itemBuilder: (context, index) => Dismissible(
                onDismissed: (direction) {
                  setState(() {
                    listOfNotes.removeAt(index);
                  });
                },
                key: UniqueKey(),
                child: _buildNote(index),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: ((ctx) => _buildPopUpDialog(ctx)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
