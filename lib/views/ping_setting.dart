import 'dart:io';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PingType {
  proxyGet('via Proxy GET'),
  proxyHead('via Proxy HEAD'),
  tcp('TCP'),
  icmp('ICMP');

  final String label;
  const PingType(this.label);
}

class PingTypeNotifier extends Notifier<PingType> {
  @override
  PingType build() => PingType.tcp;

  void setType(PingType type) => state = type;
}

final pingTypeProvider = NotifierProvider<PingTypeNotifier, PingType>(PingTypeNotifier.new);

class PingResultFormatNotifier extends Notifier<String> {
  @override
  String build() => 'Время';

  void setFormat(String format) => state = format;
}

final pingResultFormatProvider = NotifierProvider<PingResultFormatNotifier, String>(PingResultFormatNotifier.new);

class PingSettingView extends ConsumerStatefulWidget {
  const PingSettingView({super.key});

  @override
  ConsumerState<PingSettingView> createState() => _PingSettingViewState();
}

class _PingSettingViewState extends ConsumerState<PingSettingView> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final currentUrl = ref.read(appSettingProvider.select((state) => state.testUrl));
    _urlController = TextEditingController(text: currentUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildPingTypeSection(ThemeData theme) {
    final selectedType = ref.watch(pingTypeProvider);
    final cardColor = theme.cardColor.withOpacity(0.5);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          for (int i = 0; i < PingType.values.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Colors.white10),
            InkWell(
              borderRadius: BorderRadius.vertical(
                top: i == 0 ? const Radius.circular(8) : Radius.zero,
                bottom: i == PingType.values.length - 1 ? const Radius.circular(8) : Radius.zero,
              ),
              onTap: () {
                ref.read(pingTypeProvider.notifier).setType(PingType.values[i]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Radio<PingType>(
                      value: PingType.values[i],
                      groupValue: selectedType,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(pingTypeProvider.notifier).setType(value);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      PingType.values[i].label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTestUrlSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _urlController,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            ref.read(appSettingProvider.notifier).update((state) => state.copyWith(testUrl: value));
          }
        },
      ),
    );
  }

  Widget _buildInterfaceSection(ThemeData theme) {
    final resultFormat = ref.watch(pingResultFormatProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Результат пинга',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: resultFormat,
                isDense: true,
                dropdownColor: theme.cardColor,
                items: const [
                  DropdownMenuItem(value: 'Время', child: Text('Время', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'мс', child: Text('мс', style: TextStyle(fontSize: 13))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(pingResultFormatProvider.notifier).setFormat(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseScaffold(
      title: '${context.appLocalizations.settings} > Пинг',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Тип пинга'),
          _buildPingTypeSection(theme),
          _buildSectionHeader('Тестовый URL (via Proxy)'),
          _buildTestUrlSection(theme),
          _buildSectionHeader('Настройки интерфейса'),
          _buildInterfaceSection(theme),
        ],
      ),
    );
  }
}
