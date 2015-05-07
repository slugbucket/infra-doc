class InfraApplication
  def initialize(dbh, id)
    @id = id
    qry = "SELECT * FROM applications WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name                  = row[:name]
	  @application_type_id   = row[:application_type_id]
	  @application_status_id = row[:application_status_id]
	  @vendor_id             = row[:vendor_id]
	  @support_contact_id    = row[:support_contact_id]
	  @support_group_id      = row[:support_group_id]
	  @description           = row[:description]
	  @escalation_level_id   = row[:escalation_level_id]
	  @impact_level_id       = row[:impact_level_id]
	  @impact_hour_id        = row[:impact_hour_id]
	  @dr_shutdown_stage_id  = row[:dr_shutdown_stage_id]
	  @created_at            = row[:created_at]
	  @updated_at            = row[:updated_at]
	end
	result.cancel
	@app_type          = InfraApplicationType.new(dbh, @application_type_id) if @application_type_id
	@app_status        = InfraApplicationStatus.new(dbh, @application_status_id)
	@vendor            = InfraVendor.new(dbh, @vendor_id)
	@support_contact   = InfraSupportContact.new(dbh, @support_contact_id)
	@support_group     = InfraSupportGroup.new(dbh, @support_group_id)
	@escalation_level  = InfraEscalationLevel.new(dbh, @escalation_level_id)
	@impact_level      = InfraImpactLevel.new(dbh, @impact_level_id)
	@impact_hour       = InfraImpactHour.new(dbh, @impact_hour_id)
	@dr_shutdown_stage = InfraDrShutdownStage.new(dbh, @dr_shutdown_stage_id)
	# Grab the hosts details from the association table
	qry = "SELECT host_id FROM application_hosts WHERE application_id = #{id}"
	rs1 = dbh.execute(qry)
	rs1.each(:symbolize_keys => true)
	@hosts = Hash.new
	if rs1.any?then
	  rs1.each do |row|
	    @hosts[row[:host_id]] = InfraHost.new(dbh, row[:host_id])
	  end
	end

    # Grab the application user details from the association table
	qry = "SELECT app_user_id FROM app_user_applications WHERE application_id = #{id}"
	rs2 = dbh.execute(qry)
	rs2.each(:symbolize_keys => true)
	@app_users = Hash.new
	if rs2.any? then
	  rs2.each do |row|
	    @app_users[row[:app_user_id]] = InfraAppUser.new(dbh, row[:app_user_id])
	  end
	end

    # Grab the application database from the association table
	qry = "SELECT db_instance_db_name_id FROM application_db_instance_db_names WHERE application_id = #{id}"
	rs3 = dbh.execute(qry)
	rs3.each(:symbolize_keys => true)
	@didn = Hash.new
	if rs3.any?then
	  rs3.each do |row|
	    @didn[row[:db_instance_db_name_id]] = InfraDbInstanceDbName.new(dbh, row[:db_instance_db_name_id])
	  end
	end
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
  def hosts
    @hosts
  end
  def app_users
    @app_users
  end
  def db_instance_db_names
    @didn
  end
end
###
### Application type ###
###
class InfraApplicationType
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM application_types WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM application_statuses WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name = row[:name]
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
    @id = id
	qry = "SELECT * FROM vendors WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM app_user_types WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM app_users WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	  @app_user_type = InfraAppUserType.new(dbh, row[:app_user_type_id])
	end
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
    @id = id
	qry = "SELECT * FROM support_contacts WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM support_groups WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM escalation_levels WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM impact_levels WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM impact_hours WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
    @id = id
	qry = "SELECT * FROM dr_shutdown_stages WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
### Hosts and supporting information ###
### These are handled independently of the main application because of the additional
### associations required to link them to applications; those tables are not modeled
### direcly here but would be available in a Rails ActiveRecord model.
###
class InfraAdDomain
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM ad_domains WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	  @active      = row[:active]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
  def active
    @active
  end
end
class InfraDrMethod
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM dr_methods WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
class InfraLocation
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM locations WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
class InfraModel
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM models WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	  @vendor_id   = row[:vendor_id]
	end
	@vendor = InfraVendor.new(dbh, @vendor_id)
  end
  def name
    @name
  end
  def description
    @description
  end
  def vendor
    vendor
  end
  def vendor_name
    @vendor.name
  end
end
class InfraOobRemoteMngmt
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM oob_remote_mngmts WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
class InfraOperatingSystem
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM operating_systems WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	  @expiry      = row[:expiry]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
  def expiry
    @expiry
  end
