import 'package:car_care/features/maintenance/user_quotations/domain/entities/accept_quotations_entity.dart';
import 'package:car_care/features/maintenance/user_quotations/domain/entities/quotations_entity.dart';

abstract class QuotationsState {
  const QuotationsState();
}

// initial
class QuotationsInitial extends QuotationsState {}

// loading
class QuotationsLoading extends QuotationsState {}

// fetch quotations success
class QuotationsLoaded extends QuotationsState {
  final QuotationsEntity quotations;

  const QuotationsLoaded(this.quotations);
}

// fetch accepted quotations success
class AcceptedQuotationsLoaded extends QuotationsState {
  final QuotationsEntity quotations;

  const AcceptedQuotationsLoaded(this.quotations);
}

// accept quotation success
class QuotationAccepted extends QuotationsState {
  final AcceptQuotationEntity result;

  const QuotationAccepted(this.result);
}

// reject quotation success
class QuotationRejected extends QuotationsState {
  final AcceptQuotationEntity result;

  const QuotationRejected(this.result);
}

// error
class QuotationsError extends QuotationsState {
  final String message;

  const QuotationsError(this.message);
}