require "spec_helper"

describe "bundle pack with gems" do
  describe "when there are only gemsources" do
    before :each do
      gemfile <<-G
        gem 'rack'
      G

      system_gems "rack-1.0.0"
      bundle :pack
    end

    it "locks the gemfile" do
      bundled_app("Gemfile.lock").should exist
    end

    it "caches the gems" do
      bundled_app("vendor/cache/rack-1.0.0.gem").should exist
    end

    describe "when there are any git sources" do
      describe "when floating on master" do
        before :each do
          build_git "foo"

          gemfile <<-G
            source "file://#{gem_repo1}"
            git "#{lib_path('foo-1.0')}" do
              gem 'foo'
            end
          G

          bundle :pack
        end

        fit "caches the repository" do
          bundled_app("vendor/cache/foo/").should exist
        end
      end

      describe "when given a ref" do
=begin TODO
        before(:each) do
          build_git "foo"
          @revision = revision_for(lib_path("foo-1.0"))
          update_git "foo"
        end
=end
      end
    end
  end
end
