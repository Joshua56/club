import 'package:club/modals/product_modal.dart';

class PreoderModal{
  final String id;
  final List<OderItemModal> oderItems;

  get totalAmount => calcTotalAmount();


  PreoderModal({
    this.id = '',
    this.oderItems
  });

  double calcTotalAmount(){
    double total = 0;
    oderItems.forEach((item){
      total += item.totalCost;
    });

    return total;
  }
}

class OderItemModal{
  final ProductModal product;
  final int quantity;

  get totalCost => product.price * quantity;

  OderItemModal({
    this.product,
    this.quantity
  });
}
