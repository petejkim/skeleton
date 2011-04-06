module FixtureSaver
  # Saves the markup to a fixture file using the given name
  def save_fixture(markup, name)
    fixture_path = File.join(Rails.root, '/tmp/js_dom_fixtures')
    Dir.mkdir(fixture_path) unless File.exists?(fixture_path)
    fixture_file = File.join(fixture_path, "#{name}.fixture.html")
    File.open(fixture_file, 'w') do |file|
      file.puts(markup)
    end
  end

  def all_html
    response.body
  end

  # From the controller spec response body, extracts html identified
  # by the css selector.
  def html_for(selector = 'body')
    doc = Nokogiri::HTML(response.body)

    prepare_html(doc)

    content = doc.css(selector).first.to_s
    convert_body_tag_to_div(content)
  end

  def prepare_html(doc)
    set_sources_to_nothing(doc)
    remove_third_party_scripts(doc)
    remove_iframes(doc)
  end

  def set_sources_to_nothing(doc)
    blank_png = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAQAAAADCAIAAAA7ljmRAAAAGElEQVQIW2P4DwcMDAxAfBvMAhEQMYgcACEHG8ELxtbPAAAAAElFTkSuQmCC'
    images = doc.search('img')
    images.each{ |img| img['src'] = blank_png }

    images = doc.search('*[style*="background"]')
    images.each do |el|
      el['style'] = el['style'].gsub(/url\([^\)]*\)/,"url(#{blank_png})")
    end
  end

  def remove_third_party_scripts(doc)
    scripts = doc.search('.third_party_script') +
              doc.search('script[src]') +
              doc.search('script:contains("fbAsyncInit")')
    scripts.remove if scripts
  end

  def remove_iframes(doc)
    iframes = doc.search('iframe')
    iframes.remove if iframes
  end

  # Many of our css and jQuery selectors rely on a class attribute we
  # normally embed in the <body>. For example:
  #
  # <body class="workspaces show">
  #
  # Here we convert the body tag to a div so that we can load it into
  # the document running js specs without embedding a <body> within a <body>.
  def convert_body_tag_to_div(markup)
    markup.gsub("<body", '<div').gsub("</body>", "</div>")
  end
end
