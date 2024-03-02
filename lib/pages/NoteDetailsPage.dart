import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/db/NotesDatabase.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/pages/EditNotePage.dart';

class NoteDetailPage extends StatefulWidget {

  final int noteId;

  const NoteDetailPage({Key? key, required this.noteId,}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {

  late Note note;
  bool isLoading = false;

  @override
  void initState() {

    super.initState();

    refreshNote();
  }

  Future refreshNote() async{
    setState(() {
      isLoading = true;
    });

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          editButton(),
          deleteButton(),
        ],
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ): Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(note.title, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8,),
            Text(
              DateFormat.yMMMd().format(note.createdTime),
              style: TextStyle(color: Colors.white54),),
            const SizedBox(height: 8,),
            Text(note.description, style: TextStyle(color: Colors.white70, fontSize: 18),),
          ],
        ),
      )
    );
  }

  Widget editButton(){
    return IconButton(
        onPressed: () async {
          if (isLoading) return;
          await Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotePage(note: note,)));

          refreshNote();
        },
        icon: const Icon(Icons.edit),
    );
  }

  Widget deleteButton(){
    return IconButton(
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Delete Note?',
            desc: 'Do you really want to delete this note?',
            btnCancelColor: Colors.green,
            btnCancelOnPress: (){},
            btnOkColor: Colors.red,
            btnOkText: 'Delete',
            btnOkOnPress: ()async{
              await NotesDatabase.instance.delete(widget.noteId);

              Navigator.pop(context);
            },
          ).show();
        },
        icon: const Icon(Icons.delete)
    );
  }

}
