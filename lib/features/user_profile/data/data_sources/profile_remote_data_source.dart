import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/user_profile/data/model/profile_model.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.put(
      endPoint: ApiEndpoints.updateprofile,
      data: data,
    );
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> deleteProfile() async {
    final response = await _apiService.delete(
      endPoint: ApiEndpoints.deletprofile,
    );
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updatePassword(Map<String, dynamic> data) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.updatepassword,
      data: data,
    );
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateAvatar(Map<String, dynamic> data) async {
    final response = await _apiService.post(
      endPoint: ApiEndpoints.updateavatar,
      data: data,
    );
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> deleteAvatar() async {
    final response = await _apiService.delete(
      endPoint: ApiEndpoints.deletavatar,
    );
    return ProfileModel.fromJson(response);
  }
   Future<ProfileModel> showprofile() async {
   
    final response = await _apiService.get(
      endPoint: ApiEndpoints.showprofile,
    );
   
    return ProfileModel.fromJson(response);
  }
}