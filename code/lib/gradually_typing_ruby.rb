class EmailContact
  attr_accessor :name, :email, :message

  def intialize(name:, email:, message:)
    name = name
    email = email
    message = message
  end

  def deliver
    # imagine
  end
end

# EmailContact.new(name: 'Bob', email: 'bob@bob.bob', messsage: 'Bobobobobob')
