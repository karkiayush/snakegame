import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  String formatDateTime(String isoString) {
    final dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('MMMM d, y - h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Scores")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase
            .from('scores')
            .select()
            .eq('user_id', userId as Object)
            .order('played_at', ascending: false),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data!;
          if (scores.isEmpty) {
            return const Center(child: Text("No scores yet."));
          }

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final item = scores[index];
              final playedAt=formatDateTime(item['played_at']);
              return ListTile(
                title: Text("Score: ${item['score']}"),
                subtitle: Text("Played on: $playedAt"),
              );
            },
          );
        },
      ),
    );
  }
}
