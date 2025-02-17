require 'rails_helper'

RSpec.describe 'recipe show page' do
  before :each do
    @ingredient1 = Ingredient.create!(name: 'Oreos', cost: 2)
    @ingredient2 = Ingredient.create!(name: 'Reeses', cost: 1)
    @ingredient3 = Ingredient.create!(name: 'Vanilla Ice Cream', cost: 4)
    @recipe1 = Recipe.create!(name: 'Halloween Bucket', complexity: 1, genre: 'Halloween')
    @recipe2 = Recipe.create!(name: 'Ice Cream Sundae', complexity: 2, genre: 'Dessert')
    RecipeIngredient.create!(recipe_id: @recipe1.id, ingredient_id: @ingredient1.id)
    RecipeIngredient.create!(recipe_id: @recipe1.id, ingredient_id: @ingredient2.id)
    RecipeIngredient.create!(recipe_id: @recipe2.id, ingredient_id: @ingredient1.id)
    RecipeIngredient.create!(recipe_id: @recipe2.id, ingredient_id: @ingredient2.id)
    RecipeIngredient.create!(recipe_id: @recipe2.id, ingredient_id: @ingredient3.id)
  end

  describe '/recipes/:id' do
    it 'sees the recipes attributes' do
      visit "/recipes/#{@recipe1.id}"

      expect(current_path).to eq("/recipes/#{@recipe1.id}")
      expect(page).to have_content(@recipe1.name)
      expect(page).to have_content(@recipe1.complexity)
      expect(page).to have_content(@recipe1.genre)
    end

    it 'sees a list of all names for ingredients for recipe' do
      visit "/recipes/#{@recipe1.id}"

      expect(page).to have_content(@ingredient1.name)
      expect(page).to have_content(@ingredient2.name)
    end

    it 'sees the total cost of all ingredients in recipe' do
      visit "/recipes/#{@recipe1.id}"

      expect(page).to have_content('Cost of Ingredients: $3')
    end

    it 'sees a form to add an ingredient to recipe' do
      visit "/recipes/#{@recipe1.id}"

      expect(page).to have_selector(:css, 'form')
      expect(find('form')).to have_content('Ingredient id:')
      expect(page).to have_button('Add Ingredient')
    end

    it 'fills in form with existing ingredient ID and when I hit submit, it takes me back to show page with ingredient listed' do
      visit "/recipes/#{@recipe1.id}"
      expect(page).to_not have_content(@ingredient3.name)

      fill_in('ingredient_id', with: @ingredient3.id.to_s)
      click_button('Add Ingredient')

      expect(current_path).to eq("/recipes/#{@recipe1.id}")
      expect(page).to have_content(@ingredient1.name)
      expect(page).to have_content(@ingredient2.name)
      expect(page).to have_content(@ingredient3.name)
      expect(page).to have_content('Cost of Ingredients: $7')
    end
  end
end
