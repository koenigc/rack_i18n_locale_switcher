# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_locale_switch_session',
  :secret      => '988dd546608bed25e452d519f87b8fcbb902d7db28676c700592e106313357773abe38141b8a40ddafb28e35be14aa55d9838681a121db0cc4c4fdb6e841cd95'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
