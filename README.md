# ActionCable CLI

This is a tiny PoC that shows a Rails API-Only app, communicated with via
CLI -> ActionCable (WebSockets). It also has RedLock for distributed locking.
This was based on [https://www.hansschnedlitz.com/2021/04/04/build-real-time-clis-with-actioncable.html]
with some minor changes.

This is for demonstration purposes only!! If you want to actually extend this
thing and put it to use, fork it and start a real project! Keep this repo as
bare-bones as possible.

## Options used to generate the initial Rails app

Here is the command-line used to generate the initial Rails app:

```shell
rails new actioncable-cli \
    --api \
    --skip-action-mailer \
    --skip-action-mailbox \
    --skip-action-text \
    --skip-active-job \
    --skip-active-record \
    --skip-active-storage \
    --skip-javascript \
    --skip-jbuilder \
    --skip-spring \
    --skip-test \
    --skip-system-test \
    --skip-webpack-install \
    --skip-turbolinks
```

You're probably going to want AR and other things if you were doing a real
app.

## Why?

Rails is a powerful framework with a huge community, but sometimes you don't
really want a WebApp. You just want the ORM, messaging, logging, etc. for your
CLI app. You'll get all of that, plus the benefits of WebSockets. WS brings
a lot of message bus features to the table without needing to run an actual
message bus like RabbitMQ or ActiveMQ.

AND, this architecture will allow your CLI to scale prittay, prittay, prittay,
prittayyyy well.

## Pre-Requisites

Redis Server either running on localhost:6379 OR you can export REDIS_URL in
the environment to use whatever. Don't clobber something important in an
important Redis box!

Probably want RVM working, I put this together on Ruby 3.2.0.

## To Setup

bundle install

## To Run

### Backend

#### Use the run-backend script

Use the bin/run-backend script to start Rails and Sidekiq in a terminal
window. This script will exit if you hit any key or ctrl-c it. This is the
easy way.

#### The script doesn't work how can I run it manually?

Alternatively to run the backend manually:

Start Rails and Sidekiq (you will need two terminals unless you put them in
the background):

```bash
  bundle exec rails server
  bundle exec sidekiq
```

### CLI

The CLI in this case is just a simple Thor task for demonstration purposes. In
real life you'd probably have a small script in bin to load Thor and use it
more like a traditional CLI. There is nothing stopping you from using another
CLI framework though.

```bash
  bundle exec thor worker:start
```

You will see a worker executes on the backend and streams its progress back to
your client (the thor task).

## How Does this Work?

### 1. Thor task connects to Rails' WebSocket Server (ActionCable)

The thor worker:start task (located in lib/tasks/worker.thor), connects to
Rails' websocket server running on localhost:3000, and it does so
asynchronously. It connects to the route /cable, which is the the default
ActionCable route, and it passes a "client_id" parameter to the /cable route.

These parameters are processed in app/channels/application_cable/connection.rb

In there, the 'connect' method is called when a connection is made, and that's
how you set WebSocket session parameters.

### 2. ActionCable now sends a "welcome" message to the Thor task (your CLI)

Rails sends you a message of type 'welcome,' which calls a callback in the
thor worker code called "on_connected."

### 3. Thor task sends a "subscribe" message to ActionCable

The on_connected callback sends a subscribe message to ActionCable for the
channel 'WorkerChannel' which is defined in app/channels/worker_channel.rb.

### 4. WorkerChannel Starts Stream for Client

The WorkerChannel's subscribe method calls stream_for to client_#{client_id}.

This is the reference that the rest of the app will use to send messages to
this client.

### 5. ActionCable sends a 'confirm_subscription' message to Thor task (your CLI)

Once the Thor task receives this confirmation (remember it is waiting in an
async loop executing callbacks on each message received), it calls the
'on_subscribed' method on account of the message type (confirm_subscription).

### 6. Thor task hits the /workers/start route to start a background job

The on_subscribed callback hits the /workers/start route (defined with all
routes in config/routes.rb) which is configured to route to the
WorkersController's start method. The task passes its client_id in the
request parameters, which allows us to communicate back to the client
since the WorkerChannel utilized its client ID to create a streaming
channel.

### 7. Worker's 'perform_async' called by the WorkersController

Worker is a class defined in app/workers/worker.rb. This is a Sidekiq worker
that really doesn't do much but sleep and broadcast messages to the client.

### 8. The End

The Thor task will receive various messages that the worker started, updated,
etc which you can see in the Worker class (app/workers/worker.rb). Note the
callbacks on the Thor task to see what draws the progress bar on the screen.

## Can I see the difference between a newborn Rails app and this?

This is very close to a default Rails app with a small amount of code added
to show you how easy it is to get going with such advanced architecture. To
see these changes run:

```shell
  git diff 93556557bcee94711920d3692c5abe0ad57a897b..9be03fb7d0fe4c9a4a9c75750fb92fc2b7c830aa
```

