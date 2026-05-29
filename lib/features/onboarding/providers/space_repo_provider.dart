import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/space_repository.dart';

final spaceRepositoryProvider = Provider<SpaceRepository>(
  (_) => SpaceRepository(),
);
