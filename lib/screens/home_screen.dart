import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';
import 'user_list_screen.dart';
import 'login_screen.dart';
import 'post_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SecureStorageService _storage = SecureStorageService();

  final TextEditingController _tokenController = TextEditingController();

  bool _hasToken = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final result = await _storage.hasToken();

    if (!mounted) return;

    setState(() {
      _hasToken = result;
      _isLoading = false;
    });
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token tidak boleh kosong')));
      return;
    }

    await _storage.saveToken(token);
    _tokenController.clear();
    await _checkToken();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Token berhasil disimpan')));
  }

  Future<void> _deleteToken() async {
    await _storage.deleteToken();
    await _checkToken();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Token berhasil dihapus')));
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteToken();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage & HTTP'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.security, size: 70, color: Colors.blue),
                  const SizedBox(height: 12),
                  const Text(
                    'Keamanan Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status Token',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                _hasToken ? Icons.check_circle : Icons.cancel,
                                color: _hasToken ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _hasToken
                                    ? 'Token tersimpan'
                                    : 'Token belum tersimpan',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _tokenController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Masukkan Token',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveToken,
                                  child: const Text('Simpan Token'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _hasToken ? _deleteToken : null,
                                  child: const Text('Hapus Token'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'HTTP Request',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserListScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.people),
                    label: const Text('Lihat Daftar Pengguna'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostListScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.article),
                    label: const Text('Lihat Daftar Postingan'),
                  ),
                ],
              ),
            ),
    );
  }
}
