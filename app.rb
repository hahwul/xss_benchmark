# frozen_string_literal: true

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

# Helper for HTML template
def html_template(title, content)
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>#{title}</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case #{title}</h1>
      #{content}
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Index page listing all endpoints
get '/' do
  endpoints = (1..50).map do |i|
    "<li><a href='/#{i}?query=test'>Endpoint #{i}</a></li>"
  end.join("\n")

  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>XSS Benchmark</title>
    </head>
    <body>
      <h1>XSS Benchmark Server</h1>
      <p>Each endpoint has a different XSS vulnerability pattern. Use the <code>query</code> parameter.</p>
      <ul>
        #{endpoints}
      </ul>
    </body>
    </html>
  HTML
end

# Case 1: Basic reflected XSS in HTML body
get '/1' do
  query = params[:query] || ''
  html_template('1', "<p>Search result for: #{query}</p>")
end

# Case 2: XSS in HTML attribute (unquoted)
get '/2' do
  query = params[:query] || ''
  html_template('2', "<input type=text value=#{query}>")
end

# Case 3: XSS in HTML attribute (single quoted)
get '/3' do
  query = params[:query] || ''
  html_template('3', "<input type='text' value='#{query}'>")
end

# Case 4: XSS in HTML attribute (double quoted)
get '/4' do
  query = params[:query] || ''
  html_template('4', "<input type=\"text\" value=\"#{query}\">")
end

# Case 5: XSS in href attribute
get '/5' do
  query = params[:query] || ''
  html_template('5', "<a href=\"#{query}\">Click here</a>")
end

# Case 6: XSS in script tag context
get '/6' do
  query = params[:query] || ''
  html_template('6', "<script>var data = '#{query}';</script><p>Check console</p>")
end

# Case 7: XSS in script tag with double quotes
get '/7' do
  query = params[:query] || ''
  html_template('7', "<script>var data = \"#{query}\";</script><p>Check console</p>")
end

# Case 8: XSS in onclick event handler
get '/8' do
  query = params[:query] || ''
  html_template('8', "<button onclick=\"alert('#{query}')\">Click me</button>")
end

# Case 9: XSS in img src attribute
get '/9' do
  query = params[:query] || ''
  html_template('9', "<img src=\"#{query}\" alt=\"image\">")
end

# Case 10: XSS in img onerror attribute
get '/10' do
  query = params[:query] || ''
  html_template('10', "<img src=\"x\" onerror=\"console.log('#{query}')\">")
end

# Case 11: XSS in style attribute
get '/11' do
  query = params[:query] || ''
  html_template('11', "<div style=\"background: #{query}\">Styled div</div>")
end

# Case 12: XSS in textarea
get '/12' do
  query = params[:query] || ''
  html_template('12', "<textarea>#{query}</textarea>")
end

# Case 13: XSS in title tag
get '/13' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>#{query}</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 13</h1>
      <p>Check the page title</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 14: XSS in iframe src
get '/14' do
  query = params[:query] || ''
  html_template('14', "<iframe src=\"#{query}\" width=\"300\" height=\"200\"></iframe>")
end

# Case 15: XSS in SVG
get '/15' do
  query = params[:query] || ''
  html_template('15', "<svg><text x=\"10\" y=\"20\">#{query}</text></svg>")
end

# Case 16: XSS in data attribute
get '/16' do
  query = params[:query] || ''
  html_template('16', "<div data-info=\"#{query}\">Data attribute content</div>")
end

# Case 17: XSS in meta refresh
get '/17' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta http-equiv="refresh" content="0;url=#{query}">
      <title>17</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 17</h1>
      <p>Meta refresh redirect</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 18: XSS in object data attribute
get '/18' do
  query = params[:query] || ''
  html_template('18', "<object data=\"#{query}\">Object content</object>")
end

# Case 19: XSS in embed src
get '/19' do
  query = params[:query] || ''
  html_template('19', "<embed src=\"#{query}\">")
end

# Case 20: XSS in form action
get '/20' do
  query = params[:query] || ''
  html_template('20', "<form action=\"#{query}\"><input type=\"submit\" value=\"Submit\"></form>")
end

# Case 21: XSS in body onload event
get '/21' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>21</title>
    </head>
    <body onload="console.log('#{query}')">
      <h1>XSS Benchmark - Case 21</h1>
      <p>Body onload event</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 22: XSS in onmouseover event handler
get '/22' do
  query = params[:query] || ''
  html_template('22', "<div onmouseover=\"alert('#{query}')\">Hover over me</div>")
end

# Case 23: XSS in onfocus event handler
get '/23' do
  query = params[:query] || ''
  html_template('23', "<input type=\"text\" onfocus=\"alert('#{query}')\" value=\"Click me\">")
end

# Case 24: XSS in oninput event handler
get '/24' do
  query = params[:query] || ''
  html_template('24', "<input type=\"text\" oninput=\"console.log('#{query}')\">")
end

# Case 25: XSS in onchange event handler
get '/25' do
  query = params[:query] || ''
  html_template('25', "<select onchange=\"console.log('#{query}')\"><option>Choose</option><option>Option 1</option></select>")
