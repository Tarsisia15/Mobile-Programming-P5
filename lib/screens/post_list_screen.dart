import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();

  List<Post> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final posts = await _apiService.getPosts();

      if (!mounted) return;

      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
        actions: [
          IconButton(onPressed: _loadPosts, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_errorMessage!),
                  ElevatedButton(
                    onPressed: _loadPosts,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(
                        post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(post.body),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
