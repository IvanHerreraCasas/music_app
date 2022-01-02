import 'package:flutter/material.dart';
import 'package:music_app/ui/home/screens/screens.dart';
import 'package:music_app/ui/home/widgets/widgets.dart';
import 'package:music_app/ui/widgets/current_song.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top + 40,
          0,
          80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Listening',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicator: TabIndicator(Theme.of(context).primaryColor),
              labelStyle: Theme.of(context).textTheme.headline3,
              unselectedLabelStyle: Theme.of(context).textTheme.headline3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Songs'),
                Tab(text: 'Albums'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  SongsPage(),
                  AlbumsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: const CurrentSong(),
    );
  }
}
