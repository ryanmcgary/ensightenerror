# require 'rubygems'
require 'eventmachine-le'
require 'evma_httpserver'

class Handler  < EventMachine::Connection
  include EM::HttpServer
  include EM::Deferrable

  def process_http_request
    resp = EM::DelegatedHttpResponse.new( self )
    resp.status = 204
    resp.send_response
   
    
    EM.add_timer(1) do
      puts @http_query_string    
    end
      
  end

end

EM.epoll
EM.run{
  host, port = "0.0.0.0", ENV['PORT']
  puts "Starting on #{host}:#{port}..."
  EventMachine::start_server(host, port, Handler)
}

