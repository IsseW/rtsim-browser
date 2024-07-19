main-username = Ім'я користувача
main-server = Сервер
main-password = Пароль
main-connecting = З'єднання
main-creating_world = Створення світу
main-tip = Підказка:
main-unbound_key_tip = Від'єднати
main-notice =
    Вітаємо в альфа-версії Veloren!

    Кілька моментів перед зануренням у пригоди:

    - Це дуже рання альфа. Будьте готові до багів, сирого ігроладу, невідполірованих механік та відсутності функцій/можливостей.

    - Якщо у Вас є конструктивна критика, відгуки, поради або Ви знайшли помилки - можете зв'язатись з нами на нашому репозиторії GitLab чи Discord або Matrix сервері.

    - Veloren - це проект з відкритим кодом. Ви можете вільно грати, змінювати та поширювати гру відповідно до версії 3 загальнодоступної ліцензії GNU.

    - Veloren - це неприбутковий проект, і всі, хто над ним працюють - волонтери.
    Якщо він Вам подобається гра - ласкаво просимо долучитись до будь-якої групи команди розробників.

    Дякуємо, що прочитали. Щиро сподіваємось, що вам сподобається гра!

    ~ Команда розробників
main-login_process =
    Про багатокористувацький режим:

    Врахуйте будь ласка, що вам потрібен обліковий запис для гри на серверах
    з увімкненою авторизацією.

    Створити обліковий запис можна тут:
    https://veloren.net/account/
