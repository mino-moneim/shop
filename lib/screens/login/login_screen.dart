import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/login/cubit/cubit.dart';
import '/screens/login/cubit/states.dart';
import '/screens/screens.dart';
import '/shared/components/text_form_field.dart';
import '/shared/components/toast.dart';
import '/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static final _emailController = TextEditingController();

  static final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopScreen(),
                  ),
                );
                _emailController.clear();
                _passwordController.clear();
              });
            } else {
              showToast(
                message: state.loginModel.message!,
                state: toastStates.error,
              );
            }
          }
        },
        builder: (context, state) => Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 120.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.purpleAccent,
                          ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'login now to browse our hot offers',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    myTextFromField(
                      controller: _emailController,
                      type: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {},
                      hint: 'email',
                      prefixIcon: Icons.alternate_email,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    myTextFromField(
                      controller: _passwordController,
                      type: TextInputType.visiblePassword,
                      onSubmit: (value) {
                        if (_formKey.currentState!.validate()) {
                          ShopLoginCubit.get(context).userLogin(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      scurePassword: ShopLoginCubit.get(context).isPassword,
                      hint: 'password',
                      validator: (value) {},
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: ShopLoginCubit.get(context).suffix,
                      suffixPressed: () {
                        ShopLoginCubit.get(context).changePasswordVisibility();
                      },
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! ShopLoginLoadingState,
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      builder: (context) => Container(
                        width: double.infinity,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account ?'),
                        TextButton(
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                              color: Colors.purpleAccent,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
