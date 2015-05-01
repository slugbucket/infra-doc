#!/usr/bin/env ruby

require "tiny_tds"
load './InfraDoc.rb'
load './InfraAppList.rb'

begin
  #dbh = DBI.connect('dbi:ODBC:SQL-Mailaliases', 'mailaliases', 'M@!1r0Ut3')
  client = TinyTds::Client.new username: 'istapplist_dev', password: 'istapplist_dev', host: 'localhost', database: 'istapplist_dev'
  
  # Prepare the PDF document
  title = "Infrastructure application list"
  subject = "List of infrastructure applications"
  company = "Magic Widget Company"
  author = "System Administrator"
  version = "1.1"
  info = {:title => title, :subject => subject, :creator => company, :author => author, :version => version}
  pdf = InfraDoc.new
  pdf.stroke_axis
  
  pdf.metadata(info)
  pdf.front_page
  pdf.table_of_contents

  stmta = "SELECT TOP 10 id FROM applications ORDER BY name"

  result = client.execute(stmta)
  result.each(:symbolize_keys => true)

  if result.do then
  puts "Processing #{result.do} applications... "
#    #fh = File.open(tmpfile, 'w')
#    # Output the details for each site
    result.each do |rowset|
#	  puts "Appname: #{rowset[:name]}."
      app = InfraApplication.new(client, rowset[:id])
	  pdf.application_page(app)

	end
  end



  # Add header, footer and page numbers
  pdf.page_header
  pdf.page_footer
  pdf.page_numbers
  pdf.render_file "applist.pdf"

  rescue TinyTds::Error => e
    puts "An error occurred"
    puts "Error message: #{e}"
    ensure # Stuff that must be done at the end of the script
#    # disconnect from server
    client.close if client
end