module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(options)
      @response = options[:response]
      @status = options[:status]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :card => options[:card],
          :description => options[:description].presence || ''
        )
        new(response: response, status: :success)
      rescue Stripe::CardError => e
        new(response: e, status: :failure)
      end
    end

    def successful?
      status == :success
    end

    def failure_message
      response.message
    end
  end

  class Customer
    attr_reader :response, :status

    def initialize(options)
      @response = options[:response]
      @status = options[:status]
    end

    def self.create(options = {})
      begin
        response = Stripe::Customer.create(
          :plan => 'base',
          :email => options[:user].email,
          :card => options[:card],
          :description => "Subscripts by #{options[:user].full_name}"
        )
        new(response: response, status: :success)
      rescue Stripe::CardError => e
        new(response: e, status: :failure)
      end
    end

    def successful?
      status == :success
    end

    def id
      response.id if status == :success
    end

    def failure_message
      response.message
    end
  end
end