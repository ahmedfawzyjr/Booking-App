import 'package:booking_app/Application/Utils/validator.dart';
import 'package:booking_app/Application/Widgets/commonAppBarView.dart';
import 'package:booking_app/Application/Widgets/commonButton.dart';
import 'package:booking_app/Application/Widgets/commonTextFieldView.dart';
import 'package:booking_app/Application/Widgets/removeForce.dart';
import 'package:booking_app/Data/Language/appLocalizations.dart';
import 'package:booking_app/Presentation/Modules/login/facebookTwitterButtonView.dart';
import 'package:booking_app/Presentation/Routes/routeNames.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: RemoveForce(
        onClick: () {
          FocusScope.of(
            context,
          ).requestFocus(
            FocusNode(),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonAppBarView(
              iconData: Icons.arrow_back,
              titleText: AppLocalizations(context).of(
                "login",
              ),
              onBackClick: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 32,
                      ),
                      child: FacebookTwitterButtonView(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations(
                          context,
                        ).of(
                          "log_with mail",
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(
                            context,
                          ).disabledColor,
                        ),
                      ),
                    ),
                    CommonTextFieldView(
                      controller: _emailController,
                      errorText: _errorEmail,
                      titleText: AppLocalizations(
                        context,
                      ).of(
                        "your_mail",
                      ),
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 16,
                      ),
                      hintText: AppLocalizations(
                        context,
                      ).of(
                        "enter_your_email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (
                        String txt,
                      ) {},
                    ),
                    CommonTextFieldView(
                      titleText: AppLocalizations(
                        context,
                      ).of(
                        "password",
                      ),
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      hintText: AppLocalizations(
                        context,
                      ).of(
                        "enter_password",
                      ),
                      isObscureText: true,
                      onChanged: (
                        String txt,
                      ) {},
                      errorText: _errorPassword,
                      controller: _passwordController,
                    ),
                    _forgotYourPasswordUI(),
                    CommonButton(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 16,
                      ),
                      buttonText: AppLocalizations(context).of(
                        "login",
                      ),
                      onTap: () {
                        if (_allValidation()) {
                          NavigationServices(context).gotoTabScreen();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgotYourPasswordUI() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        right: 16,
        bottom: 8,
        left: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
            onTap: () {
              NavigationServices(context).gotoForgotPassword();
            },
            child: Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Text(
                AppLocalizations(
                  context,
                ).of(
                  "forgot_your_Password",
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).disabledColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = AppLocalizations(
        context,
      ).of(
        'email_cannot_empty',
      );
      isValid = false;
    } else if (!Validator.validateEmail(
      _emailController.text.trim(),
    )) {
      _errorEmail = AppLocalizations(
        context,
      ).of(
        'enter_valid_email',
      );
      isValid = false;
    } else {
      _errorEmail = '';
    }

    if (_passwordController.text.trim().isEmpty) {
      _errorPassword = AppLocalizations(
        context,
      ).of(
        'password_cannot_empty',
      );
      isValid = false;
    } else if (_passwordController.text.trim().length < 6) {
      _errorPassword = AppLocalizations(
        context,
      ).of(
        'valid_password',
      );
      isValid = false;
    } else {
      _errorPassword = '';
    }
    setState(() {});
    return isValid;
  }
}
