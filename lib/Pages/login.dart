import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_orders/Models/store.dart';
import 'package:warehouse_orders/Models/user.dart';
import 'package:warehouse_orders/Pages/PagesWidget.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  User c_user = new User();
  Store c_store = new Store();
  List<User> listUsers = <User>[];
  List<Store> listStores = <Store>[];

  bool IsLoadind = false;
  bool ShowIndicator = false;
  var txt_Emp_ID  ;
  var txt_Emp_Password  ;
  bool _rememberMeFlag = true;

  bool _secureText = true;
  final Controller_EmpPass = TextEditingController();

  Store _dropdownStoreValue ;
  User _selectedUserValue ;

  List<DropdownMenuItem<Store>> _dropListStores(){
    return listStores.map((e) => DropdownMenuItem<Store>(value: e,child: Text(e.StoreName),)).toList();

  }

  List<DropdownMenuItem<User>> _dropListUsers(){
    return listUsers.map((e) => DropdownMenuItem<User>(value: e , child: Text(e.UserName),)).toList();
  }

  void listenForUsers() async {
    var stream = await getUsers();
    stream.listen((User _user1)
    {
      setState(() =>
          listUsers.add(_user1)
      );
    },
        onError: (a) {
          print(a);
        },
        onDone: () {
        }
    );
  }

  void listenForStores() async {
    var stream = await getStores();
    stream.listen((Store _store1)
    {
      setState(() =>
          listStores.add(_store1)
      );
    },
        onError: (a) {
          print(a);
        },
        onDone: () {
        }
    );
  }


  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      login_mo(c_user).then((value) {
        if (value != null && value.UserID != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Welcome " + value.UserName),
          ));
          single_store(c_store).then((value1) {
            if(value1 == null)
              {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("wrong store"),
                ));
              }
          });
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => PagesWidget(currentTab: 0,)));
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("wrong username or password"),
          ));
        }
      });
    }
  }

  Container dropdownStores(){
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:BorderRadius.circular(10),
        border: Border.all(width: 0.1, style: BorderStyle.solid),
      ),
      child: new DropdownButtonHideUnderline(
          child: DropdownButton(
            value: _dropdownStoreValue,
            onChanged: (Store value) {
              setState(() {
                _dropdownStoreValue = value;
                c_store.StoreName = value.StoreName;
                c_store.StoreID = value.StoreID;
              });
            },
            items: _dropListStores(),
            style: TextStyle(color: Colors.blueGrey  , fontWeight: FontWeight.bold),
            icon: Icon(Icons.arrow_drop_down_circle  ,color: Colors.grey,),
            hint: Text("اختر الفرع" ,style:  TextStyle(fontSize: 14),) ,
          )
      ) ,
    );
  }

  Container dropdownUsers(){
   return Container(
      width: MediaQuery.of(context).size.width - 60,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(10),
          border: Border.all(width: 0.1, style: BorderStyle.solid),
          color: Colors.white
      ),
      child: new DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedUserValue,
          onChanged: (User value) {
            setState(() {
              _selectedUserValue = value;
              c_user.UserName = value.UserName;
              c_user.apiToken = value.apiToken;
              c_user.UserID = value.UserID;
            });
          },
          items: _dropListUsers(),
          style: TextStyle(color: Colors.blueGrey  , fontWeight: FontWeight.bold),
          icon: Icon(Icons.arrow_drop_down_circle  ,color: Colors.grey,),
          hint: Text("اختر الموظف") ,
        ),
      ) ,
    );
  }

  @override
  void initState() {
    super.initState();
    listenForUsers();
    listenForStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xfff2f4f7),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //mainAxisSize: MainAxisSize.max,

              children: <Widget>[
//          //logo
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                SizedBox(height: 20,),

                Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Employee Code
                      listStores.isEmpty ?
                      Container(
                        child: CircularProgressIndicator(),
                      )
                          :dropdownStores(),

                      SizedBox(height: 10,),

                    listUsers.isEmpty ?
                       Container(
                         child: CircularProgressIndicator(),
                       )
                      :dropdownUsers(),

                      SizedBox(height: 10,),
                      // Password
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                        ),
                        child: TextFormField(
                          controller: Controller_EmpPass,
                          keyboardType: TextInputType.text,
                          obscureText: _secureText,
                          style:TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            color: const Color(0xff0d2137),
                          ),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _secureText = !_secureText;
                                });
                              },
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            prefixIcon: Icon(Icons.lock , color: const Color(0xff2e77ae),) ,
                            hintText: "Password" ,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          onFieldSubmitted:(_) => FocusScope.of(context).unfocus(),
                          onSaved: (input) => c_user.PasswordStored = input,
                          validator: (value){
                            if(value.isEmpty)
                            {return "Employee Password is required" ;}
                            else{
                              txt_Emp_Password = value ;
                            }
                          },
                        ),
                      ),
                      //remmember
                      Container(
                        margin: new EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: Colors.grey,
                              value: _rememberMeFlag,
                              onChanged: (value) => setState(() {
                                _rememberMeFlag = !_rememberMeFlag;
                              }),
                            ),
                            new Text(
                             "Remember me",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: const Color(0xff696969),
                              ),
                            )
                          ],
                        ),
                      ),
                      //button login
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 50,
                        child: new  RaisedButton(

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                          ),

                          color:  const Color(0xff3c82ff),
                          highlightColor: Colors.blueGrey,
                          elevation: 5,
                          onPressed: (){
                            login();
                          },
                          child:  ShowIndicator ? CircularProgressIndicator() : Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 24,
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          ),
//                          Ink(
//                              decoration: const BoxDecoration(
//                                gradient:LinearGradient(
//                                  colors: <Color>[Colors.blue, Colors.purple],
//                                ),
//                                borderRadius: BorderRadius.all(Radius.circular(80.0)),
//                              ),
//                            child:
//                          )

                        ),
                      ),
                      //Forgot password
                    ],
                  ),
                ),

                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                       Container(
                        margin: new EdgeInsets.only(right: 5.0,left: 5),
                        child: FlatButton(
                          onPressed: () {
                            //Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                          },
                            child:Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: const Color(0xff696969),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ubuntu-eg.com'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('to reset password contact your administrator'),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  }



