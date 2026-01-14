import 'package:film_app/core/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/logic/providers/movie_provider.dart';
import 'package:film_app/ui/widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).loadMovies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ------------------- _buildTab -------------------
  Widget _buildTab(int index, String title, MovieProvider provider) {
    final isSelected = provider.selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: ResponsiveUtil.isTablet(context) ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- _buildContent -------------------
  Widget _buildContent(MovieProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.loadMovies(),
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    final movies = _isSearching
        ? provider.searchResults
        : provider.currentMovies;

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: ResponsiveUtil.isDesktop(context) ? 120 : 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _isSearching ? 'Ничего не найдено' : 'Нет фильмов',
              style: TextStyle(
                fontSize: ResponsiveUtil.isDesktop(context) ? 24 : 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final crossAxisCount = ResponsiveUtil.getCrossAxisCount(context);
    final padding = ResponsiveUtil.getHorizontalPadding(context);

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: ResponsiveUtil.getCardAspectRatio(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (ctx, index) => MovieCard(movie: movies[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    final isDesktop = ResponsiveUtil.isDesktop(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Film App Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Главная'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Фильмы на вечер'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('О приложении'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('О приложении'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Размер экрана: ${MediaQuery.of(context).size.width.toInt()}px',
                        ),
                        Text(
                          'Тип: ${isDesktop
                              ? 'Desktop'
                              : isTablet
                              ? 'Tablet'
                              : 'Mobile'}',
                        ),
                        Text('Фильмов: ${provider.currentMovies.length}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск фильмов...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            provider.clearSearch();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                  provider.searchMovies(value);
                },
              )
            : const Text('🎬 Кинопоиск'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  provider.clearSearch();
                }
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: provider.selectedTab,
              onDestinationSelected: (index) => provider.setTab(index),
              backgroundColor: const Color(0xFF2A2A2A),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.trending_up),
                  label: Text('Популярные'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.star),
                  label: Text('Топ 250'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.new_releases),
                  label: Text('Новинки'),
                ),
              ],
            ),
          Expanded(
            child: Column(
              children: [
                if (!_isSearching && !isDesktop)
                  Container(
                    color: const Color(0xFF2A2A2A),
                    child: Row(
                      children: [
                        _buildTab(0, 'Популярные', provider),
                        _buildTab(1, 'Топ 250', provider),
                        _buildTab(2, 'Новинки', provider),
                      ],
                    ),
                  ),
                Expanded(child: _buildContent(provider)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
