class DebugOutput {
  double totalTime;
  double pathCalculationTime;
  double precalculationTime;
  double renderingTime;
  bool timedOut;

  DebugOutput({
    this.totalTime,
    this.pathCalculationTime,
    this.precalculationTime,
    this.renderingTime,
    this.timedOut,
  });

  factory DebugOutput.fromJson(Map<String, dynamic> json) => DebugOutput(
        totalTime: double.tryParse(json['totalTime'].toString()) ?? 0,
        pathCalculationTime:
            double.tryParse(json['pathCalculationTime'].toString()) ?? 0,
        precalculationTime:
            double.tryParse(json['precalculationTime'].toString()) ?? 0,
        renderingTime: double.tryParse(json['renderingTime'].toString()) ?? 0,
        timedOut: json['timedOut'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'totalTime': totalTime,
        'pathCalculationTime': pathCalculationTime,
        'precalculationTime': precalculationTime,
        'renderingTime': renderingTime,
        'timedOut': timedOut,
      };
}
