import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    fetchUserName();
    super.initState();
  }

  Future fetchUserName() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await supabase
            .from('users')
            .select('username')
            .eq('id', user.id as Object)
            .single();

        return response['username'] ?? user.email ?? "User";
      } catch (e) {
        debugPrint("Error fetching username: $e");
        return user.email ?? "User";
      }
    } else {
      return "User";
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userEmail = supabase.auth.currentUser?.email ?? "Unknown";
    // final userName=supabase.auth.

    return Scaffold(
      appBar: AppBar(
        title: const Text("Snake Game Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: fetchUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final name = snapshot.data ?? "User";

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome $name 👋", style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  child: const Text("🎮 Start Game"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/scores');
                  },
                  child: const Text("📈 View Scores"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
