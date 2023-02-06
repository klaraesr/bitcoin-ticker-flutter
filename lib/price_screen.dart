import 'dart:convert';
import 'package:bitcoin_ticker/api_key.dart';
import 'package:bitcoin_ticker/utils/wrappers.dart';
import 'package:bitcoin_ticker/widgets/currency_picker.dart';
import 'package:bitcoin_ticker/widgets/rate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'coin_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map rates = new Map();
  bool isScrolling = false;
  NumberFormat compactFormatter = NumberFormat.compact();
  SpinKitThreeBounce loader2 = SpinKitThreeBounce(color: Color.fromARGB(255, 168, 198, 250), size: 20.0);

  @override
  initState() {
    super.initState();
    updateRates();
  }

  void updateRates() async {
    Map tempRates = new Map();
    cryptoList.forEach((element) async {
      try {
        var data = await fetchRate(element);
        tempRates[element] = compactFormatter.format(jsonDecode(data.body)['rate']);
      } catch (e) {
        print('Could not fetch rate for currency $element $e');
        tempRates[element] = '-';
      }
    });
    setState(() {
      isScrolling = false;
      rates = tempRates;
    });
  }

  void updateSelectedCurrency(selectedIndex) => setState(
        () {
          selectedCurrency = currenciesList[selectedIndex];
        },
      );

  Future<http.Response> fetchRate(String baseCurrency) async {
    http.Response resp = await http.get(
        Uri.parse('https://rest.coinapi.io/v1/exchangerate/$baseCurrency/$selectedCurrency'),
        headers: {"X-CoinAPI-Key": api_key});
    return resp;
  }

  void onScrollStart() {
    setState(() {
      isScrolling = true;
    });
  }

  void onScrollEnd(selectedIndex) async {
    updateRates();
    setState(() {
      selectedCurrency = currenciesList[selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RateCard(
                  baseCurrency: 'BTC', currency: selectedCurrency, rate: rates['BTC'] ?? '-', isLoading: isScrolling),
              RateCard(
                  baseCurrency: 'LTC', currency: selectedCurrency, rate: rates['LTC'] ?? '-', isLoading: isScrolling),
              RateCard(
                  baseCurrency: 'ETH', currency: selectedCurrency, rate: rates['ETH'] ?? '-', isLoading: isScrolling),
            ],
          ),
          CurrencyPicker(
            selectedCurrency: selectedCurrency,
            onScrollStart: onScrollStart,
            onScrollEnd: onScrollEnd,
            onSelectCurrency: (value) => setState(() {
              selectedCurrency = value;
            }),
          ),
        ],
      ),
    );
  }
}
