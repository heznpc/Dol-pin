import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/result.dart';

/// Payment result data
class PaymentResult {
  final String transactionId;
  final String status; // 'success', 'pending', 'failed'
  final int amount;
  final String currency;

  const PaymentResult({
    required this.transactionId,
    required this.status,
    required this.amount,
    required this.currency,
  });
}

/// Abstract payment gateway interface
abstract class PaymentGateway {
  Future<Result<PaymentResult>> initiatePayment({
    required String reservationId,
    required int amount,
    required String currency,
    required String description,
  });

  Future<Result<PaymentResult>> checkStatus(String transactionId);

  Future<Result<void>> refund(String transactionId, {int? amount});
}

/// PortOne (Korea) implementation
class PortOneGateway implements PaymentGateway {
  @override
  Future<Result<PaymentResult>> initiatePayment({
    required String reservationId,
    required int amount,
    required String currency,
    required String description,
  }) async {
    // TODO: Implement PortOne SDK integration
    // Uses iamport_flutter package
    return Fail(const ServerFailure('PortOne not yet configured'));
  }

  @override
  Future<Result<PaymentResult>> checkStatus(String transactionId) async {
    return Fail(const ServerFailure('PortOne not yet configured'));
  }

  @override
  Future<Result<void>> refund(String transactionId, {int? amount}) async {
    return Fail(const ServerFailure('PortOne not yet configured'));
  }
}

/// Xendit (Indonesia) implementation
class XenditGateway implements PaymentGateway {
  @override
  Future<Result<PaymentResult>> initiatePayment({
    required String reservationId,
    required int amount,
    required String currency,
    required String description,
  }) async {
    return Fail(const ServerFailure('Xendit not yet configured'));
  }

  @override
  Future<Result<PaymentResult>> checkStatus(String transactionId) async {
    return Fail(const ServerFailure('Xendit not yet configured'));
  }

  @override
  Future<Result<void>> refund(String transactionId, {int? amount}) async {
    return Fail(const ServerFailure('Xendit not yet configured'));
  }
}

/// Stripe (Japan/Global) implementation
class StripeGateway implements PaymentGateway {
  @override
  Future<Result<PaymentResult>> initiatePayment({
    required String reservationId,
    required int amount,
    required String currency,
    required String description,
  }) async {
    return Fail(const ServerFailure('Stripe not yet configured'));
  }

  @override
  Future<Result<PaymentResult>> checkStatus(String transactionId) async {
    return Fail(const ServerFailure('Stripe not yet configured'));
  }

  @override
  Future<Result<void>> refund(String transactionId, {int? amount}) async {
    return Fail(const ServerFailure('Stripe not yet configured'));
  }
}

/// Routes to the correct payment gateway based on currency
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

class PaymentService {
  PaymentGateway gatewayForCurrency(String currency) => switch (currency) {
        'KRW' => PortOneGateway(),
        'IDR' => XenditGateway(),
        _ => StripeGateway(),
      };

  Future<Result<PaymentResult>> pay({
    required String reservationId,
    required int amount,
    required String currency,
    required String description,
  }) {
    final gateway = gatewayForCurrency(currency);
    return gateway.initiatePayment(
      reservationId: reservationId,
      amount: amount,
      currency: currency,
      description: description,
    );
  }

  Future<Result<void>> refund({
    required String transactionId,
    required String currency,
    int? amount,
  }) {
    final gateway = gatewayForCurrency(currency);
    return gateway.refund(transactionId, amount: amount);
  }
}
