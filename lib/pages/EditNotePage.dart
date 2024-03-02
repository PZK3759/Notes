import 'package:flutter/material.dart';
import 'package:notes_app/db/NotesDatabase.dart';
import 'package:notes_app/widgets/NoteFormWidget.dart';

import '../models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;
  const EditNotePage({super.key, this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {

  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),

      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangedImportant: (isImportant) => setState(() {
            this.isImportant = isImportant;
          }),
          onChangedNumber: (number) => setState(() {
            this.number = number;
          }),
          onChangedTitle: (title) => setState(() {
            this.title = title;
          }),
          onChangedDescription: (description) => setState(() {
            this.description = description;
          }),
        ),
      ),
    );
  }

  Widget buildButton(){

    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isFormValid ? Colors.blueAccent : Colors.grey.shade700,
          ),
          onPressed: addOrUpdateNote,
          child: Text('Save')),
    );
  }

  void addOrUpdateNote() async{
    final isValid = _formKey.currentState!.validate();

    if(isValid){
      final isUpdating = widget.note != null;

      if(isUpdating){
        await updateNote();
      }
      else{
        addNote();
      }
      Navigator.pop(context);
    }

  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);

  }

  Future addNote() async {
    final note = Note(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());

    await NotesDatabase.instance.create(note);

  }

}
