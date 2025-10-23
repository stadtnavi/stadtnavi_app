import 'package:de_stadtnavi_herrenberg_internal/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/services/online_request_plan/graphql_plan_repository.dart';
import 'package:trufi_core/models/plan_entity.dart';
import 'package:trufi_core/pages/home/service/routing_service/otp_stadtnavi/grapqhql_queries/otp_stadtnavi_models/enums/mode.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';
import 'package:trufi_core/extensions/stadtnavi/stadtnavi_extensions.dart';

class OnlineGraphQLRepository {
  final String graphQLEndPoint;
  final GraphQLPlanRepository _graphQLPlanRepository;

  OnlineGraphQLRepository({required this.graphQLEndPoint})
    : _graphQLPlanRepository = GraphQLPlanRepository(endpoint: graphQLEndPoint);

  Future<PlanEntity> fetchAdvancedPlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    PlanEntity planData = await _graphQLPlanRepository.fetchPlanAdvanced(
      fromLocation: from,
      toLocation: to,
      advancedOptions: advancedOptions,
      locale: localeName,
    );
    planData = planData.copyWith(
      itineraries: planData.itineraries
          ?.where(
            (itinerary) => !(itinerary.legs ?? []).every(
              (leg) => leg.mode == Mode.walk.name,
            ),
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
    PlanEntity planEntity = planData;
    if (!planEntity.isOnlyWalk) {
      planEntity = planData.copyWith(
        itineraries: planData.itineraries
            ?.where(
              (itinerary) =>
                  !(itinerary.legs ?? []).every((leg) => leg.mode == Mode.walk),
            )
            .toList(),
      );
    }

    return planEntity.copyWith(
      // planInfoBox: planEntity.isOnlyWalk
      //     ? PlanInfoBox.noRouteMsg
      //     : (mainFetchIsEmpty
      //         ? PlanInfoBox.usingDefaultTransports
      //         : PlanInfoBox.undefined),
    );
  }

  Future<PlanEntity> fetchMoreItineraries({
    required TrufiLocation from,
    required TrufiLocation to,
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    PlanEntity planData = await _graphQLPlanRepository.fetchPlanAdvanced(
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
    PlanEntity planEntity = planData;

    return planEntity.copyWith(
      // planInfoBox: planEntity.isOnlyWalk
      //     ? PlanInfoBox.noRouteMsg
      //     : (mainFetchIsEmpty
      //           ? PlanInfoBox.noRouteMsgWithChanges
      //           : PlanInfoBox.undefined),
    );
  }

  Future<ModesTransportEntity> fetchTransportModePlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    ModesTransportEntity planEntityData = await _graphQLPlanRepository
        .fetchWalkBikePlanQuery(
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
                  (itinerary.legs ?? []).any((leg) => leg.transitLeg ?? false),
            )
            .toList(),
      ),
    );
    return planEntityData;
  }
}
