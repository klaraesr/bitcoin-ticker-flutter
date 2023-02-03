import 'dart:convert';
import 'dart:ffi';

import 'package:bitcoin_ticker/api_key.dart';
import 'package:bitcoin_ticker/utils/wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:money2/money2.dart' show Currency;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = '-';
  String selectedCurrencyBtcRate = '-';
  NumberFormat compactFormatter = NumberFormat.compact();
  bool isScrolling = false;

  void updateSelectedCurrency(selectedIndex) => setState(
        () {
          selectedCurrency = currenciesList[selectedIndex];
        },
      );

  Future<http.Response> fetchRate() async {
    http.Response resp = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency'),
        headers: {"X-CoinAPI-Key": api_key});
    return resp;
    // print(jsonDecode(resp.body));
    // setState(() {
    //   selectedCurrencyBtcRate = compactFormatter.format(jsonDecode(resp.body)['rate']);
    // });
  }

  void onScrollStart() {
    setState(() {
      isScrolling = true;
      selectedCurrency = '-';
      selectedCurrencyBtcRate = '-';
    });
  }

  void onScrollEnd(selectedIndex) async {
    var selected = currenciesList[selectedIndex];
    var currencyData = await fetchRate();
    setState(() {
      isScrolling = false;
      selectedCurrency = selected;
      selectedCurrencyBtcRate = compactFormatter.format(jsonDecode(currencyData.body)['rate']);
    });
  }

  DropdownButton<String> androidDropdown() => DropdownButton<String>(
        value: selectedCurrency,
        alignment: Alignment.topRight,
        menuMaxHeight: 200.0,
        items: currenciesList.map((element) => DropdownMenuItem(child: Text(element), value: element)).toList(),
        onChanged: (value) => setState(() => selectedCurrency = value),
      );

  CupertinoPicker iOSPicker() => CupertinoPicker(
        itemExtent: 46.0,
        magnification: 1.2,
        onSelectedItemChanged: (selectedIndex) => setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        }),
        children: currenciesList
            .map((element) => DropdownMenuItem(
                alignment: Alignment.center,
                child: Text(
                  element,
                  textAlign: TextAlign.center,
                ),
                value: element))
            .toList(),
      );

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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $selectedCurrencyBtcRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? scrollListenerWrapper(onScrollStart, onScrollEnd, iOSPicker()) : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
