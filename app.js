const http = require('http');

const PORT = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Deploy CI/CD funcionando via GitHub Actions + EC2 + Docker!\n');
});

server.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