end
class InfraServiceLevel
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM service_levels WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
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
class InfraHost
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM hosts WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @active              = row[:active]
	  @name                = row[:name]
	  @ad_domain_id        = row[:ad_domain_id]
	  @asset_tag           = row[:asset_tag]
	  @description         = row[:description]
	  @dr_method_id        = row[:dr_method_id]
	  @location_id         = row[:location_id]
	  @model_id            = row[:model_id]
	  @name                = row[:name]
	  @oob_remote_mngmt_id = row[:oob_remote_mngmt_id]
	  @operating_system_id = row[:operating_system_id]
	  @primary_use         = row[:primary_use]
	  @service_level_id    = row[:service_level_id]
	  @warranty            = row[:warranty]
	end
	@ad_domain        = InfraAdDomain.new(dbh, @ad_domain_id)
	@dr_method        = InfraDrMethod.new(dbh, @dr_method_id)
	@location         = InfraLocation.new(dbh, @location_id)
	@model            = InfraModel.new(dbh, @model_id)
	@oob_remote_mngmt = InfraOobRemoteMngmt.new(dbh, @oob_remote_mngmt_id)
	@operating_system = InfraOperatingSystem.new(dbh, @operating_system_id)
	@service_level    = InfraServiceLevel.new(dbh, @service_level_id)
  end
  def active
    @active
  end
  def description
    @description
  end
  def name
    @name
  end
  def ad_domain
    @ad_domain
  end
   def ad_domain_name
    @ad_domain.name
  end
  def dr_method
    @dr_method
  end
   def dr_method_name
    @dr_method.name
  end
  def location
    @location
  end
   def location_name
    @location.name
  end
  def model
    @model
  end
   def model_name
    @model.name
  end
  def oob_remote_mngmt
    @oob_remote_mngmt
  end
   def oob_remote_mngmt_name
    @oob_remote_mngmt.name
  end
  def operating_system
    @operating_system
  end
   def operating_system_name
    @operating_system.name
  end
  def primary_use
    @primary_use
  end
  def service_level
    @service_level
  end
  def service_level_name
    @service_level.name
  end
  def warranty
    @warranty
  end
end
###
### Database classes ###
###
class InfraCluster
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM db_clusters WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	end
  end
  def name
    @name
  end
  def description
    @description
  end
  def name
    @name
  end
end
class InfraDbServer
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM db_servers WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	end
	# Grab the hosts details from the association table
	qry = "SELECT host_id FROM db_server_hosts WHERE db_server_id = #{id}"
	rs1 = dbh.execute(qry)
	rs1.each(:symbolize_keys => true)
	@hosts = Hash.new
	if rs1.any?then
	  rs1.each do |row|
	    @hosts[row[:host_id]] = InfraHost.new(dbh, row[:host_id])
	  end
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
  def hosts
    @hosts
  end
end
class InfraServerApp
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM server_apps WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	end
  end
  def description
    @description
  end
  def name
    @name
  end
end
class InfraDbInstance
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM db_instances WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name          = row[:name]
	  @description   = row[:description]
	  @db_server     = InfraDbServer.new(dbh, row[:db_server_id])
	  @server_app    = InfraServerApp.new(dbh, row[:server_app_id])
	end
	
    # Grab the db server hosts
    qry = "SELECT host_id FROM db_server_hosts WHERE db_server_id = #{@db_server.id}"
	rs1 = dbh.execute(qry)
	rs1.each(:symbolize_keys => true)
	@hosts = Hash.new
	if rs1.any?then
	  rs1.each do |row|
	    @hosts[row[:host_id]] = InfraHost.new(dbh, row[:host_id])
	  end
	end
	
  end
  def name
    @name
  end
  def description
    @description
  end
  def db_server
    @db_server
  end
  def server_app
    @server_app
  end
end
class InfraDbName
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM db_names WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @name        = row[:name]
	  @description = row[:description]
	end
  end
  def description
    @description
  end
  def name
    @name
  end
end
class InfraDbInstanceDbName
  def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM db_instance_db_names WHERE id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @db_instance = InfraDbInstance.new(dbh, row[:db_instance_id])
	  @db_name     = InfraDbName.new(dbh, row[:db_name_id])
	end
  end
  def db_instance
    @db_instance
  end
  def db_instance_name
    @db_instance.name
  end
  def db_name
    @db_name
  end
  def db_name_name
    @db_name.name
  end
end
class InfraEnterpriseApplication
  def initialize(dbh, id)
  end
end
class InfraApplicationEnterpriseApplication
def initialize(dbh, id)
    @id = id
	qry = "SELECT * FROM application_enterprise_applications WHERE application_id = '#{id}'"
	result = dbh.execute(qry)
	result.each(:symbolize_keys => true)
	result.each do |row|
	  @application = InfraDbInstance.new(dbh, row[:application_id])
	  @enterprise_application     = InfraApplication.new(dbh, row[:enterprise_application_id])
	end
  end
end