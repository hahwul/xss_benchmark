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
  endpoints = (1..20).map do |i|
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
