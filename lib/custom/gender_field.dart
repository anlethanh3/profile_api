import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class GenderField extends StatefulWidget {
  @override
  _GenderFieldState createState() => _GenderFieldState();
  final FormFieldValidator<int> validate;
  final String hintText;
  final ValueChanged<int> valueChanged;

  GenderField({this.validate, this.hintText, this.valueChanged});
}

class _GenderFieldState extends State<GenderField> {
  final _style = Injector.getInjector().get<Style>();
  var _selectedValue = -1;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
          widget.valueChanged(value);
        });
      },
      items: [
        DropdownMenuItem(
          value: -1,
          child: Text(
            'Gender',
            style: TextStyle(color: _style.textColor),
          ),
        ),
        DropdownMenuItem(
          value: 0,
          child: Text(
            'Male',
            style: TextStyle(color: _style.textColor),
          ),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text('Female', style: TextStyle(color: _style.textColor)),
        )
      ],
      value: _selectedValue,
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
    );
  }
}
