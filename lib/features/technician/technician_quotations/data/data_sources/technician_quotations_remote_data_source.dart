import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/technician/technician_quotations/data/models/submit_quotation_model.dart';

class TechnicianQuotationsRemoteDataSource {

  const TechnicianQuotationsRemoteDataSource(this._apiService);

  final ApiService _apiService;

    Future<SubmitQuotationModel> updateTechnicianProfile(Map<String, dynamic> data,String idRequest) async {
    final response = await _apiService.post(
      endPoint:"${ ApiEndpoints.submitQuotation}/$idRequest/quotation",
      data: data,
    );
    return SubmitQuotationModel.fromJson(response);
  }
  
}
