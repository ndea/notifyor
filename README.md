# Notifyor
## [![](http://i.imgur.com/FrRacwt.png)]()
Get realtime notifications (growl messages) on your desktop if something happens in your rails app.
Events are pushed to redis and collected by ssh to be displayed as a growl message on your local machine.

Simply put:
Very growl. Such notifications. Much Notifyor.

## Installation

Add this line to your Gemfile:

```ruby
gem 'notifyor', '~> 0.4.3'
```

And then execute:

    $ bundle install

## Getting started
Run the bundle command to install it.
After you install Notifyor create a new file **config/initializers/notifyor.rb** (a rails generator will be available soon for this task). Add the following content to your initializer.
```ruby
Notifyor.configure do |config|
  #config.ssh_host = 'some_host_address'
  #config.ssh_port = 22
  #config.ssh_user = 'some_user'
  #config.ssh_password = 'please dont do this'
end
```
Every option can be overwritten with the CLI by providing certain arguments (see CLI) 

## Usage

### Plugin
Notifyor can be plugged into your models by adding the *notifyor* method to your class.
```ruby
class SomeClass < ActiveRecord::Base
    notifyor
end
```
By just including the method without options, notifyor will send notifications for the following events: *create*, *update* and *destroy*. The default message is the i18n key **notifyor.model.[create | update | destroy]** you have to provide in your application.
If you want to customize this message you can provide the following option to the notifyor method:
```ruby
class SomeClass < ActiveRecord::Base
    notifyor messages: {
      create: -> (model) { "My Message for model #{model.id}." },
      update: -> (model) { "My Message for model #{model.id}." },
      destroy: -> (model) { "My Message for model #{model.id}." }
  }
end 
```

If you dont want to receive a notification for a certain action just add the **only** option to notifyor.
```ruby
class SomeClass < ActiveRecord::Base
    notifyor only: [:create]
end 
```
### CLI
```bash
notify_me --ssh-host some_host --ssh-port some_port --ssh-user some_user --ssh-password some_password
```
#### Arguments for the CLI
 - **ssh-host** Provide the ssh host to which notifyor should connect to.
 - **ssh-port** Provide the ssh port on which notifyor should connect to.
 - **ssh-password** Provide the ssh password to your remote server. (Please use ssh keys so that you just have to provide the *ssh-host*. -> Segurity reasons)
 - **ssh-user** Provide the ssh user for your remote server. (Please use ssh keys so that you just have to provide the *ssh-host*. -> Segurity reasons)

**If you dont provide a ssh host notifyor will  pull messages from your local redis and display them.**

## Roadmap
- Notifications for multiple OS (currently only Mac OS X)
- Multiple users to receive notifications
- Provide own logo in the growl notification
- Specs
- Notifications on localhost

## Development

After checking out the repo, run `bundle install` to install dependencies. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/notifyor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
