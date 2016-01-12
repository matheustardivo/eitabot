ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'

require ::File.expand_path('../../app',  __FILE__)

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

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
    post_and_assert_response '/eitabot repo matheustardivo/dotfiles', 'https://github.com/matheustardivo/dotfiles'
  end

  def test_repo_with_colon
    post_and_assert_response '/eitabot: repo matheustardivo/dotfiles', 'https://github.com/matheustardivo/dotfiles'
  end

  def test_issues
    post_and_assert_response '/eitabot issues matheustardivo/dotfiles', 'There are 0 open issues on matheustardivo/dotfiles'
  end

  def test_issues_with_colon
    post_and_assert_response '/eitabot: issues matheustardivo/dotfiles', 'There are 0 open issues on matheustardivo/dotfiles'
  end

  def post_and_assert_response(text, expected)
    post '/gateway', text: text, trigger_word: '/eitabot'
    assert last_response.ok?
    assert_equal expected, JSON.parse(last_response.body)['text']
  end
end
