# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Goldfinchjewellery::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || '46986bfa4720a9b912faec0a9e633547508f2074f96ab8e0c6815eed7cad1c293ae719af67270ab6ef57efdbbc8b7c0fee4fd231d4550ed0315df0fc8d477aa7'
