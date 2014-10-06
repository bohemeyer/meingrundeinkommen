class PaymentsController < ApplicationController
require "uri"
require "net/http"

protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller

  def create
    #ActionMailer::Base.mail(:from => "micha@mein-grundeinkommen.de", :to => "micha@mein-grundeinkommen.de", :subject => "method called", :body => "").deliver
    response = validate_IPN_notification(request.raw_post)
    case response
      when "VERIFIED"
        Rails.logger.info 'verified'
        #ActionMailer::Base.mail(:from => "micha@mein-grundeinkommen.de", :to => "micha@mein-grundeinkommen.de", :subject => "verified", :body => "").deliver
        support = Support.find(params[:custom].to_i) if params[:custom]
        if support
          Rails.logger.info support
          #ActionMailer::Base.mail(:from => "micha@mein-grundeinkommen.de", :to => "micha@mein-grundeinkommen.de", :subject => "support found", :body => support.to_s).deliver
          if support.payment_method != 'bank' && params[:payment_status] == 'Completed'
            Rails.logger.info 'conditions ok'
            #ActionMailer::Base.mail(:from => "micha@mein-grundeinkommen.de", :to => "micha@mein-grundeinkommen.de", :subject => "conditions true", :body => "").deliver
            support.payment_completed = true
            support.email = params[:payer_email] if !support.email && params[:payer_email]
            support.nickname = params[:first_name] if !support.nickname && params[:first_name]
            support.city = params[:address_city] if params[:address_city]
            support.country = params[:address_country] if params[:address_country]
            support.save

            Rails.logger.info support
            #ActionMailer::Base.mail(:from => "micha@mein-grundeinkommen.de", :to => "micha@mein-grundeinkommen.de", :subject => "updated support", :body => support.to_s).deliver

            # pp_params = params
            # pp_params.cmd = '_notify-validate'
            # x = Net::HTTP.post_form(URI.parse('https://www.paypal.com/cgi-bin/webscr'), params)
          end
        end
        # check that paymentStatus=Completed
        # check that txnId has not been previously processed
        # check that receiverEmail is your Primary PayPal email
        # check that paymentAmount/paymentCurrency are correct
        # process payment
      when "INVALID"
        # log for investigation
        #ActionMailer::Base.mail(:from => "micha@mein-grundeinkommen.de", :to => "micha@mein-grundeinkommen.de", :subject => "invalid :(", :body => "").deliver
      else
        # error
      end

    render :nothing => true
  end




  protected
  def validate_IPN_notification(raw)
    uri = URI.parse('https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "My custom user agent"
                       ).body
  end






end
