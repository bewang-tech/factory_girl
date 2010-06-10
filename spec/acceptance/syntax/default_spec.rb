require 'spec_helper'

describe "default syntax" do
  before do
    Factory.sequence(:email) { |n| "somebody#{n}@example.com" }
    Factory.define :user do |factory|
      factory.first_name { 'Bill'               }
      factory.last_name  { 'Nye'                }
      factory.email      { Factory.next(:email) }
    end
  end

  after do
    Factory.factories.clear
    Factory.sequences.clear
  end

  describe "after making an instance" do
    before do
      @instance = Factory(:user, :last_name => 'Rye')
    end

    it "should use attributes from the definition" do
      @instance.first_name.should == 'Bill'
    end

    it "should evaluate attribute blocks for each instance" do
      @instance.email.should =~ /somebody\d+@example.com/
      Factory(:user).email.should_not == @instance.email
    end
  end
end

describe "defining a factory" do
  before do
    @name    = :user
    @factory = "factory"
    stub(@factory).factory_name { @name }
    @options = { :class => 'magic' }
    stub(Factory).new { @factory }
  end

  after { Factory.factories.clear }

  it "should create a new factory using the specified name and options" do
    mock(Factory).new(@name, @options) { @factory }
    Factory.define(@name, @options) {|f| }
  end

  it "should pass the factory do the block" do
    yielded = nil
    Factory.define(@name) do |y|
      yielded = y
    end
    yielded.should == @factory
  end

  it "should add the factory to the list of factories" do
    Factory.define(@name) {|f| }
    @factory.should == Factory.factories[@name]
  end

  it "should allow a factory to be found by name" do
    Factory.define(@name) {|f| }
    Factory.factory_by_name(@name).should == @factory
  end
end
