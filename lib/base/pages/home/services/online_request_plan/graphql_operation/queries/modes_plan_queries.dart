// ...ItineraryListContainer_plan
// ...ItineraryDetails_plan
// ...ItineraryDetails_itinerary
// ...ItineraryListContainer_itineraries
// ...ItineraryLine_legs
// ...RouteLine_pattern
// ...ItineraryList_itineraries

const String walkAndBikeQuery = r'''
  query ItineraryQueries_WalkBike_Query(
    $fromPlace: String!
    $toPlace: String!
    $intermediatePlaces: [InputCoordinates!]
    $date: String!
    $time: String!
    $walkReluctance: Float
    $walkBoardCost: Int
    $minTransferTime: Int
    $walkSpeed: Float
    $wheelchair: Boolean
    $ticketTypes: [String]
    $arriveBy: Boolean
    $transferPenalty: Int
    $bikeSpeed: Float
    $optimize: OptimizeType
    $triangle: InputTriangle
    $itineraryFiltering: Float
    $unpreferred: InputUnpreferred
    $locale: String
    $shouldMakeWalkQuery: Boolean!
    $shouldMakeBikeQuery: Boolean!
    $shouldMakeCarQuery: Boolean!
    $shouldMakeParkRideQuery: Boolean!
    $shouldMakeOnDemandTaxiQuery: Boolean!
    # TODO harmonize names shouldMakeXYZQuery vs showXYZItineraries
    $showBikeAndPublicItineraries: Boolean!
    $showBikeRentAndPublicItineraries: Boolean!
    $showBikeAndParkItineraries: Boolean!
    $shouldMakeScooterQuery: Boolean!
    $bikeAndPublicModes: [TransportMode!]
    $bikeRentAndPublicModes: [TransportMode!]
    $scooterRentAndPublicModes: [TransportMode!]
    $onDemandTaxiModes: [TransportMode!]
    $bikeParkModes: [TransportMode!]
    $carParkModes: [TransportMode!]
    $carRentalModes: [TransportMode!]
    $parkRideModes: [TransportMode!]
    # TODO still to be implemented in upstream OTP
    # $bannedVehicleParkingTags: [String]
    # $bannedBicycleParkingTags: [String]
    # $preferredBicycleParkingTags: [String]
    # $unpreferredBicycleParkingTagPenalty: Float
    # $useVehicleParkingAvailabilityInformation: Boolean
    $allowedVehicleRentalNetworks: [String]
  ) {
    walkPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      transportModes: [{ mode: WALK }]
      date: $date
      time: $time
      walkSpeed: $walkSpeed
      wheelchair: $wheelchair
      arriveBy: $arriveBy
      locale: $locale
    ) @include(if: $shouldMakeWalkQuery) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        walkDistance
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        legs {
          mode
          ...ItineraryLine_legs
          steps {
            distance
            lon
            lat
            relativeDirection
            absoluteDirection
            streetName
            exit
            stayOn
            area
            walkingBike
            bogusName
            alerts {
              feed
            }
          }
          legGeometry {
            points
          }
          distance
        }
      }
    }

    bikePlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      transportModes: [{ mode: BICYCLE }]
      date: $date
      time: $time
      walkSpeed: $walkSpeed
      arriveBy: $arriveBy
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      locale: $locale
    ) @include(if: $shouldMakeBikeQuery) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        legs {
          mode
          ...ItineraryLine_legs
          legGeometry {
            points
          }
          distance
        }
      }
    }

    bikeAndPublicPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 6
      transportModes: $bikeAndPublicModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      locale: $locale
    ) @include(if: $showBikeAndPublicItineraries) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          mode
          ...ItineraryLine_legs
          transitLeg
          legGeometry {
            points
          }
          route {
            gtfsId
            type
            shortName
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          distance
        }
      }
    }

    bikeRentAndPublicPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 6
      transportModes: $bikeRentAndPublicModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      allowedVehicleRentalNetworks: $allowedVehicleRentalNetworks
      locale: $locale
    ) @include(if: $showBikeRentAndPublicItineraries) {
      # todo: does this match the expected data of bike (rent) + public itineraries
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          mode
          ...ItineraryLine_legs
          transitLeg
          rentedBike
          startTime
          endTime
          legGeometry {
            points
          }
          route {
            gtfsId
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          distance
        }
      }
    }

    scooterRentAndPublicPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 6
      transportModes: $scooterRentAndPublicModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      allowedVehicleRentalNetworks: $allowedVehicleRentalNetworks
      locale: $locale
    ) @include(if: $shouldMakeScooterQuery) {
      # todo: does this match the expected data of scooter (rent) + public itineraries
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          mode
          ...ItineraryLine_legs
          transitLeg
          rentedBike
          startTime
          endTime
          legGeometry {
            points
          }
          route {
            gtfsId
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          distance
        }
      }
    }

    onDemandTaxiPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 6
      transportModes: $onDemandTaxiModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      locale: $locale
      searchWindow: 10800
    ) @include(if: $shouldMakeOnDemandTaxiQuery) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        ...ItineraryList_itineraries
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          mode
          ...ItineraryLine_legs
          transitLeg
          rentedBike
          distance
          startTime
          endTime
          route {
            url
            mode
            shortName
          }
          legGeometry {
            points
          }
          trip {
            gtfsId
            tripShortName
          }
        }
      }
    }

    bikeParkPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 6
      transportModes: $bikeParkModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      locale: $locale
    )
    # TODO still be added in upstream OTP
    # bannedVehicleParkingTags: $bannedBicycleParkingTags
    # preferredVehicleParkingTags: $preferredBicycleParkingTags
    # unpreferredVehicleParkingTagPenalty: $unpreferredBicycleParkingTagPenalty
    @include(if: $showBikeAndParkItineraries) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          mode
          ...ItineraryLine_legs
          transitLeg
          legGeometry {
            points
          }
          route {
            gtfsId
            type
            shortName
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          to {
            bikePark {
              bikeParkId
              name
            }
          }
          distance
        }
      }
    }

    carPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 5
      transportModes: $carParkModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      locale: $locale
    ) @include(if: $shouldMakeCarQuery) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          startTime
          endTime
          mode
          ...ItineraryLine_legs
          transitLeg
          legGeometry {
            points
          }
          route {
            gtfsId
            type
            shortName
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          from {
            name
            lat
            lon
          }
          to {
            name
            lat
            lon
            bikePark {
              bikeParkId
              name
            }
          }
          distance
        }
      }
    }

    carRentalPlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 1
      transportModes: $carRentalModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      allowedVehicleRentalNetworks: $allowedVehicleRentalNetworks
      locale: $locale
    ) @include(if: $shouldMakeCarQuery) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          startTime
          endTime
          mode
          ...ItineraryLine_legs
          rentedBike
          transitLeg
          legGeometry {
            points
          }
          route {
            gtfsId
            type
            shortName
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          from {
            name
            lat
            lon
          }
          to {
            name
            lat
            lon
            bikePark {
              bikeParkId
              name
            }
          }
          distance
        }
      }
    }

    parkRidePlan: plan(
      fromPlace: $fromPlace
      toPlace: $toPlace
      intermediatePlaces: $intermediatePlaces
      numItineraries: 5
      transportModes: $parkRideModes
      date: $date
      time: $time
      walkReluctance: $walkReluctance
      walkBoardCost: $walkBoardCost
      minTransferTime: $minTransferTime
      walkSpeed: $walkSpeed
      allowedTicketTypes: $ticketTypes
      arriveBy: $arriveBy
      transferPenalty: $transferPenalty
      bikeSpeed: $bikeSpeed
      optimize: $optimize
      triangle: $triangle
      itineraryFiltering: $itineraryFiltering
      unpreferred: $unpreferred
      locale: $locale
    )
    # TODO add to upstream OTP
    # useVehicleParkingAvailabilityInformation: $useVehicleParkingAvailabilityInformation
    # bannedVehicleParkingTags: $bannedVehicleParkingTags
    @include(if: $shouldMakeParkRideQuery) {
      ...ItineraryListContainer_plan
      ...ItineraryDetails_plan
      itineraries {
        duration
        startTime
        endTime
        ...ItineraryDetails_itinerary
        ...ItineraryListContainer_itineraries
        emissionsPerPerson {
          co2
        }
        legs {
          mode
          ...ItineraryLine_legs
          transitLeg
          startTime
          legGeometry {
            points
          }
          route {
            gtfsId
            type
            shortName
          }
          trip {
            gtfsId
            directionId
            stoptimesForDate {
              scheduledDeparture
            }
            pattern {
              ...RouteLine_pattern
            }
          }
          to {
            carPark {
              carParkId
              name
            }
            name
            lat
            lon
          }
          from {
            name
            lat
            lon
          }
          distance
        }
      }
    }
  }
''';
