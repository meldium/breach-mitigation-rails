# breach-mitigation-rails

Makes Rails 3 and 4 applications less susceptible to the BREACH /
CRIME attacks. See [breachattack.com](http://breachattack.com/) for
details.

## How it works

This gem implements two of the suggestion mitigation strategies from
the paper:

*Masking Secrets*: The Rails CSRF token is 'masked' by encrypting it
with a 32-byte one-time pad, and the pad and encrypted token are
returned to the browser, instead of the "real" CSRF token. This only
protects the CSRF token from an attacker; it does not protect other
data on your pages (see the paper for details on this).

*Length Hiding*: The BreachMitigation::LengthHiding middleware
appends an HTML comment up to 2k in length to the end of all HTML
documents served by your app. As noted in the paper, this does not
prevent plaintext recovery, but it can slow the attack and it's
relatively inexpensive to implement. Unlike the CSRF token masking,
length hiding protects the entire page body from recovery.

## Warning!

BREACH and CRIME are **complicated and wide-ranging attacks**, and this
gem offers only partial protection for Rails applications. If you're
concerned about the security of your web app, you should review the
BREACH paper and look for other, application-specific things you can
do to prevent or mitigate this class of attacks.

## Installation

Add this line to your Rails Gemfile:

    gem 'breach-mitigation-rails'

And then execute:

    $ bundle

The length-hiding can be disabled by doing:

    Rails.application.config.exclude_breach_length_hiding = true

For most Rails apps, that should be enough, but read on for the gory
details...

## Gotchas

* The length-hiding middleware adds random text (in the form of an HTML
  comment) to every page you serve. This can break HTTP caching / ETags for
  public pages since they are no longer identical on each request.
* The length-hiding middleware adds up to 2k of text to each page you
  serve, which means more bandwidth consumed and potentially slower
  performance.
* If you have overridden the verified_request? method in your
  application (likely in ApplicationController) you may need to update
  it to be compatible with the secret masking code. See
  `lib/breach_mitigation/railtie.rb` for an example.

## Contributing

Pull requests are welcome, either to enhance the existing mitigation
strategies or to add new ways to mitigate against the attack.
