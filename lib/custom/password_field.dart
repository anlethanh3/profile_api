import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
  final bool isDone;
  final TextEditingController controller;

  PasswordField({this.isDone = true, this.controller});
}

class _PasswordFieldState extends State<PasswordField> {
  final _style = Injector.getInjector().get<Style>();
  bool _isShowPassword = false;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: !_isShowPassword,
      autovalidate: true,
      style: TextStyle(fontSize: _style.largeTextSize),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
              top: _style.spacingNormal,
              left: _style.spacingNormal,
              right: 30,
              bottom: _style.spacingNormal),
          hintStyle: TextStyle(fontSize: _style.largeTextSize),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(_style.radius))),
          hintText: 'Password',
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _isShowPassword = !_isShowPassword;
              });
            },
            borderRadius: BorderRadius.circular(40),
            child: Icon(
              _isShowPassword ? Icons.visibility : Icons.visibility_off,
              color: _style.showPasswordIconColor,
              size: 24,
            ),
          )),
      validator: (value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onFieldSubmitted: (value) {
        _focusNode.nextFocus();
      },
      textInputAction:
          widget.isDone ? TextInputAction.done : TextInputAction.next,
    );
  }
}
