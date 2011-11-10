Deface::Override.new(:virtual_path => "admin/payment_methods/_form",
                     :name => "admin_payment_methods_calculators",
                     :insert_after => "table[data-hook='payment_method']",
                     :text => "<div data-hook=\"admin_shipping_method_form_calculator_fields\"><%= render \"admin/shared/calculator_fields\", :f => f %></div>")

Deface::Override.new(:virtual_path => "checkout/_payment",
                   :name => "checkout_payment_price",
                   :insert_bottom => 'div[data-hook="checkout_payment_step"] label',
                   :partial => "checkout/payment_price")
