require 'spec_helper'
require 'capture_helper'
require 'preek/cli'

describe Preek::CLI do
  include CaptureHelper

  def test_file(file_name)
    File.expand_path(File.join(File.dirname(__FILE__),'test_files/',"#{file_name}.rb"))
  end


  describe 'Commands' do

    context 'errors' do
      When(:output) { capture(:stderr) { Preek::CLI.start args } }

      context 'with no argument' do
        Given(:args){ [] }
        Then{ expect(output).to include("was called with no arguments")}
      end

      context 'with "smell" and no argument' do
        Given(:args){ ['smell'] }
        Then{ expect(output).to include("was called with no arguments")}
      end
    end

    context 'no errors' do
      When(:output) { capture(:stdout) { Preek::CLI.start args } }

      context 'with "smell" and a file as argument' do
        Given(:args){ ['smell', test_file('non_smelly')] }
        Then{expect(output).to include("No smells")}
      end

      context 'with a file as argument' do
        Given(:args){ [test_file('non_smelly')] }
        Then{expect(output).to include("No smells")}
      end

      context 'with "help" as argument' do
        Given(:args){ ['help'] }
        Then{expect(output).to match /Commands:/}
      end

      context 'with "version"' do
        Given(:args){ ['version'] }
        Then {expect(output).to match /(\d\.?){3}/}
      end

      context "with non-existing file in ARGS" do
        Given(:args) { ['i/am/not/a_file'] }
        Then{expect(output).to_not include("success")}
        Then{expect(output).to include("No such file")}
        Then{expect(output).to include(args[0])}
      end
    end
  end

  describe "Reports" do
    When(:output) { capture(:stdout) { Preek::CLI.start args } }

    context 'default quiet report' do

      context "when given file has no smells" do
        Given(:args){ [test_file('non_smelly')] }
        Then{expect(output).to include("No smells")}
        Then{expect(output).to_not include(args[0])}
      end

      context "when given file has no smells and the other does not exist" do
        Given(:args){ [test_file('non_smelly'), 'i/am/not/a_file'] }
        Then{expect(output).to include("No smells")}
        Then{expect(output).to_not include(args[0])}
        Then{expect(output).to include("No such file")}
        Then{expect(output).to include(args[1])}
      end

      context "when given file has no smells" do
        Given(:args){ [test_file('no_smells')] }
        Then{expect(output).to include("No smells")}
        Then{expect(output).to_not include(args[0])}
      end

      context "when given a file with two smelly classes" do
        Given(:args){ [test_file('two_smelly_classes')] }
        Then{expect(output).to include('SecondSmelly')}
        Then{expect(output).to include('UncommunicativeMethodName')}

        describe 'total count' do
          Then{expect(output).to match(/total.*2/)}
        end
      end

      context "when given two smelly files" do
        Given(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
        Then{expect(output).to include('UncommunicativeMethodName', 'TooManyStatements')}
        Then{expect(output).to include(args[0], args[1])}
        Then{expect(output).to include("#loong_method", "#x")}

        describe 'total count' do
          Then{expect(output).to match(/total.*3/)}
        end
      end

      context "when given one file without smells and another with smells" do
        Given(:args){ [test_file('non_smelly'), test_file('too_many_statements')] }

        Then{expect(output).to include('TooManyStatements')}
        Then{expect(output).to include(args[1])}
        Then{expect(output).to include("#loong_method")}
        Then{expect(output).to_not include(args[0])}
      end

      context "when given file has NilCheck smell" do
        Given(:args){ [test_file('nil_check')] }
        Then{expect(output).to include("NilCheck")}
        Then{expect(output).to include(args[0])}
      end
    end

    context 'with --irresponsible option' do
      When(:output) { capture(:stdout) { Preek::CLI.start ['-i'].concat(args) } }

      context "when given file has Irresponsible smell" do
        Given(:args){ [test_file('irresponsible')] }
        Then{expect(output).to include("Irresponsible")}
      end

      context "when given a file with two smelly classes" do
        Given(:args){ [test_file('two_smelly_classes')] }
        Then{expect(output).to include('FirstSmelly', 'SecondSmelly')}
        Then{expect(output).to include('Reek::Smells::IrresponsibleModule', 'Reek::Smells::UncommunicativeMethodName')}
      end

      context "when given two smelly files" do
        Given(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
        Then{expect(output).to include('IrresponsibleModule', 'UncommunicativeMethodName', 'TooManyStatements')}
        Then{expect(output).to include(args[0], args[1])}
        Then{expect(output).to include("#loong_method", "#x")}
      end

      context "when given a file with two different smells" do
        Given(:args){ [test_file('irresponsible_and_lazy')] }
        Then{expect(output).to include('IrresponsibleModule', 'UncommunicativeMethodName')}
      end
    end

    context 'with --verbose option' do
      When(:output) { capture(:stdout) { Preek::CLI.start ['--verbose'].concat(args) } }

      context "when given file has no smells" do
        Given(:args){ [test_file('non_smelly')] }
        Then{expect(output).to include("No smells")}
        Then{expect(output).to include(args[0])}
      end

      context "when given two smelly files" do
        Given(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
        Then{expect(output).to include(args[0], args[1])}
      end

      context "when given one file without smells and another with smells" do
        Given(:args){ [test_file('non_smelly'), test_file('too_many_statements')] }
        Then{expect(output).to include(args[1], args[0])}
      end
    end

    # Also tests proper output fully
    context "with --compact option" do
      Given(:args){ [test_file('too_many_statements')] }
      Given(:dir){File.dirname(__FILE__)}
      Given(:expected_output){"\n-\n\nfile: #{dir}/test_files/too_many_statements.rb\nclass: TooManyStatments\nsmells: \n#loong_method has approx 7 statements (Reek::Smells::TooManyStatements) at lines 4\n\n-\n\ntotal: 1\n\n-\n\n"}
      When(:output) { capture(:stdout) { Preek::CLI.start ['-c'].concat(args) } }
      Then{expect(output).to eq expected_output}
    end

  end

  describe 'Git' do
    Given(:cli) { Preek::CLI.new }
    Given{cli.stub(:git_status).and_return(git_output)}
    When{cli.git}

    context 'with ruby file' do
      Given(:git_output){" M .travis.yml\n M Gemfile\n M lib/random/file.rb\n M preek.gemspec\n"}
      Given{cli.should_receive(:smell).with('lib/random/file.rb')}
      Then{}
    end

    context 'with deleted file' do
      Given(:git_output){" M .travis.yml\n M Gemfile\n M lib/random/file.rb\n D ruby.rb\n"}
      Given{cli.should_receive(:smell).with('lib/random/file.rb')}
      Then{}
    end

    context 'without ruby file' do
      Given(:git_output){" M .travis.yml\n M Gemfile\n M preek.gemspec\n"}
      Given{cli.should_not_receive(:smell)}
      Then{}
    end
  end
end