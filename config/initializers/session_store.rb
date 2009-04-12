# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_splatcamp_session',
  :secret      => 'b78f377e16db25e152debb50dace4069eee059c90ee5d178064bda4553feb2c17656f358e8c79ed19467681c48a07e0b6f3698cd196d6a97868e6e6f395303da'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
