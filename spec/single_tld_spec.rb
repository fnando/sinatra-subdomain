require "spec_helper"

describe "single TLD" do
  let(:tld) { ".org" }
  it_behaves_like "subdomain"
end
