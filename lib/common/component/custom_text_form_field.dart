import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
    this.hintText,
    this.errorText,
    super.key});

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    ); /// TextFormField의 기본 보더는 UnderlineInputBorder

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autofocus, /// 위젯에 화면에 보일 때, 자동으로 focus
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20), /// 텍스트 필드 안에 패딩 추가
        hintText: hintText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        errorText: errorText,
        fillColor: INPUT_BG_COLOR,
        filled: true, /// false면 배경색 없음. true면 배경색 있음
        border: baseBorder, /// 모든 Input 상태의 기본 스타일 세팅
        enabledBorder: baseBorder, /// 포커스x의 활성화되어 있는 보더
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
