import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/features/provider_invoices/data/data_sources/provider_invoices_remote_data_source.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoice_details_entity.dart';
import 'package:car_care/features/provider_invoices/domain/entities/provider_invoices_list_entity.dart';
import 'package:car_care/features/provider_invoices/domain/mapper/provider_invoice_details_mapper.dart';
import 'package:car_care/features/provider_invoices/domain/mapper/provider_invoice_mapper.dart';
import 'package:car_care/features/provider_invoices/domain/repositories/i_provider_invoices_repository.dart';

import 'package:dartz/dartz.dart';

class ProviderInvoicesRepositoryImpl implements IProviderInvoicesRepository {
  final ProviderInvoicesRemoteDataSource remoteDataSource;
  ProviderInvoicesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProviderInvoicesListEntity>> getMyInvoices() async {
    try {
      final model = await remoteDataSource.getMyInvoices();
      return Right(mapProviderInvoicesList(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ أثناء جلب الفواتير'));
    }
  }

  @override
  Future<Either<Failure, ProviderInvoiceDetailsEntity>> showInvoice(
      String id) async {
    try {
      final model = await remoteDataSource.showInvoice(id);
      return Right(mapProviderInvoiceDetails(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}