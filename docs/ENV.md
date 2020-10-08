# Env 

When developing mobile apps, it's very common to come upon the scenario of interacting with a network API. More then likely, your app is going to perform HTTP requests to perform some work. 

Let's say that you are using the Stripe API to process credit card payments in your app. Allowing people to buy products within your app with a credit card. That's easy! Learn how to use the Stripe API by reading Stripe's documentation and read our document on how to use [Moya](libs/MOYA.md) to learn how to perform HTTP requests in this project. 

Here is our problem. When your app customers are using your app to make credit card payments, you want your customers to be making real transactions against their credit cards. But while you are *developing* the app, you don't want to make real credit card transactions against your credit card to test the app. Stripe, as well as many other API services provide an API that your customers use (we call this the *production* API) and they provide a separate API that is used for development and testing purposes (we call this the *development, testing, or QA* API). The 2 APIs are identical in that you send requests to them the same way, except the production API will charge your credit card while the development/testing/QA API will not charge a credit card. 

In our project, how do we easily switch between using the production and development API for Stripe? **We use what are called *environments* (Env for short).**

Think of environments like this: "When my app is used by this person, how do I expect my app to work?" Often, the answer to that question is: "When my app customers are using the app, I expect the app to be setup in the *production environment*. When I am developing the app on my own personal computer adding new features and such, I expect my app to be setup in the *development environment*." 

You might have more then these 2 environments. If I have beta testers who test out my app before I send the app out to paying customers in the app store, I expect my app to be setup in the *beta environment*. You can create as many environments as you wish. Although, I advice you to keep your number of unique environments to a minimum to keep them easier to manage. 

**Environment is a fancy work that means we want to dynamically change some of our code at compile time**. When we want to compile our app for the production environment, we want to setup our code base to use the Stripe production API hostname (use the string `https://production-api.stripe.com`). When we want to compile our app for the development environment, we want our code base to instead compile with the development API hostname string of `https://development-api.stripe.com`. That way when the app runs, the app will call different API servers at runtime. 

# Using environment variables in project 

How do we make changes to our code based on the environment? **We use environment variables**. 

What is an environment variable? Environment variables are variables that change the behavior of your computer. Environment variables are used a lot in Windows, Linux, and macOS computers for example. If you open up your terminal on your Linux or macOS computer and type `echo $HOME`, it will return back a value to you. It returns the value of the environment variable `HOME`. If you were to logout of your computer, login to another user account you have setup on your operating system and enter `echo $HOME` again for this separate user, you will get a different value. These variables dynamically change the operating system depending on the logged in user.

Environment variables can be variables defined on your operating, yes, but environment variables can also be stored and loaded from a file. We call these `.env` files (pronounced "dot env") and this is the syntax of these files:

```
# This is a comment. 
VARIABLE_NAME=variable value

# You can define hostnames
STRIPE_API_HOSTNAME=https://api.stripe.com

# Define booleans. 
ENABLE_LOGGING=true

# Define numbers 
RETRY_POLICY_NUMBER=3

# Values can have spaces
APP_NAME=Puppy Fan Club
```

Pretty simple. Variable name, `=` character, then the value of that variable. 

