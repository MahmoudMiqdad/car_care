import 'package:car_care/features/technician/technician_quotations/domain/repositories/i_technician_quotations_repository.dart';
import 'package:car_care/features/technician/technician_quotations/presentation/cubit/technician_quotations_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SubmitQuotationCubit extends Cubit<SubmitQuotationState> {
  SubmitQuotationCubit(this._repository)
      : super(SubmitQuotationInitial());

  final ITechnicianQuotationsRepository _repository;

  Future<void> submitQuotation(
    Map<String, dynamic> data,
    String requestId,
  ) async {
    emit(SubmitQuotationLoading());

    final result =
        await _repository.submitQuotation(data, requestId);

    result.fold(
      (failure) => emit(SubmitQuotationError(failure.message)),
      (data) => emit(SubmitQuotationSuccess(data)),
    );
  }
}