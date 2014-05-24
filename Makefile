.PHONY: gem test

gem:
	gem build baikal.gemspec

test:
	ruby test/test_baikal.rb
