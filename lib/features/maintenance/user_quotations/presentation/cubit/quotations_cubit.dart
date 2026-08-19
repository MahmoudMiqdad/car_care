import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/repositories/i_quotations_repository.dart';
import 'quotations_state.dart';

class QuotationsCubit extends Cubit<QuotationsState> {
  final IQuotationsRepository _repository;

  bool _accepting = false;
  bool _rejecting = false;

  QuotationsCubit(this._repository) : super(QuotationsInitial());

  Future<void> fetchQuotations(String requestId) async {
    emit(QuotationsLoading());

    final result = await _repository.fetchQuotations(requestId);

    result.fold(
      (failure) => emit(QuotationsError(failure.displayMessage)),
      (data) => emit(QuotationsLoaded(data)),
    );
  }

  Future<void> fetchAcceptedQuotations(String requestId) async {
    emit(QuotationsLoading());

    final result = await _repository.fetchAcceptedQuotations(requestId);

    result.fold(
      (failure) => emit(QuotationsError(failure.displayMessage)),
      (data) => emit(AcceptedQuotationsLoaded(data)),
    );
  }

  Future<void> acceptQuotation(
    Map<String, dynamic> data,
    String requestId,
    String quotationId,
  ) async {
    if (_accepting) return;
    _accepting = true;

    emit(QuotationsLoading());

    final result = await _repository.acceptQuotation(
      data,
      requestId,
      quotationId,
    );

    _accepting = false;

    result.fold(
      (failure) => emit(QuotationsError(failure.displayMessage)),
      (res) => emit(QuotationAccepted(res)),
    );
  }

  Future<void> rejectQuotation(String reason, String quotationId) async {
    if (_rejecting) return;
    _rejecting = true;

    emit(QuotationsLoading());

    final result = await _repository.rejectQuotation(reason, quotationId);

    _rejecting = false;

    result.fold(
      (failure) => emit(QuotationsError(failure.displayMessage)),
      (res) => emit(QuotationRejected(res)),
    );
  }
}
