VendingAutomats

Проект для автоматизации вендинговых автоматов.

Состоит из клиента на RPi и серверной части (MVC и backend).

Клиент конфигурируется через xml, задаются параметры модулей.

Каждый модуль может общаться с сервером (пример - модуль пинг, модуль для HC-04 в релиз не вошел)

Backend сервера исходя из того, какой модуль обращается, вызывает соответствующий парсер, который и принимает решение об обновлении данных.
Данные ловит Catcher, который получив достаточно данных (либо по таймауту) пуляет их в таблицу (чтобы избежать перегрузки кучей мелких транзакций).

MVC часть почти не готова, написана на MVC 4 и JQuery.

Содержит набросок отображения уровня по датчику HC-04, истории изменения уровней и пинг.
