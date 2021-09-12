import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int? _selectedValue = k30;
  late TextEditingController _textFieldController;
  late FocusNode _textFieldNode;

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController();
    _textFieldNode = FocusNode();

    _textFieldNode.addListener(() {
      if (_textFieldNode.hasFocus) {
        setState(() {
          _selectedValue = int.tryParse(_textFieldController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  Icon(
                    CupertinoIcons.back,
                    color: kBackButtonColor,
                  ),
                  Text(
                    txtBack,
                    style: TextStyle(
                      color: kBackButtonColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TimeOption(
                          value: k30,
                          isSelected: _selectedValue == k30,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _selectedValue = k30;
                            });
                          },
                        ),
                        TimeOption(
                          value: k45,
                          isSelected: _selectedValue == k45,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _selectedValue = k45;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: Material(
                        elevation: _textFieldNode.hasFocus ? 10.0 : 0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(40),
                        child: TextField(
                          controller: _textFieldController,
                          focusNode: _textFieldNode,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(color: kBorderColor),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(60, 20, 20, 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: kBorderColor, width: 2.0),
                            ),
                            hintText: txtCustom,
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: kTimerColor,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny('-'),
                            FilteringTextInputFormatter.deny('.'),
                          ],
                          style:
                              textStyle.copyWith(fontWeight: FontWeight.w500),
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = int.tryParse(value);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _selectedValue);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: kButtonColor,
                        onPrimary: kButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                        fixedSize: const Size(200, 48),
                      ),
                      child: const Text(
                        txtSave,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeOption extends StatelessWidget {
  final int value;
  final bool isSelected;
  final VoidCallback? onPressed;

  const TimeOption({
    Key? key,
    required this.value,
    this.isSelected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
            ),
            child: TimeLabel(
              value: value,
              color: isSelected ? kTimeOptionColor : kTimerColor,
            ),
          ),
          Positioned(
            left: 0,
            top: 30,
            child: Icon(
              Icons.arrow_drop_up,
              size: 64,
              color: isSelected ? kTimeOptionColor : kTimerColor,
            ),
          )
        ],
      ),
    );
  }
}

class TimeLabel extends StatelessWidget {
  final int value;
  final Color color;

  const TimeLabel({
    Key? key,
    required this.value,
    this.color = kTimeOptionColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            txtS,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
