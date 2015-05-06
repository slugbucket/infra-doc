#!/usr/bin/env ruby

gem 'prawn-table'
require 'prawn'
require 'prawn/table'

# Sample class for Prawn lifted from
# http://adamalbrecht.com/2014/01/14/generate-clean-testable-pdf-reports-in-rails-with-prawn/
class InfraDoc < Prawn::Document
  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","DDDDDD"]
  TABLE_FONT_SIZE = 9
  TABLE_BORDER_STYLE = :grid
  
  def initialize(default_prawn_options={})
    super(default_prawn_options)
    font_size 10
	@info = {}
  end
  # The method below should be to alternate the position of the page number on odd and even pages
  # But it doesn't work: only adds the last odd number to the even page.
  def page_numbers
    string = "<page>"
    odd_options = { :at => [bounds.right - 150, 0],
                            :width => 150,
						    :align => :right,
						    #:page_filter => :odd,
						    :start_at_count => 1}
    even_options = { :at => [0, bounds.left],
                             :width => 150,
                             :align => :left,
                             :page_filter => :even,
                             :start_at_count => 2}
    number_pages string, odd_options
    #number_pages string, even_options
  end
  def metadata(info = {})
    @info = info
	puts @info[:title]
  end
  def front_page(title = nil, subject = nil, company = nil, author = nil)
    bounding_box([50, 300], :width => 400, :height => 250) do
      heading
	end
	move_down 10
	bounding_box([50, 375], :width => 550, :height => 600) do
	  info_box
	  move_down 10
	  revision_history
    end
  end
  def table_of_contents
    start_new_page
	bounding_box([50, 700], :width => 550, :height => 600) do
	  text "Table of contents", :align => :left, :size => 16, :font_style => :bold
	end
  end
  def page_header
    repeat(:all) do
      draw_text "#{@info[:title]} : #{@info[:title]}", :at => bounds.top_left, :size => 10
	end
  end
  def page_footer
    repeat(:all) do
      draw_text "This document is confidential and should not be distributed outside of Groovy Widgets Inc", :at => [50, -20], :size => 10
	end
  end
    ###
  ### Method to export an application's details ###
  ### app: InfraApplication object describing the application
  ###
  def application_page(app = nil)
    nil unless app.id
  puts "Preparing application table for #{app.name}, id #{app.id}"
    start_new_page
	# Get the host details
	host_row = get_hosts_table(app.hosts)
	app_user_row = get_app_users_table(app.app_users)
	didn_ary = get_database_names_and_instances(app.db_instance_db_names)

	bounding_box([50,700], :width => 450, :height => 625) do
	  appinfo = [
        [{:content => app.name, :colspan => 4, :align => :left}],
        ["Type: #{app.application_type_name}", "Status : #{app.application_status_name}", "Vendor : #{app.vendor_name}", "Shutdown: #{app.dr_shutdown_stage_name}"],
        [{:content => app.description, :colspan => 4, :align => :left}],
        ["Contact: #{app.support_contact_name}",
         "Group: #{app.support_group_name}",
         "Impact: #{app.impact_level_name}",
         "Escalation: #{app.escalation_level_name}"],
        [{:content => "Hosts", :colspan => 4}],
		[{:content => host_row, :colspan => 4, :width => 450}],
        [{:content => "Databases", :colspan => 4}],
		["","","",""],
		[{:content => "Users", :colspan => 4}],
		[{:content => app_user_row, :colspan => 4, :width => 450}]
      ]
      table appinfo, :cell_style => {:overflow => :shrink_to_fit, :border_line => [:dotted], :border_width => 0.1, :border_color => "808080"} do
        row(0).font_style = :bold
        row(0).background_color = "c0c0c0"
        row(1).background_color = "e0e0e0"
        row(3).background_color = "e0e0e0"
        row(4).font_style = :bold
        row(4).background_color = "c0c0c0"
		row(5).background_color = "e0e0e0"
		row(5).overflow = :shrink_to_fit
		#row(5).border_line = :dashed
		row(5).border_width = 0.1
		row(5).border_color = "808080"
        row(6).font_style = :bold
        row(6).background_color = "c0c0c0"
		row(7).background_color = "e0e0e0"
		row(7).overflow = :shrink_to_fit
		row(8).font_style = :bold
        row(8).background_color = "c0c0c0"
		row(9).background_color = "e0e0e0"
		row(9).overflow = :shrink_to_fit
		#row(9).border_line = :dashed
		row(9).border_width = 0.1
		row(9).border_color = "808080"
      end
	  
    end
	#start_new_page
	#puts "App user array for app id #{app.id} consists of #{app_user_row}"
	#table app_user_row
  end
  
  private
  def heading()
    # Document heading
    text_box @info[:title], :at => [100, 650], :align => :right, :size => 16, :font_style => :bolder, :color => "0000FF"
    text_box @info[:subject], :at => [100, 600], :height => 150, :align => :right, :size => 32, :color => "0000FF", :font_style => :bold
	move_down 10
    text_box "Prepared for", :at => [200, 500], :align => :right, :size => 12
    text_box @info[:creator], :at => [200, 475], :size => 12, :align => :right, :font_style => :bold
    text_box "Author", :at => [200, 450], :align => :right, :size => 12
    text_box @info[:author], :at => [200, 425], :size => 12, :align => :right, :font_style => :bold
  end
  def info_box
    # Add an information box
      
	text "Document information"
	move_down 10
	docinfo = [["Title", @info[:title]], ["Subject", @info[:subject]], ["Version", @info[:version]]]
	table docinfo, :column_widths => [100, 300], :cell_style => {:border_line => [:dotted], :border_width => 0.1} do
	  column(0).font_style = :bold
	  column(0).background_color = "c0c0c0"
	  column(1).background_color = "e0e0e0"
	end
  end
  def revision_history
    # Revision history
	text "Revision history"
	revhist = [["Version", "Date", "Description"],["1.0", "12/04/2015", "Initial version"],["1.1", "16/04/2015", "Second version"], [" ", " ", " "], [" ", " ", " "]]
	table revhist, :column_widths => [100, 100, 200], :cell_style => {:border_line => [:dotted], :border_width => 0.1} do
	  row(0).background_color = "c0c0c0"
	  row(0).font_style = :bold
	  rows(1..4).background_color = "e0e0e0"
	end
  end
  ###
  ### Get an array of hosts with suitable additional support information ###
  ###
  def get_hosts_table(host_ary = nil)
  return [["None", "", ""]] if host_ary.empty?
    #host_ary.each do |id, host| puts "Found host: #{id} name: #{host.name} at #{host.location.name}." end
	rows = []
	host_ary.each do |id, host| 
	  #puts "Making row for #{host.name}"
	  row = []
	  row << host.name << host.operating_system_name << host.warranty
	  #puts row
	  rows << row
	end
	#puts rows
	#t = make_table rows, {:column_widths => [100, 100, 250], :cell_style => {:size => 6, :overflow => :shrink_to_fit, :border_line => [:dotted], :border_width => 0.1, :border_color => "808080", :background_color => "e0e0e0"} }
	return rows
  end
  ###
  ### Get an array of application users with suitable additional support information ###
  ###
  def get_app_users_table(app_user_ary = nil)
    return [["None", "", ""]] if app_user_ary.empty?
	
    #app_user_ary.each do |id, app_user| puts "Found app_user: #{id} name: #{app_user.name} at #{app_user.app_user_type.name}." end
	rows = []
	app_user_ary.each do |id, app_user| 
	  row = []
	  row << app_user.name << app_user.app_user_type_name << app_user.description
	  rows << row
	end
	#puts rows
	#t = make_table rows, {:column_widths => [100, 100, 250], :cell_style => {:size => 6, :overflow => :shrink_to_fit, :border_line => [:dotted], :border_width => 0.1, :border_color => "808080", :background_color => "e0e0e0"} }
	return rows
  end
  ###
  ### Get an array of databases and instances with suitable additional support information ###
  ###
  def get_database_names_and_instances(didn_ary = nil)
  return [["None", "", ""]] if didn_ary.empty?
  puts "Found #{didn_ary.size} database/instance pairs for the application."
  
  didn_ary.each do |id, didn| puts "Found instance: #{didn.db_instance_name} name: #{didn.db_name_name}." end
	rows = []
	didn_ary.each do |id, didn| 
	  #puts "Making user row for #{app_user.name}"
	  row = []
	  row << didn.db_instance_name << didn.db_name_name << app_user.description
	  #puts row
	  rows << row
	end
	#puts rows
	#t = make_table rows, {:column_widths => [100, 100, 250], :cell_style => {:size => 6, :overflow => :shrink_to_fit, :border_line => [:dotted], :border_width => 0.1, :border_color => "808080", :background_color => "e0e0e0"} }
	return rows
  end
end