import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpaceFormState {
  final String spaceName;
  final String? spaceType;
  final String description;
  final String? capacity;

  final String streetAddress;
  final String? city;
  final String? state;
  final String zipCode;

  final String hourlyRate;
  final String minHours;
  final List<String> availableDays;
  final String? availableFrom;
  final String? availableUntil;

  final List<String> amenities;
  final String spaceRules;

  const SpaceFormState({
    this.spaceName = '',
    this.spaceType,
    this.description = '',
    this.capacity,
    this.streetAddress = '',
    this.city,
    this.state,
    this.zipCode = '',
    this.hourlyRate = '',
    this.minHours = '',
    this.availableDays = const [],
    this.availableFrom,
    this.availableUntil,
    this.amenities = const [],
    this.spaceRules = '',
  });

  SpaceFormState copyWith({
    String? spaceName,
    String? spaceType,
    String? description,
    String? capacity,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? hourlyRate,
    String? minHours,
    List<String>? availableDays,
    String? availableFrom,
    String? availableUntil,
    List<String>? amenities,
    String? spaceRules,
  }) {
    return SpaceFormState(
      spaceName: spaceName ?? this.spaceName,
      spaceType: spaceType ?? this.spaceType,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      minHours: minHours ?? this.minHours,
      availableDays: availableDays ?? this.availableDays,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
      amenities: amenities ?? this.amenities,
      spaceRules: spaceRules ?? this.spaceRules,
    );
  }
}

class SpaceFormNotifier extends StateNotifier<SpaceFormState> {
  SpaceFormNotifier() : super(const SpaceFormState());

  void update(SpaceFormState Function(SpaceFormState) updater) {
    state = updater(state);
  }
}

final spaceFormProvider =
    StateNotifierProvider<SpaceFormNotifier, SpaceFormState>(
  (ref) => SpaceFormNotifier(),
);
