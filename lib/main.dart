import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/services/audio_query.dart';
import 'package:music_app/services/audio_handler.dart';
import 'package:music_app/riverpod/providers.dart';
import 'package:music_app/theme.dart';
import 'package:music_app/ui/home/home.dart';
import 'package:music_app/ui/loading/loading.dart';
import 'package:music_app/ui/permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool loading = true;
  bool permission = false;

  late final List<Album> albums;
  late final List<MediaItem> mediaItems;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var storagePermission = Permission.storage;
    if (await storagePermission.status.isGranted) {
      _loadData();
    } else {
      var status = await storagePermission.request();
      if (status.isGranted) {
        _loadData();
      } else {
        setState(() {
          permission = false;
          loading = false;
        });
      }
    }
  }

  void _loadData() async {
    final audioApi = AudioQuery();
    albums = await audioApi.queryAlbums();
    mediaItems = await audioApi.queryMediaItems();
    ref.watch(songsProvider.state).state = mediaItems;
    ref.watch(albumsProvider.state).state = albums;
    setState(() {
      permission = true;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light(),
      home: loading
          ? const LoadingScreen()
          : permission
              ? const HomeScreen()
              : const PermissionScreen(),
    );
  }
}
