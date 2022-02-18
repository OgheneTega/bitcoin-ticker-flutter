import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();

  String selectedCurrency = "AUD";

  Map<String, dynamic> cryptoPrices = {};
  bool isLoading = false;

  void getCoinData() async {
    for (String crypto in cryptoList) {
      isLoading = true;
      try {
        var coinData = await CoinData().getCoinData(selectedCurrency, crypto);
        isLoading = false;
        setState(() {
          if (coinData == null) {
            return "?";
          } else {
            double lastPrice = coinData['rate'];
            cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getCoinData();
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoPriceCard(
                value: isLoading ? "?" : cryptoPrices['BTC'],
                cryptocurrency: 'BTC',
                selectedCurrency: selectedCurrency,
              ),
              CryptoPriceCard(
                value: isLoading ? "?" : cryptoPrices['ETH'],
                cryptocurrency: 'ETH',
                selectedCurrency: selectedCurrency,
              ),
              CryptoPriceCard(
                value: isLoading ? "?" : cryptoPrices['LTC'],
                cryptocurrency: 'LTC',
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (selectedIndex) {
                      print(currenciesList[selectedIndex]);
                    },
                    children: List.generate(
                      currenciesList.length,
                      (index) {
                        return Text(currenciesList[index]);
                      },
                    ),
                  )
                : DropdownButton<String>(
                    value: selectedCurrency,
                    items: List.generate(currenciesList.length, (index) {
                      return DropdownMenuItem<String>(
                        child: Text(currenciesList[index]),
                        value: currenciesList[index],
                      );
                    }),
                    onChanged: (v) async {
                      setState(() {
                        selectedCurrency = v;
                        getCoinData();
                      });

                      print(selectedCurrency);
                    }),
          ),
        ],
      ),
    );
  }
}

class CryptoPriceCard extends StatelessWidget {
  const CryptoPriceCard({
    Key key,
    @required this.value,
    @required this.selectedCurrency,
    @required this.cryptocurrency,
  }) : super(key: key);

  final String value;
  final String selectedCurrency;
  final String cryptocurrency;

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            '1 $cryptocurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
