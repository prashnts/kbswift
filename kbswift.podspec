Pod::Spec.new do |s|
  s.name         = "kbswift"
  s.version      = "0.0.1"
  s.summary      = "Keybase API client."
  s.description  = <<-DESC
                   kbswift is a client for `keybase.io`.
                   DESC
  s.homepage     = "https://github.com/prashnts/kbswift"
  s.license      = "MIT"
  s.author             = { "Prashant Sinha" => "prashant+git@noop.pw" }
  s.social_media_url   = "https://twitter.com/prashnts"
  s.source       = {
    :git => "https://github.com/prashnts/kbswift.git",
    :tag => "#{s.version}"
  }

  s.source_files  = 'kbswift/**/*.{swift,h,m}'

  s.ios.deployment_target = "9.2"
  s.osx.deployment_target = "10.11"
  s.requires_arc = true
end
