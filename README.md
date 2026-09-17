# Lampac HAOS Add-on

[![GitHub Release](https://img.shields.io/github/v/release/KsergeyI/Lampac-haos?style=flat-square)](https://github.com/KsergeyI/Lampac-haos/releases)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/KsergeyI/Lampac-haos/check-lampac-update.yml?style=flat-square&label=Lampac%20update)](https://github.com/KsergeyI/Lampac-haos/actions)
[![Architecture](https://img.shields.io/badge/HAOS-amd64%20%7C%20aarch64-blue?style=flat-square)](https://www.home-assistant.io/)

**Lampac Next Generation для Home Assistant OS**

Home Assistant Add-on для запуска [Lampac Next Generation](https://github.com/lampac-nextgen/lampac) непосредственно в Home Assistant OS.

Проект использует **официальный Docker-образ Lampac** и представляет собой тонкую HAOS-обёртку, которая добавляет интеграцию с системой Add-on Home Assistant и обеспечивает сохранение данных между перезапусками и обновлениями.

---

## ✨ Возможности

- 🚀 Запуск Lampac непосредственно в Home Assistant OS
- 🐳 Использование официального образа `ghcr.io/lampac-nextgen/lampac`
- 💾 Сохранение конфигурации и данных между перезапусками и обновлениями
- ⚙️ Редактирование `init.conf` через интерфейс Home Assistant
- 🎬 Встроенный TorrServer
- 🔄 Автоматическое обновление TorrServer до актуального релиза
- 📦 Сохранение базы и настроек TorrServer
- 🧩 Сохранение `mods`
- 🔌 Сохранение `lampainit.js`
- 🔐 Сохранение `passwd`
- 🔄 Автоматическое отслеживание обновлений официального Lampac
- 🏠 Поддержка архитектур `amd64` и `aarch64`

---

## 📦 Установка

### 1. Добавить репозиторий

В Home Assistant откройте:

**Настройки → Дополнения → Магазин дополнений → ⋮ → Репозитории**

Добавьте:

```text
https://github.com/KsergeyI/Lampac-haos
```

После добавления репозитория в списке дополнений появится **Lampac**.

### 2. Установить Add-on

Откройте Lampac и нажмите:

**Установить**

После установки запустите Add-on.

---

## 🌐 Веб-интерфейс

Lampac работает на порту:

```text
9118
```

В интерфейсе Home Assistant Add-on можно использовать кнопку **Web UI** для открытия Lampac.

Также интерфейс доступен по адресу:

```text
http://IP_HOME_ASSISTANT:9118/
```

---

## ⚙️ Конфигурация

Основная конфигурация Lampac задаётся через параметр `init_conf` в настройках Add-on.

Откройте:

**Lampac → Конфигурация**

и укажите необходимый JSON.

Пример конфигурации по умолчанию:

```json
{
  "BaseModule": {
    "LoadModules": [".*"],
    "SkipModules": [
      "Catalog",
      "Tracks",
      "Transcoding",
      "WebLog",
      "CacheMedia",
      "ForkPlayerXML",
      "MsxNative",
      "Potok",
      "TelegramAuth",
      "TelegramAuthBot"
    ]
  },
  "TorrServer": {
    "releases": "latest"
  }
}
```

> В поле `init_conf` необходимо вставлять **только JSON**, без `init_conf:`.

### Как работает `init.conf`

При запуске Add-on значение `init_conf` из настроек Home Assistant записывается в:

```text
/config/init.conf
```

Затем этот файл передаётся Lampac.

Таким образом, **настройки Add-on являются источником конфигурации `init.conf`**.

---

## 🎬 TorrServer

Lampac содержит встроенный модуль TorrServer.

В конфигурации Add-on по умолчанию используется:

```json
"TorrServer": {
  "releases": "latest"
}
```

Это позволяет модулю Lampac автоматически получать актуальную версию TorrServer.

Данные TorrServer сохраняются в:

```text
/data/ts
```

Сохраняются, в частности:

- база конфигурации;
- настройки;
- учётные данные;
- загруженный бинарный файл;
- информация о версии.

Поэтому перезапуск или обновление Add-on не приводит к сбросу настроек TorrServer.

---

## 💾 Сохранение данных

Основные каталоги Lampac переносятся в постоянное хранилище Home Assistant.

| Данные | Постоянное расположение |
|---|---|
| Cache | `/data/cache` |
| Database | `/data/database` |
| TorrServer | `/data/ts` |
| Mods | `/data/mods` |
| Plugins | `/data/plugins` |
| Password | `/data/passwd` |
| `init.conf` | `/config/init.conf` |

Внутри Lampac используются соответствующие символические ссылки.

Это позволяет сохранять данные при:

- перезапуске Add-on;
- перезапуске Home Assistant;
- обновлении Add-on;
- обновлении базового образа Lampac.

---

## 🔄 Обновление Lampac

Add-on использует официальный образ:

```text
ghcr.io/lampac-nextgen/lampac:latest
```

GitHub Actions проекта периодически проверяет digest официального образа Lampac.

Проверка выполняется каждые **6 часов**.

Если официальный образ изменился:

1. определяется новый digest;
2. увеличивается версия Add-on;
3. изменения автоматически отправляются в репозиторий;
4. Home Assistant получает новую версию Add-on;
5. при обновлении используется новый официальный образ Lampac.

### Важно

GitHub Actions **не обновляет Home Assistant напрямую**.

Он обновляет версию Add-on в репозитории, после чего Home Assistant может установить новую версию.

---

## 🏗️ Архитектура

Проект намеренно использует минимальную обёртку над официальным Lampac.

```text
Home Assistant OS
        │
        ▼
   Lampac Add-on
        │
        ▼
    Dockerfile
        │
        ▼
ghcr.io/lampac-nextgen/lampac:latest
        │
        ▼
      Lampac
```

При запуске Add-on выполняется `run.sh`, который:

1. получает `init_conf` из настроек Home Assistant;
2. подготавливает постоянные каталоги;
3. восстанавливает сохранённые данные;
4. создаёт необходимые символические ссылки;
5. запускает Lampac от пользователя `lampac`.

---

## 🧩 Структура проекта

```text
Lampac-haos/
├── .github/
│   └── workflows/
│       └── check-lampac-update.yml
│
├── lampac/
│   ├── config.yaml
│   ├── Dockerfile
│   └── run.sh
│
└── repository.yaml
```

### `config.yaml`

Описание Home Assistant Add-on, поддерживаемых архитектур, портов и настроек.

### `Dockerfile`

Создаёт образ Add-on на основе официального Docker-образа Lampac.

Дополнительно устанавливается `jq`, необходимый для обработки конфигурации Home Assistant.

### `run.sh`

Подготавливает окружение и постоянное хранилище перед запуском Lampac.

### `check-lampac-update.yml`

Автоматически отслеживает изменения официального Docker-образа Lampac.

---

## 🛠️ Требования

- Home Assistant OS
- архитектура `amd64` или `aarch64`
- доступ к интернету для получения Docker-образов и обновлений

---

## ❓ FAQ

### Это форк Lampac?

Нет.

Проект не является форком исходного Lampac. Он использует официальный Docker-образ:

```text
ghcr.io/lampac-nextgen/lampac:latest
```

### Сбрасываются ли настройки после обновления?

Нет. Основные данные Lampac и TorrServer хранятся в постоянном хранилище Home Assistant.

### Можно ли изменить `init.conf`?

Да. Полный JSON можно указать непосредственно в поле `init_conf` в настройках Add-on.

### Обновляется ли TorrServer?

Да. В стандартной конфигурации используется:

```json
"releases": "latest"
```

### Как часто проверяется обновление Lampac?

GitHub Actions проверяет официальный Docker-образ каждые 6 часов.

### Обновляется ли Home Assistant автоматически?

Нет. GitHub Actions только обновляет версию Add-on в репозитории. Установка новой версии в Home Assistant выполняется механизмом обновления Add-on.

---

## 📌 Примечания

Проект создан для удобного запуска Lampac Next Generation в Home Assistant OS без необходимости самостоятельно управлять отдельным Docker-контейнером.

Основная идея проекта:

**официальный Lampac + Home Assistant Add-on + постоянное хранилище + автоматическое отслеживание обновлений.**

---

## 🔗 Ссылки

- [Lampac Next Generation](https://github.com/lampac-nextgen/lampac)
- [Документация Lampac](https://docs.lampac.dev/)
- [Docker deployment](https://docs.lampac.dev/deployment/docker)
- [Home Assistant Add-ons](https://www.home-assistant.io/addons/)
- [Репозиторий Lampac HAOS](https://github.com/KsergeyI/Lampac-haos)
