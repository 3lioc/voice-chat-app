import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

const brand = Color(0xFF8B5CF6);
const bg = Color(0xFF08090D);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const key = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  if (url.isNotEmpty && key.isNotEmpty) {
    await Supabase.initialize(url: url, anonKey: key);
  }
  runApp(const RivoApp());
}

class RivoApp extends StatelessWidget {
  const RivoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RIVO',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bg,
          colorScheme: ColorScheme.fromSeed(seedColor: brand, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const Shell(),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override State<Shell> createState() => _ShellState();
}
class _ShellState extends State<Shell> {
  int index = 0;
  final pages = const [HomePage(), DiscoverPage(), MessagesPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'اكتشف'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'الرسائل'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final rooms = const [
    RoomData('مجلس ريفو', 'سوالف وأصدقاء', 18, Icons.mic),
    RoomData('ليالي بغداد', 'موسيقى وسوالف', 32, Icons.music_note),
    RoomData('أصدقاء ريفو', 'تعرف وتكلم', 11, Icons.groups),
    RoomData('جلسة الألعاب', 'تحديات ومسابقات', 24, Icons.sports_esports),
  ];
  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: bg,
          title: const Text('RIVO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search)), IconButton(onPressed: () {}, icon: const Icon(Icons.mail_outline))],
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: _HeroCard())),
        const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('الغرف المباشرة', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)))),
        SliverList(delegate: SliverChildBuilderDelegate((context, i) => RoomTile(room: rooms[i]), childCount: rooms.length)),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),
        const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('فعاليات وألعاب', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)))),
        SliverToBoxAdapter(child: SizedBox(height: 120, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(12), children: const [_EventCard('🎁 الهدايا', 'أرسل هدية داخل الغرفة'), _EventCard('🎮 الألعاب', 'تحديات جماعية'), _EventCard('🏆 الترتيب', 'اصعد بالترتيب اليومي')])))
      ]);
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF30205B), Color(0xFF11131D)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
        child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('جاهز للسوالف؟', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), SizedBox(height: 6), Text('ادخل غرفة صوتية وتعرف على ناس جدد.', style: TextStyle(color: Colors.white70))])),
          FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRoomPage())), icon: const Icon(Icons.add), label: const Text('غرفة')),
        ]),
      );
}

class RoomTile extends StatelessWidget {
  final RoomData room;
  const RoomTile({super.key, required this.room});
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: CircleAvatar(radius: 28, backgroundColor: brand.withOpacity(.22), child: Icon(room.icon, color: brand)),
          title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${room.people} متواجدين • ${room.topic}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceRoomPage(room: room))),
        ),
      );
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('اكتشف')), body: ListView(padding: const EdgeInsets.all(16), children: const [
    Text('مجتمعات مقترحة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    SizedBox(height: 12),
    _PersonCard('سارة', 'موسيقى وسوالف', Icons.music_note),
    _PersonCard('علي', 'ألعاب وتحديات', Icons.sports_esports),
    _PersonCard('نور', 'تعرف وأصدقاء', Icons.favorite_border),
  ]));
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الرسائل')), body: ListView(children: const [
    ListTile(leading: CircleAvatar(child: Text('س')), title: Text('سارة'), subtitle: Text('أهلاً، شلونك؟'), trailing: Text('الآن')),
    ListTile(leading: CircleAvatar(child: Text('ع')), title: Text('علي'), subtitle: Text('نشوفك بالغرفة'), trailing: Text('5د')),
  ]));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('حسابي'), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))]), body: ListView(padding: const EdgeInsets.all(20), children: [
    const Center(child: CircleAvatar(radius: 46, backgroundColor: brand, child: Icon(Icons.person, size: 46))),
    const SizedBox(height: 12),
    const Center(child: Text('مستخدم RIVO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    const Center(child: Text('Level 1 • 0 متابع', style: TextStyle(color: Colors.white60))),
    const SizedBox(height: 24),
    Card(child: ListTile(leading: const Icon(Icons.diamond_outlined), title: const Text('الرصيد'), subtitle: const Text('0 عملة'), trailing: FilledButton(onPressed: () {}, child: const Text('شحن')))),
    Card(child: ListTile(leading: const Icon(Icons.card_giftcard), title: const Text('الهدايا'), trailing: const Icon(Icons.chevron_right))),
    Card(child: ListTile(leading: const Icon(Icons.emoji_events_outlined), title: const Text('الترتيب'), trailing: const Icon(Icons.chevron_right))),
  ]));
}

class VoiceRoomPage extends StatefulWidget {
  final RoomData room;
  const VoiceRoomPage({super.key, required this.room});
  @override State<VoiceRoomPage> createState() => _VoiceRoomPageState();
}
class _VoiceRoomPageState extends State<VoiceRoomPage> {
  bool muted = true;
  bool joined = false;
  final messages = <String>['هلا بالجميع 👋', 'منو يريد لعبة؟'];
  final text = TextEditingController();
  RtcEngine? engine;
  String status = 'وضع تجريبي — اربط Agora حتى يصبح الصوت حقيقيًا';

