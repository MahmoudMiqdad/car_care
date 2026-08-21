import 'package:car_care/features/provider_invoices/domain/entities/provider_invoices_list_entity.dart';

abstract class ProviderInvoicesState {}

class ProviderInvoicesInitial extends ProviderInvoicesState {}

class ProviderInvoicesLoading extends ProviderInvoicesState {}

class ProviderInvoicesLoaded extends ProviderInvoicesState {
  final ProviderInvoicesListEntity response;
  ProviderInvoicesLoaded(this.response);
}

class ProviderInvoicesError extends ProviderInvoicesState {
  final String message;
  ProviderInvoicesError(this.message);
}