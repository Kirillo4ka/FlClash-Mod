<div align="center">

# ⚡ FlClash-Mod

<p align="center">
  <strong>Мощный кроссплатформенный GUI-клиент на базе Clash / Mihomo с расширенным функционалом, умным парсером подписок, выбором режимов пинга и стильным интерфейсом.</strong>
</p>

[![Release](https://img.shields.io/github/v/release/Kirillo4ka/FlClash-Mod?color=7E69B5&label=%D0%A0%D0%B5%D0%BB%D0%B8%D0%B7)](https://github.com/Kirillo4ka/FlClash-Mod/releases/latest)
[![Platform](https://img.shields.io/badge/%D0%9F%D0%BB%D0%B0%D1%82%D1%84%D0%BE%D1%80%D0%BC%D1%8B-Windows%20%7C%20Android-1A1920?logo=windows&logoColor=white)](https://github.com/Kirillo4ka/FlClash-Mod/releases/latest)
[![License](https://img.shields.io/badge/%D0%9B%D0%B8%D1%86%D0%B5%D0%BD%D0%B7%D0%B8%D1%8F-GPL--3.0-blue.svg)](LICENSE)

<br/>

[**📥 Скачать последний релиз (Releases)**](https://github.com/Kirillo4ka/FlClash-Mod/releases/latest) • [**✨ Возможности**](#-особенности-модификации) • [**💻 Скачать**](#-скачать) • [**🛠 Сборка**](#-сборка-из-исходного-кода-build)

</div>

---

## ✨ Особенности модификации

### 🚀 1. Универсальный умный парсер подписок и прямых ссылок
Больше не нужно конвертировать конфигурации вручную. FlClash-Mod поддерживает прямую вставку и импорт любых типов ссылок и подписок:
- **Протоколы:** `vless://` (Reality, WS, gRPC, TCP), `vmess://`, `trojan://`, `ss://` (Shadowsocks), `hysteria2://`, `tuic://`.
- **Форматы подписок:** Base64-кодированные списки узлов, сырые текстовые ссылки (raw config), стандартные Clash YAML профили.
- **🏷 Автоматическое извлечение названий:** имя профиля мгновенно распознаётся из заголовков `#title:`, `Profile-Title`, `Content-Disposition` или параметров ссылки.

### ⚡ 2. Выбор метода замера задержки (Пинг)
В меню **«Инструменты» ➡️ «Пинг»** добавлено переключение режима тестирования задержки серверов:
- **`TCP` (Handshake)** — прямой замер времени установки TCP-соединения до порта сервера (быстрый и точный отклик 2–20 мс, как в Happ/v2rayN). Идеально для узлов из White-List.
- **`ICMP`** — стандартный системный ICMP-пинг.
- **`via Proxy GET` / `via Proxy HEAD`** — полноценная проверка доступности ресурсов через прокси-туннель.
- ⏱ **Увеличенный таймаут:** порог ожидания теста расширен до 6000 мс для предотвращения ложных таймаутов на нагруженных узлах.

### 🛡 3. Автоматическая маскировка uTLS Fingerprint
- Автоматическая установка отпечатка `chrome` для всех узлов Reality / TLS, что гарантирует максимальную проходимость через DPI и блокировки.

---

## 📦 Скачать

Перейдите на страницу [**Последнего релиза**](https://github.com/Kirillo4ka/FlClash-Mod/releases/latest) и выберите подходящий файл:

### 💻 Для Windows:
- **`FlClash-Mod-Setup.exe`** — Установщик программы.
- **`FlClash-Mod-v0.8.96_mod-Windows-x64.zip`** — Портативная версия (распакуйте в любую папку и запускайте).

### 📱 Для Android:
- **`FlClash-Mod-v0.8.96_mod-Android-arm64-v8a.apk`** — **(Рекомендуется)** Для всех современных смартфонов и планшетов (64-bit ARM).
- **`FlClash-Mod-v0.8.96_mod-Android-armeabi-v7a.apk`** — Для более старых 32-битных устройств и ТВ-приставок (ARMv7).
- **`FlClash-Mod-v0.8.96_mod-Android-x86_64.apk`** — Для эмуляторов Android на ПК и устройств на базе Intel/AMD.

> [!NOTE]
> Все APK-файлы для Android подписаны полным набором цифровых подписей (V1 + V2 + V3) и устанавливаются без ошибок сертификатов на любой версии Android (от Android 7.0 до Android 15+).

---

## 🛠 Сборка из исходного кода (Build)

### Требования:
- Flutter SDK `>=3.27.0` (Dart `>=3.8.0`)
- Rust toolchain (`cargo`, `rustc`)
- LLVM / Clang (для Windows)
- Android SDK & NDK (для сборки APK)

```bash
# Клонирование репозитория
git clone https://github.com/Kirillo4ka/FlClash-Mod.git
cd FlClash-Mod

# Установка зависимостей
flutter pub get

# Сборка для Windows
flutter build windows --release

# Сборка для Android (раздельные APK по архитектурам)
flutter build apk --release --split-per-abi
```

---

## 👥 Благодарности (Credits)

- **[Kirillo4ka](https://github.com/Kirillo4ka)** — Автор и разработчик модификации **FlClash-Mod**.
- **[chen08209 / FlClash](https://github.com/chen08209/FlClash)** — Автор оригинального проекта FlClash.
- **[MetaCubeX / Mihomo](https://github.com/MetaCubeX/mihomo)** — Разработчики ядра Clash.Meta / Mihomo.

---

## 📄 Лицензия

Проект распространяется под условиями лицензии [GNU General Public License v3.0 (GPL-3.0)](LICENSE).
