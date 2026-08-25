import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/ping_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

double get listHeaderHeight {
  final measure = globalState.measure;
  return 20 + measure.titleMediumHeight + 4 + measure.bodyMediumHeight + 2;
}

double getItemHeight(ProxyCardType proxyCardType) {
  final measure = globalState.measure;
  final baseHeight =
      16 + measure.bodyMediumHeight * 2 + measure.bodySmallHeight + 8 + 4;
  return switch (proxyCardType) {
    ProxyCardType.expand => baseHeight + measure.labelSmallHeight + 6,
    ProxyCardType.shrink => baseHeight,
    ProxyCardType.min => baseHeight - measure.bodyMediumHeight,
  };
}

List<Group> getCurrentGroups() {
  return globalState.container.read(currentGroupsStateProvider).value;
}

List<Group> getGroups() {
  return globalState.container.read(groupsProvider);
}

void updateCurrentGroupName(String groupName) {
  globalState.container
      .read(proxiesActionProvider.notifier)
      .updateCurrentGroupName(groupName);
}

void updateCurrentUnfoldSet(Set<String> value) {
  globalState.container
      .read(proxiesActionProvider.notifier)
      .updateCurrentUnfoldSet(value);
}

Future<int> _tcpPingFallback(String proxyName, int? profileId) async {
  if (profileId == null) return -1;
  try {
    final path = await appPath.getProfilePath(profileId.toString());
    final file = File(path);
    if (!await file.exists()) return -1;
    final lines = await file.readAsLines();
    bool inTargetProxy = false;
    String server = '';
    int port = 0;

    for (final line in lines) {
      final t = line.trim();
      if (t.startsWith('- name:') || t.startsWith('name:')) {
        var n = t.substring(t.indexOf('name:') + 5).trim();
        if (n.startsWith('"') && n.endsWith('"') && n.length >= 2) {
          n = n.substring(1, n.length - 1);
        }
        if (n == proxyName) {
          inTargetProxy = true;
          server = '';
          port = 0;
          continue;
        } else if (inTargetProxy) {
          break;
        }
      }
      if (inTargetProxy) {
        if (t.startsWith('server:')) {
          server = t.substring(7).trim().replaceAll('"', '');
        } else if (t.startsWith('port:')) {
          port = int.tryParse(t.substring(5).trim()) ?? 0;
        }
        if (server.isNotEmpty && port > 0) {
          break;
        }
      }
    }

    if (server.isNotEmpty && port > 0) {
      final sw = Stopwatch()..start();
      final socket = await Socket.connect(server, port, timeout: const Duration(seconds: 3));
      sw.stop();
      socket.destroy();
      return sw.elapsedMilliseconds;
    }
  } catch (_) {}
  return -1;
}

Future<void> proxyDelayTest(Proxy proxy, [String? testUrl]) async {
  final ref = globalState.container;
  final groups = getGroups();
  final currentProfile = ref.read(currentProfileProvider);
  final selectedMap = currentProfile?.selectedMap ?? {};
  final state = computeRealSelectedProxyState(
    proxy.name,
    groups: groups,
    selectedMap: selectedMap,
  );
  final currentTestUrl = state.testUrl.takeFirstValid([
    ref.read(realTestUrlProvider(testUrl)),
  ]);
  if (state.proxyName.isEmpty) {
    return;
  }
  ref
      .read(proxiesActionProvider.notifier)
      .setDelay(Delay(url: currentTestUrl, name: state.proxyName, value: 0));

  final pingType = ref.read(pingTypeProvider);
  if (pingType == PingType.tcp) {
    final tcpValue = await _tcpPingFallback(state.proxyName, currentProfile?.id);
    ref
        .read(proxiesActionProvider.notifier)
        .setDelay(Delay(url: currentTestUrl, name: state.proxyName, value: tcpValue));
    return;
  }

  try {
    final delay = await coreController.getDelay(
      currentTestUrl,
      state.proxyName,
    );
    if ((delay.value ?? 0) > 0) {
      ref.read(proxiesActionProvider.notifier).setDelay(delay);
      return;
    }
  } catch (_) {}

  // Fallback to TCP ping (handshake check like in Happ)
  final tcpValue = await _tcpPingFallback(state.proxyName, currentProfile?.id);
  ref
      .read(proxiesActionProvider.notifier)
      .setDelay(Delay(url: currentTestUrl, name: state.proxyName, value: tcpValue));
}

Future<void> delayTest(List<Proxy> proxies, [String? testUrl]) async {
  final batches = proxies.batch(maxConcurrentDelayTests);
  for (final batch in batches) {
    await Future.wait(
      batch.map((proxy) async {
        await proxyDelayTest(proxy, testUrl);
      }),
    );
  }
  globalState.container.read(sortNumProvider.notifier).add();
}

double getScrollToSelectedOffset({
  required String groupName,
  required List<Proxy> proxies,
  required int columns,
}) {
  final ref = globalState.container;
  final proxyCardType = ref.read(
    proxiesStyleSettingProvider.select((state) => state.cardType),
  );
  final selectedProxyName = ref.read(selectedProxyNameProvider(groupName));
  final findSelectedIndex = proxies.indexWhere(
    (proxy) => proxy.name == selectedProxyName,
  );
  final selectedIndex = findSelectedIndex != -1 ? findSelectedIndex : 0;
  final rows = (selectedIndex / columns).floor();
  return rows * getItemHeight(proxyCardType) + (rows - 1) * 8;
}
