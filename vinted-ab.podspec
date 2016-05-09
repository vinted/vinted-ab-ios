Pod::Spec.new do |s|
  s.name             = "vinted-ab"
  s.version          = "1.1.0"
  s.summary          = "Vinted AB testing framework."

  s.description  = <<-DESC
Vinted AB testing framework.
* What it is - Vinted AB testing framework is used to determine
whether an identifier belongs to a particular ab test and which
variant of that ab test. Identifiers will usually represent users,
but other scenario are possible.
* High-level description - Identifiers are divided into some
number of buckets, using hashing. Before a test is started,
buckets are chosen for that test. That gives the ability to
pick the needed level of isolation. Each test also has a seed,
which is used to randomise how users are divided among test
variants.
DESC
  s.homepage     = "https://github.com/vinted/vinted-ab-ios"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrius Janauskas" => "andrius.janauskas@vinted.com" }
  s.source       = { :git => "https://github.com/vinted/vinted-ab-ios", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'vinted-ab/Classes/*'
  s.public_header_files = 'vinted-ab/Classes/*.h'

  s.dependency 'JKBigInteger', '~> 0.0.1'
  s.dependency 'JSONModel', '~> 1.0.1'
end
