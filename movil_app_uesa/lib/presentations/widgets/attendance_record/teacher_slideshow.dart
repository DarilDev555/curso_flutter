import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class TechearSlideshow extends StatelessWidget {
  const TechearSlideshow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          // final movie = movies[index];
          // return _Slide(movie);
          return Placeholder();
        },
      ),
    );
  }
}
