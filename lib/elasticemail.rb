require "elasticemail/version"
require "json"

module Elasticemail
  class API
    BASE_API_URI="https://api.elasticemail.com/v2".freeze
    def initialize apikey
      @apikey = apikey
    end

    # convenience methods
    def contact_load_blocked search=""
      url = "#{BASE_API_URI}/contact/loadblocked"
      abuse = get("contact/loadblocked", {search: search, status: "Abuse"})
      bounced = get("contact/loadblocked",{search: search, status: "Bounced"})
      if abuse["success"] == "true" || bounced["success"] == true
        abuse["data"]+bounced["data"]
      else
        raise StandardError, "Error retriving data"
      end
    end

    # generic get method
    def get api_url, msg_info={}
      url = "#{BASE_API_URI}/#{api_url}"
      call_api_get(url, msg_info)
    end

    # generic post method
    def post api_url, msg_info={}
      url = "#{BASE_API_URI}/#{api_url}"
      res = call_api_post(url, msg_info)
    end

    private
    def call_api_post url, msg_info={}
      begin
        msg_info[:apikey] = @apikey

        res = Net::HTTP.post_form(url, msg_info)
        JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
      rescue StandardError => e
        e.message
      end
    end

    def call_api_get url, msg_info={}
      msg_info[:apikey] = @apikey

      uri = URI(url)
      uri.query = URI.encode_www_form(msg_info)
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        #request = Net::HTTP::Get.new uri
        #response = http.request request
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
      end
    end


  end

end
