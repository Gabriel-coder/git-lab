// app.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('App atualizado para testes de CI e CD separados!');
});

app.listen(3000, () => {
  console.log('Servidor rodando na porta 3000');
});
