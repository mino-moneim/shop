import 'package:minoshop/models/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates {}

class ShopLoginSuccessState extends ShopLoginStates {
  late final LoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginLoadingState extends ShopLoginStates {}

class ShopLoginErrorState extends ShopLoginStates {
  final String error;

  ShopLoginErrorState(this.error);
}

class ShopRegisterSuccessState extends ShopLoginStates {
  late final LoginModel loginModel;

  ShopRegisterSuccessState(this.loginModel);
}

class ShopRegisterLoadingState extends ShopLoginStates {}

class ShopRegisterErrorState extends ShopLoginStates {
  final String error;

  ShopRegisterErrorState(this.error);
}

class ShopChangePasswordVisibilityState extends ShopLoginStates {}

class ShopChangeAppTheme extends ShopLoginStates {}
