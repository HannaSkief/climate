import 'package:climate/features/climate/presentaion/bloc/climate_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClimateController extends StatefulWidget {
  @override
  _ClimateControllerState createState() => _ClimateControllerState();
}

class _ClimateControllerState extends State<ClimateController> {
  bool isSearch = false;
  String city='';

  @override
  Widget build(BuildContext context) {
    return isSearch
        ? Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSearch = false;
                  });
                },
                child: Icon(Icons.close),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  autofocus: true,
                  onSubmitted: (value) {
                    _getInputLocationClimate(context, value);
                  },
                  onChanged: (value){
                    city=value;
                  },
                  decoration: InputDecoration(hintText: 'Search'),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _getInputLocationClimate(context, city);
                  FocusScope.of(context).unfocus();
                },
                child: Icon(Icons.search),
              ),
            ],
          )
        : CurrentLocation(
            searchCallBack: () {
              setState(() {
                isSearch = true;
              });
            },
          );
  }
}

class CurrentLocation extends StatelessWidget {
  final Function searchCallBack;

  const CurrentLocation({Key key, this.searchCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: () {
              _getCurrentLocationClimate(context);
            },
            color: Colors.teal.shade800,
            child: Text(
              'Get Current Location Weather',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: searchCallBack,
          child: Icon(Icons.search),
        ),
      ],
    );
  }
}

void _getCurrentLocationClimate(BuildContext context) {
  BlocProvider.of<ClimateBloc>(context).dispatch(GetCurrentLocationClimate());
}

void _getInputLocationClimate(BuildContext context, String city) {
  BlocProvider.of<ClimateBloc>(context)
      .dispatch(GetInputLocationClimate(city: city));
}
