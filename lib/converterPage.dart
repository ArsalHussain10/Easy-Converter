import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'countries.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {


  List<DropdownMenuItem> getListOfCountries()
  {
    List <DropdownMenuItem>myCountries =[];




    for( String country in countries )
      {

        myCountries.add(DropdownMenuItem(value: country,child: Text(country),));

      }
    return myCountries;

  }
  final myController = TextEditingController();

  String fromCountry,toCountry,convertedAmount,fromSelectedCountry=countries.first,toSelectedCountry=countries.first;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  int amount;
  bool flag=false;

  @override
  Widget build(BuildContext context) {




    return Scaffold(

        body: SafeArea(
          child: ModalProgressHUD(

            inAsyncCall: flag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(

                      child: Text('Easy Converter'

                      ,style: TextStyle(
                          color: Colors.green,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.green,
                  thickness: 2,),
                  SizedBox(height: 7,),
                  Text('From',
                    style: kFromToText
                    ),
                  DropdownButton(
                    isExpanded: true,

                    value: fromSelectedCountry,

                      items: getListOfCountries() ,
                    onChanged: (value){
                      setState(() {
                        fromSelectedCountry=value;


                      fromCountry=  convertIntoCode(value);
                    print(fromCountry);
                      });
                  },),


                  SizedBox(height: 40),
                  Text('TO',
                  style: kFromToText
                    ,
                  ),
                  DropdownButton(
                    isExpanded: true,
                    iconSize: 15,
                    value: toSelectedCountry,

                    items: getListOfCountries() ,

                    onChanged: (value){
                      setState(() {
                        toSelectedCountry=value;
                      toCountry=  convertIntoCode(value);

                      });
                  },),
                  SizedBox(height: 10,),
                  TextField(
                    controller: myController,

                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white10)
                      ),

                      hintText: 'Enter amount',
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('Converted Amount',
                        style: kFromToText
                        ,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(labelText: convertedAmount,
                        focusColor: Colors.black,
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                      ),
                    ),
                  ),
                  Flexible(
                    child: RaisedButton(
                      child: Text('Convert'),

                        onPressed: ()async{
                          amount=int.parse(myController.text);
                          setState(() {
                            flag=true;
                          });

                            http.Response response = await http.get(
                                'https://api.getgeoapi.com/v2/currency/convert?api_key=d360226b1abac6e4d340d0f58f0e0227056a99e9&from=$fromCountry&to=$toCountry&amount=$amount&format=json');



                      setState(() {
                        flag=false;
                      });
                          setState(() {
                            dynamic temp= jsonDecode( response.body);

                            convertedAmount=temp['rates'][toCountry]['rate_for_amount'];
                          });




                        }),
                  )
                ],

              ),
            ),
          ),
        ),
    );
  }
}


String convertIntoCode(String val)
{
  bool flag=false;
  for(int i=0;i<countries.length && flag==false;i++)
    {
      if(val==countries[i])
        {
          val=countriesCode[i];
          flag=true;

        }
    }
  return val;

}
