import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/login/cubit/cubit.dart';
import '/screens/login/cubit/states.dart';
import '/screens/screens.dart';
import '/screens/search/cubit/cubit.dart';
import '/screens/shop/cubit/cubit.dart';
import '/shared/components/token.dart';
import '/shared/network/local/cache_helper.dart';
import '/shared/network/remote/dio_helper.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();

  Widget widget;

  await CacheHelper.init();
  dynamic onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopScreen();
    } else {
      widget = const LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(ShopApp(
    onBoarding: onBoarding,
    startWidget: widget,
  ));
}

class ShopApp extends StatelessWidget {
  const ShopApp({
    Key? key,
    required this.onBoarding,
    required this.startWidget,
  }) : super(key: key);

  final bool? onBoarding;
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopLoginCubit(),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavoritesData()
            ..getUserData(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
      ],
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          home: startWidget,
          theme: ShopTheme.light(),
        ),
      ),
    );
  }
}
