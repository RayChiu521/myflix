jQuery ($) ->
  $('#register_form').submit (event) ->
    $form = $(this)
    $form.find('submit').prop('disabled', true)
    Stripe.card.createToken(
      number: $('[data-role="card-number"]').val()
      cvc: $('[data-role="card-security-code"]').val()
      exp_month: $('[data-role="card-expiry-month"]').val()
      exp_year: $('[data-role="card-expiry-year"]').val()
    , stripeResponseHandler)
    false

  stripeResponseHandler = (status, response) ->
    $form = $('#register_form')
    if response.error
      $form.find('.payment-errors')
        .text(response.error.message)
        .addClass('alert alert-danger')
      $form.find('submit').prop('disabled', false)
    else
      token = response.id
      $form.append('<input type="hidden" name="stripeToken" value="' + token + '" />')
      $form.get(0).submit()