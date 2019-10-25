module BrowserFormatterHelper

  def get_browser_log(type=:browser)
    @browser.driver.manage.logs.get(type)
  end

  def get_browser_log_messages(browser_logs)
    message = ''
    browser_logs.each{|log| message += log.message + "\n"}
    message
  end

  def get_browser_url
    "URL: #{@browser.url}"
  end

  def get_browser_ready_state
    "ReadyState: #{@browser.ready_state}"
  end

  def get_current_cookies
    "All cookies: #{@browser.driver.manage.all_cookies}"
  end
end