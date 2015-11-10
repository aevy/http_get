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

  def get(url, params = {}, redirects = 0,
          after_success: ->(resp) { resp },
          before_redirect: ->(url) { url },
          blocked_condition: ->(resp) { false })
    raise RedirectError if redirects > 5

    url = Addressable::URI.parse(url).normalize.to_s
    resp = HTTPClient.new(@opts).get(url, params)

    if resp.status_code == 200
      instance_eval { after_success.call(resp) }
    elsif resp.status_code == 301
      redirect_url = before_redirect.call(resp.header['Location'].first)

      get(redirect_url, params, redirects + 1)
    elsif blocked_condition.call(resp)
      raise BlockedError
    else
      raise MissingError
    end
  end

  class BlockedError < StandardError; end
  class MissingError < StandardError; end
  class RedirectError < StandardError; end
end
