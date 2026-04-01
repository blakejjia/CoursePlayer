import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:lemon/core/data/models/models.dart';

class AISortService {
  final FirebaseAI _firebaseAI = FirebaseAI.googleAI(
    appCheck: FirebaseAppCheck.instance,
  );

  Future<Map<String, ({int rank, String aiTitle})>> generateAiMetadata(
      List<Song> songs) async {
    if (songs.isEmpty) return {};

    // Prepare the metadata for the AI
    final songData = songs
        .map((s) => {
              'id': s.id,
              'name': s
                  .title, // using title which is usually the filename in this app
            })
        .toList();

    final prompt = """
You are an expert music playlist organizer. Analyze the following list of song filenames and determine their most logical sequential order. 
For each song, provide:
1. A 'rank' (an integer starting from 1) reflecting its position in the sequence.
2. An 'aiTitle' which is a cleaned-up version of the filename. 
   - Add the sequence number at the very beginning (e.g., "01. ", "02. ").
   - Remove advertisements, website URLs, redundant prefixes/suffixes, and irrelevant metadata.
   - Keep the core information of the song or course title.
   - Ensure the title is concise and professional.

Return exactly one JSON object mapping each song's 'id' to an object containing its 'rank' and 'aiTitle'.

Input:
${jsonEncode(songData)}

Output Format:
{"id": {"rank": 1, "aiTitle": "01. Core Title"}, ...}
""";

    try {
      final model =
          _firebaseAI.generativeModel(model: 'gemini-3.1-flash-lite-preview');
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception("AI returned empty response");
      }

      // Cleanup the text in case AI added markdown code blocks
      String cleanJson = text;
      if (text.contains("```json")) {
        cleanJson = text.split("```json")[1].split("```")[0];
      } else if (text.contains("```")) {
        cleanJson = text.split("```")[1].split("```")[0];
      }
      cleanJson = cleanJson.trim();

      final Map<String, dynamic> decoded = jsonDecode(cleanJson);
      return decoded.map((key, value) {
        final val = value as Map<String, dynamic>;
        return MapEntry(
            key, (rank: val['rank'] as int, aiTitle: val['aiTitle'] as String));
      });
    } catch (e) {
      print("Error in AISortService: $e");
      rethrow;
    }
  }
}
