#!/usr/bin/env ruby

load './InfraDoc.rb'


begin
  # Document details
  title = "Infrastructure application list"
  subject = "List of infrastructure applications"
  company = "London Business School"
  author = "Julian Rawcliffe"
  version = "1.1"
  info = {:title => title, :subject => subject, :creator => company, :author => author, :version => version}
  pdf = InfraDoc.new
  pdf.stroke_axis
  
  pdf.metadata(info)
  pdf.front_page
  pdf.table_of_contents
  
  pdf.page_header
  pdf.page_footer
  pdf.page_numbers
  
  pdf.render_file "manual.pdf"
end