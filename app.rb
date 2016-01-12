require 'httparty'
require 'json'
require 'logger'
require 'sinatra'

require ::File.expand_path('../models/github',  __FILE__)

logger = Logger.new(STDOUT)

configure do
  use Rack::CommonLogger, logger
end

get '/' do
  content_type :text
  'OK'
end

# Retrieve GitHub info from API
# Sample commands:
# * /eitabot user matheustardivo
# * /eitabot repo matheustardivo/dotfiles
# * /eitabot issues matheustardivo/dotfiles
# {"token"=>"zvt90fQUPTn0aNYuv9IE4HXE", "team_id"=>"T0FTQEWPR", "team_domain"=>"reflectiveti", "service_id"=>"15936832052", "channel_id"=>"C0FTQEWQP", "channel_name"=>"general", "timestamp"=>"1449236778.000006", "user_id"=>"U0FTR0A5N", "user_name"=>"matheustardivo", "text"=>"eitabot: issues _ twbs/bootstrap", "trigger_word"=>"eitabot"}
post '/gateway' do
  logger.info "Gateway params: #{params}"

  message = params[:text].gsub(/#{params[:trigger_word]}:*/, '').strip

  action, text = message.split(' ').map { |c| c.strip.downcase }

  logger.info "Gateway action: #{action}; text: #{text}"

  respond_message Github.new.send(action, text)
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end
