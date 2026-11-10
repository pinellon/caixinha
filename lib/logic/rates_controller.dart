import 'package:caixinha/data/models/exchange_rate.dart';
import 'package:caixinha/data/services/rates_service.dart';
import 'package:caixinha/logic/load_status.dart';
import 'package:flutter/foundation.dart';

class RatesController extends ChangeNotifier {
  RatesController(this._service);

  final RatesService _service;

  LoadStatus _status = LoadStatus.loading;
  List<ExchangeRate> _rates = [];
  String? _errorMessage;

  LoadStatus get status => _status;
  List<ExchangeRate> get rates => List.unmodifiable(_rates);
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    if (_status != LoadStatus.loading) {
      _status = LoadStatus.loading;
      notifyListeners();
    }
    try {
      _rates = await _service.fetchRates();
      _errorMessage = null;
      _status = LoadStatus.ready;
    } on RatesException catch (error) {
      _errorMessage = error.message;
      _status = LoadStatus.error;
    } catch (_) {
      _errorMessage =
          'Não foi possível obter as cotações. Verifique sua conexão com a internet.';
      _status = LoadStatus.error;
    }
    notifyListeners();
  }
}
