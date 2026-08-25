<div align="center">

# FlClash-Mod

**A powerful, multi-platform GUI proxy client based on Clash / Mihomo with custom enhancements, raw subscription parsing, and fast TCP Handshake ping.**

[**Скачать последний релиз (Releases)**](https://github.com/Kirillo4ka/FlClash-Mod/releases/latest)

</div>

---

## Особенности модификации (Mod Features)

- **Быстрый TCP Handshake замер задержки**: Реальные миллисекунды (2–20 мс) для узлов из белого списка (White-List), которые блокируют стандартный внешний HTTP-пинг.
- **Универсальный парсер подписок и прямых ссылок**: Поддержка импорта списков и ссылок `vless://` (Reality, WS, gRPC, TCP), `vmess://`, `trojan://`, `ss://`, `hysteria2://`, `tuic://`, а также Base64-подписок.
- **Умное определение названия профиля**: Автоматическое извлечение имени подписки из `# profile-title:`, HTTP-заголовков или пути ссылки вместо случайных цифр.
- **Встроенные оптимизированные DNS**: Автоматическая конфигурация безопасных DNS-резолверов для стабильного подключения.
- **Стабильный рендерер на Windows**: Отключен сбойный Impeller OpenGLES, задействован нативный Direct3D/Skia бэкенд.

---

## Скачать и установить

Перейдите в раздел [**Releases**](https://github.com/Kirillo4ka/FlClash-Mod/releases/latest):

1. **`FlClash-Mod-Setup.exe`** — Установщик в один клик (сам распакует файлы и создаст ярлык на Рабочем столе).
2. **`FlClash-Mod-v0.8.96_mod-Windows-x64.zip`** — Портативная версия (распакуйте в любую папку и запустите `FlClash-Mod.exe`).

---

## Создатели и благодарности

- **Kirillo4ka** — Создатель модификации FlClash-Mod
- **chen08209** — Автор оригинального проекта FlClash
- **MetaCubeX** — Разработчики ядра Mihomo (Clash.Meta)

---

## Лицензия

Проект распространяется под лицензией [GPL-3.0](LICENSE).
