import 'package:car_care/features/provider_invoices/domain/repositories/i_provider_invoices_repository.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/list/provider_invoices_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderInvoicesCubit extends Cubit<ProviderInvoicesState> {
  final IProviderInvoicesRepository _repository;
  ProviderInvoicesCubit(this._repository) : super(ProviderInvoicesInitial());

  Future<void> fetch() async {
    emit(ProviderInvoicesLoading());
    final result = await _repository.getMyInvoices();
    result.fold(
      (failure) => emit(ProviderInvoicesError(failure.message)),
      (response) => emit(ProviderInvoicesLoaded(response)),
    );
  }
}