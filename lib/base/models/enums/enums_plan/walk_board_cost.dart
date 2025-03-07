part of 'enums_plan.dart';
// TODO considerate remove
enum WalkBoardCostEnum { defaultCost, walkBoardCostHigh }

extension WalkBoardCostExtension on WalkBoardCostEnum {
  static const values = <WalkBoardCostEnum, int>{
    WalkBoardCostEnum.defaultCost: 600,
    WalkBoardCostEnum.walkBoardCostHigh: 1200,
  };
  int get value => values[this] ?? 600;
}
