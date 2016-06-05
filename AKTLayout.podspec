#
#  Be sure to run `pod spec lint AKTLayout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "AKTLayout"
  s.version      = "1.2.2"
  s.summary      = "The best framework for automatic layout."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
 * Configure layout attributes. It's a AKTLayout method and you can add layout items such as: top/left/bottom/width/whRatio... into currentView. When you add items you don't need to care about the order of these items. The syntax is very easy to write and understand. In order to meet the requirements, we did a lot in the internal processing. But the performance is still outstanding. I have already no longer use autolayout. Because autolayout has a bad performance especially when the view is complex.In order to guarantee the performance we can handwrite frame code. But it's a boring thing and a waste of time. What should I do? Please try AKTLayout！！！
 * 添加AKTLayout布局属性，你可以为视图添加多种布局项（top/left/bottom/width/whRatio...），当你添加布局项时你不用关心添加的顺序，语法非常容易理解和编写，为了达到要求我们进行了很多内部转换，但是仍然保持了高性能表现，我已经很久不用系统的自动布局，因为在复杂的视图关系中，它的性能表现实在过于糟糕，为了达到性能要求，必须要手写并计算布局代码，这是一件令人乏味而耗费时间的事情，如果你正在被这些问题困扰，可以尝试一下性能优异的AKTLayout！！！
 * https://github.com/AkteamYang/AKTKit.AKTLayout
 * 我们的目标是成为最好的自动布局框架
 * 你的支持将有助于AKTLayout不断提升，欢迎为AKTLayout提供代码支持、改进建议或者为我们点上一颗Star
                   DESC

  s.homepage     = "https://github.com/AkteamYang/AKTKit.AKTLayout"
  s.social_media_url = 'http://www.jianshu.com/users/f448a4768cf5/latest_articles'
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = 'MIT'
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "AKTeamYang" => "battle0001@sina.com" }
  # Or just: s.author    = "AKTeamYang"
  # s.authors            = { "AKTeamYang" => "battle0001@sina.com" }
  # s.social_media_url   = "http://twitter.com/AKTeamYang"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  # s.platform     = :ios, "7.0"

  #  When using multiple platforms
  s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/AkteamYang/AKTKit.AKTLayout.git", :tag => "1.2.2" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  arc_files = "AKTKit/*.{h,m}", "AKTKit/**/*.{h,m}"

  s.source_files  = arc_files
  # s.exclude_files = non_arc_files
  s.requires_arc =  "AKTKit/ARC_File/*.{h,m}", "AKTKit/ARC_File/**/*.{h,m}"
  # s.dependency = "AKTLayout"

  # s.subspec 'AKTLayout' do |cs|
  #   cs.source_files  = non_arc_files
  #   cs.requires_arc = false
  # end

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
