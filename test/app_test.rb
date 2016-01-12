ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require 'mocha/test_unit'

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
    stub_github_api_with 'github_user.json'
    post_and_assert_response '/eitabot user matheustardivo', 'https://github.com/matheustardivo'
  end

  def test_user_with_colon
    stub_github_api_with 'github_user.json'
    post_and_assert_response '/eitabot: user matheustardivo', 'https://github.com/matheustardivo'
  end

  def test_repo
    stub_github_api_with 'github_repo.json'
    post_and_assert_response '/eitabot repo matheustardivo/dotfiles', 'https://github.com/matheustardivo/dotfiles'
  end

  def test_repo_with_colon
    stub_github_api_with 'github_repo.json'
    post_and_assert_response '/eitabot: repo matheustardivo/dotfiles', 'https://github.com/matheustardivo/dotfiles'
  end

  def test_issues
    stub_github_api_with 'github_repo.json'
    post_and_assert_response '/eitabot issues matheustardivo/dotfiles', 'There are 0 open issues on matheustardivo/dotfiles'
  end

  def test_issues_with_colon
    stub_github_api_with 'github_repo.json'
    post_and_assert_response '/eitabot: issues matheustardivo/dotfiles', 'There are 0 open issues on matheustardivo/dotfiles'
  end

  def post_and_assert_response(text, expected)
    post '/gateway', text: text, trigger_word: '/eitabot'
    assert last_response.ok?
    assert_equal expected, JSON.parse(last_response.body)['text']
  end

  def fixtures
    @fixtures ||= Pathname.new(File.dirname(__FILE__) + "/fixtures")
  end

  def read_fixture(filename)
    fixtures.join(filename).read
  end

  def json_fixture(filename)
    JSON.parse read_fixture(filename)
  end

  def stub_github_api_with(fixture_name)
    Github.any_instance.stubs(:json_parse).returns json_fixture(fixture_name)
  end
end
