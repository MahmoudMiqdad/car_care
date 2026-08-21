import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_details_entity.dart';

abstract class ShowProviderInvoiceState {}

class ShowProviderInvoiceInitial extends ShowProviderInvoiceState {}

class ShowProviderInvoiceLoading extends ShowProviderInvoiceState {}

class ShowProviderInvoiceLoaded extends ShowProviderInvoiceState {
  final ProviderInvoiceDetailsEntity invoice;
  ShowProviderInvoiceLoaded(this.invoice);
}

class ShowProviderInvoiceError extends ShowProviderInvoiceState {
  final String message;
  ShowProviderInvoiceError(this.message);
}