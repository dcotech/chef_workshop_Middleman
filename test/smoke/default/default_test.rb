# # encoding: utf-8

# Inspec test for recipe middleman::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

describe package %(
  build-essential 
  libssl-dev 
  libyaml-dev 
  libreadline-dev 
  openssl 
  curl 
  git-core 
  zlib1g-dev 
  bison 
  libxml2-dev 
  libxslt1-dev 
  libcurl4-openssl-dev 
  nodejs 
  libsqlite3-dev 
  sqlite3
  apache2
  git
) do
  it { should be_installed }
end

describe service('apache2') do
  it { should be running }
end

describe file ('/etc/apache2/sites-enabled/blog.conf') do
  it { should exist }
end

describe file ('/etc/thin/blog.yml') do
  it { should exist }
end

describe file ('/etc/init.d/thin') do
  it { should exist }
end
