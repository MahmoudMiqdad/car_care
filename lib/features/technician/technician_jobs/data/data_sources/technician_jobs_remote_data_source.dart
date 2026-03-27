import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/technician/technician_jobs/data/models/my_jobs_model.dart';
import 'package:car_care/features/technician/technician_jobs/data/models/update_job_status_model.dart';

class TechnicianJobsRemoteDataSource {

  const TechnicianJobsRemoteDataSource(this._apiService);

  final ApiService _apiService;

   Future<MyJobsModel> fetchmyJobs() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.myJobs,
    );
   
    return MyJobsModel.fromJson(response);
  }
     Future<MyJobsModel> fetchmyacceptedJobs() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.myacceptedJobs,
    );
   
    return MyJobsModel.fromJson(response);
  }

    Future<UpdateJobStatusModel> changeAvailability( Map<String, dynamic> data, String id) async {
    final response = await _apiService.patch(
      endPoint: "${ApiEndpoints.updateJobStatus}/$id/status",
      data: data,
    );
    return UpdateJobStatusModel.fromJson(response);
  }
}
