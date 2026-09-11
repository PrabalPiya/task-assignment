const http = require("node:http");
const { Pool } = require("pg");

const database = new Pool({
  host: "db",
  database: process.env.POSTGRES_DB,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  connectionTimeoutMillis: 5000,
});

database.on("error", (error) => {
  console.error("Database connection error:", error.message);
});

const server = http.createServer(async (request, response) => {
  if (request.method !== "GET" || request.url !== "/") {
    response.writeHead(404);
    response.end("Not found");
    return;
  }

  try {
    await database.query(`
      CREATE TABLE IF NOT EXISTS visits (
        id SERIAL PRIMARY KEY
      )
    `);

    await database.query("INSERT INTO visits DEFAULT VALUES");

    const result = await database.query("SELECT COUNT(*) FROM visits");
    const visits = result.rows[0].count;

    response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    response.end(`
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <title>DevOps Assignment</title>
        </head>
        <body>
          <h1>My DevOps Assignment</h1>
          <p>Node.js application is running.</p>
          <p>Database connection: successful</p>
          <p>Total page visits: ${visits}</p>
        </body>
      </html>
    `);
  } catch (error) {
    console.error("Database request failed:", error.message);
    response.writeHead(503, { "Content-Type": "text/plain" });
    response.end("Database unavailable. Please try again later.");
  }
});

server.listen(5000, "0.0.0.0", () => {
  console.log("Application listening on port 5000");
});

