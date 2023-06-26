import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String? hint;
  bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  late bool? showEye;
  late Color? color;
  final IconData icon;
  late Color? borderColor;
  late Color? hintColor;
  late double? radius;
  final String? Function(String?)? validator; // Add validator parameter

  final TextCapitalization? textCapitalization;

  TextFieldWidget({
    super.key,
    required this.icon,
    required this.label,
    this.hint = '',
    required this.controller,
    this.isObscure = false,
    this.width = double.infinity,
    this.height = 40,
    this.maxLine = 1,
    this.hintColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.showEye = false,
    this.color = Colors.white,
    this.radius = 5,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputType = TextInputType.text,
    this.validator, // Add validator parameter
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        style: const TextStyle(color: Colors.white, fontFamily: 'QRegular'),
        textCapitalization: widget.textCapitalization!,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle:
              const TextStyle(color: Colors.white, fontFamily: 'QRegular'),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Set underline color
          ),
          prefixIcon: Icon(
            widget.icon,
            color: Colors.white,
          ),
          suffixIcon: widget.showEye! == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.isObscure = !widget.isObscure!;
                    });
                  },
                  icon: widget.isObscure!
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                        ))
              : const SizedBox(),
          hintText: widget.hint,
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          errorStyle: const TextStyle(fontFamily: 'QBold', fontSize: 12),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),

        maxLines: widget.maxLine,
        obscureText: widget.isObscure!,
        controller: widget.controller,
        validator: widget.validator, // Pass the validator to the TextFormField
      ),
    );
  }
}