If you followed the [Getting Started instructions in this project](../README.md#Getting-started) it tells you to run the command `cp .env.example .env`. This file, along with the program [dotenv-ios](https://github.com/levibostian/dotenv-ios) allows you to use environment variables from your `.env` file in your iOS app. 

This project is already setup to use `.env` files. All you need to do is follow these steps:

1. Open your `.env` file in the root directory of your project and define a variable with it's value. For example purposes, let's say that you are defining the variable `STRIPE_API_HOSTNAME=https://api.stripe.com`. 
2. In your app's code, enter `Env.stripeApiHostname` anywhere where you need to use the value of `STRIPE_API_HOSTNAME`. When you type this at first, XCode will complain to you saying that `stripeApiHostname` is not defined in the `Env` class. That's ok! Go to the next step. 
3. Build your app in XCode. XCode's error saying that `stripeApiHostname` is not defined in the `Env` class should go away and your app should build successfully. 

> Note: All properties of the `Env` file are strings. If you define a value `ENABLE_LOGGING=true` that looks like a boolean, `Env.enableLogging` is a string data type. The recommended way to get around this is to create a Swift extension.

If you cannot get the project to compile, read the documentation for [dotenv-ios](https://github.com/levibostian/dotenv-ios). Make sure that everything is setup correctly to get it to work. 

# When should I use an environment variable? 

The more that you add environment variables to your code, the harder everything is to manage. You don't want to go overboard on defining tons of environment variables. I follow the rule of only defining environment variables when I absolutely need them. I try to write all of my code to not need them at first and only define them if needed. 

In this document, we gave the example of dynamically changing the URL hostname to the Stripe API we want to use. That's a great example of a variable to define with an environment variable. The app is going to behave identically except what API you communicate with. Error handling, data storage, and all other app behavior is identical. 

That's very important. Make sure your app behaves identically as close as possible no matter what environment it is in. Your app should be dumb. It should not care at all what environment it is in. When you encounter bugs in your app, it is *way* easier to debug the errors when the app behaves identically no matter the environment. Trust me. You will catch more bugs during development and testing and you will be able to fix them faster when they happen in production. 

#### Some bad examples of when you would use environment variables would be:

* Enabling and disabling features of your app. 

Well, if you have a paid version of your app and a free version, this might be acceptable. But if you have a production environment and a development version of the same app you want to keep all of the features identical because during development when you're testing your app works correctly, you can feel confident that your app will work correctly because it is identical to the production app except some very small changes. If the app works during development, you can feel confident it will work at production. 

* Modifying critical behavior of your app. 

Let's say that we implement a retry policy into our app so that when the user encounters an error performing a HTTP network request we automatically perform a retry. Let's say we create an environment variable `NUMBER_RETRIES=3`. When we are developing, we define the value at `NUMBER_RETRIES=1` because it's annoying to wait longer for network requests during development but in production we define the value at `NUMBER_RETRIES=5`. During your development of the app, your network calls are super fast because if an error happens, it will only retry once. You develop the app and push it to the app store to your customers. Next thing you know, you start to get some bad reviews made in the app store from users saying that the app is slow and takes forever to load. If you set `NUMBER_RETRIES=5` in your development environment *and* production environment, you would have realized during development that the app loads slow. That would have been nice to know! The way to fix this is to choose a value for the number of retires and hard code that value into the code. Do not make it an environment variable. That way it will be that same way for all environments. 

Keep your critical behavior of your app identical. The app should behave identically no matter the environment. 

# How to manage .env files

When we compile our code, the compiler will use the `.env` file in the root directory of our project. We are supposed to have a separate `.env` file for every environment of our app. One `.env` for development, one `.env` for production, etc. 

How do we manage all of these separate `.env` files? Some people do something like this where they create multiple files: `.env.production`, `.env.development` and then before they compile their app, they run a command `cp .env.production .env` which copies the contents of the `.env.production` file and puts it into `.env` ready to compile for the production environment. 

Although this could work, it's not secure. What if we need to put secret passwords or private API keys into our `.env` file? Not all projects need this, but some might. It's bad practice to save passwords and other private information like API keys in your git version control repository. Even if your GitHub repository is set to private, it's still a bad idea to save these secrets there. 

So, how do we manage 1+ `.env` files and also store them in a secure way? 

This project uses a tool for that purpose called [cici](https://github.com/levibostian/cici/). cici is a program that stores files in your version control in a secure way and helps you manage them all. 

The best place to learn how to use cici is the [project documentation](https://github.com/levibostian/cici/). It's quick and simple to understand how to use it. 

A gist of how we use cici to manage our environments is:
* Define a *cici set* for all of our separate environments in our project. For example, define a set `production` and a set `development`. 1 set for 2 separate environments. 
* After you create all of your separate `.env` files for each of your environments, encrypt the files with `cici encrypt` on your machine. 
* Then, when you want to compile your production app, run `cici decrypt --set production` and compile your app. Done! 

# Why not use XCode configurations? 

You can implement this idea of environments using XCode configurations. XCode configurations allow you to set variables that get put into your app at compile time. This is cool, but in this project I have decided to use another approach. Here is why I prefer this strategy from 12 factor app:

* Environment variables are universally supported by all languages, frameworks, operating systems. This means that if you get used to programming with environment variables, you can apply the same methodology to all of your projects. Because it's the same very simple system, I have noticed less confusion compiling and debugging my apps. 

* XCode configuration are stored in plain text. What if I need to store a secret API key? There are ways to store secret strings in your project, but at that point you might as well just use this `.env` idea! 

* Using a single `.env` file is future-proof. If the iOS build system makes a major upgrade in the future (which it has in the past!), then you may need to change your XCode configurations to adopt to these new changes. This may require more for you to learn, it may break your system that you currently use for building and deploying, you have to teach it to your team, and so on. This system takes a `.env` file and generates a Swift file. The only way that this system would break is it Swift had a major upgrade and we have to change the syntax of the file we generate. That's it! 

No system is perfect. I prefer this one, I really enjoy it, so I will continue to use it until I find a reason to switch. 
