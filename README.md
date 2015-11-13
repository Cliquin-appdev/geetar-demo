## geetar

I created this app so I don't have to deal with all of the crap on ultimate-guitar.com. The mobile version of the site is particularly annoying; with inturrupting ads it's basically impossible to view tabs from my phone.

Geetar sends your search query to ulitmate-guitar.com, scrapes the results and displays them in a bullshit-free UI for your guitar playing pleasure. I understand that this sounds kinda shady (it's basically ripping content from one site and displaying it on another), so this app will randomly click on an ad on ultimate-guitar.com 1 out of 50 times it scrapes content. Is that good enough? I hope so.

Please don't tell ultimate-guitar.com. I wouldn't want them to be offended.

www.geetar.lol

## Local Setup

1. `$ git clone https://github.com/jpalmieri/geetar.git`
2. `$ cd geetar`
3. `$ bundle install`

## Heroku setup

Heroku will need multiple buildpacks, since this uses phantomjs to click on ads with a headless webdriver.

1. Create new heroku app: `$ heroku create`
2. Add phantomjs buildpack `$ heroku buildpacks:add --index 2 https://github.com/stomita/heroku-buildpack-phantomjs.git`
3. Push to heroku `$ git push heroku master`

Go visit your site! You can find your app's url with `$ heroku app:info`