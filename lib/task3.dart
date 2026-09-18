abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem({required this.id, required this.title, required this.price});

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Downloading $title...');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook({
    required String id,
    required String title,
    required double price,
    required this.durationHours,
    required this.narrator,
  }) : super(id: id, title: title, price: price);

  @override
  String getDetails() {
    return '$title - Audiobook, $durationHours hours, narrator: $narrator';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook({
    required String id,
    required String title,
    required double price,
    required this.fileSizeMB,
    required this.author,
  }) : super(id: id, title: title, price: price);

  @override
  String getDetails() {
    return '$title - EBook, $fileSizeMB MB, author: $author';
  }
}

class ShoppingCart {
  List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double total = _items.fold(0.0, (sum, item) => sum + item.price);

    return total + total * taxRate;
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) => item.price <= maxPrice).toList();
  }

  void printReceipt() {
    print('Receipt:');

    for (MediaItem item in _items) {
      print(item.getDetails());

      if (item is Audiobook) {
        item.download(item.title);
      }

      if (item is EBook) {
        item.download(item.title);
      }
    }

    print('Total with tax: ${calculateTotalWithTax()}');
  }
}

void main() {
  ShoppingCart cart = ShoppingCart();

  Audiobook audiobook = Audiobook(
    id: 'A1',
    title: 'Harry Potter',
    price: 3000.0,
    durationHours: 8.5,
    narrator: 'Jim Dale',
  );

  EBook ebook = EBook(
    id: 'E1',
    title: 'Clean Code',
    price: 5000.0,
    fileSizeMB: 4.5,
    author: 'Robert Martin',
  );

  cart.addItem(audiobook);
  cart.addItem(ebook);

  cart.printReceipt();

  print('Books under 4000 ₸:');

  for (MediaItem item in cart.filterByMaxPrice(4000.0)) {
    print(item.getDetails());
  }
}
