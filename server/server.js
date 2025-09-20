import express from "express";
import fetch from "node-fetch";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();
const app = express();
const PORT = 4000;

// Replace with your Discord app details
const DISCORD_CLIENT_ID = process.env.DISCORD_CLIENT_ID;
const DISCORD_CLIENT_SECRET = process.env.DISCORD_CLIENT_SECRET;
const DISCORD_REDIRECT = "http://localhost:4000/callback";
const DISCORD_GUILD_ID = process.env.DISCORD_GUILD_ID;
const REQUIRED_ROLE_ID = process.env.REQUIRED_ROLE_ID; // role allowed to spin
const JWT_SECRET = process.env.JWT_SECRET;

app.get("/login", (req, res) => {
  const url = `https://discord.com/api/oauth2/authorize?client_id=${DISCORD_CLIENT_ID}&redirect_uri=${encodeURIComponent(DISCORD_REDIRECT)}&response_type=code&scope=identify%20guilds%20guilds.members.read`;
  res.redirect(url);
});

app.get("/callback", async (req, res) => {
  const code = req.query.code;
  if (!code) return res.send("No code provided");

  // Exchange code for access token
  const tokenRes = await fetch("https://discord.com/api/oauth2/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      client_id: DISCORD_CLIENT_ID,
      client_secret: DISCORD_CLIENT_SECRET,
      grant_type: "authorization_code",
      code,
      redirect_uri: DISCORD_REDIRECT,
    }),
  });
  const tokenData = await tokenRes.json();

  // Fetch user guild membership
  const memberRes = await fetch(`https://discord.com/api/users/@me/guilds/${DISCORD_GUILD_ID}/member`, {
    headers: { Authorization: `Bearer ${tokenData.access_token}` },
  });
  const memberData = await memberRes.json();

  // Check if they have the required role
  if (memberData.roles && memberData.roles.includes(REQUIRED_ROLE_ID)) {
    const signedToken = jwt.sign({ id: memberData.user.id }, JWT_SECRET, { expiresIn: "1h" });
    res.send(`Success! Your spin token: ${signedToken}`);
  } else {
    res.send("You do not have the required role.");
  }
});

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

