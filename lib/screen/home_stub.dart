import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/bloc/home_bloc.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/common/style.dart';

class HomeStub extends StatelessWidget {
  final HomeBloc _bloc;
  final Style _style;
  final Storage _storage;

  HomeStub(this._bloc, this._style, this._storage);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: _style.spacingLarge,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'Hello',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: _style.headerTextSize),
            )),
          ],
        ),
        SizedBox(
          height: _style.spacingSmall,
        ),
        BlocBuilder(
          bloc: _bloc,
          builder: (ctx, state) {
            return Row(
              children: <Widget>[
                Expanded(
                    child: Text(_storage.profile?.name ?? 'John Doe',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: _style.headerSize))),
              ],
            );
          },
        )
      ],
    );
  }
}
