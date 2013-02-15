require 'spec_helper'

describe Preek::Preek do

  describe "#version" do
    let(:output) { capture(:stdout) { subject.version} }
    it "outputs the gem version in the right format" do
      output.should =~ /(\d\.?){3}/
    end
  end

  describe "#parse" do
    let(:output) { capture(:stdout) { subject.parse(args) } }

    context "with non-existing file in ARGS" do
      let(:args) { ['i/am/not/a_file'] }
      it "outputs 'No such file'" do
        output.should include("No such file")
      end
      it "outputs the name of the file" do
        output.should include(args[0].to_s)
      end
      it "does not assign the file to @files" do
        output
        subject.instance_variable_get("@files").should be_empty
      end
      it "does not call #run_reek_examiner" do
        output
        subject.should_not_receive(:run_reek_examiner)
      end
    end

    context "with existing file in ARGS" do
      let(:args) { [__FILE__] }
      it "outputs stuff" do
        output.should_not be_empty
      end

      it "assigns the file to @files" do
        output
        subject.instance_variable_get("@files").should eq(args)
      end
    end
  end
end