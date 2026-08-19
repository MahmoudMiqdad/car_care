
import 'package:car_care/features/provider_invoices/data/models/meta_model.dart';
import 'package:car_care/features/provider_invoices/data/models/provider_invoice_model.dart';

class ProviderInvoicesListModel {
  final bool? success;
  final List<ProviderInvoiceModel> data;
  final MetaModel? meta;

  ProviderInvoicesListModel({
    this.success,
    required this.data,
    this.meta,
  });

  factory ProviderInvoicesListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProviderInvoicesListModel(data: []);

    return ProviderInvoicesListModel(
      success: json["success"],
      data: json["data"] != null
          ? List<ProviderInvoiceModel>.from(
              json["data"].map((x) => ProviderInvoiceModel.fromJson(x)))
          : [],
      meta: json["meta"] != null ? MetaModel.fromJson(json["meta"]) : null,
    );
  }
}