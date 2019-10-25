# Qaa_helpers

## Description
This Helpers contains helpers that used in both Mobile and Desktop

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'qaa_helpers'
```

## Usage
```ruby
# get list of helpers for Mobile theme and Desktop theme
require 'qaa/qaa_helpers'
```
## Contributing
Create ticket on jira, project WSAT, component qaa_helpers for any bug found, or improvement suggestion

## Improvement
More helpers will be added: logger-helper, report-helper, price-helper, hook-helper 

## More information

## Version
* 6.0.5 : support for Cucumber 3, remove watir dependency
* 5.0.1 : add HTTP delete method
* 5.0.0 : remove api config in this gem, rename apihelper to api_handler
* 4.0.1 : make apihelper return a full response of an api request
* 4.0.0 : upgrade apihelper, add put and post method
* 3.0.2 : Fix bug: close log file after writing
* 3.0.1 : Fix bug of default severity
* 3.0.0 : change printing log by logger to writing file 
* 2.0.0 : Change ReportHelper and LoggerHelper to class. Give more info to ReportHelper 
* 1.2.2 : Fix bug logger-helper: cannot debug in ruby 2.3.0 
* 1.2.1 : Fix bug report-helper: does not have screenshot 
* 1.2.0 : adding report-helper
* 1.1.0 : adding logger-helper
* 1.0.1 : hotfix on name, architectures, dependencies
* 1.0.0 : adding uri-helper
