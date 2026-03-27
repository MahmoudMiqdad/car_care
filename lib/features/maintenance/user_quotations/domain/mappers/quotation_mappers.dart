
  import 'package:car_care/features/maintenance/user_quotations/data/models/accept_quotations_model.dart';
import 'package:car_care/features/maintenance/user_quotations/data/models/quotations_model.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/accept_quotations_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotation_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotations_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/service_job_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/technician_entity.dart';

QuotationsEntity mapQuotations(QuotationsModel model) {
    return QuotationsEntity(
      success: model.success ?? false,
      data: model.data?.map((e) {
            return QuotationEntity(
              id: e.id ?? 0,
              price: e.price ?? 0,
              priceFormatted: e.priceFormatted ?? '',
              estimatedDays: e.estimatedDays ?? 0,
              notes: e.notes ?? '',
              partsIncluded: e.partsIncluded ?? false,
              status: e.status ?? '',
              statusText: e.statusText ?? '',
              createdAt: e.createdAt ?? DateTime.now(),
              createdAgo: e.createdAgo ?? '',
              technician: TechnicianEntity(
                id: e.technician?.id ?? 0,
                name: e.technician?.name ?? '',
                phone: e.technician?.phone ?? '',
                technicianProfile: TechnicianProfileEntity(
                  specialization: e.technician?.technicianProfile?.specialization ?? '',
                  experienceYears: e.technician?.technicianProfile?.experienceYears ?? 0,
                ),
              ),
            );
          }).toList() ??
          [],
    );
  }

  AcceptQuotationEntity mapAccept(AcceptQuotationsModel model) {
    final q = model.data.quotation;
    final s = model.data.serviceJob;

    return AcceptQuotationEntity(
      success: model.success,
      message: model.message,
      data: AcceptQuotationDataEntity(
        quotation: QuotationEntity(
          id: q.id,
          price: q.price,
          priceFormatted: q.priceFormatted,
          estimatedDays: q.estimatedDays,
          notes: q.notes,
          partsIncluded: q.partsIncluded,
          status: q.status,
          statusText: q.statusText,
          createdAt: q.createdAt,
          createdAgo: q.createdAgo,
          technician: TechnicianEntity(
            id: q.technician.id,
            name: q.technician.name,
            phone: q.technician.phone,
            technicianProfile: TechnicianProfileEntity(
              specialization: q.technician.technicianProfile.specialization,
              experienceYears: q.technician.technicianProfile.experienceYears,
            ),
          ),
        ),
        serviceJob: ServiceJobEntity(
          maintenanceRequestId: s.maintenanceRequestId,
          quotationId: s.quotationId,
          technicianId: s.technicianId,
          status: s.status,
          scheduledDate: s.scheduledDate,
          notes: s.notes,
          updatedAt: s.updatedAt,
          createdAt: s.createdAt,
          id: s.id,
        ),
      ),
    );
  }
