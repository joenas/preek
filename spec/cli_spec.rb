require 'spec_helper'
require 'capture_helper'
require 'preek/cli'

describe Preek::CLI do
  include CaptureHelper

  def test_file(file_name)
    File.expand_path(File.join(File.dirname(__FILE__),'test_files/',"#{file_name}.rb"))
  end

  describe "#version" do
    When(:output) { capture(:stdout) { subject.version} }
    Then {output.should =~ /(\d\.?){3}/}
  end

  describe "#smell" do

    When(:output) { capture(:stdout) { subject.smell(*args) } }

    context "with non-existing file in ARGS" do
      Given(:args) { ['i/am/not/a_file'] }
      Then{output.should_not include("success")}
      Then{output.should include("No such file")}
      Then{output.should include(args[0])}
    end

    context 'default quiet report' do

      context "when given file has no smells" do
        Given(:args){ [test_file('non_smelly')] }
        Then{output.should include("No smells")}
        Then{output.should_not include(args[0])}
      end

      context "when given file has no smells" do
        Given(:args){ [test_file('non_smelly'), 'i/am/not/a_file'] }
        Then{output.should include("No smells")}
        Then{output.should_not include(args[0])}
        Then{output.should include("No such file")}
        Then{output.should include(args[1])}
      end

      context "when given file has Irresponsible smell" do
        Given(:args){ [test_file('irresponsible')] }
        Then{output.should include("No smells")}
        Then{output.should_not include(args[0])}
      end

      context "when given a file with two smelly classes" do
        Given(:args){ [test_file('two_smelly_classes')] }
        Then{output.should include('SecondSmelly')}
        Then{output.should include('UncommunicativeMethodName')}
      end

      context "when given two smelly files" do
        Given(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
        Then{output.should include('UncommunicativeMethodName', 'TooManyStatements')}
        Then{output.should include(args[0], args[1])}
        Then{output.should include("#loong_method", "#x")}
      end

      context "when given one file without smells and another with smells" do
        Given(:args){ [test_file('non_smelly'), test_file('too_many_statements')] }

        Then{output.should include('TooManyStatements')}
        Then{output.should include(args[1])}
        Then{output.should include("#loong_method")}
        Then{output.should_not include(args[0])}
      end

      context "when given file has NilCheck smell" do
        Given(:args){ [test_file('nil_check')] }
        Then{output.should include("NilCheck")}
        Then{output.should include(args[0])}
      end
    end

    context 'with --irresponsible option' do
      Given{subject.options =  {irresponsible: true} }

      context "when given file has Irresponsible smell" do
        Given(:args){ [test_file('irresponsible')] }
        Then{output.should include("Irresponsible")}
      end

      context "when given a file with two smelly classes" do
        Given(:args){ [test_file('two_smelly_classes')] }
        Then{output.should include('FirstSmelly', 'SecondSmelly')}
        Then{output.should include('IrresponsibleModule', 'UncommunicativeMethodName')}
      end

      context "when given two smelly files" do
        Given(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
        Then{output.should include('IrresponsibleModule', 'UncommunicativeMethodName', 'TooManyStatements')}
        Then{output.should include(args[0], args[1])}
        Then{output.should include("#loong_method", "#x")}
      end

      context "when given a file with two different smells" do
        Given(:args){ [test_file('irresponsible_and_lazy')] }
        Then{output.should include('IrresponsibleModule', 'UncommunicativeMethodName')}
      end
    end

    context 'with --verbose option' do
      Given{subject.options =  {verbose: true}}

      context "when given file has no smells" do
        Given(:args){ [test_file('non_smelly')] }
        Then{output.should include("No smells")}
        Then{output.should include(args[0])}
      end

      context "when given two smelly files" do
        Given(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
        Then{output.should include(args[0], args[1])}
      end

      context "when given one file without smells and another with smells" do
        Given(:args){ [test_file('non_smelly'), test_file('too_many_statements')] }
        Then{output.should include(args[1], args[0])}
      end
    end
  end
end