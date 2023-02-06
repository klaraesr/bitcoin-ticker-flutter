import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RateCard extends StatelessWidget {
  final String baseCurrency;
  final String currency;
  final String rate;
  final bool isLoading;

  RateCard({this.baseCurrency, this.currency, this.rate, this.isLoading});

  @override
  Widget build(Object context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '1 $baseCurrency = ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              isLoading
                  ? Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: SpinKitThreeBounce(color: Color.fromARGB(255, 245, 249, 255), size: 20.0))
                  : Text(
                      '$rate $currency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
