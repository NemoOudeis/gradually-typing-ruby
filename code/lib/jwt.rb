require 'jwt'

payload = { data: 'test' }

token = JWT.encode payload, nil, 'none'

puts token

decoded_token = JWT.decode token, nil, false, 0xA6

puts decoded_token