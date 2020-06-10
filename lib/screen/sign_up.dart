import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/bloc/register_bloc.dart';
import 'package:flutter_info_app/common/api_provider.dart';
import 'package:flutter_info_app/common/helper.dart';
import 'package:flutter_info_app/common/routes.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_info_app/custom/gender_field.dart';
import 'package:flutter_info_app/custom/input_field.dart';
import 'package:flutter_info_app/custom/password_field.dart';
import 'package:flutter_info_app/repository/register_repository.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _style = Injector.getInjector().get<Style>();
  final _router = Injector.getInjector().get<Router>();
  final _helper = Injector.getInjector().get<Helper>();
  final _storage = Injector.getInjector().get<Storage>();
  final _apiProvider = Injector.getInjector().get<ApiProvider>();
  final _formKey = GlobalKey<FormState>();
  RegisterBloc _bloc;
  RegisterRepository _repository;
  final _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var gender = -1;

  @override
  void initState() {
    super.initState();
    _repository = RegisterRepository(_apiProvider);
    _bloc = RegisterBloc(_repository, _storage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            _router.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: _style.accentColor,
          ),
        ),
      ),
      body: BlocProvider(
        create: (ctx) => _bloc,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(_style.spacingNormal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
                          'Register',
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
                          'Already have an account? ',
                          style: TextStyle(fontSize: _style.normalTextSize),
                        ),
                        InkWell(
                          onTap: () {
                            _router.pop(context);
                          },
                          child: Text(
                            'Login',
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
                                  hintText: 'Name',
                                  validate: _helper.validateName,
                                  textInputType: TextInputType.text,
                                  controller: _controllers[0],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: _style.spacingNormal,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InputField(
                                  hintText: 'Email',
                                  validate: _helper.validateEmail,
                                  textInputType: TextInputType.emailAddress,
                                  controller: _controllers[1],
                                ),
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
                                  isDone: false,
                                  controller: _controllers[2],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: _style.spacingNormal,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: GenderField(
                                  hintText: 'Gender',
                                  validate: _helper.validateGender,
                                  valueChanged: (value) {
                                    gender = value;
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: _style.spacingNormal,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InputField(
                                  hintText: 'Age',
                                  validate: _helper.validateAge,
                                  textInputType: TextInputType.number,
                                  isNumberOnly: true,
                                  controller: _controllers[3],
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
                                'Register',
                                style: TextStyle(
                                    color: _style.secondColor,
                                    fontSize: _style.headerTextSize),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _bloc.add(RegisterEvent(
                                      _controllers[0].text,
                                      _controllers[1].text,
                                      _controllers[2].text,
                                      gender,
                                      int.parse(_controllers[3].text)));
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
              builder: (ctx, state) {
                if (state is RegisterLoadingState && state.isLoading) {
                  return Container(
                    color: Colors.black45,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is RegisterFailureState) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text(
                                  'Register error, try later!',
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
                } else if (state is RegisterSuccessState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      _router.navigateTo(context, Routes.profile,
                          replace: true, clearStack: true));
                }
                return Container();
              },
              bloc: _bloc,
            ),
          ],
        ),
      ),
    );
  }
}
