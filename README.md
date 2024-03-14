# Omniauth::Immutable::PassportOpenId

Strategy to authenticate with Immutable Passport via OpenId in OmniAuth.

For more details, read the [Immutable Passport documentation](https://docs.immutable.com/docs/x/passport).

#### Caveat

Currently, Immutable Passport handles user authentication via it's [typescript SDK](https://docs.immutable.com/docs/x/passport/identity/login). This means the request phase is currently irrelevant and the callback phase must be initialized explicitly via a client request after the immutable passport flow is complete on the client. In other words, this gem's current purpose is to allow you to manage the user identity as you do other providers in your custom app after the user has already been authenticated. This means the client keys are not needed atm.

## Installation

Add this line to your application's Gemfile:

```ruby
git 'https://github.com/maxschridde1494/omniauth-immutable-passport-openid.git', branch: 'main' do
  gem 'omniauth-immutable-passport-openid'
end
```

And then execute:

    $ bundle install

## Usage

Here's an example for adding the middleware to a Rails app in `config/initializers/omniauth.rb `:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :immutable_passport, strategy_class: OmniAuth::Immutable::Strategies::PassportOpenId, callback_path: '/auth/immutable_passport/callback.json'
end
```

You can now access the OmniAuth PassportOpenId callback URL at `auth/immutable_passport/callback`

## Auth Hash

Here is an example of the user profile auth blob the immutable passport sdk returns on successful auth ([docs](https://docs.immutable.com/docs/x/passport/identity/user-info#getting-user-information)):

```javascript
{
    "email": "yourname@gmail.com",
    "nickname": "yournickname",
    "sub": "google-oauth2|some_id_here"
}
```

Assuming `const userProfile` is set to that blob, this should be POSTed to `auth/immutable_passport/callback.json` as

```javascript
{
    omniauth: {
        provider: 'immutable_passport',
        uid: userProfile.sub,
        info: { 
            email: userProfile.email, 
            nickname: userProfile.nickname,
            name: 'optional_name' // this won't come from passport but can be passed through
        },
    },
}
```

### Integrate with Devise 

In `config/initializers/devise.rb`

```ruby
Devise.setup do |config|
  ...
  config.omniauth :immutable_passport, 
    strategy_class: OmniAuth::Immutable::Strategies::PassportOpenId,
    callback_path: '/users/auth/immutable_passport/callback.json'
  ...
end
```

NOTE: If you are using this gem with devise with above snippet in `config/initializers/devise.rb` then do not create `config/initializers/omniauth.rb` which will conflict with devise configurations.

Then add the following to `config/routes.rb` so the callback routes are defined.

```ruby
devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
```

Make sure your model is omniauthable. Generally this is `app/models/user.rb`

```ruby
devise :omniauthable, omniauth_providers: [:immutable_passport]
```

Then make sure your callbacks controller is setup.

```ruby
# app/controllers/users/omniauth_callbacks_controller.rb:

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def immutable_passport
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Immutable Passport'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.immutable_passport_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxschridde1494/omniauth-immutable-passport-openid.

