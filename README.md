# Live Site

You can see the URL Shortener [here](https://url-shrtnr-app.herokuapp.com/).  
It's on a Heroku free dyno, so it may take a sec for it to wake up.  

# Setup

You should be able to simply clone the repo, run `bundle install` to install
dependencies, followed by `rake db:create`, and `rake db:migrate` to get the
database set up, assuming you have postgres installed.  

You can start the app with `rails s` and everything should just work.  

When deploying to hosting infrastructure, a DATABASE_URL environment variable
must be set, conforming to the spec [here](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING),
and SITE_ROOT should match your site's root.  

If you want to make requests to the app using cURL, you can use the following, replacing the URL you want to shorten:  
`curl -X POST -d "url=YOUR_FULL_URL" https://url-shrtnr-app.herokuapp.com`  

You can get the Top 100 via:  
`curl -H "Accept: application/json" https://url-shrtnr-app.herokuapp.com/top`  

See where you'll be redirected via:  
`curl -I https://url-shrtnr-app.herokuapp.com/x` (replace x with the shortened path)  

# Shortening Algorithm

The approach for shortening URLs that this app uses is actually pretty simple. It relies on the insight
that we can convert any base10 number into a number with a much larger base, and cut down
on the length of digits needed to represent that number.  

The list of url safe characters is a-z, A-Z, and 0-9, giving a total of 62 characters. We can then use these
62 characters, and use them as digits in our base62 numbering system. The last step is to
simply convert the unique base10 encoded database keys for each record into base62, and map each
numerical digit, to one of our Url safe characters. We can do this easily by pre-populating an
array with all 62 URL safe characters, and just doing array lookups for each base62 digit.  

This approach gives us very short URL's which can represent very large base10 numbers, ie:  
1 digit : 61 records (since 0 will not be a DB id)  
2 digit : 3,843 records  
3 ..    : 238,327 ..  
4 ..    : 14,776,335 ..  
5 ..    : 916,132,831 ..  
6 ..    : 56,800,235,583 ..  

