class Admin::PaymentsController < AdminsController
  def index
    @payments = Payment.all.decorate
  end
end