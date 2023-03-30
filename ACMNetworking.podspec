Pod::Spec.new do |spec|
    spec.name         = "ACMNetworking"
    spec.version      = "1.1.1"
    spec.summary      = "ACMNetworking iOS Library"
    spec.description  = <<-DESC
            ACMNetworking is a package that help developers to make requests easily.
                     DESC

    spec.homepage     = "https://github.com/AppcentMobile/ACMNetworking"  
    spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENCE" }  
    spec.author       = "burak"
    spec.platform     = :ios
    spec.ios.deployment_target  = '13.0'
    spec.swift_version = '5.0'  
    spec.source       = { :git => "https://github.com/AppcentMobile/ACMNetworking.git", :tag => "#{spec.version}" }
    spec.source_files  = "Sources/**/*.{h,m,swift}"
  end
