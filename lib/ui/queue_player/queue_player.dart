import 'package:flutter/material.dart';
import 'package:music_app/ui/queue_player/widgets/widgets.dart';

class QueuePlayerScreen extends StatelessWidget {
  const QueuePlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top + 20,
          0,
          10,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_downward),
                  ),
                  Text(
                    'Now playing',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const QueueIcon(),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const SongInfo(),
            const SizedBox(height: 30),
            const Carousel(),
            const SizedBox(height: 50),
            const ControlButtons(),
            const SizedBox(height: 20),
            const AudioProgressBar(),
          ],
        ),
      ),
    );
  }
}
