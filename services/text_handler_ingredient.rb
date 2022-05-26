# frozen_string_literal: true

module Services
  class TextHandlerIngredient
    def text_for_message(answer:)
      "Ingredient: #{answer['strIngredient']}\n\n" \
        "Description: #{answer['strDescription']}\n" \
    end
  end
end
