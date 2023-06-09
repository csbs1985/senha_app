import 'package:flutter/material.dart';
import 'package:senha_app/theme/ui_borda.dart';
import 'package:senha_app/theme/ui_texto.dart';

class FormularioInput extends StatefulWidget {
  final bool? autoFocus;
  final TextEditingController? controller;
  final Function? callback;
  final bool? expands;
  final FocusNode? focusNode;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function(String?)? onSaved;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool? pesquisar;
  final String? Function(String?)? validator;

  const FormularioInput({
    Key? key,
    this.autoFocus = false,
    this.controller,
    this.callback,
    this.expands = false,
    this.focusNode,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onSaved,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.pesquisar = false,
    this.validator,
  }) : super(key: key);

  @override
  State<FormularioInput> createState() => _FormularioInputState();
}

class _FormularioInputState extends State<FormularioInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        autofocus: widget.autoFocus!,
        controller: widget.controller,
        expands: widget.expands!,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        onChanged: (value) => widget.callback!(value),
        onSaved: widget.onSaved,
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        style: Theme.of(context).textTheme.displaySmall,
        textAlignVertical: TextAlignVertical.center,
        validator: widget.validator,
        decoration: InputDecoration(
          counterStyle: Theme.of(context).textTheme.headlineSmall,
          hintText: widget.hintText,
          isDense: true,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          errorStyle: UiTexto.erro,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(UiBorda.quadrada),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(UiBorda.quadrada),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(UiBorda.quadrada),
          ),
        ),
      ),
    );
  }
}
