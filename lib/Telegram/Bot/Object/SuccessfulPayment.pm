package Telegram::Bot::Object::SuccessfulPayment;

# ABSTRACT: The base class for Telegram 'SuccessfulPayment' type objects

use Mojo::Base 'Telegram::Bot::Object::Base';
# use Telegram::Bot::Object::OrderInfo;

has 'currency';
has 'total_amount';
has 'invoice_payload';
has 'shipping_option_id';
# has 'order_info'; #OrderInfo XXX
has 'telegram_payment_charge_id';
has 'provider_payment_charge_id';

sub fields {
  return { scalar => [qw/currency total_amount invoice_payload shipping_option_id
                         telegram_payment_charge_id provider_payment_charge_id/],
       # 'Telegram::Bot::Object::OrderInfo' => [qw/order_info/],

         };
}

1;
