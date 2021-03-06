import 'package:flutter/material.dart';

class NewTournamentField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isExpanded;
  final bool requiredCapitalization;
  final Function(String) onChanged;
  NewTournamentField({
    this.hintText,
    this.controller,
    this.textInputType = TextInputType.text,
    this.isExpanded = false,
    this.requiredCapitalization = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        maxLines: isExpanded ? 5 : 1,
        minLines: 1,
        keyboardType: textInputType,
        textCapitalization: requiredCapitalization
            ? TextCapitalization.words
            : TextCapitalization.sentences,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: Colors.blue,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: isExpanded ? 15.0 : 10.0, horizontal: 10.0),
        ),
      ),
    );
  }
}
