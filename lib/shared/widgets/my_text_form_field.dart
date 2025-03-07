import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.initial,
    this.isPassword = false,
    this.isReadOnly = false,
    this.isAddressMap = false,
    this.autofocus = false,
    this.isInlineIcon = false,
    this.type,
    this.validator,
    this.onTap,
    this.onEditingComplete,
    this.icon,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? initial;
  final TextInputType? type;
  final FormFieldValidator<String>? validator;
  final bool isPassword;
  final bool isReadOnly;
  final bool isAddressMap;
  final bool isInlineIcon;
  final bool autofocus;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final Widget? icon;

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late bool _isSecure;

  void switchSecure() {
    setState(() {
      _isSecure = !_isSecure;
    });
  }

  @override
  void initState() {
    _isSecure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          label: Text(widget.label),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: const OutlineInputBorder(),
          icon: widget.icon != null && !widget.isInlineIcon
              ? IconButton(onPressed: widget.onTap, icon: widget.icon!)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: switchSecure,
                  icon:
                      Icon(_isSecure ? Icons.visibility_off : Icons.visibility))
              : widget.isAddressMap
                  ? IconButton(
                      onPressed: widget.onTap,
                      icon: const Icon(Icons.add_location_alt_outlined))
                  : widget.icon != null && widget.isInlineIcon
                      ? IconButton(
                          onPressed: widget.onTap,
                          icon: widget.icon!,
                        )
                      : null,
          hintText: widget.hint),
      autofocus: widget.autofocus,
      keyboardType: widget.type,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      initialValue: widget.initial,
      inputFormatters: widget.type == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'\d')),
            ]
          : null,
      controller: widget.controller,
      obscureText: _isSecure,
      readOnly: widget.isReadOnly,
      enableSuggestions: !_isSecure,
      onEditingComplete: widget.onEditingComplete,
      onTap: !widget.isAddressMap && widget.icon == null ? widget.onTap : null,
    );
  }
}
