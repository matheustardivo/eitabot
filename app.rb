require 'sinatra'
require 'httparty'
require 'json'

post '/gateway' do
  puts params
  # {"token"=>"zvt90fQUPTn0aNYuv9IE4HXE", "team_id"=>"T0FTQEWPR", "team_domain"=>"reflectiveti", "service_id"=>"15936832052", "channel_id"=>"C0FTQEWQP", "channel_name"=>"general", "timestamp"=>"1449236778.000006", "user_id"=>"U0FTR0A5N", "user_name"=>"matheustardivo", "text"=>"eitabot: issues _ twbs/bootstrap", "trigger_word"=>"eitabot"}
  message = params[:text].gsub(params[:trigger_word], '').strip

  puts message

  action, repo = message.split('_').map { |c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"

  puts "Action: #{action}; repo_url: #{repo_url}"

  case action
  when 'issues'
    resp = HTTParty.get repo_url
    resp = JSON.parse resp.body
    puts "Repo response: #{resp}"

    respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"

  else
    puts "Invalid action: #{action}"
  end
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end
