require 'goliath'
require 'em-synchrony/em-http'
require 'em-http/middleware/json_response'
require 'yajl'

class Hello < Goliath::API
  def response(env)
    [204, {}, "Hello World"]
  end
end