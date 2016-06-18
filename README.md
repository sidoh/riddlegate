# riddlegate
Riddlegate is a little server that enables you to automate gate buzzers you often find in apartment buildings. It works in conjuction with [Twilio](http://twilio.com) (which, among other things, allows you to call webhooks when a phone number is called).

#### What you'll need for this to work:

1. A [Twilio](http://twilio.com) account and number. Twilio offers numbers for $1/month and ~$0.01 per call. Your buzzer gate will need to be configured to direct calls to this number.
2. An externally accessible web server to run riddlegate on.

## Setup

#### Run it

Make sure Ruby is installed on your system. [rbenv](https://github.com/rbenv/rbenv) is a nice way to manage ruby installs.

Check out the project somewhere:
```
git clone git@github.com:sidoh/riddlegate.git ./riddlegate && cd ./riddlegate
```

Install the bundle (libraries):
```
bundle install
```

Start the server (you can use `bin/stop` to stop it):
```
bin/start
```

By default, the server listens on port 8000. To change that behavior, edit `./config/puma/production.rb`.

#### Configure it

The remainder of the configuration is done through the web UI. Access it (by default) at `http://your-servers-host:8000`. The default credentinals to the admin area are admin/hunter2.

Configuration parameters should be roughly self-explanatory. Hover over questionmark icons for a description.

#### Make it accessible

Do whatever you need to to make the riddlegate web server accessible to the outside world. I use nginx to proxy:

```
upstream riddlegate {
  server http://127.0.0.1:8000;
}

server {
  listen 80;
  server_name rg.mydomain.com;

  location / {
    try_files index.htm index.html @riddlegate;
  }

  location @riddlegate {
    proxy_redirect     off;

    proxy_set_header   X-Forwarded-Proto $scheme;
    proxy_set_header   Host              $http_host;
    proxy_set_header   X-Real-IP         $remote_addr;
    proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;

    proxy_pass http://riddlegate;
  }
}
```

#### Configure Twilio

In the settings for your Twilio number, configure it to direct calls to send HTTP POST requests to riddlegate's Twilio webhook, which is:

```
http://your-twilio-address/twilio
```

## Security

There are a few things you can do that'll help secure riddlegate:

1. Change the admin credentials.
2. Change permissions of riddlegate's database file (`./db/sqlite3.db`) to 0600 and run riddlegate as the same user that owns the file.
3. Serve over HTTPS. Putting riddlegate behind nginx is an easy way to enable that. Note that if you're using a self-signed cert, you'll need to update your Twilio settings to allow for that.
4. Enable API and Twilio request validation. This ensures requests sent to riddlegate are from the parties you expect them to be.

## API

Riddlegate comes equipped with an API that allows you to control the same settings you see in the admin area. The endpoint is `PUT /api/settings`, and the following parameters are supported:

1. `mode` possible values: locked, unlocked, forward
2. `recording_url`
3. `passcode`
4. `forward_number`
5. `timeout`

#### Security

You can either secure the API endpoint by requiring users authenticate with the same admin username/password, or by providing an HMAC signature with the key configured in the admin area.

Here is a groovy snippet used to send signed requests to Riddlegate. Note that what's being signed is a concatenation of the request URI, sorted and concatenated parameters, and the timestamp.

```groovy
def hmac(String data, String key) throws SignatureException {
  final Mac hmacSha1;
  try {
    hmacSha1 = Mac.getInstance("HmacSHA1");
  } catch (Exception nsae) {
    hmacSha1 = Mac.getInstance("HMAC-SHA-1");         
  }
  
  final SecretKeySpec macKey = new SecretKeySpec(key.getBytes(), "RAW");
  hmacSha1.init(macKey);
  
  final byte[] signature =  hmacSha1.doFinal(data.getBytes());
  
  return signature.encodeHex()
}

def sendUpdateCommand(params) {
	log.info "sending update command. params: $params"
    
    long time = new Date().getTime() 
    time /= 1000L
    
    final def endpoint = settings.endpoint
    final def hmacSecret = settings.hmacSecret;
    final def uri = "${endpoint}/api/settings"
	  final def payload = uri + params.sort { it.key }.inject('') { a,k,v -> a+k+v } + time
    
    final String signature = hmac(payload, hmacSecret);

    httpPut(
    	[
        	uri: uri,
			    body: params,
          headers: [
          	'X-Signature-Timestamp': time,
            'X-Signature': signature,
            'X-Computed-Payload': payload
          ]
        ]
    )
}
```

## Why "riddlegate?"
[(![The Riddle Gate](http://i.imgur.com/IiyEupU.png)](https://www.youtube.com/watch?v=jbK8UfalSEQ)

Unfortunately, riddlegate doesn't come equipped with eye-lasers.
