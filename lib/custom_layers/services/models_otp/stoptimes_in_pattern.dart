import 'pattern.dart';
import 'stoptime.dart';

class StoptimesInPattern {
  Pattern pattern;
  List<Stoptime> stoptimes;

  StoptimesInPattern({
    this.pattern,
    this.stoptimes,
  });

  factory StoptimesInPattern.fromJson(Map<String, dynamic> json) =>
      StoptimesInPattern(
        pattern: json['pattern'] != null
            ? Pattern.fromJson(json['pattern'] as Map<String, dynamic>)
            : null,
        stoptimes: json['stoptimes'] != null
            ? List<Stoptime>.from((json["stoptimes"] as List<dynamic>).map(
                (x) => Stoptime.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'pattern': pattern?.toJson(),
        'stoptimes': List.generate(
            stoptimes?.length ?? 0, (index) => stoptimes[index].toJson()),
      };
}