  Future<void> toggleVoice() async {
    const appId = String.fromEnvironment('AGORA_APP_ID', defaultValue: '');
    const token = String.fromEnvironment('AGORA_TOKEN', defaultValue: '');
    if (appId.isEmpty) {
      setState(() { muted = !muted; joined = true; status = 'واجهة جاهزة. تحتاج AGORA_APP_ID + Token للصوت الحقيقي.'; });
      return;
    }
    try {
      if (engine == null) {
        engine = createAgoraRtcEngine();
        await engine!.initialize(const RtcEngineContext(appId: appId, channelProfile: ChannelProfileType.channelProfileLiveBroadcasting));
        await engine!.enableAudio();
      }
      if (!joined) {
        await engine!.joinChannel(token: token, channelId: 'rivo_${widget.room.name}', uid: 0, options: const ChannelMediaOptions(clientRoleType: ClientRoleType.clientRoleBroadcaster, publishMicrophoneTrack: true, autoSubscribeAudio: true));
        setState(() { joined = true; muted = false; status = 'متصل بالصوت'; });
      } else {
        await engine!.muteLocalAudioStream(!muted);
        setState(() => muted = !muted);
      }
    } catch (e) { setState(() => status = 'تعذر الاتصال بالصوت: $e'); }
  }
  @override void dispose() { engine?.release(); text.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.room.name), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))]),
    body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: Align(alignment: Alignment.centerRight, child: Text(status, style: const TextStyle(color: Colors.white54, fontSize: 12)))),
      Expanded(child: GridView.builder(padding: const EdgeInsets.all(16), itemCount: 12, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 18, crossAxisSpacing: 12), itemBuilder: (_, i) => Column(children: [CircleAvatar(radius: 30, backgroundColor: i == 0 ? brand : Colors.white10, child: Icon(i == 0 ? Icons.person : Icons.mic_none, color: i == 0 ? Colors.white : Colors.white54)), const SizedBox(height: 5), Text(i == 0 ? 'أنت' : 'مقعد ${i + 1}', style: const TextStyle(fontSize: 11))]))),
      if (messages.isNotEmpty) SizedBox(height: 90, child: ListView.builder(reverse: true, padding: const EdgeInsets.symmetric(horizontal: 14), itemCount: messages.length, itemBuilder: (_, i) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(messages[messages.length - 1 - i])))),
      Row(children: [Expanded(child: TextField(controller: text, decoration: const InputDecoration(hintText: 'اكتب رسالة...', border: OutlineInputBorder()))), IconButton(onPressed: () { final v = text.text.trim(); if (v.isEmpty) return; setState(() { messages.add(v); text.clear(); }); }, icon: const Icon(Icons.send))]),
      SafeArea(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [FilledButton.icon(onPressed: toggleVoice, icon: Icon(muted ? Icons.mic_off : Icons.mic), label: Text(muted ? 'فتح المايك' : 'كتم المايك')), OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.exit_to_app), label: const Text('خروج')), IconButton(onPressed: () {}, icon: const Icon(Icons.card_giftcard))]))
    ]),
  );
}

class CreateRoomPage extends StatefulWidget { const CreateRoomPage({super.key}); @override State<CreateRoomPage> createState() => _CreateRoomPageState(); }
class _CreateRoomPageState extends State<CreateRoomPage> {
  final name = TextEditingController();
  @override void dispose() { name.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('إنشاء غرفة')), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الغرفة', border: OutlineInputBorder())), const SizedBox(height: 16), DropdownButtonFormField<String>(value: 'عام', items: const [DropdownMenuItem(value: 'عام', child: Text('غرفة عامة')), DropdownMenuItem(value: 'خاص', child: Text('غرفة خاصة'))], onChanged: (_) {}, decoration: const InputDecoration(labelText: 'الخصوصية', border: OutlineInputBorder())), const SizedBox(height: 20), SizedBox(width: double.infinity, child: FilledButton(onPressed: () { final n = name.text.trim().isEmpty ? 'غرفة RIVO' : name.text.trim(); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VoiceRoomPage(room: RoomData(n, 'غرفتي الجديدة', 1, Icons.mic)))); }, child: const Text('إنشاء ودخول'))])));
}

class _PersonCard extends StatelessWidget { final String name, topic; final IconData icon; const _PersonCard(this.name, this.topic, this.icon); @override Widget build(BuildContext context) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: brand, child: Icon(icon)), title: Text(name), subtitle: Text(topic), trailing: OutlinedButton(onPressed: () {}, child: const Text('متابعة')))); }
class _EventCard extends StatelessWidget { final String title, sub; const _EventCard(this.title, this.sub); @override Widget build(BuildContext context) => Container(width: 210, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withOpacity(.06), borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(sub, style: const TextStyle(color: Colors.white60))])); }

class RoomData { final String name, topic; final int people; final IconData icon; const RoomData(this.name, this.topic, this.people, this.icon); }
