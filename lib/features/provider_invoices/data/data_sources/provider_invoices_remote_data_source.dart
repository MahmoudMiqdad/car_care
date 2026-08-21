import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoice_details_model.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoices_list_model.dart';

class ProviderInvoicesRemoteDataSource {
  const ProviderInvoicesRemoteDataSource(this._apiService);

  final ApiService _apiService;

  /// getMyInvoices
  Future<ProviderInvoicesListModel> getMyInvoices() async {
    final response = await _apiService.get(
      endPoint: ApiEndpoints.providerInvoices,
    );


    return ProviderInvoicesListModel.fromJson(response);
  }

  /// showInvoice
  Future<ProviderInvoiceDetailsModel> showInvoice(String id) async {
    final response = await _apiService.get(
      endPoint: '${ApiEndpoints.providerInvoices}/$id',
    );

    return ProviderInvoiceDetailsModel.fromJson(response['data']);
  }
}