main-singleplayer-new = Нова
main-singleplayer-delete = Видалити
main-singleplayer-regenerate = Перегенерувати
main-singleplayer-create_custom = Налаштувати
main-singleplayer-invalid_name = Помилка: неприпустиме ім'я
main-singleplayer-seed = Зерно
main-singleplayer-random_seed = Випадкова
main-singleplayer-size_lg = Логарифмічний розмір
main-singleplayer-map_large_warning = Застереження: Перший запуск великих світів може зайняти багато часу.
main-singleplayer-world_name = Назва світу
main-singleplayer-map_scale = Вертикальне масштабування
main-singleplayer-map_erosion_quality = Якість ерозії
main-singleplayer-map_shape = Форма
main-singleplayer-play = Грати
main-singleplayer-generate_and_play = Згенерувати і Грати
menu-singleplayer-confirm_delete = Ви дійсно хочете видалити "{ $world_name }"?
menu-singleplayer-confirm_regenerate = Ви дійсно хочете перегенерувати "{ $world_name }"?
main-login-server_not_found = Сервер не знайдено.
main-login-authentication_error = Помилка авторизації на сервері.
main-login-internal_error = Внутрішня помилка у клієнта. Підказка: можливо персонаж гравця був видалений.
main-login-failed_auth_server_url_invalid = Не вдалося з'єднатися з сервером аутентифікації.
main-login-insecure_auth_scheme = Схема HTTP аутентифікації не підтримується. Це небезпечно! Для розробки, HTTP дозволено для 'localhost' або для дебажних збірок.
main-login-server_full = Сервер переповнений.
main-login-untrusted_auth_server = Ненадійний сервер аутентифікації.
main-login-outdated_client_or_server = ServerWentMad: ймовірно версії не сумісні, перевірте оновлення.
main-login-timeout = Чай вийшов: сервер не відповів вчасно. Підказка: можливо сервер наразі перенавантажений, або є якісь проблеми з мережею.
main-login-server_shut_down = Сервер вимкнено.
main-login-network_error = Помилка мережі.
main-login-network_wrong_version = Неспівпадіння версій сервера та клієнта. Підказка: можливо Вам потрібно оновити свій ігровий клієнт.
main-login-failed_sending_request = Запит до сервера аутентифікації невдалий.
main-login-invalid_character = Обраний персонаж недоступний.
main-login-client_crashed = Клієнт впав.
main-login-not_on_whitelist = Ви не знаходитесь у білому списку сервера, до якого спробували приєднатись.
main-login-banned = Вас заблоковано з наступної причини:
main-login-kicked = Вас викинуто з наступної причини:
main-login-select_language = Оберіть мову
main-login-client_version = Версія клієнта
main-login-server_version = Версія сервера
main-login-client_init_failed = Помилка запуску клієнта: { $init_fail_reason }
main-login-username_bad_characters = Ім'я користувача містить некоректні символи! (Використовуйте тільки букви, цифри, '_' та '-').
main-login-username_too_long = Ім'я персонажа занадто довге! Максимальна довжина: { $max_len }
main-servers-select_server = Виберіть сервер
main-servers-singleplayer_error = Помилка підключення до внутрішнього сервера: { $sp_error }
main-servers-network_error = Помилка сокету/мережі серверів: { $raw_error }
main-servers-participant_error = Від'єднання учасника/помилка протоколу: { $raw_error }
main-servers-stream_error = Помилка даних клієнта під час підключення: { $raw_error }
main-servers-database_error = Помилка даних сервера: { $raw_error }
main-servers-persistence_error = Помилка зберігання (Можливо, пов'язано з ресурсами гри або даними про персонажа): { $raw_error }
main-servers-other_error = Помилка сервера: { $raw_error }
main-credits = Подяки
main-credits-created_by = зроблено
main-credits-music = Музика
main-credits-fonts = Шрифти
main-credits-other_art = Інші роботи
main-credits-contributors = Автори
loading-tips =
    .a0 = Натисніть '{ $gameinput-togglelantern }', щоб вмикнути ліхтар.
    .a1 = Натисніть '{ $gameinput-help }', щоб переглянути прив'язки клавіш за замовчуванням.
    .a2 = Можна ввести /say чи /s, щоб написати лише гравцям поряд.
    .a3 = Можна ввести /region чи /r, щоб написати лише гравцям в радіусі кількох сотень блоків навколо.
    .a4 = Адміністратори можуть використовувати команду /build для переходу в режим будування.
    .a5 = Можна ввести /group чи /g, щоб написати лише гравцям з Вашої поточної групи.
    .a6 = Щоб надіслати приватне повідомлення, введіть /tell або /t, ім'я гравця, та Ваше повідомлення.
    .a7 = Тримайте око на вістрі - їжа, скрині та інші корисні предмети можуть бути де-завгодно!
    .a8 = Інвентар переповнений харчами? Спробуйте приготувати з них кращу їжу!
    .a9 = Шукаєте чим би це зайнятись? Відвідайте одне з позначених на мапі підземель!
    .a10 = Не забудьте налаштувати оптимальну для Вашої системи якість зображення. Натисніть '{ $gameinput-settings }', щоб відкрити налаштування.
    .a11 = Грати з іншими весело! Натисніть '{ $gameinput-social }', щоб переглянути список користувачів у мережі.
    .a12 = Натисніть '{ $gameinput-dance }', щоб потанцювати. Гей-гоп!
    .a13 = Натисніть '{ $gameinput-glide }', щоб дістати Дельтаплан, та підкорюйте небеса!
    .a14 = Veloren все ще на стадії ранньої альфи. Ми стараємося кожного дня щоб робити покращення!
    .a15 = Якшо Ви хочете долучитись до розробки або ж просто поспілкуватись із розробниками, приєднуйтесь до нашого Discord-серверу.
    .a16 = Ви можете змінити тип відображення здоров'я на індикаторі здоров'я в налаштуваннях.
    .a17 = Присядьте біля вогнища (натиснувши кнопку '{ $gameinput-sit }'), щоб повільно відновити здоров'я.
    .a18 = Потребуєте більше торбин чи кращу броню? Натисніть '{ $gameinput-crafting }' щоб відкрити ремісниче меню!
    .a19 = Натисніть '{ $gameinput-roll }' щоб зробити перекат. Перекати можуть використовуватися для швидшого переміщення та ухиляння від атак.
    .a20 = Цікавитесь для чого цей предмет? Введіть 'input:<item name>' в полі пошуку ремісничого меню щоб переглянити список рецептів, в яких він використовується.
    .a21 = Знайшли щось файне? Зробіть знімок екрану, натиснувши '{ $gameinput-screenshot }'.
main-singleplayer-day_length = Тривалість дня
main-server-rules = Цей сервер має правила, які необхідно прийняти.
main-server-rules-seen-before = Ці правила змінилися з часу, коли ви востаннє приймали їх.
