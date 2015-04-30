class InfraApplication
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
    #@dbh = TinyTds::Client.new username: 'istapplist_dev', password: 'istapplist_dev', host: 'localhost', database: 'istapplist_dev'
	qry = "SELECT * FROM applications WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @application_type_id = row[:application_type_id]
	  @application_status_id = row[:application_status_id]
	  @vendor_id = row[:vendor_id]
	  @support_contact_id = row[:support_contact_id]
	  @support_group_id = row[:support_group_id]
	  @description = row[:description]
	  @escalation_level_id = row[:escalation_level_id]
	  @impact_level_id = row[:impact_level_id]
	  @impact_hour_id = row[:impact_hour_id]
	  @dr_shutdown_stage_id = row[:dr_shutdown_stage_id]
	  @created_at = row[:created_at]
	  @updated_at = row[:updated_at]
	end
	@app_type = InfraApplicationType.new(@dbh, @application_type_id) if @application_type_id
	@app_status = InfraApplicationStatus.new(@dbh, @application_status_id)
	@vendor = InfraApplicationStatus.new(@dbh, @vendor_id)
	@support_contact = InfraSupportContact.new(@dbh, @support_contact_id)
	@support_group = InfraSupportGroup.new(@dbh, @support_group_id)
	@escalation_level = InfraImpactLevel.new(@dbh, @escalation_level_id)
	@impact_level = InfraImpactLevel.new(@dbh, @impact_level_id)
	@impact_hour = InfraImpactHour.new(@dbh, @impact_hour_id)
	@dr_shutdown_stage = InfraDrShutdownStage.new(@dbh, @dr_shutdown_stage_id)
  end
  def name
    @name
  end
  def id
    @id
  end
  def description
    @description
  end
  def application_type
    @app_type
  end
  def application_type_name
    @app_type.name
  end
  def application_status
	@app_status
  end
  def application_status_name
	(@app_status.nil?) ? nil : @app_status.name
  end
  def vendor
   @vendor
  end
  def vendor_name
    @vendor.name
  end
  def support_contact
   @support_contact
  end
  def support_contact_name
    @support_contact.name
  end
  def support_group
   @support_group
  end
  def support_group_name
    @support_group.name
  end
  def escalation_level
   @escalation_level
  end
  def escalation_level_name
    @escalation_level.name
  end
  def impact_level
   @impact_level
  end
  def impact_level_name
    @impact_level.name
  end
  def impact_hour
   @impact_hour
  end
  def impact_hour_name
    @impact_hour.name
  end
  def dr_shutdown_stage
   @dr_shutdown_stage
  end
  def dr_shutdown_stage_name
    @dr_shutdown_stage.name
  end
end
###
### Application type ###
###
class InfraApplicationType
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM application_types WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
class InfraApplicationStatus
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM application_statuses WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
end
###
### Vendor ###
###
class InfraVendor
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM vendors WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def id
    @id
  end
  def name
    @name
  end
  def description
    @description
  end
end
###
### Application user and type ###
###
class InfraAppUserType
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM app_user_types WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
class InfraAppUser
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM app_users WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
	@app_user_type = InfraAppUserType.new(@dbh, row[:app_user_type_id])
  end
  def name
    @name
  end
  def description
    @description
  end
  def app_user_type
    @app_user_type
  end
  def app_user_type_name
    @app_user_type.name
  end
end
###
### Support contact and group ###
###
class InfraSupportContact
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM support_contacts WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
class InfraSupportGroup
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM support_groups WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
###
### Impacts and escalations ###
###
class InfraEscalationLevel
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM escalation_levels WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
class InfraImpactLevel
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM impact_levels WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
class InfraImpactHour
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM impact_hours WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
###
### Shutdown stage ###
###
class InfraDrShutdownStage
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM dr_shutdown_stages WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
end
###
### Database classes ###
###
class InfraDbInstance
  def initialize(dbh, id)
    @dbh = dbh
	@id = id
	qry = "SELECT * FROM db_instances WHERE id = '#{id}'"
	result = @dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
	end
  end
end