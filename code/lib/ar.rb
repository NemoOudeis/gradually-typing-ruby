class Pet < ActiveRecord::Base
  validates :name, presence: true
  validates :species,
            inclusion: {
              in: %w[cat fish],
              message: "species must be 'cat' or 'fish' if it is my favorite pet"
            },
            if: proc { |it|
              # @type var it: untyped
              it.my_favorite_pet?
            }

  def my_favorite_pet?
    name == 'calcifer'
  end
end

Pet.new(name: 'calcifer', species: 'dog').save!

# == Schema Information
#
# Table name: Pet
#
#  id     :integer          not null, primary key
#  name   :string
#  species   :string
#
