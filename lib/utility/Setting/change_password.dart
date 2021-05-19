import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_orders/Models/user.dart';
import 'package:warehouse_orders/Pages/login.dart';
import 'package:warehouse_orders/utility/Localizations/localization_constants.dart';
import '../../Models/user.dart' as user_model;

class change_password extends StatefulWidget {
  @override
  _change_password createState() => _change_password();
}


class _change_password extends State<change_password> {
  SharedPreferences prefs;

  var txt_Old_Password;
  var txt_New_Password;
  var txt_Confirm_Password;
  var txt_mob;

  final c_Old_Password = new TextEditingController();
  final c_New_Password = new TextEditingController();
  final c_Confirm_Password = new TextEditingController();
  final c_mob = new TextEditingController();
  final loginFormKey = GlobalKey<FormState>();



//  static Pattern Password_pattern =  r'(^(?:[+0]9)?[0-9]{1,12}$)'
//  static Pattern Password_pattern =  r'^(?=.*?[0-9]).{8,}$';
//  static Pattern Code_pattern =  r'(^(?:[+0]9)?[0-9]{1,12}$)';
//  RegExp regex_pass = new RegExp(Password_pattern);
//  RegExp regex_code = new RegExp(Code_pattern);
  bool _secureText = true;
  bool _isSamePass = false;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  @override
  void initState() {
    getMobile();
    c_Old_Password.addListener(txt_Old_Password);
    c_New_Password.addListener(txt_New_Password);
    c_Confirm_Password.addListener(txt_Confirm_Password);

    super.initState();
  }


  void dispose() {
    c_Old_Password.dispose();
    c_New_Password.dispose();
    c_Confirm_Password.dispose();
    c_mob.dispose();
    super.dispose();
  }

  Future<String> getMobile() async{
    try{
      prefs = await SharedPreferences.getInstance();
      setState(() {
        txt_mob =   prefs.getString("mob");
        c_mob.text = txt_mob;
      });
    }
    catch(e)
    {
      print(e);
    }
    return txt_mob;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f4f7),
      body:_body()
    );
  }


  Widget _body(){
    return  SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 10,),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                getTranslated(context, 'Update_Profile_Information'),
                style: TextStyle(
                  fontFamily: 'Circular Std Medium',
                  fontSize: 22,
                  color: const Color(0xff0D2137),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                user_model.currentUser.value.UserName,
                style: TextStyle(
                  fontFamily: 'Circular Std Medium',
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),
            Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: 5,),
                  // Password
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffffffff),
                        border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                    ),
                    child: TextFormField(
                      controller: c_Old_Password,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      style:TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        color: const Color(0xff0d2137),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        prefixIcon: Icon(Icons.lock , color: const Color(0xff2E77AE),) ,
                        hintText: getTranslated(context, 'Current_Password'),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      onFieldSubmitted:(_) => FocusScope.of(context).unfocus(),
                      validator: (value){
                        if(value.isEmpty)
                        {return getTranslated(context, 'Employee_Password_is_required');}
                        else{
                          txt_Old_Password = value ;
                          if (value.isEmpty)
                            return getTranslated(context, 'Enter_valid_password');
                          else
                            return null;
                        }
                      },


                    ),
                  ),
                  SizedBox(height: 10,),
                  Divider(),

                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      getTranslated(context, 'Enter_New_Password'),
                      style: TextStyle(
                        fontFamily: 'Circular Std Medium',
                        fontSize: 18,
                        color: const Color(0xff3a4759),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffffffff),
                        border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                    ),
                    child: TextFormField(
                      controller: c_New_Password,
                      keyboardType: TextInputType.text,
                      obscureText: _secureText,
                      style:TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        color: const Color(0xff0d2137),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        prefixIcon: Icon(Icons.lock , color: const Color(0xff2E77AE),) ,
                        hintText: getTranslated(context, 'New_password'),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      onFieldSubmitted:(_) => FocusScope.of(context).unfocus(),
                      validator: (value){
                        if(value.isEmpty)
                        {return getTranslated(context, 'Employee_Password_is_required');}
                        else{
                          txt_New_Password = value ;
                          if (value.isEmpty)
                            return getTranslated(context, 'Enter_valid_password');
                          else
                            return null;
                        }
                      },


                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffffffff),
                        border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                    ),
                    child: TextFormField(
                      controller: c_Confirm_Password,
                      keyboardType: TextInputType.text,
                      obscureText: _secureText,
                      style:TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        color: const Color(0xff0d2137),
                      ),

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        prefixIcon: Icon(Icons.arrow_forward_ios , color: const Color(0xff2E77AE),) ,
                        hintText: getTranslated(context, 'Confirm_Password'),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        errorText: txt_Confirm_Password,
                      ),
                      onFieldSubmitted:(_) => FocusScope.of(context).unfocus(),
                      validator: (value){
                        if(value.isEmpty)
                        {return getTranslated(context, 'Employee_Password_is_required');}
                        else{
                          txt_Confirm_Password = value ;
                          if (value.isEmpty)
                            return getTranslated(context, 'Type_Password_Again');
                          else
                            return null;
                        }
                      },


                    ),
                  ),
                  SizedBox(height: 15,),


                  Divider(),

                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      getTranslated(context, 'Mobile'),
                      style: TextStyle(
                        fontFamily: 'Circular Std Medium',
                        fontSize: 18,
                        color: const Color(0xff3a4759),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffffffff),
                        border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                    ),
                    child: TextFormField(
                      controller: c_mob,

                      keyboardType: TextInputType.phone,
                      style:TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        color: const Color(0xff0d2137),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(Icons.phone),
                        ),
                        prefixIcon: Icon(Icons.lock , color: const Color(0xff2E77AE),) ,
                        hintText: getTranslated(context, 'Mobile'),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      onFieldSubmitted:(_) => FocusScope.of(context).unfocus(),
                      validator: (value) {
                        txt_mob = value;
                      },
                    ),
                  ),


                  MaterialButton(
                    child: Container(
                        height: 62,
                        margin: EdgeInsets.only(bottom: 20,top: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: const Color(0xff3A4759),
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        child: Wrap(
                          children: <Widget>[

                            SizedBox(width: 10),
                            Text(
                                getTranslated(context, 'Save'),
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                    color: const Color(0xffF2F4F7))
                            ),
                          ],
                        )
                    ),
                    onPressed: (){
                      resetPassword() ;
                    },
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    ) ;
  }


  void resetPassword() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      var user = new User();
      user.UserID = user_model.currentUser.value.UserID;
      user.PasswordStored = txt_New_Password;
      user.Mobile = txt_mob;
      user_model.resetPassword(user).then((value) {
        if (value != null ) {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => Login()));
        } else {
          print('eror');
        }
      });
    }
  }


//  check() {
//    final form = _formKey.currentState;
//    if (form.validate()) {
//      form.save();
//      if(txt_Confirm_Password == txt_New_Password){
//        resetPassword();
//      }
//      else{
//        setState(() {
//          txt_Confirm_Password = getTranslated(context, 'Password_does_not_match');
//        });
//      }
//
//    }
//  }


}

//logout().then((value) {
//Navigator.of(context).pushNamedAndRemoveUntil('/Pages', (Route<dynamic> route) => false, arguments: 2);
//});
