# Jack bot (boilerplate for [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby))

Telegram bot for searching for alcoholic drinks and cocktails. Example with convenient scaling and ability to connect to postgresql database via ActiveRecord library in the future it is planned to change the default ORM to a faster one. 

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
    COCKTAILS_VERSION=v1

---
## How to use

It all starts with bin/bot. Client from the telegram-bot-ruby library, it starts listening to messages, all messages that come into our application. This is a very important point because, as you can see in the example, there are 3 main types of messages.

```ruby
bot.listen do |message|
  if message.instance_of?(Telegram::Bot::Types::CallbackQuery)
    Controllers::CallbackController.new(bot: bot, message: message).perform
    logger.debug "@#{message.from.username}: #{message.data}"
  
  elsif message.instance_of?(Telegram::Bot::Types::ChatMemberUpdated)
    Controllers::MemberController.new(bot: bot, message: message).perform
    logger.debug "@#{message.from.username}: subscribe/unsubscribe"

  else
    Controllers::MessageController.new(bot: bot, message: message).perform
    logger.debug "@#{message.from.username}: #{message.text}"
  end
end
```
---
### Controllers
The main difference between the **сallback_controller** and the **message_controller** is that in regular messages we receive 'text' in the body of the message - this is what we get when the user enters some text, and callback messages give us 'data' - since sending is not via chat.

We also have messages with type **ChatMemberUpdated** - this is a special type of message in which it can occur only 2 times from 1 user, this is when he presses / start and if he wants to unsubscribe from the bot and delete it, we will catch messages with type **ChatMemberUpdated**.

```ruby
class MessageController < Controllers::BaseController
  attr_accessor :check_authenticate

  def initialize(message:, bot:)
    super
    @check_authenticate = Services::Authenticate.new(bot: @bot, message: @message)
  end

  def perform
    if @check_authenticate.perform(operation: @message.text.split.first.tr('/', ''))
      update_user
      commands_request
    else
      @check_authenticate.answer
    end
  end

  private

  def commands_request
    case @message.text.split.first.tr('/', '')
    when 'start'
      Operations::Start.new(bot: @bot, message: @message).perform
    when 'stop'
      Operations::Stop.new(bot: @bot, message: @message).perform
    when 'random'
      Operations::Random.new(bot: @bot, message: @message).perform
    when 'search'
      Operations::Search.new(bot: @bot, message: @message).perform
    when 'help'
      Operations::Help.new(bot: @bot, message: @message).perform
    when 'support'
      Operations::Support.new(bot: @bot, message: @message).perform
    else
      @bot.api.send_message(
        chat_id: @message.from.id,
        text: 'Sorry, I dont understand what you mean...'
      )
    end
  end
end
```

There is 1 main method in our controller, it is perform and it is designed for certain validations at controller level or a kind of before action as in rails, depending on the command that the user enters or what data came from the callback, the bot will perform the operation.

---
### Operations

The contain operations are responsible for the bot's behavior and give a response depending on the command, for example, we received the message /random, the controller will detect the command and run the Random operation.

```ruby
class Random < Operations::BaseOperation
  def perform
    answer = send_request
    return success(answer: JSON.parse(answer.body)['drinks'].first) if answer.success?

    error(errors: JSON.parse(answer.body)['errors'].first)
  end

  private

  def success(answer:)
    @bot.api.sendPhoto(
      chat_id: @message.from.id,
      photo: answer['strDrinkThumb']
    )
    @bot.api.send_message(
      chat_id: @message.from.id,
      text: Services::TextHandlerCocktail.new.text_for_message(answer: answer),
      reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: Telegram::Bot::Types::InlineKeyboardButton.new(
          text: 'Give me random cocktail',
          callback_data: 'random'
        )
      )
    )
  end

  def send_request
    Faraday.get(
      "https://www.thecocktaildb.com/api/json/#{ENV.fetch('COCKTAILS_VERSION',
                                                          nil)}/#{ENV.fetch('COCKTAILS_KEY', nil)}/random.php"
    )
  end
end
```

Send a request to API if it is successful, return success or error (defined in base_operations).
