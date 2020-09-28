import 'package:climate/features/climate/domain/entities/climate.dart';
import 'package:climate/features/climate/presentaion/bloc/climate_bloc.dart';
import 'package:climate/features/climate/presentaion/widgest/climate_controller.dart';
import 'package:climate/features/climate/presentaion/widgest/climate_widget.dart';
import 'package:climate/features/climate/presentaion/widgest/message_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      resizeToAvoidBottomInset: false,
    );
  }
}

BlocProvider<ClimateBloc> buildBody(BuildContext context) {
  return BlocProvider(
    builder: (_) => sl<ClimateBloc>(),
    child: SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: ClimateController(),
            ),
            Expanded(
              child: BlocBuilder<ClimateBloc, ClimateState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return SpinKitDoubleBounce(
                      color: Colors.teal.shade800,
                      size: 100,
                    );
                  } else if (state is Empty) {
                    return MessageHolder(
                      message: 'Get Climate for your location or any location',
                    );
                  } else if (state is Error) {
                    return MessageHolder(
                      message: state.message,
                    );
                  } else if (state is Loaded) {
                    return ClimateWidget(
                      climate: state.climate,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}





