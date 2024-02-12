import 'dart:convert'; //49:28

import 'package:crud_app_restapi/add_new_product_screen.dart';
import 'package:crud_app_restapi/edit_product_screen.dart';
import 'package:crud_app_restapi/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

enum PopupMenuType {
  edit,
  delete,
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList=[];
  bool _inProgress = false;
  @override
  void initState() {
    super.initState();
    getProductListFromApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          getProductListFromApi();
        },
        child: Visibility(
          visible: _inProgress==false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.builder(

            itemBuilder: (context, index) {
              return ListTile( // <------------------------------ keep in separate place
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(// not Image.network
                      productList[index].image ?? ''),
                ),
                title: Text(productList[index].productName?? 'unknown'),
                subtitle: Wrap(
                  spacing: 12,
                  children: [
                    Text('Product code ${productList[index].productCode?? 'unknown'}'),
                    Text('Unit price ${productList[index].unitPrice?? 'unknown'}'),
                    Text('quantity ${productList[index].quantity?? 'unknown'}'),
                    Text('Total price ${productList[index].totalPrice?? 'unknown'}'),
                  ],
                ),
                trailing: PopupMenuButton<PopupMenuType>(
                  //icon: Icon(Icons.settings),
                  onSelected: (type)=> onTapPopUpMenuButton(type, productList[index]),
                  // onSelected: (PopupMenuType value) { // String value
                  //   // do something with the selected value here
                  // },
                  itemBuilder: (BuildContext ctx) =>
                      //PopupMenuEntry<PopupMenuType>
                      [
                    const PopupMenuItem(
                      value: PopupMenuType.edit,
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    // PopupMenuItem( child: Text('Option 1'), value: '1'),
                    const PopupMenuItem(
                      value: PopupMenuType.delete,
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: productList.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewProductScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("add"), // not child, as extended^
      ),
    );
  }
  void onTapPopUpMenuButton(PopupMenuType type, Product product)async{
    switch(type){
      case PopupMenuType.edit:
        final result= await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductScreen(product: product,),
          ),
        );
        if(result != null && result==true){
          getProductListFromApi();
        }
        break;
      case  PopupMenuType.delete:
        _showDeleteDialog(product.id!);
        break;
    }
  }
  void _showDeleteDialog(String productId){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('are you sure to delete this product?'),
            actions: [
              TextButton(
                onPressed: () {
                  _deleteProduct(productId);
                  Navigator.pop(context);
                },
                child: const Text(
                  'delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
            ],
      );
    });
  }
  Future <void> getProductListFromApi()async{
    _inProgress = true;
    setState(() {});
    const url ="https://crud.teamrabbil.com/api/v1/ReadProduct";
    Uri uri = Uri.parse(url);
    Response response = await get(uri); // <-------------------------------------- read
    //print(response);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      productList.clear();
      var decodedResponse = jsonDecode(response.body);
      if(decodedResponse['status']=='success'){
        var list = decodedResponse['data']; //--------------------------------------------------------------------
        for(var item in list){
          Product product = Product.fromJson(item); // calling named constructor
          /*Product product = Product(
            id: item['_id'],
            productName: item['ProductName'],
            productCode: item['ProductCode'],
            unitPrice: item['UnitPrice'],
            image: item['Img'],
            quantity: item['Qty'],
            totalPrice: item['TotalPrice'],
            createdDate: item['CreatedDate'],
          );*/
          productList.add(product); //-------------------------------------------------------------------- list vs productList
        }
        setState(() {});
      }
    }
    _inProgress =false;
    setState(() {});
  }

  Future <void> _deleteProduct(String productId)async{
    _inProgress = true;
    setState(() {});
    final url ="https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId";
    Uri uri = Uri.parse(url);
    Response response = await get(uri); //<--------------------------------------- delete
    if(response.statusCode==200){
      //getProductListFromApi();
      productList.removeWhere((element) => element.id == productId);
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('deletion failed!!')));
    }
    _inProgress =false;
    setState(() {});
  }
}
