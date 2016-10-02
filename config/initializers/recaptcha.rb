# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.public_key  = '6LfxHggUAAAAAApWalT6gpdct117pk3UvEM9bWOp'
  config.private_key = '6LfxHggUAAAAAOXVVIuhAmy8nDzWeTlpdq0Almt1'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end