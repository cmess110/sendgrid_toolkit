require 'json'

module SendgridToolkit
  class Mail < AbstractSendgridClient
    def send_mail(options = {})
      response = api_post('mail', 'send', convert_params(options))
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].inspect}") if response["message"] == "error"
      response
    end

    private
    def convert_params(options)
      if options.has_key?("x-smtpapi") && !x_smtpapi_parsable_json?(options)
        options["x-smtpapi"] = options["x-smtpapi"].to_json
      end
      options
    end

    def x_smtpapi_parsable_json? options
      !!JSON.parse(options["x-smtpapi"])
    rescue
      false
    end
  end
end
