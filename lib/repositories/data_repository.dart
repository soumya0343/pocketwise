import '../api/api_client.dart';
import '../models/transaction.dart';
import '../models/goal.dart';
import '../models/summary.dart';
import 'package:dio/dio.dart';

class DataRepository {
  final ApiClient _apiClient;

  DataRepository(this._apiClient);

  // Transactions
  Future<List<Transaction>> getTransactions({String? month}) async {
    try {
      final response = await _apiClient.get(
        '/api/transactions',
        queryParameters: month != null ? {'month': month} : null,
      );
      return (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch transactions');
    }
  }

  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await _apiClient.post('/api/transactions', data: transaction.toJson());
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create transaction');
    }
  }

  Future<Transaction> updateTransaction(String id, Transaction transaction) async {
    try {
      final response = await _apiClient.put('/api/transactions/$id', data: transaction.toJson());
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update transaction');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _apiClient.delete('/api/transactions/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete transaction');
    }
  }

  // Goals
  Future<List<Goal>> getGoals({String? month}) async {
    try {
      final response = await _apiClient.get(
        '/api/goals',
        queryParameters: month != null ? {'month': month} : null,
      );
      return (response.data as List).map((json) => Goal.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch goals');
    }
  }

  Future<Goal> createGoal(Goal goal) async {
    try {
      final response = await _apiClient.post('/api/goals', data: goal.toJson());
      return Goal.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create goal');
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _apiClient.delete('/api/goals/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete goal');
    }
  }

  // Summary
  Future<Summary> getSummary(String month) async {
    try {
      final response = await _apiClient.get('/api/summary', queryParameters: {'month': month});
      return Summary.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch summary');
    }
  }
}

