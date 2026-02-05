const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({ message: "Hello from the DevOps Candidate!", status: "success" });
});

app.get('/health', (req, res) => {
  res.json({ status: "healthy", uptime: process.uptime() });
});

// Export app for testing, only listen if not in test mode
if (require.main === module) {
  app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
  });
}

module.exports = app;
