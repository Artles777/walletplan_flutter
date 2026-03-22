import "package:beamer/beamer.dart";
import "package:flutter/widgets.dart";

extension BeamerContext on BuildContext {
  BeamerDelegate get beamer => Beamer.of(this);
  BeamerDelegate get rootBeamer => Beamer.of(this, root: true);

  BeamState get state => beamer.currentBeamLocation.state as BeamState;
  Uri get uri => state.uri;

  BeamState get rootState => rootBeamer.currentBeamLocation.state as BeamState;
  Uri get rootUri => rootState.uri;

  void beamToNamed(
    String uri, {
    Object? routeState,
    Object? data,
    String? popToNamed,
    TransitionDelegate? transitionDelegate,
    bool beamBackOnPop = false,
    bool popBeamLocationOnPop = false,
    bool stacked = true,
    bool replaceRouteInformation = false,
  }) {
    beamer.beamToNamed(
      uri,
      routeState: routeState,
      data: data,
      popToNamed: popToNamed,
      transitionDelegate: transitionDelegate,
      beamBackOnPop: beamBackOnPop,
      popBeamLocationOnPop: popBeamLocationOnPop,
      stacked: stacked,
      replaceRouteInformation: replaceRouteInformation,
    );
  }

  void beamToNamedRoot(
    String uri, {
    Object? routeState,
    Object? data,
    String? popToNamed,
    TransitionDelegate? transitionDelegate,
    bool beamBackOnPop = false,
    bool popBeamLocationOnPop = false,
    bool stacked = true,
    bool replaceRouteInformation = false,
  }) {
    rootBeamer.beamToNamed(
      uri,
      routeState: routeState,
      data: data,
      popToNamed: popToNamed,
      transitionDelegate: transitionDelegate,
      beamBackOnPop: beamBackOnPop,
      popBeamLocationOnPop: popBeamLocationOnPop,
      stacked: stacked,
      replaceRouteInformation: replaceRouteInformation,
    );
  }

  bool beamBack({Object? data, bool replaceRouteInformation = false}) {
    if (!beamer.canBeamBack) {
      return false;
    }
    return beamer.beamBack(
      data: data,
      replaceRouteInformation: replaceRouteInformation,
    );
  }

  bool beamBackRoot({Object? data, bool replaceRouteInformation = false}) {
    if (!rootBeamer.canBeamBack) {
      return false;
    }
    return rootBeamer.beamBack(
      data: data,
      replaceRouteInformation: replaceRouteInformation,
    );
  }
}
