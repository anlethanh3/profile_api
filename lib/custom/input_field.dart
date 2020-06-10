import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class InputField extends StatefulWidget {
  final FormFieldValidator<String> validate;
  final String hintText;
  final TextInputType textInputType;
  final bool isNumberOnly;
  final TextEditingController controller;

  InputField(
      {this.validate,
      this.hintText,
      this.textInputType,
      this.controller,
      this.isNumberOnly = false});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _style = Injector.getInjector().get<Style>();
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focus,
      autovalidate: true,
      style: TextStyle(fontSize: _style.largeTextSize),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(_style.spacingNormal),
        hintStyle: TextStyle(fontSize: _style.largeTextSize),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(_style.radius))),
        hintText: widget.hintText,
      ),
      validator: (value) => widget.validate(value),
      textInputAction: TextInputAction.next,
      keyboardType: widget.textInputType ?? TextInputType.text,
      inputFormatters: widget.isNumberOnly
          ? [WhitelistingTextInputFormatter.digitsOnly]
          : null,
      onFieldSubmitted: (value) {
        _focus.nextFocus();
      },
    );
  }
}
