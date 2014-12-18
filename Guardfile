# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$}) { |m| m[0] }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/cli_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
