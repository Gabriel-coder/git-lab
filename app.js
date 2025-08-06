const express = require('express');
const app = express();
const port = 3000;

// Simula erro de sintaxe (faltando parêntese)
app.get('/', (req, res) => {
  res.send('Erro proposital para teste de rollback';

app.listen(port, () => {
  console.log(`App quebrado rodando na porta ${port}`);
});
