
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_details_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoices_list_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';

abstract class IProviderInvoicesRepository {
  Future<Either<Failure, ProviderInvoicesListEntity>> getMyInvoices();
  Future<Either<Failure, ProviderInvoiceDetailsEntity>> showInvoice(String id);
}