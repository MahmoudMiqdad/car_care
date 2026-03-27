import 'package:car_care/features/technician/technician_profile/data/data_sources/technician_profile_remote_data_source.dart';
import 'package:car_care/features/technician/technician_profile/data/models/technician_availability_model.dart';
import 'package:car_care/features/technician/technician_profile/data/models/technician_profile.dart';
import 'package:car_care/features/technician/technician_profile/domain/entities/technician_availability_entity.dart';
import 'package:car_care/features/technician/technician_profile/domain/repositories/i_technician_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:car_care/core/errors/filuar.dart';
import 'package:car_care/core/errors/excptions.dart';
import '../../domain/entities/technician_profile_entity.dart';


class TechnicianProfileRepositoryImpl implements ITechnicianProfileRepository {
  final TechnicianProfileRemoteDataSource _remoteDataSource;

  TechnicianProfileRepositoryImpl(this._remoteDataSource);
TechnicianAvailabilityEntity _mapAvailability(TechnicianAvailabilityModel model) {
  return TechnicianAvailabilityEntity(
    success: model.success,
    message: model.message,
  );
}

  TechnicianProfileEntity _map(TechnicianProfile model) {
    final data = model.data;
    return TechnicianProfileEntity(
      success: model.success,
      data: data == null
          ? null
          : TechnicianDataEntity(
              id: data.id,
              userId: data.userId,
              specialization: data.specialization,
              experienceYears: data.experienceYears,
              phone: data.phone,
              city: data.city,
              hourlyRate: data.hourlyRate,
              isAvailable: data.isAvailable,
              certifications: data.certifications,
              certificationsRaw: data.certificationsRaw,
              user: data.user == null
                  ? null
                  : UserEntity(
                      id: data.user!.id,
                      name: data.user!.name,
                      email: data.user!.email,
                    ),
              createdAt: data.createdAt,
              updatedAt: data.updatedAt,
            ),
    );
  }

  @override
  Future<Either<Failure, TechnicianProfileEntity>> showProfile() async {
    try {
      final model = await _remoteDataSource.showProfile();
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, TechnicianProfileEntity>> updatetechnicianprofile(
      Map<String, dynamic> params) async {
    try {
      final model = await _remoteDataSource.updateTechnicianProfile(params);
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, TechnicianProfileEntity>> inserttechnicianprofile(
      Map<String, dynamic> params) async {
    try {
      final model = await _remoteDataSource.insertTechnicianProfile(params);
      return Right(_map(model));
    } on ServerExpcptions catch (e) {
      return Left(e.error);
    } catch (_) {
      return const Left(Failure(message: 'حدث خطأ غير متوقع'));
    }
  }
  @override
Future<Either<Failure, TechnicianAvailabilityEntity>> changeAvailability(String isAvailable) async {
  try {
    final model = await _remoteDataSource.changeAvailability(isAvailable);
    return Right(_mapAvailability(model));
  } on ServerExpcptions catch (e) {
    return Left(e.error);
  } catch (_) {
    return const Left(Failure(message: 'حدث خطأ غير متوقع'));
  }
}
}