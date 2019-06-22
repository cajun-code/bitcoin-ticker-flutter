import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> prices = {};
  CoinData data = CoinData();

  Widget getAndroidDropdown() {
    List<DropdownMenuItem<String>> items = List<DropdownMenuItem<String>>();
    currenciesList.forEach(
      (element) => items.add(
            DropdownMenuItem<String>(
              value: element,
              child: Text(element),
            ),
          ),
    );

    return DropdownButton<String>(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          updatePrices();
        });
      },
    );
  }

  Widget getIOSPicker(){
    List<Text> items = [];
    for (String currency in currenciesList) {
      items.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedindex) {
        setState(() {
          selectedCurrency = currenciesList[selectedindex];
          updatePrices();
        });
      },
      children: items,
    );
  }

  List<Widget> createCards() {
    List<Widget> widgets = [];
    for(String crypto in cryptoList){
      Widget widget = createCard(crypto);
      widgets.add(widget);
    }

    Widget widget = Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker(): getAndroidDropdown(),
          );
    widgets.add(widget);
    return widgets;
  }

  Widget createCard(String crypto) {
    String price = prices[crypto];
    Widget widget = Padding(
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
                '1 $crypto = $price $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
    return widget;
  }
  
  void initState(){
    super.initState();
    cryptoList.forEach((element)=>prices[element]="0.00");
    updatePrices();
  }
  void updatePrices() async {
    Map <String, String> crypt = {};
    for(String crypto in cryptoList){
      crypt[crypto] = await data.getCoinData(crypto, selectedCurrency);
    }
    setState((){
      prices = crypt;
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
        children: createCards(),
      ),
    );
  }
}
