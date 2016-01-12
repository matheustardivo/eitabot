class Github
  include HTTParty
  base_uri 'https://api.github.com'

  def issues(repository)
    json = json_parse self.class.get("/repos/#{repository}")

    "There are #{json['open_issues_count']} open issues on #{repository}"
  end

  def user(username)
    json = json_parse self.class.get("/users/#{username}")

    json['html_url']
  end

  def repo(repository)
    json = json_parse self.class.get("/repos/#{repository}")

    json['html_url']
  end

  def json_parse(response)
    logger.debug "GitHub API response body: #{response.body}"

    JSON.parse response.body
  end

  def logger
    logger ||= ::Logger.new(STDOUT)
  end
end
