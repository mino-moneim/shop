import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/login/cubit/cubit.dart';
import '/screens/login/cubit/states.dart';
import '/screens/screens.dart';
import '/shared/components/text_form_field.dart';
import '/shared/components/toast.dart';
import '/shared/network/local/cache_helper.dart';
import '../../theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _nameController = TextEditingController();
  static final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();

    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {
        if (state is ShopRegisterSuccessState) {
          if (state.loginModel.status!) {
            CacheHelper.saveData(
              key: 'token',
              value: state.loginModel.data!.token,
            ).then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
              _emailController.clear();
              _passwordController.clear();
              _nameController.clear();
              _phoneController.clear();
            });
          } else {
            showToast(
              message: state.loginModel.message!,
              state: toastStates.error,
            );
          }
        }
      },
      builder: (context, state) => MaterialApp(
        theme: ShopTheme.light(),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REGISTER',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.purpleAccent,
                          ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Register now to enjoy our offers',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    myTextFromField(
                      controller: _nameController,
                      hint: 'name',
                      textInputAction: TextInputAction.next,
                      type: TextInputType.text,
                      prefixIcon: Icons.title,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    myTextFromField(
                      controller: _phoneController,
                      hint: 'phone',
                      type: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    myTextFromField(
                      controller: _emailController,
                      hint: 'email',
                      type: TextInputType.emailAddress,
                      prefixIcon: Icons.alternate_email,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    myTextFromField(
                      controller: _passwordController,
                      type: TextInputType.visiblePassword,
                      onSubmit: (value) {
                        if (_formKey.currentState!.validate()) {
                          ShopLoginCubit.get(context).userRegister(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                            phone: _phoneController.text,
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
                      height: 40.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! ShopRegisterLoadingState,
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
                              ShopLoginCubit.get(context).userRegister(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: _nameController.text,
                                phone: _phoneController.text,
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              'REGISTER',
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
