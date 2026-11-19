import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // Static Dio instance
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.groq.com/openai/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  /// Static method — panggil dengan GeminiService.sendMessage(text, base64Image: ...)
  /// [base64Image] bersifat opsional, jika diisi maka AI akan menganalisis gambar.
  static Future<String> sendMessage(String message, {String? base64Image}) async {
    try {
      // 🔍 DEBUG: Cek API Key
      final apiKey = dotenv.env["GROQ_API_KEY"];
      print("🔑 API Key: ${apiKey == null ? 'NULL' : '${apiKey.substring(0, 10)}...'}");
      print("📨 Pesan: $message");
      print("🖼️ Ada Gambar? ${base64Image != null ? 'Ya' : 'Tidak'}");

      if (apiKey == null || apiKey.isEmpty) {
        print("❌ GROQ_API_KEY tidak ditemukan di .env");
        return "GROQ_API_KEY tidak ditemukan di file .env";
      }

      // --- SIAPKAN KONTEN PESAN ---
      // Jika tidak ada gambar, kirim teks biasa.
      // Jika ada gambar, kirim dalam format list (multimodal).
      dynamic userContent;
      
      if (base64Image != null) {
        userContent = [
          {
            "type": "text",
            "text": message.isEmpty ? "Tolong analisis gambar ini." : message
          },
          {
            "type": "image_url",
            "image_url": {
              "url": "data:image/jpeg;base64,$base64Image"
            }
          }
        ];
      } else {
        userContent = message; // Teks biasa
      }

      print("🚀 Mengirim request ke Groq API...");
      final response = await _dio.post(
        "/chat/completions",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
          },
        ),
        data: {
          // ⚠️ PENTING: Jika mengirim gambar, WAJIB gunakan model Vision.
          // Jika hanya teks, model 'openai/gpt-oss-120b' atau 'llama3-8b-8192' bisa dipakai.
          // Kita buat logika: jika ada gambar, pakai model Vision.
          "model": base64Image != null 
              ? "qwen/qwen3.8-27b" 
              : "openai/gpt-oss-120b",
          "messages": [
            {
              "role": "system",
              "content":
                  "Kamu adalah AI InvestEdu. Jawablah pertanyaan seputar investasi. "
                  "Jika user mengirim gambar (seperti grafik saham, screenshot aplikasi, dll), analisis gambar tersebut dan jelaskan kaitannya dengan investasi. "
                  "Jawab dengan format teks biasa tanpa markdown, tanpa tanda bintang, tanpa tabel, dan tanpa simbol-simbol khusus."
            },
            {
              "role": "user",
              "content": userContent,
            }
          ],
          "temperature": 0.7,
          "max_tokens": 1024,
        },
      );

      print("✅ Status Code: ${response.statusCode}");
      // print("📦 Response: ${response.data}"); // Matikan jika log terlalu panjang

      if (response.statusCode == 200) {
        return response.data["choices"][0]["message"]["content"];
      }

      return "Error ${response.statusCode}\n${response.data}";
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Type: ${e.type}");
      print("❌ Response: ${e.response?.data}");
      print("❌ Status Code: ${e.response?.statusCode}");

      if (e.type == DioExceptionType.connectionError) {
        return "Koneksi gagal. Cek internet atau CORS.";
      }
      return e.response?.data.toString() ?? e.toString();
    } catch (e) {
      print("❌ Error umum: $e");
      return e.toString();
    }
  }
}