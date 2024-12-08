import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../asdc_context_menu_builder.dart';
import 'krs_field_label.dart';
import 'krs_field_loading_button.dart';
import 'krs_input_decoration.dart';

double? doubleValueTransformer(String? value) => double.tryParse(value ?? '');
int? intValueTransformer(String? value) => int.tryParse(value ?? '');

class KrsTextField<T> extends FormBuilderFieldDecoration<String> {
  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  ///
  /// If not provided, will build a default menu based on the platform.
  ///
  /// See also:
  ///
  ///  * [AdaptiveTextSelectionToolbar], which is built by default.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  KrsTextField({
    super.key,
    required super.name,
    super.onChanged,
    super.enabled,
    super.initialValue,
    super.validator,
    dynamic Function(String?)? valueTransformer,
    this.textCapitalization = TextCapitalization.none,
    String? labelText,
    String? hintText,
    Widget? suffix,
    Widget? suffixIcon,
    bool loading = false,
    bool obscureText = false,
    TextInputAction? textInputAction,
    void Function(String)? onSubmitted,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    TextInputType? keyboardType,
    bool readOnly = false,
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 24.0),
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    bool isDense = false,
    bool hidden = false,
    List<String> autofillHints = const <String>[],
  }) : super(
          valueTransformer: (T == double)
              ? doubleValueTransformer
              : (T == int)
                  ? intValueTransformer
                  : valueTransformer,
          builder: (FormFieldState<String> field) {
            final state = field as _KrsTextFieldState;
            final theme = Theme.of(state.context);

            final decoration = KrsInputDecoration(
              theme: theme,
              enabled: state.enabled && !loading,

              isDense: isDense,

              errorText: state.errorText,
              hintText: hintText,

              suffixIcon: loading ? const KrsFieldLoadingButton() : suffixIcon,
              // prefixIcon: prefixIcon,
            );

            if (hidden) {
              return const SizedBox();
            }

            final contextMenuController = AsdcContextMenuController();
            // if (widget.contextButtonsBuilder != null && kIsWeb) {
            //   html.document.onContextMenu.listen((event) {
            //     if (event.path.firstOrNull.toString() == 'flutter-view') {
            //       return event.preventDefault();
            //     }
            //   });
            // }

            return KrsFieldLabel(
              padding: padding,
              hasError: state.hasError,
              hasFocus: state.effectiveFocusNode.hasFocus,
              labelText: labelText,
              maxLength: maxLength,
              controller: state._effectiveController,
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior(),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onSecondaryTapUp: state.enabled
                            ? null
                            : (t) {
                                final position = t.globalPosition;

                                contextMenuController.show(
                                  context: state.context,
                                  contextMenuBuilder: (context) {
                                    return AdaptiveTextSelectionToolbar
                                        .buttonItems(
                                      anchors: TextSelectionToolbarAnchors(
                                        primaryAnchor: position,
                                      ),
                                      buttonItems: [
                                        ContextMenuButtonItem(
                                          onPressed: () {
                                            AsdcContextMenuController
                                                .removeAny();
                                            Clipboard.setData(ClipboardData(
                                                text: state.value ?? ''));
                                          },
                                          label:
                                              MaterialLocalizations.of(context)
                                                  .copyButtonLabel,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                        child: TextField(
                          scrollPadding: EdgeInsets.zero,
                          controller: state._effectiveController,
                          focusNode: state.effectiveFocusNode,
                          decoration: decoration,
                          keyboardType: keyboardType,
                          // textInputAction: textInputAction,
                          contextMenuBuilder: contextMenuBuilder,
                          style: decoration.textStyle,
                          obscureText: obscureText,
                          textInputAction: textInputAction,
                          onSubmitted: onSubmitted,
                          textCapitalization: textCapitalization,
                          autofillHints: autofillHints,

                          // autofocus: autofocus,
                          readOnly: readOnly,

                          // autocorrect: autocorrect,
                          // enableSuggestions: enableSuggestions,
                          maxLength: maxLength,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return null;
                          },
                          // onTap: onTap,
                          onTapOutside: (event) {
                            /// убираем фокус с поля
                            state.effectiveFocusNode.unfocus();
                          },
                          // onEditingComplete: onEditingComplete,
                          // onSubmitted: onSubmitted,
                          inputFormatters: inputFormatters ??
                              [
                                if (T == int)
                                  FilteringTextInputFormatter.digitsOnly,
                                if (T == double)
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,4}'),
                                  ),
                              ],
                          enabled: state.enabled,
                          // keyboardAppearance: keyboardAppearance,
                        ),
                      ),
                    ),
                    if (suffix != null) suffix
                  ],
                ),
              ),
            );
          },
        );

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) =>
      AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState,
      );

  @override
  FormBuilderFieldDecorationState<KrsTextField, String> createState() =>
      _KrsTextFieldState();
}

class _KrsTextFieldState<T>
    extends FormBuilderFieldDecorationState<KrsTextField, String> {
  TextEditingController? get _effectiveController => _controller;

  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    //setting this to value instead of initialValue here is OK since we handle initial value in the parent class
    _controller = TextEditingController(text: value);
    _controller!.addListener(_handleControllerChanged);

    effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    // Dispose the _controller when initState created it
    _controller!.removeListener(_handleControllerChanged);
    _controller!.dispose();

    effectiveFocusNode.removeListener(_handleFocusChanged);

    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = initialValue ?? '';
    });
  }

  @override
  void didChange(value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != (value ?? '')) {
      didChange(_effectiveController!.text);
    }
  }

  void _handleFocusChanged() {
    setState(() {});
  }
}
