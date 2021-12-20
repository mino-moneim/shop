import 'package:flutter/material.dart';
import 'package:minoshop/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/models/models.dart';
import '../screens.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final List<BoardingModel> _boarding = [
    BoardingModel(
      image: 'assets/on_boarding/boa1.jpg',
      title: 'Screen title 1',
      body: 'Screen body 1',
    ),
    BoardingModel(
      image: 'assets/on_boarding/boa2.png',
      title: 'Screen title 2',
      body: 'Screen body 2',
    ),
    BoardingModel(
      image: 'assets/on_boarding/boa3.jpg',
      title: 'Screen title 3',
      body: 'Screen body 3',
    ),
  ];

  final _controller = PageController();

  bool _isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Text(
              'Skip',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.purple,
                  ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  if (index == _boarding.length - 1) {
                    setState(() {
                      _isLast = true;
                    });
                  } else {
                    setState(() {
                      _isLast = false;
                    });
                  }
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildBoardingItem(context, _boarding[index]),
                itemCount: _boarding.length,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _boarding.length,
                  effect: const ScaleEffect(
                    dotWidth: 6.0,
                    dotHeight: 6.0,
                    dotColor: Colors.grey,
                    spacing: 8.0,
                    activeDotColor: Colors.purple,
                    scale: 1.7,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  child: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    if (_isLast) {
                      submit();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(
                          milliseconds: 700,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(context, BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Text(
            model.title,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            model.body,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );
}
