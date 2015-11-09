require 'httpclient'
require 'addressable/uri'

class HttpGet::Client
  ::USER_AGENTS ||= ["Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"]

  def initialize(user_agent: USER_AGENTS.sample)
    @opts = { agent_name: user_agent }
  end

  def with_proxy(proxy)
    host, port, user, password = proxy
    proxy_str = [[user, password].join(':'), "#{host}:#{port}"].join('@')
    @opts = @opts.merge({ proxy:  'http://' + proxy_str })
    self
  end

  def get(url, params = {}, redirects: 0, after_success: ->(resp) { resp })
    raise RedirectError if redirects > 5

    url = Addressable::URI.parse(url).normalize.to_s

    resp = HTTPClient.new(@opts).get(url, params)

    after_success.call(resp)
  end

  class BlockedError < StandardError; end
  class MissingError < StandardError; end
  class RedirectError < StandardError; end
end
