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

## Testing
Tests use RSpec and [Rack::Test](https://github.com/rack-test/rack-test)

### Manually with RSpec
I recommend using a formatter in order to see the specifics of the tests:
`$ rspec --format documentation`
```
StelligentMiniProject
  get "/"
    should eq 200
    should include "Automation for the People"
  returns the JSON message
    has a content type of JSON

Finished in 0.01576 seconds (files took 0.11677 seconds to load)
3 examples, 0 failures
```

### Automatically with Rake task
```ruby
$ rake

StelligentMiniProject
  when getting "/"
    should eq 200
    should include "Automation for the People"
  when getting "/some_invalid_path/"
    should not eq 200
    should match /4\d\d/
    should eq 404
  when in development or test
    runs on port 8888
  when in deploy or production
    runs on port 8080
  when returning the required JSON message
    has a content type of JSON
    uses an integer timestamp format
    has the appropriate timestamp string length

Finished in 0.03266 seconds (files took 0.18749 seconds to load)
10 examples, 0 failures
```

## Clean up after Elastic Beanstalk deployment
### Terminate the environment
The following command will terminate the entire environment and its application stack in Elastic Beanstalk:
```bash
eb terminate stelligent-dev
```

### Delete old versions
Terminated environments are **not deleted**! They can be restored if desired, such as in a rollback operation.
To completely destroy the environment (and not run into a `TooManyApplicationVersions Exception` when you [hit the limit](https://docs.aws.amazon.com/elasticbeanstalk/latest/api/API_CreateApplicationVersion.html#API_CreateApplicationVersion_Errors)
```bash
# View application versions (even deleted ones):
$ aws elasticbeanstalk describe-application-versions --profile $AWS_PROFILE --region $AWS_REGION | egrep "ApplicationName|VersionLabel"
# Delete old versions:
$ eb labs cleanup-versions --older-than 1 --num-to-leave 1 stelligent
```

You can leave more than one old version by changing the `--older-than` and `--num-to-leave` values.


## FAQ
### How do I associate git branches with Elastic Beanstalk application stack environments?
[Check out the FOO branch and then \`eb use BAR\` to associate the branch with the environment](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-cli-git.html#eb3-cli-git.branches)

## Additional features exposed by the REST endpoint
You can only GET, but it's still technically REST, right? ;)

### Server (host) uptime and visitor IP counts
```bash
curl $SERVER_IP:8080/system
```
```json
{"siteUpSince":"2018-01-07 00:07:14 +0100","IPs":{"123.45.167.89":4}}
```

### Service (application) uptime and visitor IP counts
The service uptime tends to be low, especially relative to the server (instance) uptime. This is due to Puma stopping/starting as load fluctuates
```bash
curl $SERVER_IP:8080/service
```
```json
{"siteUpSince":"2019-08-23 19:34:47 +0000","IPs":{"70.178.62.10":2}}
```

## Original text:
> ## Stelligent Mini-Project ##
> This is your chance to WOW us and showcase your experience! Build an application in the
> programming language of your choice that exposes a REST endpoint that returns a following
> JSON payload with the current timestamp and a static message:
> ```json
> {
>     "message": "Automation for the People",
>     "timestamp": 1566515652
> }
>
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

