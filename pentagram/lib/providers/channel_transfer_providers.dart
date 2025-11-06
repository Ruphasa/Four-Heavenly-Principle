import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/services/channel_transfer_service.dart';

final channelTransferServiceProvider = Provider<ChannelTransferService>((ref) => const ChannelTransferService());

class ChannelTransferState {
  final bool loading;
  final String? error;
  const ChannelTransferState({this.loading = false, this.error});
  ChannelTransferState copyWith({bool? loading, String? error}) =>
      ChannelTransferState(loading: loading ?? this.loading, error: error);
}

class ChannelTransferController extends StateNotifier<ChannelTransferState> {
  ChannelTransferController(this._ref) : super(const ChannelTransferState());
  final Ref _ref;
  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _ref.read(channelTransferServiceProvider).refresh();
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final channelTransferControllerProvider = StateNotifierProvider<ChannelTransferController, ChannelTransferState>((ref) => ChannelTransferController(ref));
