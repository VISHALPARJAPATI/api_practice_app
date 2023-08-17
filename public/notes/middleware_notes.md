# What is middleware
A middleware is nothing but a class with a `call` method that recieves the incoming HTTP request (env) from the web server, processes it before passing it to the Rails application, processes the response received from the application, and returns the response back to the web server.

When we say an application is Rack-compliant, it means the following:

1. It has a call method that accepts a single argument env, containing all the data about the request, and
2. It returns an array containing the status, headers, and response.


## Two important things to note here:

The middleware receives the application (or the next middleware) in the constructor.
After receiving the response from the application, it has to return the response to the web server, or the next middleware in the pipeline.

`You can refer to the image middleware.png to better explain the working`

## Why Use Middleware?

Middleware is very useful for writing logic that is not specific to your web application, such as authenticating the request, logging, or error handling. It focuses on doing one thing and doing it well.


Middleware sits between the user and the application code. When an HTTP request comes in, the middleware can intercept, examine, and modify it. Similarly, it can examine and modify the HTTP response before forwarding it to the user.

Using middleware also simplifies your application code, and it can only focus on the logic related to the application.

There are several middleware (is 'middlewares' a word?) included in the Rails framework. You can see a list of all middleware by running the `bin/rails middleware` command. 

##  Create Custom Middleware

Let's say you want to add a new middleware for your application that does a simple thing: verify a token sent in the header by the client code. If this token matches our secret token, allow the request to proceed. Otherwise, immediately return an error without passing the request to the application.

# STEP to create a custom middleware

1. create a middleware directory in the lib or app. I've created a middleware directory in the `lib`
2. Then create a file there, this file is our custom middleware. I've created authentication.rb
3. To add a new middleware, use the `config.middleware.use MiddleWareClassNAME`, passing the name of the Ruby class that acts as middleware. Rails will insert this middleware at the end of the existing middleware stack, meaning it will get executed in the end, just before your application is called.

Example to include middleware in application.rb

```ruby ```
require_relative "../lib/middleware/verify_token"'

module Blog
  class Application < Rails::Application
    config.middleware.use Middleware::VerifyToken
  end
end

Instead of putting your middleware in the end, if you wish to insert it before or after another middleware, you can do so using the `insert_before` or `insert_after` method.


## Passing Parameters to Middleware

# Set custom middleware
config.middleware.use Middleware::VerifyToken, default_token: 'another-token'
