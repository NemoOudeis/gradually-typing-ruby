require 'jwt'

payload = { data: 'test' }

token = JWT.encode payload, nil, 'none'

puts token

decoded_token = JWT.decode token, nil, false

puts decoded_token