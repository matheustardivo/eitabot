ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'

require ::File.expand_path('../../app',  __FILE__)

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  TRIGGER_WORD = '/eitabot'

  def app
    Sinatra::Application
  end

  def test_ok
    get '/'
    assert last_response.ok?
    assert_equal 'OK', last_response.body
  end

  def test_user
    post_and_assert_response '/eitabot user matheustardivo', 'https://github.com/matheustardivo'
  end

  def test_user_with_colon
    post_and_assert_response '/eitabot: user matheustardivo', 'https://github.com/matheustardivo'
  end

  def test_repo
    post_and_assert_response '/eitabot repo matheustardivo/eitabot', 'https://github.com/matheustardivo/eitabot'
  end

  def test_repo_with_colon
    post_and_assert_response '/eitabot: repo matheustardivo/eitabot', 'https://github.com/matheustardivo/eitabot'
  end

  def post_and_assert_response(text, expected)
    post '/gateway', text: text, trigger_word: TRIGGER_WORD
    assert last_response.ok?
    assert_equal expected, json_parse(last_response.body)['text']
  end

  def json_parse(text)
    JSON.parse(text)
  end
end
