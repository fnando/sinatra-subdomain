require "spec_helper"

describe "multiple TLDs" do
  let(:tld) { ".com.br" }
  it_behaves_like "subdomain"
end
