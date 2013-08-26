require 'spec_helper'
require 'capture_helper'
require 'preek/cli'

describe Preek::CLI do
  include CaptureHelper

  def test_file(file_name)
    File.expand_path(File.join(File.dirname(__FILE__),'test_files/',"#{file_name}.rb"))
  end

  describe "#version" do
    let(:output) { capture(:stdout) { subject.version} }
    it "outputs the gem version in the right format" do
      output.should =~ /(\d\.?){3}/
    end
  end

  describe "#parse" do
    let(:output) { capture(:stdout) { subject.smell(*args) } }
    let(:args) { ['i/am/not/a_file'] }

    context "with non-existing file in ARGS" do
      let(:args) { ['i/am/not/a_file'] }
      it "does not output 'success'" do
        output.should_not include("success")
      end
      it "outputs 'No such file'" do
        output.should include("No such file")
      end
      it "outputs the name of the file" do
        output.should include(args[0])
      end
    end

    context "when given file has no smells" do
      let(:args){ [test_file('non_smelly')] }
      it "output contains 'success! No smells'" do
        output.should include("No smells")
      end
    end

    context "when given file has Irresponsible smell" do
      let(:args){ [test_file('irresponsible')] }
      it "output contains 'success! No smells'" do
        output.should include("No smells")
      end
    end

    context "when given file has Irresponsible smell with --irresponsible options" do
      let(:args){ [test_file('irresponsible')] }

      before :each do
        subject.options =  {irresponsible: true}
      end

      it "output contains 'Irresponsible'" do
        output.should include("Irresponsible")
      end

    end

    context "when given a file with two smelly classes" do
      let(:args){ [test_file('two_smelly_classes')] }
      it "output contains one classnames" do
        output.should include('SecondSmelly')
      end
      it "output contains one smell" do
        output.should include('UncommunicativeMethodName')
      end
    end

    context "when given a file with two smelly classes with --irresponsible options" do
      let(:args){ [test_file('two_smelly_classes')] }
      before :each do
        subject.options =  {irresponsible: true}
      end

      it "output contains both classnames" do
        output.should include('FirstSmelly', 'SecondSmelly')
      end
      it "output contains both smells" do
        output.should include('IrresponsibleModule', 'UncommunicativeMethodName')
      end
    end

    context "when given a file with two different smells with --irresponsible options" do
      let(:args){ [test_file('irresponsible_and_lazy')] }
      it "output contains both smells" do
        subject.options =  {irresponsible: true}
        output.should include('IrresponsibleModule', 'UncommunicativeMethodName')
      end
    end

    context "when given two smelly files" do
      let(:args){ [test_file('too_many_statements'), test_file('two_smelly_classes')] }
      before :each do
        subject.options =  {irresponsible: true}
      end

      it "output contains all smells" do
        output.should include('IrresponsibleModule', 'UncommunicativeMethodName', 'TooManyStatements')
      end

      it "output contains both filenames" do
        output.should include(args[0], args[1])
      end

      it "output contains the names of the smelly methods" do
        output.should include("#loong_method", "#x")
      end
    end

    context "when given one file without smells and another with smells" do
      let(:args){ [test_file('non_smelly'), test_file('two_smelly_classes')] }
      before :each do
        subject.options =  {irresponsible: true}
      end

      it "output contains all smells" do
        output.should include('IrresponsibleModule', 'UncommunicativeMethodName')
      end

      it "output contains only smelly filename" do
        output.should include(args[1])
      end

      it "output contains the names of the smelly method" do
        output.should include("#x")
      end
    end

    context "when given file has NilCheck smell" do
      let(:args){ [test_file('nil_check')] }
      it "output contains 'NilCheck'" do
        output.should include("NilCheck")
      end
      it "outputs the name of the file" do
        output.should include(args[0])
      end
    end
  end
end