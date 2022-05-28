# Jack bot

Telegram bot for search alcohol drink and cocktail.

---

### Technical stack:

* ruby: 3.0.0
* hosting: heroku
* database: postgres

---

### How i can start this bot on local machine?

1. Run bundler:


        bundle

2. Add your env:


        cp .env.example .env


3. Run rake task:


        rake db:create
        rake db:migrate


4. Run bot:


        bin/bot


---

### example .env variable:
    
    DATABASE_URL=postgres://postgres:postgres@localhost:5432/jack_bot
    POSTGRESQL=postgres://postgres:postgres@localhost:5432
    DATABASE_NAME=jack_bot
    
    TELEGRAM_TOKEN=00000000:sasasasasasasasasasasasasasa-V_EG
    COCKTAILS_KEY=1