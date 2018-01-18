Bundler.require(:default, :development)
require 'sass/plugin/rack'
require './app'

Sass::Plugin.options[:style] = :compressed
Sass::Plugin.options[:template_location] = './assets/css'
Sass::Plugin.options[:css_location] = './public/css'
use Sass::Plugin::Rack

run Sinatra::Application
