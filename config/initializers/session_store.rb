# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_harv_session',
  :secret      => 'b3e98767ac97e8750c1d3cce6c4f3fd706a267e5c565e50c17e42c6097db5f99d35551fb8f772eda7023e8dab47486617aa91211ec9ff535ddd15f437d762a47'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
