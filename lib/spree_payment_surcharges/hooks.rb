Deface::Override.new(:virtual_path => "admin/payment_methods/_form",
                     :name => "admin_payment_methods_calculators",
                     :insert_after => "table[data-hook='payment_method']",
                     :text => "<div data-hook=\"admin_shipping_method_form_calculator_fields\"><%= render \"admin/shared/calculator_fields\", :f => f %></div>",
                     :disabled => false)

Deface::Override.new(:virtual_path => "users/show",
                     :name => "account_title",
                     :replace => "h1",
                     :text => '<% content_for :title do t(:my_account) end %>',
                     :disabled => false)
