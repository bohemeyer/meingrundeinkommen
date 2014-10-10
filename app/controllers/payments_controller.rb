class PaymentsController < ApplicationController
require "uri"
require "net/http"

protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller

  def create
    response = validate_IPN_notification(request.raw_post, false )
    case response
      when "VERIFIED"
        Rails.logger.info "VERIFIED"
        support = Support.find(params[:custom].to_i) if params[:custom]
        if support
          Rails.logger.info support
          if params[:payment_status] == 'Completed'
            support.payment_completed = true
            support.email = params[:payer_email] if !support.email && params[:payer_email]
            support.nickname = params[:first_name] if !support.nickname && params[:first_name]
            support.city = params[:address_city] if params[:address_city]
            support.country = params[:address_country] if params[:address_country]
            support.save
            Rails.logger.info support
          end
        end
      when "INVALID"
        Rails.logger.info "invalid"
      else
        Rails.logger.info "error"
      end

    render :nothing => true
  end




  protected
  def validate_IPN_notification(raw, test)
    uri = URI.parse('https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate') if test
    Rails.logger.info uri.host
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    Rails.logger.info uri.request_uri
    Rails.logger.info raw
    response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "My custom user agent"
                       ).body
  end


end
