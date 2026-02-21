import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../models/trivia_question.dart';
import 'dio_client.dart';

class TriviaApiService {
  final Dio _dio;

  TriviaApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  /// Fetches questions from Open Trivia DB.
  /// [categoryId]    - Category ID (e.g., 9 = General Knowledge)
  /// [amount]        - Number of questions (default 10)
  /// [questionType]  - 'multiple', 'boolean', or null for both
  Future<List<TriviaQuestion>> fetchQuestions({
    required int categoryId,
    int amount = AppConstants.questionsPerQuiz,
    String? questionType,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'amount': amount,
        'category': categoryId,
        'difficulty': 'easy',
      };

      if (questionType != null) {
        queryParams['type'] = questionType;
      }

      final response = await _dio.get(
        AppConstants.triviaApiPath,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;
      final responseCode = data['response_code'] as int? ?? -1;

      switch (responseCode) {
        case 0:
          // Success
          final results = data['results'] as List<dynamic>? ?? [];
          return results
              .map((e) => TriviaQuestion.fromJson(e as Map<String, dynamic>))
              .toList();
        case 1:
          throw TriviaApiException(
            'Not enough questions available for this category. Try a different one.',
            code: responseCode,
          );
        case 2:
          throw TriviaApiException(
            'Invalid API parameters.',
            code: responseCode,
          );
        case 5:
          throw TriviaApiException(
            'Too many requests. Please wait a moment.',
            code: responseCode,
          );
        default:
          throw TriviaApiException(
            'Unexpected API response (code: $responseCode).',
            code: responseCode,
          );
      }
    } on DioException catch (e) {
      throw TriviaApiException(
        _mapDioError(e),
        code: e.response?.statusCode,
        original: e,
      );
    } catch (e) {
      // Catch any unexpected errors (e.g., web-specific JS errors)
      throw TriviaApiException(
        'Unable to connect. Please check your internet connection and try again.',
        original: e,
      );
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode}). Try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

class TriviaApiException implements Exception {
  final String message;
  final int? code;
  final Object? original;

  const TriviaApiException(this.message, {this.code, this.original});

  @override
  String toString() => 'TriviaApiException: $message (code: $code)';
}
