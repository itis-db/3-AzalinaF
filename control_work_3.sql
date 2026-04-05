DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS lessons CASCADE;
DROP TABLE IF EXISTS courses CASCADE;

CREATE TABLE authors (
                         author_id SERIAL primary key,
                         full_name varchar(150) not null,
                         email varchar(150) not null unique
);
create table courses (
                         course_id serial primary key,
                         author_id int not null,
                         title varchar(200) not null,
                         category varchar(100) not null,
                         level varchar(50) not null,
                         constraint fk_courses_author
                             foreign key (author_id) references authors(author_id)
);
create table lessons (
                         lesson_id serial primary key,
                         course_id int not null,
                         title varchar(200) not null,
                         description text not null,
                         position_num int not null,
                         constraint fk_lessons_courses
                             foreign key(course_id) references courses(course_id)

);
--создаем индексы
CREATE INDEX idx_courses_author_id ON courses(author_id);
CREATE INDEX idx_lessons_course_id ON lessons(course_id);
CREATE INDEX idx_lessons_position_num ON lessons(position_num);
CREATE INDEX idx_courses_category ON courses(category);
CREATE INDEX idx_courses_level ON courses(level);

--расширение для триграм
create extension if not exists pg_trgm;

-- базовые авторы
INSERT INTO authors (full_name, email) VALUES
                                           ('Иван Петров', 'ivan.petrov@example.com'),
                                           ('Мария Смирнова', 'maria.smirnova@example.com'),
                                           ('Алексей Волков', 'alexey.volkov@example.com'),
                                           ('Елена Кузнецова', 'elena.kuznetsova@example.com');

-- много авторов
INSERT INTO authors (full_name, email)
SELECT
    'Автор ' || i,
    'author' || i || '@example.com'
FROM generate_series(5, 500) AS i;

-- базовые курсы
INSERT INTO courses (author_id, title, category, level) VALUES
                                                            (1, 'Основы PostgreSQL', 'Базы данных', 'Начальный'),
                                                            (1, 'Продвинутый SQL', 'Базы данных', 'Средний'),
                                                            (2, 'Java для начинающих', 'Программирование', 'Начальный'),
                                                            (2, 'Spring Boot практика', 'Программирование', 'Средний'),
                                                            (3, 'Анализ данных на Python', 'Аналитика', 'Средний'),
                                                            (4, 'Проектирование API', 'Backend', 'Средний');

-- много курсов
INSERT INTO courses (author_id, title, category, level)
SELECT
    (1 + floor(random() * 500))::int,
    CASE
        WHEN i % 6 = 0 THEN 'Курс по PostgreSQL ' || i
        WHEN i % 6 = 1 THEN 'Курс по SQL ' || i
        WHEN i % 6 = 2 THEN 'Курс по Java ' || i
        WHEN i % 6 = 3 THEN 'Курс по Spring ' || i
        WHEN i % 6 = 4 THEN 'Курс по Python ' || i
        ELSE 'Курс по API ' || i
        END,
    CASE
        WHEN i % 4 = 0 THEN 'Базы данных'
        WHEN i % 4 = 1 THEN 'Программирование'
        WHEN i % 4 = 2 THEN 'Аналитика'
        ELSE 'Backend'
        END,
    CASE
        WHEN i % 3 = 0 THEN 'Начальный'
        WHEN i % 3 = 1 THEN 'Средний'
        ELSE 'Продвинутый'
        END
FROM generate_series(7, 3000) AS i;

