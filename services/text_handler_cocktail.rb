# frozen_string_literal: true

module Services
  class TextHandlerCocktail
    def text_for_message(answer:)
      ingredients = count_ingredients(
        ingredients: preparation_data(collection: answer, search: 'strIngredient'),
        measures: preparation_data(collection: answer, search: 'strMeasure')
      )
      text = "Drink: #{answer['strDrink']}\n" \
             "**#{answer['strAlcoholic']}**\n" \
             "Glass: #{answer['strGlass']}\n\n"
      ingredients.each do |ingredient|
        text += "#{ingredient.join(' ')}\n"
      end
      text += "\nInstruction: #{answer['strInstructions']}\n"
    end

    private

    def preparation_data(collection:, search:)
      hash = {}
      collection.each do |key, value|
        hash[key] = value if key.include?(search) && !value.nil?
      end
      hash
    end

    def count_ingredients(ingredients:, measures:)
      ingredients = ingredients.values
      measures = measures.values
      hash = {}
      ingredients.each_with_index do |object, index|
        hash[object] = measures[index]
      end
      hash
    end
  end
end
