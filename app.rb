
require 'goliath'
require 'em-synchrony/em-http'
require 'em-http/middleware/json_response'
require 'yajl'


# class Hello < Goliath::API
#   include Goliath::Rack::Templates      # render templated files from ./views

#   use(Rack::Static,                     # render static files from ./public
#       :root => Goliath::Application.app_path("public"),
#       :urls => ["/favicon.ico", '/stylesheets', '/javascripts', '/images', '/index.html'])




#   def response(env)
#     gh = EM::HttpRequest.new("http://cnn.com").get
#     logger.info "Received #{gh.response_header.status} from Github"


#     logger.info("contacted #{env['REQUEST_URI']}")
#     [204, {}, "Hello World"]
#   end
# end

connections = Array.new

def parse_sse(env)
  EM.add_periodic_timer(1) { env.stream_send("data:hello ##{rand(100)}\n\n") }
  EM.add_periodic_timer(3) do
    env.stream_send(["event:signup", "data:signup event ##{rand(100)}\n\n"].join("\n"))
  end
  streaming_response(200, {'Content-Type' => 'text/event-stream'})
end

class SSE < Goliath::API
  use Rack::Static, :urls => ["/index.html"], :root => Goliath::Application.app_path("public")



  def response(env)
    case env['PATH_INFO']
      when '/events' then 
        connections["a"] = [] << env

        parse_sse(connections["a"])
    else
      logger.info("not /events")
      [200, {}, "Hello World"]
    end  
  end


  
end