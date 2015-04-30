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
      draw_text "This document is confidential and should not be distributed outside of Groovy Widgets Inc", :at => [50, 50], :size => 10
	end
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
end