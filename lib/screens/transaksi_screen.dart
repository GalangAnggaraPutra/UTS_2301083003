import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final List<Map<String, dynamic>> _transaksiList = [];
  final _formKey = GlobalKey<FormState>();

  final _kodeTransaksiController = TextEditingController();
  final _namaPelangganController = TextEditingController();
  final _durationController = TextEditingController();
  final _tarifController = TextEditingController();
  String _selectedJenisPelanggan = 'Regular';

  double calculateDiscount(
      String jenisPelanggan, double duration, double tarif) {
    if (duration > 2) {
      if (jenisPelanggan == "VIP") {
        return tarif * duration * 0.02; 
      } else if (jenisPelanggan == "GOLD") {
        return tarif * duration * 0.05; 
      }
    }
    return 0;
  }

  double calculateTotal(double duration, double tarif, double discount) {
    return (duration * tarif) - discount;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Warnet'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Input Transaksi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _kodeTransaksiController,
                          decoration: const InputDecoration(
                            labelText: 'Kode Transaksi',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan kode transaksi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _namaPelangganController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Pelanggan',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan nama pelanggan';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedJenisPelanggan,
                          decoration: const InputDecoration(
                            labelText: 'Jenis Pelanggan',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Regular', 'VIP', 'GOLD'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedJenisPelanggan = newValue;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _durationController,
                          decoration: const InputDecoration(
                            labelText: 'Durasi (jam)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan jumlah durasi';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Input tidak Valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tarifController,
                          decoration: const InputDecoration(
                            labelText: 'Tarif per Jam',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Tarif';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Input Valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                double duration =
                                    double.parse(_durationController.text);
                                double tarif =
                                    double.parse(_tarifController.text);
                                double discount = calculateDiscount(
                                  _selectedJenisPelanggan,
                                  duration,
                                  tarif,
                                );
                                double total =
                                    calculateTotal(duration, tarif, discount);
                                setState(() {
                                  _transaksiList.add({
                                    'kodeTransaksi':
                                        _kodeTransaksiController.text,
                                    'namaPelanggan':
                                        _namaPelangganController.text,
                                    'jenisPelanggan': _selectedJenisPelanggan,
                                    'duration': duration,
                                    'tarif': tarif,
                                    'discount': discount,
                                    'total': total,
                                    'timestamp': DateTime.now(),
                                  });
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Ringkasan Transaksi'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Kode: ${_kodeTransaksiController.text}'),
                                        Text(
                                            'Nama: ${_namaPelangganController.text}'),
                                        Text('Jenis: $_selectedJenisPelanggan'),
                                        Text('Durasi: $duration jam'),
                                        Text(
                                            'Tarif per jam: Rp ${tarif.toStringAsFixed(2)}'),
                                        Text(
                                            'Subtotal: Rp ${(duration * tarif).toStringAsFixed(2)}'),
                                        Text(
                                            'Discount: Rp ${discount.toStringAsFixed(2)}'),
                                        const Divider(),
                                        Text(
                                          'Total: Rp ${total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            _kodeTransaksiController.clear();
                                            _namaPelangganController.clear();
                                            _durationController.clear();
                                            _tarifController.clear();
                                            _selectedJenisPelanggan = 'Regular';
                                          });
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Proses Transaksi',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Riwayat Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transaksiList.length,
                itemBuilder: (context, index) {
                  final transaksi =
                      _transaksiList[_transaksiList.length - 1 - index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        '${transaksi['namaPelanggan']} (${transaksi['jenisPelanggan']})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kode: ${transaksi['kodeTransaksi']}'),
                          Text('Duration: ${transaksi['duration']} hours'),
                          Text(
                            'Total: Rp ${transaksi['total'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Time: ${_formatDateTime(transaksi['timestamp'])}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
