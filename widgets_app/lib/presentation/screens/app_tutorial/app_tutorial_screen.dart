import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(
      {required this.title, required this.caption, required this.imageUrl});
}

final slides = <SlideInfo>[
  SlideInfo(
      title: 'Busca la Comida',
      caption:
          'Exercitation non culpa cillum velit laboris culpa proident ex sit. Amet do est aute pariatur voluptate ipsum ipsum sint est sunt culpa consectetur fugiat. Consequat amet magna qui occaecat ea ex esse excepteur aliquip adipisicing aliqua occaecat consequat id.',
      imageUrl: 'assets/images/1.png'),
  SlideInfo(
      title: 'Entrega rapida',
      caption:
          'Dolor aute officia reprehenderit adipisicing cillum aliqua ex. Nisi et mollit anim ut laboris cupidatat consectetur. Exercitation voluptate officia est aute ea nulla amet occaecat id ut tempor officia reprehenderit tempor. Nisi aliquip esse irure do magna sit in. Reprehenderit voluptate voluptate duis culpa voluptate incididunt labore.',
      imageUrl: 'assets/images/2.png'),
  SlideInfo(
      title: 'Disfruta la comida',
      caption:
          'Sint eiusmod eu irure mollit nostrud culpa occaecat culpa laboris aute culpa nulla sunt. Mollit eu adipisicing commodo amet voluptate cillum mollit culpa occaecat anim eiusmod. Quis cupidatat qui laborum laboris deserunt. Eu laboris aute id eu quis elit qui exercitation laborum eu laborum incididunt. Pariatur sint id proident exercitation ex deserunt. Magna excepteur ullamco nisi voluptate dolore in consequat occaecat nisi.',
      imageUrl: 'assets/images/3.png'),
];

class AppTutorialScreen extends StatefulWidget {
  static const name = 'tutorial_screen';

  const AppTutorialScreen({super.key});

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {
  final PageController pageViewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageViewController.addListener(() {
      final page = pageViewController.page ?? 0;
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageViewController,
            physics: const BouncingScrollPhysics(),
            children: slides
                .map(
                  (slideData) => _Slide(
                      title: slideData.title,
                      caption: slideData.caption,
                      imageUrl: slideData.imageUrl),
                )
                .toList(),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text('Salir'),
            ),
          ),
          endReached
              ? Positioned(
                  right: 20,
                  bottom: 10,
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: FadeInRight(
                      from: 15,
                      delay: const Duration(milliseconds: 500),
                      child: FilledButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Comenzar'),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageViewController.dispose();

    super.dispose();
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String imageUrl;

  const _Slide(
      {required this.title, required this.caption, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final captionStyle = Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(imageUrl),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: titleStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              caption,
              style: captionStyle,
            )
          ],
        ),
      ),
    );
  }
}
