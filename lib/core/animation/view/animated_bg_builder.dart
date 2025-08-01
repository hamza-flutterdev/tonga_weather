import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/utils/weather_utils.dart';
import 'package:tonga_weather/presentation/home/controller/home_controller.dart';
import '../../constants/constant.dart';
import '../controller/animation_controller.dart';
import 'animated_bg_image.dart';

class AnimatedBgImageBuilder extends StatelessWidget {
  const AnimatedBgImageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final bgAnimationController = Get.find<BgAnimationController>();

    return AnimatedBuilder(
      animation: bgAnimationController.animation,
      builder: (context, child) {
        final offsetX =
            -bgAnimationController.animation.value * mobileWidth(context);

        final selectedCity = homeController.selectedCity.value;
        final weather = selectedCity != null
            ? homeController.conditionController.allCitiesWeather[selectedCity
                  .cityAscii]
            : null;

        final weatherType = WeatherUtils.getWeatherIcon(weather?.code ?? 1000);

        return Positioned(
          left: offsetX,
          top: 0,
          child: AnimatedBgImage(weatherType: weatherType),
        );
      },
    );
  }
}
