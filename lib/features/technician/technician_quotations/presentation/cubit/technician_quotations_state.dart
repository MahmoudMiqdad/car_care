

import 'package:car_care/features/technician/technician_quotations/domain/entities/technician_quotations_entity.dart';

abstract class SubmitQuotationState {
  const SubmitQuotationState();
}

class SubmitQuotationInitial extends SubmitQuotationState {}

class SubmitQuotationLoading extends SubmitQuotationState {}

class SubmitQuotationSuccess extends SubmitQuotationState {
  final SubmitQuotationEntity data;

  const SubmitQuotationSuccess(this.data);
}

class SubmitQuotationError extends SubmitQuotationState {
  final String message;

  const SubmitQuotationError(this.message);
}