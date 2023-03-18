import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';
import 'components/coin_ticker.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'EUR';
  bool isWaitingForData = true;

  Map<String, String> mapCoinValues = {};
  List<String> priceList = [];

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownMenuItems = [];
    for (String currency in currenciesList) {
      dropDownMenuItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownMenuItems,
        onChanged: (value) => setState(() {
              selectedCurrency = value;
              getCoinDataAndUpdateUI();
            }));
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItemList = [];
    for (String currency in currenciesList) {
      pickerItemList.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) => setState(() {
        selectedCurrency = currenciesList[selectedIndex];
        getCoinDataAndUpdateUI();
      }),
      children: pickerItemList,
      scrollController: FixedExtentScrollController(
        initialItem: 4,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCoinDataAndUpdateUI();
  }

  void getCoinDataAndUpdateUI() async {
    isWaitingForData = true;
    try {
      Map<String, String> map = await coinData.getData(selectedCurrency);
      isWaitingForData = false;
      setState(() => mapCoinValues = map);
    } catch (e) {
      print(e);
    }
  }

  Column makeCryptoCard() {
    List<CoinTicker> list = [];

    for (String crypto in cryptoList) {
      list.add(CoinTicker(
        cryptoCurrency: crypto,
        price: isWaitingForData ? '?' : mapCoinValues[crypto],
        currency: selectedCurrency,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: list,
    );
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
          makeCryptoCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
