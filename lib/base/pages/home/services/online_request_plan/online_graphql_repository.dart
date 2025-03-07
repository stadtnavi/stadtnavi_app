import 'package:stadtnavi_core/base/models/enums/plan_info_box.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/mode.dart';
import 'package:stadtnavi_core/base/models/othermodel/plan.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/services/online_request_plan/graphql_plan_repository.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import '../../../../models/othermodel/modes_transport.dart';

class OnlineGraphQLRepository {
  final String graphQLEndPoint;
  final GraphQLPlanRepository _graphQLPlanRepository;

  OnlineGraphQLRepository({
    required this.graphQLEndPoint,
  }) : _graphQLPlanRepository =
            GraphQLPlanRepository(endpoint: graphQLEndPoint);

  Future<PlanEntity> fetchAdvancedPlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    Plan planData = await _graphQLPlanRepository.fetchPlanAdvanced(
      fromLocation: from,
      toLocation: to,
      advancedOptions: advancedOptions,
      locale: localeName,
    );
    planData = planData.copyWith(
      itineraries: planData.itineraries
          ?.where(
            (itinerary) =>
                !(itinerary.legs ?? []).every((leg) => leg.mode == Mode.walk),
          )
          .toList(),
    );
    final mainFetchIsEmpty = planData.itineraries?.isEmpty ?? true;
    if (mainFetchIsEmpty) {
      planData = await _graphQLPlanRepository.fetchPlanAdvanced(
        fromLocation: from,
        toLocation: to,
        advancedOptions: advancedOptions,
        locale: localeName,
        useDefaultModes: true,
      );
    }
    planData = planData.copyWith(
      itineraries: planData.itineraries
          ?.where(
            (itinerary) =>
                !(itinerary.legs ?? []).every((leg) => leg.mode == Mode.walk),
          )
          .toList(),
    );
    PlanEntity planEntity = planData.toPlan();
    if (!planEntity.isOnlyWalk) {
      planEntity = planData
          .copyWith(
            itineraries: planData.itineraries
                ?.where(
                  (itinerary) => !(itinerary.legs ?? [])
                      .every((leg) => leg.mode == Mode.walk),
                )
                .toList(),
          )
          .toPlan();
    }

    return planEntity.copyWith(
      planInfoBox: planEntity.isOnlyWalk
          ? PlanInfoBox.noRouteMsg
          : (mainFetchIsEmpty
              ? PlanInfoBox.usingDefaultTransports
              : PlanInfoBox.undefined),
    );
  }

  Future<PlanEntity> fetchMoreItineraries({
    required TrufiLocation from,
    required TrufiLocation to,
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    Plan planData = await _graphQLPlanRepository.fetchPlanAdvanced(
      fromLocation: from,
      toLocation: to,
      advancedOptions: advancedOptions,
      locale: localeName,
      numItineraries: 5,
    );
    planData = planData.copyWith(
      itineraries: planData.itineraries
          ?.where(
            (itinerary) =>
                !(itinerary.legs ?? []).every((leg) => leg.mode == Mode.walk),
          )
          .toList(),
    );
    final mainFetchIsEmpty = planData.itineraries?.isEmpty ?? true;
    PlanEntity planEntity = planData.toPlan();

    return planEntity.copyWith(
      planInfoBox: planEntity.isOnlyWalk
          ? PlanInfoBox.noRouteMsg
          : (mainFetchIsEmpty
              ? PlanInfoBox.noRouteMsgWithChanges
              : PlanInfoBox.undefined),
    );
  }

  Future<ModesTransportEntity> fetchTransportModePlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    ModesTransport planEntityData =
        await _graphQLPlanRepository.fetchWalkBikePlanQuery(
      fromLocation: from,
      toLocation: to,
      advancedOptions: advancedOptions,
      locale: localeName,
    );
    planEntityData = planEntityData.copyWith(
      parkRidePlan: planEntityData.parkRidePlan?.copyWith(
        itineraries: planEntityData.parkRidePlan?.itineraries
            ?.where(
              (itinerary) =>
                  (itinerary.legs ?? []).any((leg) => leg.transitLeg??false),
            )
            .toList(),
      ),
    );
    return planEntityData.toModesTransport();
  }
}
