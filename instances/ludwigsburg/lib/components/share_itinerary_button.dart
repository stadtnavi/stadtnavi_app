import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';

class ShareItineraryButton extends StatelessWidget {
  const ShareItineraryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapRouteCubit = context.read<MapRouteCubit>();
    final mapRouteState = mapRouteCubit.state;
    return FloatingActionButton(
      onPressed: () async {
        Share.share(Uri(
          scheme: "https",
          host: "www.google.com",
          path: "/maps/dir/",
          queryParameters: {
            "api": '1',
            "origin": mapRouteState.fromPlace.toString(),
            "destination": mapRouteState.toPlace.toString(),
          },
        ).toString());
      },
      heroTag: null,
      child: const Icon(
        Icons.send,
      ),
    );
  }
}

Widget extraButtons(BuildContext context) {
  final mapRouteState = context.watch<MapRouteCubit>().state;
  return mapRouteState.plan != null
      ? Column(
          children: const [
            Padding(padding: EdgeInsets.all(4.0)),
            ShareItineraryButton(),
          ],
        )
      : Container();
}
