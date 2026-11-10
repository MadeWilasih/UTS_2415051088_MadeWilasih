// 2415051088 - Made Wilasih
import 'package:flutter/material.dart';

import '../services/movie_note_service.dart';

class MovieNotesScreen extends StatefulWidget {
  final String movieId;
  final String movieTitle;

  const MovieNotesScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<MovieNotesScreen> createState() => _MovieNotesScreenState();
}

class _MovieNotesScreenState extends State<MovieNotesScreen> {
  final MovieNoteService _noteService = MovieNoteService();
  List _notes = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future _fetchNotes() async {
    setState(() => _isLoading = true);
    try {
      final data = await _noteService.getNotes();
      if (!mounted) return;

      List filteredList = [];
      if (data is List) {
        for (var item in data) {
          if (item['movie_id'].toString() == widget.movieId) {
            filteredList.add(item);
          }
        }
      }

      setState(() {
        _notes = filteredList;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat catatan: $e')));
    }
  }

  void _showNoteForm({dynamic existingNote}) {
    if (existingNote != null) {
      _noteController.text = existingNote['note']?.toString() ?? '';
      _ratingController.text = existingNote['rating']?.toString() ?? '';
    } else {
      _noteController.clear();
      _ratingController.clear();
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          existingNote == null ? 'Tambah Catatan Film' : 'Edit Catatan Film',
          style: const TextStyle(color: Colors.white),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _noteController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ulasan / Catatan Pribadi',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC107)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ratingController,
                style: const TextStyle(color: Colors.white),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Rating Personal (1.0 - 10.0)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFC107)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rating wajib diisi!';
                  }
                  final n = double.tryParse(value);
                  if (n == null || n < 1 || n > 10) {
                    return 'Masukkan angka antara 1.0 sampai 10.0';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final noteText = _noteController.text;
                final ratingVal = double.parse(_ratingController.text);

                try {
                  if (existingNote == null) {
                    await _noteService.addNote(
                      movieId: widget.movieId,
                      title: widget.movieTitle,
                      note: noteText,
                      rating: ratingVal,
                    );
                  } else {
                    await _noteService.updateNote(
                      id: int.parse(existingNote['id'].toString()),
                      note: noteText,
                      rating: ratingVal,
                    );
                  }

                  // Tutup dialog setelah proses database selesai
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);

                  // Muat ulang data catatan
                  await _fetchNotes();

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Catatan berhasil disimpan!')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menyimpan: $e')),
                  );
                }
              }
            },
            child: const Text(
              'Simpan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Hapus Catatan?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah kamu yakin ingin menghapus catatan ulasan ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _noteService.deleteNote(id);
              if (!mounted) return;
              _fetchNotes();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil dihapus!')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Catatan: ${widget.movieTitle}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC107)),
            )
          : _notes.isEmpty
          ? const Center(
              child: Text(
                'Belum ada catatan untuk film ini.\nTekan tombol + di bawah untuk menambah.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final item = _notes[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFC107),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Rating: ${item['rating']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _showNoteForm(existingNote: item),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  onPressed: () => _confirmDelete(
                                    int.parse(item['id'].toString()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        Text(
                          item['note']?.toString() ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _showNoteForm(),
      ),
    );
  }
}
