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

  #stha = client.prepare(stmta);
  result = client.execute(stmta)
  result.each(:symbolize_keys => true)
#
  if result.do then
  puts "Processing #{result.do} applications... "
#    #fh = File.open(tmpfile, 'w')
#    # Output the details for each site
    result.each do |rowset|
#	  puts "Appname: #{rowset[:name]}."
      app = InfraApplication.new(client, rowset[:id])
      app.name
	  pdf.start_new_page
	  pdf.bounding_box([50,700], :width => 450, :height => 650) do
	    appinfo = [
		[{:content => app.name, :colspan => 4, :align => :left}],
		["Type: #{app.application_type_name}", "Status : #{app.application_status_name}", "Vendor : #{app.vendor_name}", "Shutdown: #{app.dr_shutdown_stage_name}"],
		[{:content => app.description, :colspan => 4, :align => :left}],
		["Contact: #{app.support_contact_name}",
		 "Group: #{app.support_group_name}",
		 "Impact: #{app.impact_level_name}",
		 "Escalation: #{app.escalation_level_name}"],
		[{:content => "Hosts", :colspan => 4}],
		[{:content => "Databases", :colspan => 4}]
		]
	    pdf.table appinfo, :cell_style => {:overflow => :shrink_to_fit, :border_line => [:dotted], :border_width => 0.1, :border_color => "808080"} do
	    row(0).font_style = :bold
	    row(0).background_color = "c0c0c0"
	    row(1).background_color = "e0e0e0"
		row(3).background_color = "e0e0e0"
		row(4).font_style = :bold
	    row(4).background_color = "c0c0c0"
		row(5).font_style = :bold
	    row(5).background_color = "c0c0c0"
	end
	    #pdf.text "#{app.name} - #{app.application_type_name} : #{app.description}", :size => 10
	    #pdf.stroke_bounds
	  end
	end
  end



  # Add header, footer and page numbers
  pdf.page_header
  pdf.page_footer
  pdf.page_numbers
  pdf.render_file "applist.pdf"

  rescue TinyTds::Error => e
    puts "An error occurred"
    puts "Error code: #{e.err}"
    puts "Error message: #{e.errstr}"
    ensure # Stuff that must be done at the end of the script
#    # disconnect from server
    client.close if client
end