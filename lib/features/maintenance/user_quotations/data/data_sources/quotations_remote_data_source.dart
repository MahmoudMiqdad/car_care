import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/maintenance/user_quotations/data/models/accept_quotations_model.dart';
import 'package:car_care/features/maintenance/user_quotations/data/models/quotations_model.dart';

class QuotationsRemoteDataSource {

  const QuotationsRemoteDataSource(this._apiService);

  final ApiService _apiService;

  ///fetchQuotations
  Future<QuotationsModel> fetchQuotations(String requestId) async {
    final response = await _apiService.get(
      endPoint: "${ApiEndpoints.quotations}/$requestId/quotations",
    );
    return QuotationsModel.fromJson(response);
  }

  /// acceptQuotation
  Future<AcceptQuotationsModel> acceptQuotation(
    Map<String, dynamic> data,
    String requestId,
    String quotationId,
  ) async {
    final response = await _apiService.post(
      endPoint: "${ApiEndpoints.quotations}/$requestId/accept-quotation/$quotationId",
      data: data,
    );
    return AcceptQuotationsModel.fromJson(response);
  }

  /// fetchAcceptedQuotations
  Future<QuotationsModel> fetchAcceptedQuotations(String requestId) async {
    final response = await _apiService.get(
      endPoint: "${ApiEndpoints.quotations}/$requestId/accepted-quotation",
    );
    return QuotationsModel.fromJson(response);
  }

  ///rejectQuotation
  Future<AcceptQuotationsModel> rejectQuotation(
    String reason,
    String quotationId,
  ) async {
    final response = await _apiService.post(
      endPoint: "${ApiEndpoints.quotations}/quotations/$quotationId/reject",
      data: {"reason": reason}, 
    );
    return AcceptQuotationsModel.fromJson(response);
  }
}
