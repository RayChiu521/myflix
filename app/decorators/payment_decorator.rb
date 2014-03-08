class PaymentDecorator < Draper::Decorator

  delegate_all

  def amount
    h.number_to_currency(object.amount / 100) if object.amount.present?
  end
end