# Stelligent Mini-Project
A Rack project that runs on port 8080 and returns a JSON response that looks like the following:
```json
{
  "message": "Automation for the People",
  "timestamp": 1566515652
}
```

My example site is http://stelligent.homewor.cc/

## How to deploy to Elastic Beanstalk
### Requirements and prerequisites
[See eb.md](eb.md)

### Initialize and deploy
If you already have an Elastic Beanstalk profile set up in ~/.aws/config and ~/.aws/credentials,
   **and** you already have the `eb` CLI installed (note that this is not `aws eb`, just `eb`,
       a completely separate executable), you can skip ahead:
```bash
eb init --profile eb --platform "64bit Amazon Linux 2018.03 v2.10.1 running Ruby 2.6 (Puma)" stelligent
eb create stelligent-$(ENVIRONMENT_SUCH_AS_DEV_OR_PROD)
```

For example, `eb create stelligent-dev`

### Clean up
```bash
eb terminate stelligent-dev
```

## How to deploy elsewhere

### Prerequisites:
#### dev tools installed (for compiling EventMachine, possibly others)
##### Automatically with RVM
Installing rvm will automagically install all the build requirements in most cases.
You can manually kick off the rvm requirements installation using the following command:
```bash
rvm requirements
```

##### Manually on RHEL
If running on AL or another RHEL-based platform:
```bash
sudo yum group install "Development Tools"
```

##### Manually on Debian
If running on Ubuntu or another Debian-based platform:
```bash
sudo apt-get install build-essential
```
#### Ruby
RVM is ideal
```bash
# Install RVM
\curl -sSL https://get.rvm.io | bash -s stable --ruby
# Use the same Ruby I used to develop this package
rvm use --default ruby-2.5.1
``` 

### Install:
```bash
$ cd stelligent && bundle install
```
```ruby
Fetching gem metadata from https://rubygems.org/..............
Resolving dependencies...
Using bundler 1.16.2
Using daemons 1.2.6
Using eventmachine 1.2.7
Using rack 2.0.5
Using thin 1.7.2
Bundle complete! 2 Gemfile dependencies, 5 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

### Run:
```bash
$ bundle exec rackup -E $TEST_DEVELOPMENT_DEPLOY
```
Obviously you should not use the actual variable `$TEST_DEVELOPMENT_DEPLOY`...
For example, `-E development`, or `-E test`.

```ruby
Thin web server (v1.7.2 codename Bachmanity)
Maximum connections set to 1024
Listening on 0.0.0.0:8080, CTRL+C to stop
```

### Example results:
#### Default "/" path
This is the default, and also the only actual requirement from Stelligent
```bash
curl $SERVER_IP:8080/
```
```json
{"message":"Automation for the People","timestamp":1566515652}
```

#### App uptime
```bash
curl $SERVER_IP:8080/service
```
```json
{"siteUpSince":"2018-10-14 03:43:46 +0200","IPs":{"123.45.67.89":9}}
```

## FAQ
### How do I associate git branches with Elastic Beanstalk application stack environments?
[Check out the FOO branch and then \`eb use BAR\` to associate the branch with the environment](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-cli-git.html#eb3-cli-git.branches)

#### Server (host) uptime
```bash
curl $SERVER_IP:8080/system
```
```json
{"siteUpSince":"2018-01-07 00:07:14 +0100","IPs":{"123.45.167.89":4}}
```

## Original text:
> ## Stelligent Mini-Project ##
> This is your chance to WOW us and showcase your experience! Build an application in the
> programming language of your choice that exposes a REST endpoint that returns a following
> JSON payload with the current timestamp and a static message:
> ```json
> {
>   “message”: “Automation for the People”,
>   “timestamp”: 1529611161
> }
> ```
> Write code in a programming language (or languages, configuration management platforms, etc.) of your
> choice that provisions an environment in AWS to run the application you built.
>
> ### Requirements: ###
> * AWS must be the target infrastructure.
>     * Should be able to run in any AWS account.
> * Single Command/One-Click launch of environment.
>     * Some prerequisites are OK as long as it is properly documented.
> * Commit all code to the private repository that is provided for you in Github.
> * Include a README.MD containing detailed directions on how to run, what is running, and how to cleanup.
> * Include some form of automated tests. Demonstrate a test-first mentality.
