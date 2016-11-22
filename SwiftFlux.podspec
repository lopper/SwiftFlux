Pod::Spec.new do |s|
  s.name     = "SwiftFlux"
  s.version  = "0.6.2"
  s.summary  = "Type-Safe Flux implementation for Swift."
  s.homepage = "https://github.com/yonekawa/SwiftFlux"
  s.author = { "Kenichi Yonekawa" => "tcgrim@gmail.com" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"

  s.source = {
    git: "https://github.com/yonekawa/SwiftFlux.git",
    tag: "v0.6.2",
  }
  s.source_files = "SwiftFlux/**/*.swift"

  s.license = {
    :type => "MIT",
    :text => <<-LICENSE
      Copyright (c) 2015 Kenichi Yonekawa
      Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the "Software"), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:
      The above copyright notice and this permission notice shall be included in all
      copies or substantial portions of the Software.
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
      SOFTWARE.
    LICENSE
  }

  s.dependency "Result", "~> 3.0.0"
end