-- базовые уроки
INSERT INTO lessons (course_id, title, description, position_num) VALUES
                                                                      (1, 'Введение в PostgreSQL', 'Изучаем установку PostgreSQL, создание базы данных и базовые SQL-команды.', 1),
                                                                      (1, 'Создание таблиц', 'Разбираем типы данных, первичные ключи, внешние ключи и ограничения.', 2),
                                                                      (1, 'Индексы в PostgreSQL', 'Изучаем B-Tree, GIN, GiST и влияние индексов на производительность запросов.', 3),
                                                                      (2, 'Сложные SELECT-запросы', 'Работаем с JOIN, GROUP BY, HAVING, подзапросами и оконными функциями.', 1),
                                                                      (2, 'Оптимизация SQL', 'Разбираем EXPLAIN ANALYZE, планы выполнения и ускорение медленных запросов.', 2),
                                                                      (2, 'Полнотекстовый поиск', 'Настраиваем полнотекстовый поиск по русскому языку и сортировку по релевантности.', 3),
                                                                      (3, 'Переменные и типы данных в Java', 'Рассматриваем переменные, примитивные типы, строки и базовые операции.', 1),
                                                                      (3, 'Условия и циклы', 'Изучаем if, switch, for, while и решение простых задач.', 2),
                                                                      (3, 'Методы и классы', 'Разбираем создание методов, классов и объектов в Java.', 3),
                                                                      (4, 'Создание REST API на Spring Boot', 'Учимся создавать контроллеры, сервисы и репозитории в приложении.', 1),
                                                                      (4, 'Работа с базой данных через JPA', 'Изучаем сущности, связи между таблицами и репозитории Spring Data.', 2),
                                                                      (4, 'Безопасность приложения', 'Настраиваем Spring Security, роли пользователей и аутентификацию.', 3),
                                                                      (5, 'Введение в анализ данных', 'Знакомимся с pandas, таблицами данных и первичной обработкой информации.', 1),
                                                                      (5, 'Очистка данных', 'Учимся находить пропуски, дубликаты и аномальные значения.', 2),
                                                                      (5, 'Визуализация данных', 'Создаем графики и диаграммы для анализа результатов.', 3),
                                                                      (6, 'Что такое API', 'Разбираем назначение API, методы HTTP и структуру запросов.', 1),
                                                                      (6, 'Проектирование маршрутов', 'Учимся правильно проектировать URL, ресурсы и CRUD-операции.', 2),
                                                                      (6, 'Документирование API', 'Создаем документацию Swagger OpenAPI для backend-приложения.', 3),
                                                                      (6, 'Swagger OpenAPI спецификация', 'Редкий тестовый урок про swagger openapi и документирование backend API.', 1001),
                                                                      (6, 'Морфология и релевантность', 'Редкий урок про морфологию русского языка, релевантность и ранжирование результатов.', 1002),
                                                                      (4, 'Spring аутентификация JWT', 'Редкий урок про аутентификацию spring security jwt token.', 1003);

-- много уроков
INSERT INTO lessons (course_id, title, description, position_num)
SELECT
    (1 + floor(random() * 3000))::int,
    CASE
        WHEN i % 20 = 0 THEN 'Индексы и поиск ' || i
        WHEN i % 20 = 1 THEN 'Полнотекстовый поиск PostgreSQL ' || i
        WHEN i % 20 = 2 THEN 'GIN индекс в базе данных ' || i
        WHEN i % 20 = 3 THEN 'Оптимизация SQL запросов ' || i
        WHEN i % 20 = 4 THEN 'Триграммный индекс pg_trgm ' || i
        WHEN i % 20 = 5 THEN 'Работа с индексами ' || i
        WHEN i % 20 = 6 THEN 'Планы выполнения EXPLAIN ' || i
        WHEN i % 20 = 7 THEN 'Поиск по тексту ' || i
        WHEN i % 20 = 8 THEN 'Индексирование строк ' || i
        WHEN i % 20 = 9 THEN 'Безопасность приложения ' || i
        ELSE 'Урок №' || i
        END,
    CASE
        WHEN i % 20 = 0 THEN 'В этом уроке подробно разбираются индексы, полнотекстовый поиск, релевантность и ускорение поиска по тексту.'
        WHEN i % 20 = 1 THEN 'Изучаем поиск по словам, русский словарь, морфологию русского языка и сортировку результатов по релевантности.'
        WHEN i % 20 = 2 THEN 'Рассматриваем GIN индекс, создание индексов, оптимизацию запросов и ускорение поиска по таблице.'
        WHEN i % 20 = 3 THEN 'Разбираем EXPLAIN ANALYZE, планы выполнения, индексы и анализ производительности SQL запросов.'
        WHEN i % 20 = 4 THEN 'Изучаем pg_trgm, similarity, поиск по части слова, например по фрагменту индек или поис.'
        WHEN i % 20 = 5 THEN 'Показываем как работают индексы B-Tree, GIN и GiST в PostgreSQL.'
        WHEN i % 20 = 6 THEN 'Учимся анализировать план выполнения запросов и понимать, когда используется индекс.'
        WHEN i % 20 = 7 THEN 'Здесь есть слова поиск, поисковый, индексы, индексирование и оптимизация.'
        WHEN i % 20 = 8 THEN 'Материал содержит примеры частичного совпадения, триграмм и полнотекстового поиска.'
        WHEN i % 20 = 9 THEN 'Тема урока посвящена безопасности приложения, авторизации и защите API.'
        ELSE 'Обычное описание урока по образовательной платформе. Здесь рассматриваются разные темы: базы данных, программирование, backend и аналитика.'
        END,
    (1 + floor(random() * 30))::int
