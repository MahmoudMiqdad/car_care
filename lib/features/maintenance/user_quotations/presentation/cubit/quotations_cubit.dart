import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/repositories/i_quotations_repository.dart';
import 'quotations_state.dart';

class QuotationsCubit extends Cubit<QuotationsState> {
  final IQuotationsRepository _repository;

  QuotationsCubit(this._repository) : super(QuotationsInitial());

  /// fetch all quotations
  Future<void> fetchQuotations(String requestId) async {
    emit(QuotationsLoading());

    final result = await _repository.fetchQuotations(requestId);

    result.fold(
      (failure) => emit(QuotationsError(failure.message)),
      (data) => emit(QuotationsLoaded(data)),
    );
  }

  /// fetch accepted quotations
  Future<void> fetchAcceptedQuotations(String requestId) async {
    emit(QuotationsLoading());

    final result = await _repository.fetchAcceptedQuotations(requestId);

    result.fold(
      (failure) => emit(QuotationsError(failure.message)),
      (data) => emit(AcceptedQuotationsLoaded(data)),
    );
  }

  /// accept quotation
  Future<void> acceptQuotation(
    Map<String, dynamic> data,
    String requestId,
    String quotationId,
  ) async {
    emit(QuotationsLoading());

    final result = await _repository.acceptQuotation(
      data,
      requestId,
      quotationId,
    );

    result.fold(
      (failure) => emit(QuotationsError(failure.message)),
      (res) => emit(QuotationAccepted(res)),
    );
  }

  /// reject quotation
  Future<void> rejectQuotation(
    String reason,
    String quotationId,
  ) async {
    emit(QuotationsLoading());

    final result = await _repository.rejectQuotation(
      reason,
      quotationId,
    );

    result.fold(
      (failure) => emit(QuotationsError(failure.message)),
      (res) => emit(QuotationRejected(res)),
    );
  }
}