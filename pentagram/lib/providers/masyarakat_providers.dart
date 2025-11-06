import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/population_service.dart';

final populationServiceProvider = Provider<PopulationService>((ref) => PopulationService());

class MasyarakatState {
  final bool loading;
  final String? error;
  const MasyarakatState({this.loading = false, this.error});
  MasyarakatState copyWith({bool? loading, String? error}) =>
      MasyarakatState(loading: loading ?? this.loading, error: error);
}

class MasyarakatController extends StateNotifier<MasyarakatState> {
  MasyarakatController(this._ref) : super(const MasyarakatState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      _ref.read(populationServiceProvider).getPopulationStatistics();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final masyarakatControllerProvider = StateNotifierProvider<MasyarakatController, MasyarakatState>((ref) => MasyarakatController(ref));
