class DefaultOptions {
  late WalkBoardCost walkBoardCost;
  late WalkReluctance walkReluctance;
  List<double> walkSpeed;
  List<double> bikeSpeed;

  DefaultOptions({
    WalkBoardCost? walkBoardCost,
    WalkReluctance? walkReluctance,
    this.walkSpeed = const [0.69, 0.97, 1.2, 1.67, 2.22],
    this.bikeSpeed = const [2.77, 4.15, 5.55, 6.94, 8.33],
  }) {
    this.walkBoardCost = walkBoardCost ?? WalkBoardCost();
    this.walkReluctance = walkReluctance ?? WalkReluctance();
  }
}

class WalkBoardCost {
  int least;
  int less;
  int more;
  int most;

  WalkBoardCost({
    this.least = 3600,
    this.less = 1200,
    this.more = 360,
    this.most = 120,
  });
}

class WalkReluctance {
  double least;
  double less;
  double more;
  double most;

  WalkReluctance({
    this.least = 5.0,
    this.less = 3.0,
    this.more = 1.0,
    this.most = 0.2,
  });
}
