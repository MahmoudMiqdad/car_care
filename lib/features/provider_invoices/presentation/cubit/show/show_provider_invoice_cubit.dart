
import 'package:car_care/features/provider_invoices/domain/repositories/i_provider_invoices_repository.dart';
import 'package:car_care/features/provider_invoices/presentation/cubit/show/show_provider_invoice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowProviderInvoiceCubit extends Cubit<ShowProviderInvoiceState> {
  final IProviderInvoicesRepository _repository;
  ShowProviderInvoiceCubit(this._repository)
      : super(ShowProviderInvoiceInitial());

  Future<void> fetchInvoice(String id) async {
    emit(ShowProviderInvoiceLoading());
    final result = await _repository.showInvoice(id);
    result.fold(
      (failure) => emit(ShowProviderInvoiceError(failure.message)),
      (invoice) => emit(ShowProviderInvoiceLoaded(invoice)),
    );
  }
}