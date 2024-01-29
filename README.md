# iOS разработчик с нуля. Дипломный проект

Дипломный проект - приложение для iOS, имитирующее социальную сеть. 

![IMG_0026](https://github.com/lyapinmichael/ios-homeworks/assets/122309376/22c0c1d1-3e2e-444c-9df5-473de8367e65) ![IMG_0028](https://github.com/lyapinmichael/ios-homeworks/assets/122309376/5e5effdf-0c6a-4755-899f-af7b10ce8721) 

![IMG_0038](https://github.com/lyapinmichael/ios-homeworks/assets/122309376/9f1554dc-2bef-4c9e-b68e-a71a793a5c25) ![IMG_0034](https://github.com/lyapinmichael/ios-homeworks/assets/122309376/a1c775df-25a5-4031-87c3-05af002a0258)

![IMG_0030](https://github.com/lyapinmichael/ios-homeworks/assets/122309376/7ffb4421-329c-44c4-a810-50c0de55134b) ![IMG_0036](https://github.com/lyapinmichael/ios-homeworks/assets/122309376/5e60c5a0-4d94-4d43-a562-af12cdaa7ada)

## Ключевые функции приложения: 
- Регистрация и вход по email с использованием `Firebase`
- Публикация и просмотр в ленте постов, к которым также может быть приложена фотография (с использованием `Firestore`, `CloudStorage`)
- Публикация, изменение и удаление фото профиля (с использованием `Firestore`, `CloudStorage`)
- Изменение имения пользователя (c использованием `Firebase`, `Firestore`)
- Сохранение понравившихся постов в памяти устройства (с использованием `CoreData`, `FileManager`)
- Полная локализация всех строк в проекте
- Поддержка светлой и темной темы

## Архитектурное решение: 

- Интерфейс приложения основан на *модульной* `MVVM` архитектуре с ипользованием координаторов. 
- В общей структуре проект основан на принципах `Clean Code` и `Service Oriented Architecture`.
- Разработка следовала принципам SOLID, DRY

##### Использованные структурные паттерны: 
 - `Delegate`
 - `Observer`
 - `Factory`
 - `Coordinator`

## Чем я горжусь: 

-  Релизацией флоу регистрации и входа.
- `DimmingViewController` - кастомный сабкласс, который используется для показа полупрозрачного `ViewController`, закрывающего весь экран, включая `tabBar` и `navBar`.
- `ActionsPopoverController` - кастомный сабкласс для отображения действий, переданных массивом, в виде таблицы.
- `Observable` - кастомное решение для отслеживания изменения объекта. 
- `Repository` - единое место для хранения данных, используемых несколькими `ViewModel`. 
  
## Использованные технологии: 

##### Firebase: 
- `Authentication`
- `Firestore`
- `Cloud Storage`

##### UI:
- `UIKit` / `Autolayout`
- `CoreAnimation`

##### Multithreading:
- `GCD`

##### Cache and persistance: 
- `NSCache`
- `CoreData`
- `FileManager` 

##### Dependencies: 
- `Swift Package Manager`
- `CocoaPods`

##### Other third-party:
- `IQKeyboardManager`
- `ESPullToRefresh`
