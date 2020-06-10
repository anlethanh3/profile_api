import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/bloc/home_bloc.dart';
import 'package:flutter_info_app/common/api_provider.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/common/style.dart';
import 'package:flutter_info_app/repository/profile_repository.dart';
import 'package:flutter_info_app/screen/home_stub.dart';
import 'package:flutter_info_app/screen/profile_stub.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Home extends StatefulWidget {
  final bool isShowProfile;

  Home(this.isShowProfile);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _style = Injector.getInjector().get<Style>();
  final _storage = Injector.getInjector().get<Storage>();
  final _apiProvider = Injector.getInjector().get<ApiProvider>();
  final _router = Injector.getInjector().get<Router>();
  HomeBloc _bloc;
  ProfileRepository _repository;
  var _selectedIndex = 0;
  List<Widget> _stubs;
  List<String> _names = ['Home', 'Products', 'My Request', 'Profile', 'Logout'];

  @override
  void initState() {
    super.initState();
    _repository = ProfileRepository(_apiProvider);
    _bloc = HomeBloc(_repository, _storage);
    _stubs = [
      HomeStub(_bloc, _style, _storage),
      HomeStub(_bloc, _style, _storage),
      HomeStub(_bloc, _style, _storage),
      ProfileStub(_bloc, _style, _storage),
    ];
    if (widget.isShowProfile) {
      _selectedIndex = 3;
    }
    _bloc.add(HomeLoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => _bloc,
      child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder(
                bloc: _bloc,
                builder: (ctx, state) {
                  if (state is HomeSelectedStubState) {
                    _selectedIndex = state.index;
                  }
                  return Text(_names[_selectedIndex]);
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                BlocBuilder(
                  bloc: _bloc,
                  builder: (ctx, state) {
                    return DrawerHeader(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(
                          height: _style.spacingNormal,
                        ),
                        Row(children: [
                          Text(
                            _storage?.profile?.name ?? 'John Doe',
                            style: TextStyle(
                                fontSize: _style.largeTextSize,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                        SizedBox(
                          height: _style.spacingSmall,
                        ),
                        Row(children: <Widget>[
                          Text(
                            (_storage?.profile?.gender ?? 0) == 0
                                ? 'Male'
                                : 'Female',
                            style: TextStyle(fontSize: _style.normalTextSize),
                          )
                        ]),
                      ],
                    ));
                  },
                ),
                BlocBuilder(
                  bloc: _bloc,
                  builder: (ctx, state) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Home',
                            style: TextStyle(
                                fontSize: _style.normalTextSize,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            _bloc.add(HomeSelectedStubEvent(0));
                          },
                          selected: _selectedIndex == 0,
                        ),
                        ListTile(
                          title: Text(
                            'Products',
                            style: TextStyle(
                                fontSize: _style.normalTextSize,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            _bloc.add(HomeSelectedStubEvent(1));
                          },
                          selected: _selectedIndex == 1,
                        ),
                        ListTile(
                          title: Text(
                            'My Request',
                            style: TextStyle(
                                fontSize: _style.normalTextSize,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            _bloc.add(HomeSelectedStubEvent(2));
                          },
                          selected: _selectedIndex == 2,
                        ),
                        ListTile(
                          title: Text(
                            'Profile',
                            style: TextStyle(
                                fontSize: _style.normalTextSize,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            _bloc.add(HomeSelectedStubEvent(3));
                          },
                          selected: _selectedIndex == 3,
                        ),
                        ListTile(
                          title: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: _style.normalTextSize,
                                fontWeight: FontWeight.normal),
                          ),
                          selected: _selectedIndex == 4,
                          onTap: () async {
                            await _storage.clear();
                            await _router.navigateTo(context, "/login",
                                replace: true);
                          },
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          body: BlocBuilder(
            bloc: _bloc,
            builder: (ctx, state) {
              if (state is HomeSelectedStubState) {
                _selectedIndex = state.index;
              }
              return _stubs[_selectedIndex];
            },
          )),
    );
  }
}
