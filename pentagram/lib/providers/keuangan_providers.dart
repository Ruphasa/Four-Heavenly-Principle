import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/finance_service.dart';

final financeServiceProvider = Provider<FinanceService>((ref) => FinanceService());

class KeuanganState {
  final bool loading;
  final String? error;
  const KeuanganState({this.loading = false, this.error});
  KeuanganState copyWith({bool? loading, String? error}) =>
      KeuanganState(loading: loading ?? this.loading, error: error);
}

class KeuanganController extends StateNotifier<KeuanganState> {
  KeuanganController(this._ref) : super(const KeuanganState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      _ref.read(financeServiceProvider).getFinanceStatistics();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final keuanganControllerProvider = StateNotifierProvider<KeuanganController, KeuanganState>((ref) => KeuanganController(ref));
