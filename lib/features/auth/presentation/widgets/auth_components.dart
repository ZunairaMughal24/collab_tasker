import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Widget footer;
  final bool compactHero;
  final String sectionLabel;

  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.footer,
    this.compactHero = false,
    this.sectionLabel = 'YOUR ACCOUNT',
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: EntryPalette.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: EntryPalette.hero,
        body: SafeArea(
          bottom: false,
          child: SizedBox.expand(
            child: ColoredBox(
              color: EntryPalette.background,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthHeader(
                          title: title,
                          subtitle: subtitle,
                          compact: compactHero,
                        ),
                        ColoredBox(
                          color: EntryPalette.hero,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              28,
                              31,
                              28,
                              24 + MediaQuery.paddingOf(context).bottom,
                            ),
                            decoration: const BoxDecoration(
                              color: EntryPalette.background,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  sectionLabel,
                                  style: const TextStyle(
                                    color: EntryPalette.muted,
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 23),
                                form,
                                const SizedBox(height: 25),
                                Center(child: footer),
                                const SizedBox(height: 7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPasswordField;
  final VoidCallback? onVisibilityTap;
  final TextInputAction? textInputAction;

  const AuthFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.isPasswordField = false,
    this.onVisibilityTap,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: EntryPalette.border),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: EntryPalette.ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          autocorrect: false,
          enableSuggestions: !isPasswordField,
          style: const TextStyle(color: EntryPalette.ink, fontSize: 15),
          cursorColor: EntryPalette.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: EntryPalette.muted, fontSize: 14),
            filled: true,
            fillColor: EntryPalette.surface,
            prefixIcon: Icon(icon, color: EntryPalette.muted, size: 19),
            suffixIcon: isPasswordField && onVisibilityTap != null
                ? IconButton(
                    tooltip: obscureText ? 'Show password' : 'Hide password',
                    onPressed: onVisibilityTap,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: EntryPalette.muted,
                      size: 20,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: outline,
            enabledBorder: outline,
            focusedBorder: outline.copyWith(
              borderSide: const BorderSide(
                color: EntryPalette.accent,
                width: 1.5,
              ),
            ),
            errorBorder: outline.copyWith(
              borderSide: const BorderSide(color: EntryPalette.error),
            ),
            focusedErrorBorder: outline.copyWith(
              borderSide: const BorderSide(
                color: EntryPalette.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: EntryPalette.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: EntryPalette.accent,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}
