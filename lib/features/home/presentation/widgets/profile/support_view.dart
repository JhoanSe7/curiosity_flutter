import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportView extends ConsumerStatefulWidget {
  const SupportView({super.key});

  @override
  ConsumerState<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends ConsumerState<SupportView> {
  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Ayuda y Soporte",
      body: Column(
        children: [],
      ),
    );
  }
}
