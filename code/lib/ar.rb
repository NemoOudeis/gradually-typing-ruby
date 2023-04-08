class Pet < ActiveRecord::Base
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
#  type   :string
#