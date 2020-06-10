import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/bloc/login_bloc.dart';
import 'package:flutter_info_app/common/api_provider.dart';
import 'package:flutter_info_app/common/helper.dart';
import 'package:flutter_info_app/common/routes.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_info_app/custom/input_field.dart';
import 'package:flutter_info_app/custom/password_field.dart';
import 'package:flutter_info_app/repository/login_repository.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _style = Injector.getInjector().get<Style>();
  final _helper = Injector.getInjector().get<Helper>();
  final _router = Injector.getInjector().get<Router>();
  final _storage = Injector.getInjector().get<Storage>();
  final _apiProvider = Injector.getInjector().get<ApiProvider>();
  final _formKey = GlobalKey<FormState>();
  final _controllers = [TextEditingController(), TextEditingController()];
  LoginBloc _bloc;
  LoginRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = LoginRepository(_apiProvider);
    _bloc = LoginBloc(_repository, _storage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => _bloc,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(_style.spacingNormal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: _style.spacingLarger,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          _style.logoImage,
                          width: 250,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _style.spacingLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                              color: _style.textColor,
                              fontSize: _style.header1Size),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _style.spacingSmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account yet? ',
                          style: TextStyle(fontSize: _style.normalTextSize),
                        ),
                        InkWell(
                          onTap: () {
                            _router.navigateTo(context, Routes.signup,
                                transition: TransitionType.inFromRight);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: _style.primaryColor,
                                fontSize: _style.normalTextSize),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _style.spacingNormal,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InputField(
                                    hintText: 'Email',
                                    controller: _controllers[0],
                                    validate: _helper.validateEmail),
                              )
                            ],
                          ),
                          SizedBox(
                            height: _style.spacingNormal,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: PasswordField(
                                  controller: _controllers[1],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _style.spacingLarge,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 70,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(_style.radius))),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: _style.secondColor,
                                    fontSize: _style.headerTextSize),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _bloc.add(LoginEvent(_controllers[0].text,
                                      _controllers[1].text));
                                }
                              },
                              color: _style.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder(
                bloc: _bloc,
                builder: (ctx, state) {
                  if (state is LoginLoadingState && state.isLoading) {
                    return Container(
                      color: Colors.black45,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is LoginSuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        _router.navigateTo(context, Routes.profile,
                            replace: true));
                  } else if (state is LoginFailureState) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: Text(
                                    'Email or password not correct!',
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]),
                            ));
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }
}
