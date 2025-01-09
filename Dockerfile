FROM node:20-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Обновляем репозитории и устанавливаем необходимые пакеты, включая Python, make, g++, py3-pip, bash, libc-dev и build-base для node-gyp
RUN apk update && \
    apk add --no-cache python3 make g++ py3-pip bash libc-dev build-base git libffi-dev libc6-compat bash wget

RUN wget https://unofficial-builds.nodejs.org/download/release/v20.18.1/node-v20.18.1-headers.tar.gz

## Создаем виртуальное окружение Python и активируем его
RUN python3 -m venv /env

## Устанавливаем pip и setuptools внутри виртуального окружения
RUN /env/bin/pip install --no-cache --upgrade pip setuptools

# Скопируем файлы package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости Node.js с увеличением таймаута для npm
RUN npm install -g node-gyp && node-gyp install

ENV NODE_TLS_REJECT_UNAUTHORIZED=0
RUN npm install --verbose

## Скопируем весь проект в контейнер
COPY . .

# Открываем порт, на котором будет работать приложение
EXPOSE 3000

# Запускаем приложение
CMD ["node", "bot_next.mjs"]
