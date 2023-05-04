import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_watch/authentication/GoogleAuth.dart';
import 'package:smart_watch/screens/home.dart';
import 'package:smart_watch/screens/permissions/app_permissions.dart';
import 'package:smart_watch/widgets/profile_update.dart';

import 'forget_pw.dart';


class LogIn extends StatefulWidget {

  LogIn(this.submitFn);

  final void Function(
      String email,
      String password,
      String name,
      bool isLogIn,
      Role role,
      BuildContext ctx,
      String hr,
      ) submitFn;

  @override
  State<LogIn> createState() => _LogInState();
}
enum Role {User, Volunteer, LawEnforcer}

class _LogInState extends State<LogIn>{
  //declare
  Role? _role = Role.User;

  // getting text input
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPass = '';
  var _userName = '';
  var _userHr = '';

  void _trySubmit(){
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();


      widget.submitFn(
        _userEmail.trim(),
        _userPass.trim(),
        _userName.trim(),
        _isLogin,
        _role!,
        context,
        _userHr,
      );
    }
  }

  bool _obscureText = true; // define and initialize the obscureText variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                Text(_isLogin ? 'Login' : 'Create an Account',
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                    color: Colors.brown[300],
                  ),
                ),
                SizedBox(height: 50),

                /// ==SIGNUP== Name input
                if(!_isLogin)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: ValueKey('name'),
                          validator: (value){
                            if(value!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                                Icons.person_outline_outlined),
                            labelText: 'Name',
                            hintText: 'Name',
                            border: OutlineInputBorder()
                          ),
                          onSaved:  (value) {
                            _userName = value!;
                          },
                        ),
                      ],
                    )
                  ),

                /// ==LOGIN== Email input
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value){
                          if(value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined,

                            ),

                            labelText: 'Email Address',
                            hintText: 'Email Address',
                            border: OutlineInputBorder()

                        ),
                        onSaved:  (value) {
                          _userEmail = value!;
                        },
                      ),
                    ],
                  ),
                ),

                /// ==LOGIN== Password Input
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value){
                          if(value!.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters.';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_outlined,
                              color: Colors.red[600]),
                          labelText: 'Password',
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                        onSaved:  (value) {
                          _userPass = value!;
                        },
                      ),
                    ],
                  ),
                ),


                /// ==SIGNUP== Heart Rate input
                if(!_isLogin)
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 60, left: 20, top: 20, bottom: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 200,
                              child: TextFormField(
                                key: ValueKey('hr'),
                                validator: (value) {
                                  if (value!.isEmpty || value.length > 3 || value.length < 2) {
                                    return 'Invalid heart rate value';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.monitor_heart_outlined),
                                    labelText: 'Normal Heart Rate',
                                    hintText: 'Normal Heart Rate',
                                    border: OutlineInputBorder()
                                ),
                                onSaved: (value) {
                                  _userHr = value!;
                                },
                              ),
                            ),
                            SizedBox(width: 20,),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Note: Heart Rate must be verified by a professional'),
                                  ),
                                );
                              },
                              child: Icon(Icons.help_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ///Forget Password
                if(_isLogin)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ForgotPassword((email, isLogIn, ctx) { })
                        ),
                      );
                    },
                      child: Text('Forgot Password?',
                        style: TextStyle(color: Colors.brown[600],
                        fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),

                /// -- Select a role (for SIGNUP)
                if(!_isLogin)
                  Column(
                    children: [
                      Container(
                        child: Text('Please select a Role:'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton(
                        value: _role,
                        onChanged: (Role? value) {
                          setState(() {
                            _role = value;
                          });
                        },
                        items: Role.values.map((e) => DropdownMenuItem(
                          child: Text('${e.toString().split('.').last}'),
                          value: e,
                        ),
                        ).toList()
                      ),
                    ],
                  ),

                /// -- LOGIN OR SIGNUP BUTTON
                SizedBox(
                  width: 200,
                  /*child: _isLogin ?
                    ElevatedButton(
                        onPressed: () {
                          _trySubmit();
                        },
                        child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade200,
                        side: BorderSide.none,
                        shape: StadiumBorder(),
                      ),
                    ) : ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => CompleteProfile()));
                      },
                      child: Text('SIGNUP', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade200,
                        side: BorderSide.none,
                        shape: StadiumBorder(),
                      ),
                  ),*/

                  child: ElevatedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(_isLogin ? 'LOGIN' : 'SIGNUP', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[300],
                        side: BorderSide.none,
                        shape: StadiumBorder()

                    ),
                  ),
                ),
                SizedBox(height: 30, width: 80),
                const SizedBox(height: 30),


                /// -- DIVIDER
                Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        thickness: 0.5,
                        color: Colors.red[800],
                      ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('OR',
                      style: TextStyle(color: Colors.red[800]),
                      ),
                      ),
                      Expanded(child: Divider(
                        thickness: 0.5,
                        color: Colors.red[800],
                      ),
                      )
                    ],
                  ),
                ),

                /// GOOGLE SIGN-IN
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final provider = Provider.of<GoogleAuth>(context, listen: false);
                        provider.googleLogin();
                      },
                      child: Image.network('https://freesvg.org/img/1534129544.png',
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ],
                ),

                /// -- CREATE ACCOUNT
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLogin ?'New User?' : 'Already have an account?',
                      style: TextStyle(fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown[400]),
                    ),
                    TextButton(onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                      child: Text(_isLogin ?'Create an Account' : 'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
        ),
      ),
      ),
    );
  }
}
