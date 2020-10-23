В данном проекте реализован пример математической игры.

Здесь использован UIKit, а не SpriteKit - просмотр таблиц, изображений и так далее. (в отличии от большинства игр на iOS)

Использован фреймворк Create ML от Apple, чтобы построить модель машинного обучения для распознавания рукописного ввода от игрока.

Суть игры заключается в следующем: пользователям будет показана серия основных арифметических вопросов - 3 + 6, например, и предложение решить их, написав цифры прямо на экране.

Чтобы реализовать данную задачу, необходимо выполнить несколько шагов: обучить Core ML модель с помощью Create ML, спроектировать пользовательский интерфейс, чтобы модель распознавала почерк пользователя, а затем подключиться к остальной части игры.