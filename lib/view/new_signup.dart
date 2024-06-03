
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/register_controller.dart';


class NewSignUpScreen extends StatefulWidget {
  const NewSignUpScreen({Key? key}) : super(key: key);

  @override
  State<NewSignUpScreen> createState() => _NewSignUpScreenState();
}

class _NewSignUpScreenState extends State<NewSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (value) {
      return Scaffold(
        body: SingleChildScrollView(
          /*child: Form(
            key: value.formKey,
            child: Padding(
              padding: EdgeInsets.all(36),
              child: Center(
                child: Obx(
                  () => Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Text(
                        'WELCOME',
                        style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Register'),
                    SizedBox(
                      height: 80,
                    ),
                    Column(
                      children: [
                        CustomTextField(
                          controller: value.nameController,
                          title: AppString.name,
                          hintText: AppString.enter_name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppString.error_name_msg;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: value.emailController,
                          title: AppString.email,
                          hintText: AppString.enter_email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppString.error_email;
                            } else if (value.isValidEmail() == false) {
                              return AppString.please_enter_valid_email;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: value.passwordController,
                          title: AppString.password,
                          hintText: AppString.enter_password,
                          obscureText: !value.isShowingPassword.value,
                          suffixIcon: InkWell(
                            onTap: () {
                              value.isShowingPassword.value = !value.isShowingPassword.value;
                            },
                            child: Icon(
                              value.isShowingPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                          ),
                          onChanged: (check_value) {
                            if (value.has8Char.isFalse && check_value.length > 7) {
                              value.has8Char.value = true;
                            }
                            if (value.has8Char.isTrue && check_value.length < 8) {
                              value.has8Char.value = false;
                            }
                            if (value.hasLN.isFalse && RegExp(".*([a-zA-Z].*[0-9]|[0-9].*[a-zA-Z]).*").hasMatch(check_value)) {
                              value.hasLN.value = true;
                            }
                            if (value.hasLN.isTrue && !RegExp(".*([a-zA-Z].*[0-9]|[0-9].*[a-zA-Z]).*").hasMatch(check_value)) {
                              value.hasLN.value = false;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppString.error_msg_password;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          title: AppString.confirm_password,
                          hintText: AppString.confirm_enter_password,
                          obscureText: !value.isShowingConfirmPsd.value,
                          suffixIcon: InkWell(
                            onTap: () {
                              value.isShowingConfirmPsd.value = !value.isShowingConfirmPsd.value;
                            },
                            child: Icon(
                              value.isShowingConfirmPsd.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                          ),
                          validator: (chk_value) {
                            if (chk_value == null || chk_value.isEmpty) {
                              return AppString.confirm_error_msg_password;
                            }

                            if (chk_value != value.passwordController.text) {
                              return AppString.msg_your_password_doesnt_match;
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SubmitButton(
                          onPressed: () => {
                            if (value.formKey.currentState!.validate()) {value.onRegister()}
                          },
                          title: 'Register',
                        )
                      ],
                    )
                  ]),
                ),
              ),
            ),
          ),*/
        ),
      );
    });
  }
}
