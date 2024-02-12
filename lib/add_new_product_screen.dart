import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _amountTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductInProgress =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new Product'),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameTEController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name:',
                      hintText: ('product name:'),
                    ),
                    validator: (String? val){
                      /// todo: extract this method.
                      if(val?.trim().isEmpty ?? true){
                        return "enter product name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _productCodeTEController,
                    decoration: const InputDecoration(
                      labelText: ('Product Code'),
                      hintText: ('product code'),
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return "enter product code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _unitPriceTEController,
                    decoration: const InputDecoration(
                      labelText: ('Unit Price:'),
                      hintText: ('unit price'),
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return "enter product unit price";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _amountTEController,
                    decoration: const InputDecoration(
                      labelText: ('Amount:'),
                      hintText: ('enter amount'),
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return "enter product amount";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _totalPriceTEController,
                    decoration: const InputDecoration(
                      labelText: ('Total Price:'),
                      hintText: ('total price'),
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return "enter product total price";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _imageTEController,
                    decoration: const InputDecoration(
                      labelText: ('Image:'),
                      hintText: ('image'),
                    ),
                    validator: (String? val){
                      if(val?.trim().isEmpty ?? true){
                        return "enter product image link";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _addNewProductInProgress ==false,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              createNewProduct();
                            }
                          },
                          child: const Text("Add Product"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> createNewProduct() async{
    _addNewProductInProgress =true;
    setState(() { });
    Uri uri = Uri.parse("https://crud.teamrabbil.com/api/v1/CreateProduct");
    Map<String,dynamic> params =
    {
      "Img":_imageTEController.text.trim(),
      "ProductCode":_productCodeTEController.text.trim(),
      "ProductName":_nameTEController.text.trim(),
      "Qty":_amountTEController.text.trim(),
      "TotalPrice":_totalPriceTEController.text.trim(),
      "UnitPrice":_unitPriceTEController.text.trim(),
    };
    Response response = await post( // <------------------------------------------ add
        uri,
        body:jsonEncode(params),
        headers:{'content-type':'application/json'}
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      //print("successfully created");
      _nameTEController.clear();
      _productCodeTEController.clear();
      _unitPriceTEController.clear();
      _amountTEController.clear();
      _totalPriceTEController.clear();
      _imageTEController.clear();
      //if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar( // ---------------> discussion about this warning latter. // Don't use 'BuildContext's across async gaps.
        const SnackBar(content: Text('product added successfully')),
      );
    }
    _addNewProductInProgress =false;
    setState(() { });
  }
  @override
  void dispose() {
    _nameTEController.dispose(); // dispose even when using state management
    _productCodeTEController.dispose();
    _unitPriceTEController.dispose();
    _amountTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}
