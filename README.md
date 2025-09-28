 Описание
 
 BookCatalog Web API (Delphi + IIS + MS SQL Server)
 
Веб-приложение на Delphi, предоставляющее REST API для получения списка книг из MS SQL Server через IIS.

## Стек технологий
- Delphi (RAD Studio 10.2+)
- ISAPI (для интеграции с IIS)
- FireDAC (подключение к БД)
- MS SQL Server Express

## Установка

### 1. База данных
1. Устанавливаем MS SQL Server Express.
2. Включаем учётную запись sa и установливаем пароль.
3. Выполняем скрипт book_catalog.sql (будет создана БД BookCatalog).

### 2. Сборка проекта
1. Открываем BookAPI.dpr в Delphi.
2. Выбираем платформу Win32.
3. Собераеем проект > получаем BookAPI.dll.

### 3. Настройка IIS
1. Копируем BookAPI.dll в папку: C:\inetpub\wwwroot\books\
2. В IIS Manager:
   - Добавляем приложение с именем books
   - В ISAPI and CGI Restrictions разрешите BookAPI.dll
   - Для пула приложений установливаем: Enable 32-Bit Applications = True
3. Выполняем в командной строке от администратора:  
   ```cmd
   iisreset
