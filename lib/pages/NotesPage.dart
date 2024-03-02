import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/db/NotesDatabase.dart';
import 'package:notes_app/pages/EditNotePage.dart';
import 'package:notes_app/pages/NoteDetailsPage.dart';
import 'package:notes_app/widgets/NoteCardWidget.dart';

import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {

    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async{
    setState(() {
      isLoading = true;
    });

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes", style: TextStyle(fontSize: 24),),
      actions: const [Icon(Icons.search), SizedBox(width: 12,)],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black, 
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotePage()));

          refreshNotes();
        },
        
      ),

      body: Center(
        child: isLoading? CircularProgressIndicator() : notes.isEmpty? Text("So empty here", style: TextStyle(color: Colors.white, fontSize: 24),): buildNotes(),
      ),

    );
  }
  
  Widget buildNotes(){
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(notes.length, (index){
          final note = notes[index];
          return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailPage(noteId: note.id!),)) ;
                  refreshNotes();
                },
                  child: NoteCardWidget(note: note, index: index)),
          );

        }),

    );
  }

}
