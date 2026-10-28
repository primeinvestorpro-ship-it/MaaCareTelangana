const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 10000;

app.use(cors());
app.use(express.json({ limit: '25mb' }));

// Health Check for Render
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'MaaCare Telangana',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    geminiConfigured: Boolean(process.env.GEMINI_API_KEY),
  });
});

// Gemini AI Proxy Endpoint (keeps API key secure on server)
app.post('/api/gemini/generate', async (req, res) => {
  const apiKey = process.env.GEMINI_API_KEY || req.headers['x-gemini-key'];
  if (!apiKey) {
    return res.status(400).json({
      error: 'GEMINI_API_KEY not configured on server or in request headers.',
    });
  }

  const model = req.body.model || 'gemini-1.5-flash';
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

  try {
    const fetch = (await import('node-fetch')).default;
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(req.body.payload),
    });

    const data = await response.json();
    res.status(response.status).json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Serve Flutter Web Build
const staticPath = path.join(__dirname, 'build', 'web');
app.use(express.static(staticPath));

// SPA Fallback: Any unknown route serves index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(staticPath, 'index.html'), (err) => {
    if (err) {
      res.status(200).send(`
        <!DOCTYPE html>
        <html>
        <head><title>MaaCare Telangana Server</title></head>
        <body style="font-family:sans-serif;text-align:center;padding:50px;">
          <h2>🌸 MaaCare Telangana Web API Service</h2>
          <p>Service is live and ready for Render.com.</p>
          <p>To view Flutter web app, run <code>flutter build web --release</code> or deploy via Dockerfile.</p>
          <p><a href="/api/health">Check API Health Status</a></p>
        </body>
        </html>
      `);
    }
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🌸 MaaCare Telangana server listening on port ${PORT}`);
});
