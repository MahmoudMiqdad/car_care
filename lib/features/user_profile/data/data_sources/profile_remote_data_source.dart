import 'package:car_care/core/functions/upload_file_to_api.dart';
import 'package:car_care/core/network/api_endpoints.dart';
import 'package:car_care/core/network/api_service.dart';
import 'package:car_care/features/user_profile/data/model/avatar_model.dart';
import 'package:car_care/features/user_profile/data/model/profile_model.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<AvatarModel> updateAvatar(XFile avatar) async {
    final response = await _apiService.post(
      isFomrData: true,
      endPoint: ApiEndpoints.updateavatar,
      data: {
        "avatar":await uploadFiletoApi(avatar)
      },
    );
    return AvatarModel.fromJson(response);
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