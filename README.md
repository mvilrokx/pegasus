# Introduction
Pegasus is the code name for a tool that was developed during a ShipIt event at Oracle.  It's purpose is to make creating and finding "objects" in Fusion Applications easier and prevent duplication of Objects.

Pegasus tries to solve this by making it easy to find anything, anywhere, anytime in Fusion.

# Prerequisites
Pegasus was build with Grunt, Bower and Yeoman so you need these tools to get started.  All these tools also have a dependancy on Node.js and npm so install those first.

## node.js and npm
### Ubuntu
$ sudo apt-get install nodejs npm
### Mac (using Brew)
$ brew install node

## Yeoman, Grunt and Bower
### Ubuntu
sudo npm install yeoman -g
sudo npm install -g grunt-cli bower

# Ruby
You need ruby.  The app was build with 1.9.3 but I am assuming it is compatible with anything +1.9 and probably even lesser versions (1.8.7), no garuantees though.

# Gems
compass (0.12.2)
soulmate (1.0.0)
rack-contrib (1.1.0)
rest-client (1.6.7)
awesome_print (1.2.0)

# Install Application
Clone this repo and cd into the root folder of the project.  From there run:

   $ npm install

This will install all the node dependancies

Open the soulmate-seed.rb file and adjust the parameters for your Fusion instance, then run it:

   $ ruby soulmate-seed.rb

# Running the Application
## Start Redis server
  $ redis-server /usr/local/etc/redis.conf
## Start soulmate webapp
  $ soulmate-web --foreground --no-launch --redis=redis://localhost:6379
## Start FUSE demo WebApp
  $ grunt server

You should now be able to see the app in the browser.  Just click on the special icon in the top bar and type your query/task in the popup window.

# Trouble Shooting
## Soulmate
Try this in the brower
http://localhost:5678/search?types[]=opportunities&term=pin
## Gems
I had to uninstall the rubygems-bundler gem before grunt server started working
$ gem uninstall -i /home/mark/.rvm/gems/ruby-1.9.3-p448@global rubygems-bundler

