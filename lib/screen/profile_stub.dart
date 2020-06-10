import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/bloc/home_bloc.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/common/style.dart';

class ProfileStub extends StatelessWidget {
  final HomeBloc _bloc;
  final Style _style;
  final Storage _storage;

  ProfileStub(this._bloc, this._style, this._storage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _style.spacingLarge),
      child: Stack(
        children: <Widget>[
          BlocBuilder(
            bloc: _bloc,
            builder: (ctx, state) {
              return Container(
                alignment: Alignment(1.0, 0.2),
                child: Card(
                  margin: EdgeInsets.all(_style.spacingNormal),
                  child: Container(
                    height: 440,
                    padding: EdgeInsets.all(_style.spacingNormal),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.grey[300]),
                    child: Column(children: [
                      SizedBox(
                        height: _style.spacingLarger,
                      ),
                      getItem('Full Name', _storage.profile?.name ?? ''),
                      SizedBox(
                        height: _style.spacingNormal,
                      ),
                      getItem('Email address', _storage.profile?.email ?? ''),
                      SizedBox(
                        height: _style.spacingNormal,
                      ),
                      getItem(
                          'Gender',
                          (_storage.profile?.gender ?? 0) == 0
                              ? 'Male'
                              : 'Female'),
                      SizedBox(
                        height: _style.spacingNormal,
                      ),
                      getItem('Age', (_storage.profile?.age ?? '0').toString()),
                    ]),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage(_style.profileImage),
                    fit: BoxFit.fill,
                  )),
              width: 150,
              height: 150,
            ),
          )
        ],
      ),
    );
  }

  Widget getItem(String title, String value) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: _style.headerTextSize))),
          ],
        ),
        SizedBox(
          height: _style.spacingSmall,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Text(value,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: _style.largeTextSize,
                        color: Colors.black54))),
          ],
        ),
      ],
    );
  }
}
