import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/utils/wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrencyPicker extends StatelessWidget {
  final String selectedCurrency;
  final VoidCallback onScrollStart;
  final Function(int) onScrollEnd;
  final Function(String) onSelectCurrency;
  CurrencyPicker({this.selectedCurrency, this.onScrollStart, this.onScrollEnd, this.onSelectCurrency});

  DropdownButton<String> androidDropdown() => DropdownButton<String>(
        value: selectedCurrency,
        alignment: Alignment.topRight,
        menuMaxHeight: 200.0,
        items: currenciesList.map((element) => DropdownMenuItem(child: Text(element), value: element)).toList(),
        onChanged: (value) => () => onSelectCurrency(value),
      );

  CupertinoPicker iOSPicker() => CupertinoPicker(
        itemExtent: 46.0,
        magnification: 1.2,
        onSelectedItemChanged: (selectedIndex) => () => onSelectCurrency(currenciesList[selectedIndex]),
        scrollController: FixedExtentScrollController(initialItem: currenciesList.indexOf(selectedCurrency) ?? 1),
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
    return Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? scrollListenerWrapper(onScrollStart, onScrollEnd, iOSPicker()) : androidDropdown(),
    );
  }
}
