import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {

  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({super.key, this.isImportant = false, this.number = 0, this.title = '', this.description = '',
  required this.onChangedImportant, required this.onChangedNumber, required this.onChangedTitle, required this.onChangedDescription});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Switch(value: isImportant??false, onChanged: onChangedImportant),
                Expanded(child: Slider(
                    value: (number ?? 0).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (number)=> onChangedNumber(number.toInt())))
              ],
            ),

            buildTitle(),
            const SizedBox(height: 8,),
            buildDescription(),
            const SizedBox(height: 16,)
          ],
        ),
      ),
    );
  }


  Widget buildTitle(){
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 24,
        fontWeight: FontWeight.bold
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.white70)
      ),
      validator: (title) => title != null && title.isEmpty? 'title cannot be empty':null,
      onChanged: onChangedTitle,
    );
  }

  Widget buildDescription(){
    return TextFormField(
      maxLines: 5,
      initialValue: description,
      style:  TextStyle(
        color: Colors.white54,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type Something...',
        hintStyle: TextStyle(color: Colors.white54),
      ),
      validator: (description) => description != null && description.isEmpty? 'description cannot be empty' : null,
      onChanged: onChangedDescription,
    );
  }


}
