# Imagem base do Node.js
FROM node:18

# Diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência
COPY package*.json ./

# Instala as dependências
RUN npm install

# Copia o restante da aplicação
COPY . .

# Expõe a porta que o app escuta
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
