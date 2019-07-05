import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../widgets/background.dart';
import '../widgets/rotating_cell.dart';
import '../widgets/input_row.dart';
import '../bloc/registration/registration.dart';
import '../widgets/progress.dart';
import '../globals.dart' as global;

class RestorePage extends StatefulWidget {

  @override
  _RestorePage createState() => _RestorePage();
}

class _RestorePage extends State<RestorePage> {

  final RegBloc _bloc = RegBloc();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = new MaskedTextController(
      mask: '+7 (900) 000-00-00', text: '79');
  final TextEditingController _passwordController = new MaskedTextController(
      mask: '00000');
  final TextEditingController _confirmController = new MaskedTextController(
      mask: '00000');

  final TextStyle  _hintStyle = TextStyle(
      color: global.foregroundColor.withOpacity(0.3),
      fontSize: 12.0);

  final TextStyle _inputStyle = TextStyle(
    color:global.foregroundColor,
    fontSize: 18.0,);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocBuilder<RegEvent, RegState>(
          bloc: _bloc,
          builder: (BuildContext context, RegState state) {
            return ProgressView(
              child: SingleChildScrollView(
                child:  BackGround(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 80.0, bottom: 50.0),
                          child: Center(
                            child: new Column(
                              children: <Widget>[
                                Container(
                                  height: 128.0,
                                  width: 128.0,
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: global.foregroundColor,
                                    radius: 100.0,
                                    child: Icon(
                                      Icons.person,
                                      size: 60.0,
                                      color: global.foregroundColor,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: global.foregroundColor,
                                      width: 1.0,
                                    ),
                                    shape: BoxShape.circle,
                                    //image: DecorationImage(image: global.logo)
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: new Text(
                                    "Smart Shopper",
                                    style: TextStyle(
                                      color: global.foregroundColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),  // Logo
                        RotatingCell(
                          frontWidget: _verifyView(state),
                          backWidget: _confirmView(state),
                          cellSize: Size(MediaQuery.of(context).size.width, 250),
                          padding: EdgeInsets.all(0.0),
                          stateStream: _bloc.state,
                        )
                      ],
                    )
                ),
              ),
              visibility: state.progress,
            );
          })
      );
  }

  Widget _verifyView(RegState state){
    return  Wrap(
      children: <Widget>[
        InputRow(
          icon: Icons.email,
          isError: (state is ValidationError)?state.error['email']:false,
          child: TextField(
            controller: _emailController,
            style: _inputStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'your email',
              hintStyle: _hintStyle,
            ),
          ),
        ),  // e-mail
        InputRow(
          icon: Icons.phone,
          isError: (state is ValidationError)?state.error['phone']:false,
          child: TextField(
            controller: _phoneController,
            style: _inputStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'phone number',
              hintStyle: _hintStyle,
            ),
          ),
        ),  // phone
        InputRow(
          icon: Icons.lock_open,
          isError: (state is ValidationError)?state.error['password']:false,
          child: TextFormField(
            controller: _passwordController,
            style: _inputStyle,
            keyboardType: TextInputType.number,
            //obscureText: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'password',
              hintStyle: _hintStyle,
            ),
          ),
        ),  // secret code
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                child: new FlatButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  color: global.highlightColor2,
                  onPressed: () {
                    _bloc.dispatch(Verify(
                      email: _emailController.text,
                      phone: _phoneController.text,
                      password:  _passwordController.text
                    ));
                  },
                  child: Text(
                    "Verify phone",
                    style: TextStyle(color: global.foregroundColor),
                  ),
                ),
              ),
            ],
          ),
        ),  // Register button
      ],
    );
  }

  Widget _confirmView(RegState state){
    return Wrap(
      children: <Widget>[
        InputRow(
            icon: Icons.sms,
            isError: (state is NotValidValue),
            child:TextField(
              controller: _confirmController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: _inputStyle,
              decoration: InputDecoration(
                hintText: "SMS code.",
                hintStyle: _hintStyle,
                border: InputBorder.none,
          ),
        )),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
          alignment: Alignment.center,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new FlatButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  color: global.highlightColor2,
                  onPressed: () {
                    _bloc.dispatch(Cancel());
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: global.foregroundColor),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 20.0),),
              Expanded(
                child: new FlatButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  color: global.highlightColor2,
                  onPressed: () {
                    _bloc.dispatch(Confirm(code: _confirmController.text));
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: global.foregroundColor),
                  ),
                ),
              ),
            ],
          ),
        ),  // Register button
      ],
    );
  }


  @override
  void initState() {
     _emailController.addListener(_onChanged);
    _passwordController.addListener(_onChanged);
    _phoneController.addListener(_onChanged);
    _confirmController.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  _onChanged(){
    //print(_passwordController.text);
  }
}