FROM generate_series(19, 50000) AS i;

-- обновляем статистику
ANALYZE authors;
ANALYZE courses;
ANALYZE lessons;


SELECT * FROM authors;
SELECT * FROM courses;
SELECT * FROM lessons ORDER BY lesson_id;

DROP INDEX IF EXISTS idx_lessons_fts;

--полнотекстовый запрос по двум полям
create index idx_lessons_fts on lessons
    using GIN(
    to_tsvector(
    'russian', coalesce(title, '') || '' || coalesce(description, '')
    )
    );

--триграммные индексы для частичного поиска
create index idx_lessons_title_trgm
    on lessons
    using GIN(title gin_trgm_ops);

create index idx_lessons_description_trgm
    on lessons
    using GIN(description gin_trgm_ops);
--Полнотекстовый поиск по двум полям
select
    lesson_id,
    title,
    description,
    ts_rank(
            to_tsvector('russian', coalesce(title, '') || '' || coalesce(description, '')),
            plainto_tsquery('russian', 'поиск индексы')
    ) AS rank
from lessons
where to_tsvector('russian', coalesce(title, '') || '' || coalesce(description, ''))
                  @@ plainto_tsquery('russian', 'поиск индексы')
ORDER BY rank DESC;
--еще один запрос
select
    lesson_id,
    title,
    description,
    ts_rank(
            to_tsvector('russian', coalesce(title, '') || '' || coalesce(description, '')),
            plainto_tsquery('russian', 'безопасность приложения')
    ) as rank
FROM lessons
WHERE to_tsvector('russian', coalesce(title, '') || '' || coalesce(description, ''))
                  @@ plainto_tsquery('russian', 'безопасность приложение')
ORDER BY rank DESC;

--пример по частичному совпадению
select
    lesson_id,
    title,
    description,
    similarity(title, 'индек') as sim_title,
    similarity(description, 'индек') as sim_desc
from lessons
where title % 'индек' or description % 'индек'
order by GREATEST(similarity(title, 'индек'), similarity(description, 'индек')) DESC;

SELECT
    lesson_id,
    title,
    description,
    similarity(title, 'поиск') AS sim_title,
    similarity(description, 'поиск') AS sim_description
FROM lessons
WHERE title % 'поиск'
   OR description % 'поиск'
ORDER BY GREATEST(similarity(title, 'поиск'), similarity(description, 'поиск')) DESC;

--EXPLAIN ANALYZE для полнотекстового поиска
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    lesson_id,
    title,
    description,
    ts_rank(
            to_tsvector('russian', coalesce(title, '') || '' || coalesce(description, '')),
            plainto_tsquery('russian', 'swagger openapi')
    ) AS rank
FROM lessons
WHERE to_tsvector('russian', coalesce(title, '') || '' || coalesce(description, ''))
                  @@ plainto_tsquery('russian', 'swagger openapi')
ORDER BY rank DESC;

-- EXPLAIN ANALYZE для триграммного поиска
EXPLAIN (ANALYZE, BUFFERS)
SELECT lesson_id, title, description
FROM lessons
WHERE title ILIKE '%swagger%'
   OR description ILIKE '%swagger%';




