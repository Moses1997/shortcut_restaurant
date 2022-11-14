import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/config_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNameScreen extends StatefulWidget {
  final Product product;
  AddNameScreen({@required this.product});

  @override
  _AddNameScreenState createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> {
  List<TextEditingController> _nameControllerList = [];
  List<TextEditingController> _descriptionControllerList = [];
  List<FocusNode> _nameFocusList = [];
  List<FocusNode> _descriptionFocusList = [];
  List<Language> _languageList = Get.find<SplashController>().configModel.language;

  @override
  void initState() {
    super.initState();

    if(widget.product != null) {
      for(int index=0; index<_languageList.length; index++) {
        _nameControllerList.add(TextEditingController(
          text: widget.product.translations[widget.product.translations.length-2].value,
        ));
        _descriptionControllerList.add(TextEditingController(
          text: widget.product.translations[widget.product.translations.length-1].value,
        ));
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
        widget.product.translations.forEach((translation) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _nameControllerList[index] = TextEditingController(text: translation.value);
          }else if(_languageList[index].key == translation.locale && translation.key == 'description') {
            _descriptionControllerList[index] = TextEditingController(text: translation.value);
          }
        });
      }
    }else {
      _languageList.forEach((language) {
        _nameControllerList.add(TextEditingController());
        _descriptionControllerList.add(TextEditingController());
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.product != null ? 'update_food'.tr : 'add_food'.tr),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Column(children: [

          Expanded(child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _languageList.length,
            itemBuilder: (context, index) {
              return Column(children: [

                Text(_languageList[index].value, style: robotoBold),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                MyTextField(
                  hintText: 'food_name'.tr,
                  controller: _nameControllerList[index],
                  capitalization: TextCapitalization.words,
                  focusNode: _nameFocusList[index],
                  nextFocus: _descriptionFocusList[index],
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                MyTextField(
                  hintText: 'description'.tr,
                  controller: _descriptionControllerList[index],
                  focusNode: _descriptionFocusList[index],
                  capitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  inputAction: index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                  nextFocus: index != _languageList.length-1 ? _nameFocusList[index+1] : null,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              ]);
            },
          )),

          CustomButton(
            buttonText: 'next'.tr,
            onPressed: () {
              bool _defaultDataNull = false;
              for(int index=0; index<_languageList.length; index++) {
                if(_languageList[index].key == 'en') {
                  // if (_nameControllerList[index].text.trim().isEmpty || _descriptionControllerList[index].text.trim().isEmpty) {
                  if (_nameControllerList[index].text.trim().isEmpty) {
                    _defaultDataNull = true;
                  }
                  break;
                }
              }
              if(_defaultDataNull) {
                showCustomSnackBar('enter_data_for_english'.tr);
              }else {
                List<Translation> _translations = [];
                for(int index=0; index<_languageList.length; index++) {
                  _translations.add(Translation(
                    locale: _languageList[index].key, key: 'name',
                    value: _nameControllerList[index].text.trim().isNotEmpty ? _nameControllerList[index].text.trim()
                        : _nameControllerList[0].text.trim(),
                  ));
                  _translations.add(Translation(
                    locale: _languageList[index].key, key: 'description',
                    value: _descriptionControllerList[index].text.trim().isNotEmpty ? _descriptionControllerList[index].text.trim()
                        : _descriptionControllerList[0].text.trim(),
                  ));
                }
                Get.toNamed(RouteHelper.getAddProductRoute(widget.product, _translations));
              }
            },
          ),

        ]),
      ),
    );
  }
}
