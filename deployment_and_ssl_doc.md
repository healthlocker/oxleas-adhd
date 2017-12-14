# Deploy a Oxleas type application to an Azure instance

This readme will go through the steps needed to deploy an application similar
to Oxleas to an Azure instance that has been Provisioned by SLaM and will assume
you have both. You will also need to have an AWS SES account set up and ready to
use.

This documentation is also used as a basis for deploying similar applications,
which are listed below.

* [Healthlocker](https://github.com/healthlocker/healthlocker/blob/master/deployment_and_ssl.md)

If this document is added to, please ensure the specific instructions in other
documentation is updated accordingly.

## Before you get started
In order to go through all the steps in this README, you will need:

* An Linux VM which you have access to
* A Phoenix application that you want to deploy to Azure
* A domain name (or multiple) registered for the IP address of the server

## Local development

A `Vagrantfile` has been created in order to build a consistent and ready-to-roll development environment.  Your *regular* vagrant installation should be able to create a suitably provisioned VM with a command along with lines of:

```
vagrant up
```

### Running app locally ###

Note: these commands featured *within* the `Vagrantfile` for the Healthlocker app, however, since spinning up a local VM *might not* be for the purposes of running the app (it could be to deploy), these steps have been moved here.

After provisioning and spinning up the local development VM, ssh on to it as you would usually for your Vagrant setup and run the following two sets of commands (first set only required for the initial set up):

#### One time (provision) commands ####

```
cd /home/ubuntu/oxleas
mix deps.clean --all
mix deps.get --force
mix deps.compile
mix ecto.create -r Healthlocker.Repo
mix ecto.migrate -r Healthlocker.Repo
mix run priv/repo/seeds.exs
```

#### Run app ####

```
cd /home/ubuntu/oxleas
mix phoenix.server
```

#### Updating codebase ####
If changes are made to the codebase and update to the origin git repository, then update the local development VM with:

```
cd /home/ubuntu/oxleas
git fetch
git checkout <alternate-branch>
git pull 
mix deps.clean --all
mix deps.get --force
mix deps.compile
```

`git checkout` is optional if a branch change is required.  `git pull` will not be required if switching to a new branch.

`mix deps.<command>` lines are only required if there are any dependency changes, see main `mix.exs` file and others at `apps/*/mix.exs`

### 

## Install applications on the Azure instance

If you are running MacOS, get your public key by entering
`cat ~/.ssh/id_rsa.pub` into a terminal. Copy this so it can be used when
accessing the server.  If this command does not work for you (you are running
a different operating system or you do not have a public key saved here), then
you will need to refer to specific documentation for creating and/or retrieving
your public key.

Log in to the server with `ssh "server_user_name"@"IP address of server"` and enter
the password for the server when prompted.

Add your public key to `/home/"server_user_name"/.ssh/authorized_keys`, then save
and exit.

You will also need root access to the server. Type `sudo -i` and paste your
public key into `/root/.ssh/authorized_keys` and type `exit` twice to leave
the ssh session.

`ssh` into your Azure instance as root with `ssh root@"IP address of server"`
and use the following commands.

### Needed to run the application

#### Install Node
```
sudo apt-get update
sudo apt-get install nodejs
sudo apt-get install npm
```

#### Install PostgreSQL
```
apt-get install postgresql postgresql-contrib -y
```

#### Install Erlang
**Note:** Erlang needs to be installed with odbc, including drivers, for
Healthlocker. Please see the
[Healthlocker deployment guide](https://github.com/healthlocker/healthlocker/blob/master/deployment_and_ssl.md)
for instructions on this.

```
apt-get install erlang -y
```

#### Install Elixir
```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install esl-erlang -y
apt-get install elixir
```

#### Install Hex
```
mix local.hex
```

#### Install Phoenix
```
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
```

#### Install tools to build release with edeliver

`sudo apt-get update`

```
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install elixir erlang-base-hipe build-essential erlang-parsetools erlang-dev nodejs -y
```

## Needed to configure server

### Install Nginx
```
sudo apt-get update
sudo apt-get install nginx
```

### Needed to create an ssl certificate

#### Install Certbot
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
```
`sudo apt-get update`

`sudo apt-get install python-certbot-nginx`

## Add environment variables to Azure

You will need to add the environment variables used to run the application
to the `/.profile` file on the server. Some of these will vary from
app to app and most are sensitive so you will have to know the variables you
need to add.

An example of one you will need to add that is not too sensitive is the `PORT`.
Add the port to the `/.profile` with the following...
```
echo export PORT=4000 >> ~/.profile
```

All the other environment variables you need to add will be done following that
pattern.

One of the variables you will need to add to the `/.profile` will be the
`SECRET_KEY_BASE`. You can generate this by running the command
`mix phoenix.gen.secret` in your local terminal.

Here is a list of all the variables you will need to add
```
SES_SERVER
FROM_EMAIL
SMTP_USERNAME
SMTP_PASSWORD
SECRET_KEY_BASE
SES_PORT
TO_EMAIL
APPSIGNAL_APP_ENV
```

**Note:** [Healthlocker](https://github.com/healthlocker/healthlocker/blob/master/deployment_and_ssl.md)
had additional environment variables which need to be added.

If any of the above values have special characters, you may need to open the
profile and add them in with double quotes.

Eg. run `vim ~/.profile`
add a line at the bottom which says:
`export SOME_PASSWORD="$pecial>C%ara<ters"`

Once you have added all the variables you need, run the command
```
source ~/.profile
```

When you have completed all of the steps above exit the server by typing the
word `exit`.

## Create an SSL Certificate

*Note for next install: Try the certbot nginx method by running the command*

```
sudo certbot --nginx certonly
```

*You can see the advanced panel at https://certbot.eff.org/#ubuntuxenial-nginx.*
*If this works, please update the docs accordingly by adding the steps taken,*
*and removing redundant steps eg. may not need to configure nginx.*

Before creating an SSL certificate you must have a domain set up that you want
to use.

For this step you will need to fork the repo that can be found at this url
https://github.com/RobStallion/azure_deployment_test

Clone your forked repo to your local machine with
```
git clone https://github.com/"your organisation name"/azure_deployment_test.git
```

then change into that directory
`cd azure_deployment_test`

Once you have cloned the repo, on your local machine open the `.deliver/config`
in a text editor of your choice.

Once in here update these lines...
```
BUILD_HOST="IP address of server"

PRODUCTION_HOSTS="IP address of server"
```
with the IP address for the Azure server you want to deploy to.

Now go back onto the server with
`ssh root@"IP Address of server"`

You will need to update the nginx config so that the site can run on the domain
you are creating the SSL certificate for. Do this by running the command
`vim /etc/nginx/sites-enabled/default`.

Type `i` to go into insert mode. Find the section that looks like

```
location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
                }
```

Remove the line `try_files $uri $uri/ =404;`.
Add in `proxy_pass http://localhost:4000;`.
It should look like:

```
location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                proxy_pass http://localhost:4000;
                }
```

Press `esc`, then `:wq`.

Reload the nginx config with `service nginx reload`.

In the server run the following
`certbot certonly --manual`

this will have some on screen instructions for you to follow. After you have
entered the domain name that you wish to get a URL for you will be presented
with something like this...
![image](https://user-images.githubusercontent.com/15571853/30211128-97e145a4-9497-11e7-8ff7-e7c76c43ab5a.png)

Once here **DO NOT** continue the certbot steps.

Go back to your text editor and create the file with the same name as the first
half of the content that will be entered into the file.

Example based on image above:
file name `web/static/assets/.well-known/acme-challenge/dwOpiOLomA6F96N7yUmZzg1v2gSB7uhVDO_84eo4av0`
file content `dwOpiOLomA6F96N7yUmZzg1v2gSB7uhVDO_84eo4av0.ofSGgRI932nP_X6z-R1He5F06yk_htZDa-RiUu2ATE4`

Add, commit and push these changes to your master branch and then redeploy your
application to azure with these commands

```
git add .
git commit -m 'add file for certificate'
git push origin master
mix edeliver build release (this step takes a few minutes to complete)
mix edeliver deploy release to production
mix edeliver start production
```

Once you have run the above go back to your terminal and press continue.
If you entered more than one domain name, for example `www.test.com` and
`test.com`, then you will get a similar screen again where you will need to make
another file in `web/static/assets/.well-known/acme-challenge/` with the
given file name and contents. **DO NOT** delete the file you already made.
Run through the commands above this paragraph again, and click continue.

Certbot will continue running and when it finishes you should get a screen with
the following...
![image](https://user-images.githubusercontent.com/15571853/30107133-c6288e5c-92f5-11e7-965d-640f19ad40db.png)

Before exiting the server, run the command `ls /etc/letsencrypt/live` and
make a note of what displays. You will need this when you set up the nginx
config.

You can exit the server now with the command `exit`.
Stop the server once you have exited with the command `mix edeliver stop production`

## Use Edeliver to Deploy Application to Azure

Now in the terminal on your local machine `cd` into the directory where you
have cloned the application you want to deploy.

Open the `.deliver/config` in a text editor of your choice.

Once in here update these lines... (same as step above)
```
BUILD_HOST="staging machine IP address"
...
STAGING_HOSTS="staging machine IP address"
...
PRODUCTION_HOSTS="production machine IP address"
```
with the IP addresses for the staging and production Azure servers you want to deploy to.

**Note:** *build* host is singular, whereas *staging* and *production* is plural.  

Next run the following commands individually in your terminal, specifying deployment and app start on *either* `staging` or `production`:

```
mix edeliver build release (this step takes a few minutes to complete)
mix edeliver deploy release to <staging | production> 
mix edeliver start <staging | production>
```

This will build and deploy the current `master` branch.  In order to use a different branch, alter the first command as:

```
mix edeliver build release --branch=<branch-name>
```


## Update nginx configuration file

In your text editor open the file `nginx.config`

Everywhere that it says "enter your domain name" replace that sentence with the
domain name you will be using. This is what displayed when you typed in
`ls /etc/letsencrypt/live` while you were on the server.

For example

```
server_name "enter your domain name";
```
could become
```
server_name test-focus.headscapegreenwich.co.uk;
```

when you have changed all the places where you see that sentence (there should
be four to change), highlight and copy the entire file to your clipboard.

`ssh` back into the virtual machine with `ssh root@"IP Address of server"`

then run this command
```
vim /etc/nginx/sites-enabled/default
```

this will take you into the vim text editor. When in **type**

```
:set paste
```
the press return

Next press
`shift_key + v `
followed by
`shift_key + g`
followed by
`d`

Then press `i` to enter insert mode and press `cmd/ctrl + v` to paste what you
copied earlier into this file.

When you have done this press the
`esc_key`
followed by
`:wq`

On the virtual machine run the command
`service nginx reload`

Exit your server by typing the command `exit`.

## Add super_admin user to database

**Note:** You do not need to add a `super_admin` for
[Healthlocker](https://github.com/healthlocker/healthlocker/blob/master/deployment_and_ssl.md).
However, there are other roles which may need to be updated. Please see the
Healthlocker deployment guide for more details.


On the virtual machine run the commands

```
cd /home/"server_user_name"/"app_name"/builds (example: cd /home/oxleasadmin/oxleas_adhd/builds/)
mix ecto.create
mix ecto.migrate
sudo -u postgres psql
\connect "name_of_the_database_your_app_uses" (e.g. \connect oxleas_adhd_dev)
```

When here you will have to enter a `super_admin` into the `users` table. You can
get all the information you need to enter a `super_admin` by copying the
`super_admin` used on the `Oxleas-HL-Test` server.

To get that information open a new tab in your terminal and enter the following
```
ssh root@"IP address of Oxleas-HL-Test"
sudo -u postgres psql
\connect oxleas_adhd_dev
select * from users where role = 'super_admin';
```

That will display the `super_admin` info on screen.

Now go back to the original tab where you wanted to insert a `super_admin` user
and run the following command filling in the blanks with the information you can
see in the other tab you opened earlier.

```
insert into users (id, email, password_hash, role, first_name, last_name, inserted_at, updated_at, job_role) values ('', '', '', '', '', '', '', '', '');
```

When you have entered this info type `\q` then press `return`

## Make SSL Certificate renew automatically

Now on the virtual machine run the command
```
vim /etc/cron.daily/renew_ssl_certbot
```

Then **type**

```
:set paste
```

and press `return`.

Copy the code below
```
#!/bin/sh

# this takes less than a minute but will restart nginx once every 60 days
certbot renew --pre-hook "service nginx stop" --post-hook "service nginx start"
```

Once you have copied the above follow the instructions below in order
```
i
cmd + v (paste in the code you copied above)
esc_key
:wq
```

Next, paste the following into the terminal on the virtual machine
```
chmod a+x /etc/cron.daily/renew_ssl_certbot
```

Now type `exit`.

## Check site works

If you have followed all of the above steps you should now be able to navigate
to your domain name in a web browser and see your application running on https.

## Troubleshooting
### Phoenix Ecto.Adapters.SQL.query timeout
If you are redeploying the application and experience errors such as

![Database connection error](https://user-images.githubusercontent.com/151362/30542909-04c6534c-9c79-11e7-91a7-82be388182af.png)

then it is likely that there is a problem with the application accessing the
environment variables that were set in the profile. To resolve this, you must
run **ALL** of the steps to redeploy.

1. Stop the server with `mix edeliver stop production`
1. Build the release with `mix edeliver build release`
1. Deploy release with `mix edeliver deploy release to <staging | production>`
1. Start application with `mix edeliver start <staging | production>`

This issue may occur after:

* Rebooting the server then starting the app again with only step 4 below
(without running through steps 1-3)
* Changing the environment variables, then not running through steps 1-3 below.
The profile is sourced when the release is built, so it's not as simple as
running step 1 & step 4 again.

If you are having trouble stopping the server with
`mix edeliver stop <staging | production>` and it just 'hangs', then you can follow through
a similar process to be able to stop the app this way again.
ssh into the server containing the app you cannot stop with edeliver. Type
`reboot` and hit `enter`. You will automatically exit the server. Wait for
the website to look like below:

![502 error from nginx](https://user-images.githubusercontent.com/151362/30550507-8c337aa6-9c8f-11e7-9f12-c95990c73f01.png)

This means the server has restarted successfully. Run through steps 1-4 above.

### 502 Bad Gateway and crash file present
If a the build, deployment and app start *appeared* to be successful, but the site is just showing an nginx `502 Bad Gateway` error page, then check for an Erlang crash dump file:

1.  SSH on to the staging/production server
2.  `cd ~<server user name>/<app folder>`
3.  `ls -al erl_crash.dump`

If the crash dump file is **recent**, then have a peek at the start with `head erl_crash.dump`.

We have seen examples of the following error:

```
Slogan: could not start kernel pid (application_controller) (error in config file "/home/oxleasadmin/oxleas_adhd/var/sys.config" (none): configuration file must contain ONE list ended by <dot>)
```

On inspection, the `sys.config` file looks fine and *does* contain only one list ended by <dot>.

Fixing seems to involve some combination of ensuring that the app has been *stopped* **prior** to deployment.  Stop the app from the local deployment VM with:

```
mix edeliver stop <staging | production>
```
