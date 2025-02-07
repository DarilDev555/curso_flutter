import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView();

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNetPage();
    ref.read(popularMoviesProvider.notifier).loadNetPage();
    ref.read(toRatedMoviesProvider.notifier).loadNetPage();
    ref.read(upcomingMoviesProvider.notifier).loadNetPage();
  }

  @override
  Widget build(BuildContext context) {
    final inicialLoading = ref.watch(inicialLoadingProvider);
    if (inicialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final toRatedMovies = ref.watch(toRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final moviesSlideshow = ref.watch(moviesSlideshowProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          elevation: 1,
          title: Padding(
            padding: EdgeInsets.only(top: 8),
            child: CustomAppbar(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                MoviesSlideshow(
                  movies: moviesSlideshow,
                ),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  subTitle: 'Jueves 23',
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNetPage();
                  },
                ),
                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Proximamente',
                  subTitle: 'En este mes',
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNetPage();
                  },
                ),
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  subTitle: 'En este año',
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNetPage();
                  },
                ),
                MovieHorizontalListview(
                  movies: toRatedMovies,
                  title: 'Mejor calificadas',
                  loadNextPage: () {
                    ref.read(toRatedMoviesProvider.notifier).loadNetPage();
                  },
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