end

# Case 26: XSS in JavaScript template literal
# Note: Template literals use backticks which can be tricky to escape
get '/26' do
  query = params[:query] || ''
  html_template('26', "<script>var msg = `Hello #{query}`;</script><p>Check console</p>")
end

# Case 27: XSS in innerHTML context (DOM XSS simulation)
get '/27' do
  query = params[:query] || ''
  html_template('27', "<div id=\"target\"></div><script>document.getElementById('target').innerHTML = '#{query}';</script>")
end

# Case 28: XSS in document.write context (DOM XSS simulation)
get '/28' do
  query = params[:query] || ''
  html_template('28', "<script>document.write('#{query}');</script>")
end

# Case 29: XSS in HTML comment
get '/29' do
  query = params[:query] || ''
  html_template('29', "<!-- User comment: #{query} --><p>Check page source for comment</p>")
end

# Case 30: XSS in style tag
get '/30' do
  query = params[:query] || ''
  html_template('30', "<style>.test { color: #{query}; }</style><p class=\"test\">Styled text</p>")
end

# Case 31: XSS in base tag href
get '/31' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <base href="#{query}">
      <title>31</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 31</h1>
      <p>Base tag injection</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 32: XSS in link href (stylesheet)
get '/32' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <link rel="stylesheet" href="#{query}">
      <title>32</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 32</h1>
      <p>Link stylesheet injection</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 33: XSS in script src attribute
get '/33' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <script src="#{query}"></script>
      <title>33</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 33</h1>
      <p>Script src injection</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 34: XSS in img srcset attribute
get '/34' do
  query = params[:query] || ''
  html_template('34', "<img srcset=\"#{query}\" alt=\"image\">")
end

# Case 35: XSS in video poster attribute
get '/35' do
  query = params[:query] || ''
  html_template('35', "<video poster=\"#{query}\" controls><source src=\"movie.mp4\"></video>")
end

# Case 36: XSS in video src attribute
get '/36' do
  query = params[:query] || ''
  html_template('36', "<video src=\"#{query}\" controls></video>")
end

# Case 37: XSS in audio src attribute
get '/37' do
  query = params[:query] || ''
  html_template('37', "<audio src=\"#{query}\" controls></audio>")
end

# Case 38: XSS in source src attribute
get '/38' do
  query = params[:query] || ''
  html_template('38', "<video controls><source src=\"#{query}\"></video>")
end

# Case 39: XSS in track src attribute
get '/39' do
  query = params[:query] || ''
  html_template('39', "<video controls><track src=\"#{query}\" kind=\"subtitles\"></video>")
end

# Case 40: XSS in formaction attribute
get '/40' do
  query = params[:query] || ''
  html_template('40', "<form><button formaction=\"#{query}\" type=\"submit\">Submit</button></form>")
end

# Case 41: XSS in iframe srcdoc attribute
get '/41' do
  query = params[:query] || ''
  html_template('41', "<iframe srcdoc=\"#{query}\" width=\"300\" height=\"200\"></iframe>")
end

# Case 42: XSS in SVG onload event
get '/42' do
  query = params[:query] || ''
  html_template('42', "<svg onload=\"alert('#{query}')\"><circle cx=\"50\" cy=\"50\" r=\"40\"/></svg>")
end

# Case 43: XSS in SVG href (xlink:href)
get '/43' do
  query = params[:query] || ''
  html_template('43', "<svg><a href=\"#{query}\"><text x=\"10\" y=\"20\">Click me</text></a></svg>")
end

# Case 44: XSS in MathML context
get '/44' do
  query = params[:query] || ''
  html_template('44', "<math><mtext>#{query}</mtext></math>")
end

# Case 45: XSS in details/summary tag
get '/45' do
  query = params[:query] || ''
  html_template('45', "<details ontoggle=\"console.log('#{query}')\"><summary>Click to expand</summary><p>Content</p></details>")
end

# Case 46: XSS in marquee tag (deprecated HTML element, included for legacy testing)
get '/46' do
  query = params[:query] || ''
  html_template('46', "<marquee onstart=\"alert('#{query}')\">Scrolling text</marquee>")
end

# Case 47: XSS in contenteditable attribute
get '/47' do
  query = params[:query] || ''
  html_template('47', "<div contenteditable=\"true\" onfocus=\"alert('#{query}')\">Edit this text</div>")
end

# Case 48: XSS in autofocus attribute
get '/48' do
  query = params[:query] || ''
  html_template('48', "<input autofocus onfocus=\"alert('#{query}')\">")
end

# Case 49: XSS in JSON context
# Note: Unescaped quotes in query can break JSON parsing, demonstrating injection risk
get '/49' do
  query = params[:query] || ''
  html_template('49', "<script>var config = {\"name\": \"#{query}\"};</script><p>Check console</p>")
end

# Case 50: XSS in noscript tag
get '/50' do
  query = params[:query] || ''
  html_template('50', "<noscript>#{query}</noscript><p>Enable JavaScript to hide content</p>")
end
