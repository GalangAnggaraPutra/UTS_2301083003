class Warnet {
  final String kodeTransaksi;
  final String namaPelanggan;
  final String jenisPelanggan;
  final DateTime tglMasuk;
  final DateTime jamMasuk;
  final DateTime jamKeluar;
  final double tarif;
  late final double lama;
  late final double diskon;
  late final double totalBayar;

  Warnet({
    required this.kodeTransaksi,
    required this.namaPelanggan,
    required this.jenisPelanggan,
    required this.tglMasuk,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.tarif,
  }) {
    calculateBill();
  }
  void calculateBill() {
    lama = jamKeluar.difference(jamMasuk).inMinutes / 60;
    diskon = 0;
    if (lama > 2) {
      if (jenisPelanggan == "VIP") {
        diskon = tarif * lama * 0.02;
      } else if (jenisPelanggan == "GOLD") {
        diskon = tarif * lama * 0.05;
      }
    }
    totalBayar = (lama * tarif) - diskon;
  }
}