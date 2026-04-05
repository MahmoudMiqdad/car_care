
import 'package:car_care/features/user_profile/data/data_sources/profile_remote_data_source.dart';
import 'package:car_care/features/user_profile/data/model/avatar_model.dart';
import 'package:car_care/features/user_profile/domain/entities/Avatar_entity.dart';
import 'package:car_care/features/user_profile/domain/repositories/i_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_care/core/errors/excptions.dart';
import 'package:car_care/core/errors/filuar.dart';

import 'package:car_care/features/user_profile/data/model/profile_model.dart';
import 'package:car_care/features/user_profile/domain/entities/profile_entity.dart';


class ProfileRepositoryImpl implements IProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

AvatarEntity _mapAvatar(AvatarModel model) {
  final data = model.data;

  return AvatarEntity(
    success: model.success,
    message: model.message,
    avatarUrl: data.avatarUrl, 
  );
}
  ProfileEntity _map(ProfileModel model) {
    final data = model.data;
  

    return ProfileEntity(
      success: model.success,
      message: model.message,
      id: data?.id ?? 0,
      uuid: data?.uuid ?? '',
      name: data?.name ?? '',
      email: data?.email ?? '',
      phone: data?.phone ?? '',
      avatar: data?.avatar,
      status: data?.status ?? '',
      totalVehicles: data?.stats?.totalVehicles ?? 0,
      totalMaintenanceRequests: data?.stats?.totalMaintenanceRequests ?? 0,
      totalSosRequests: data?.stats?.totalSosRequests ?? 0,
      createdAt: data?.createdAt ?? DateTime.now(),
      createdAgo: data?.createdAgo ?? '',
      updatedAt: data?.updatedAt ?? DateTime.now(),
      profileCompleted: data?.profileCompleted ?? false,
    );
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateprofile(
    Map<String, dynamic> params,
  ) async {
    try {
      final model = await _remoteDataSource.updateProfile(params);
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, AvatarEntity>> updateavatar(
    XFile? avatar,
  ) async {
    try {
      if (avatar == null) {
        return const Left(Failure(message: 'لم يتم اختيار صورة'));
      }

   

      final model = await _remoteDataSource.updateAvatar(avatar);

      return Right(_mapAvatar(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> deletavatar() async {
    try {
      final model = await _remoteDataSource.deleteAvatar();
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
  @override
  Future<Either<Failure, ProfileEntity>> showprofile() async {
    try {
     
      final result = await _remoteDataSource.showprofile();
       
      print(result); 
      return right(_map(result));
    } on ServerExpcptions catch (e) {
      return left(e.error);
    } catch (_) {
      return left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
  @override
  Future<Either<Failure, ProfileEntity>> deletprofile(
    String password,
  ) async {
    try {
      final model = await _remoteDataSource.deleteProfile();
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updatepassword(
    String currentpassword,
    String newpassword,
    String newpasswordconfirmation,
  ) async {
    try {
      final model = await _remoteDataSource.updatePassword({
        "current_password": currentpassword,
        "new_password": newpassword,
        "new_password_confirmation": newpasswordconfirmation,
      });

      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
}