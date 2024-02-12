import 'dart:convert';

import 'package:crud_app_restapi/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key,required this.product});
  final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _amountTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName ?? '';
    _productCodeTEController.text = widget.product.productCode ?? '';
    _unitPriceTEController.text = widget.product.unitPrice ?? '';
    _amountTEController.text = widget.product.quantity ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _imageTEController.text = widget.product.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product'),),
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
                      visible: _updateProductInProgress==false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _updateProduct();
                          }
                        },
                        child: const Text("Update Product"),
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
  Future<void> _updateProduct()async{
    _updateProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse("https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}"); //widget.product.id
    Product product = Product(
      id: widget.product.id,
      productName: _nameTEController.text.trim(),
      productCode: _productCodeTEController.text.trim(),
      image: _imageTEController.text.trim(),
      unitPrice: _unitPriceTEController.text.trim(),
      quantity: _amountTEController.text.trim(),
      totalPrice: _totalPriceTEController.text.trim(),
      createdDate: widget.product.createdDate,
    );
    print(product.toJson());
    final Response response = await post(uri, // <-------------------------------- edit
        body: jsonEncode(product.toJson()),
        headers: {'Content-type': 'application/json'});
    if(response.statusCode==200){
      final decodedData = jsonDecode(response.body);
      if (decodedData["status"] == "success") {
        print("--------------------------------------- update success ----------------------------------------------------");
        print("id= ${widget.product.id}");
        _updateProductInProgress = false;
        setState(() {});
        //if (!context.mounted) return;
        Navigator.pop(context, true); // --> Don't use 'BuildContext's across async gaps.
      }else{
        _updateProductInProgress = false;
        print("--------------------------------------- update failed ----------------------------------------------------");
        setState(() {});
        //if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('product update failed, try latter again'))
        );
      }
    }else{
      _updateProductInProgress = false;
      print("--------------------------------------- update failed ----------------------------------------------------");
      setState(() {});
      //if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('product update failed, try latter again'))
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    _nameTEController.dispose();
    _productCodeTEController.dispose();
    _imageTEController.dispose();
    _unitPriceTEController.dispose();
    _amountTEController.dispose();
    _totalPriceTEController.dispose();
  }
}
