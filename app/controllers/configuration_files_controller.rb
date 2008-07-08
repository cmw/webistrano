class ConfigurationFilesController < ApplicationController
  # GET /configuration_files
  # GET /configuration_files.xml
  def index
    @configuration_files = ConfigurationFile.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @configuration_files }
    end
  end

  # GET /configuration_files/1
  # GET /configuration_files/1.xml
  def show
    @configuration_file = ConfigurationFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @configuration_file }
    end
  end

  # GET /configuration_files/new
  # GET /configuration_files/new.xml
  def new
    @configuration_file = ConfigurationFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @configuration_file }
    end
  end

  # GET /configuration_files/1/edit
  def edit
    @configuration_file = ConfigurationFile.find(params[:id])
  end

  # POST /configuration_files
  # POST /configuration_files.xml
  def create
    @configuration_file = ConfigurationFile.new(params[:configuration_file])

    respond_to do |format|
      if @configuration_file.save
        flash[:notice] = 'ConfigurationFile was successfully created.'
        format.html { redirect_to(@configuration_file) }
        format.xml  { render :xml => @configuration_file, :status => :created, :location => @configuration_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @configuration_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /configuration_files/1
  # PUT /configuration_files/1.xml
  def update
    @configuration_file = ConfigurationFile.find(params[:id])

    respond_to do |format|
      if @configuration_file.update_attributes(params[:configuration_file])
        flash[:notice] = 'ConfigurationFile was successfully updated.'
        format.html { redirect_to(@configuration_file) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @configuration_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /configuration_files/1
  # DELETE /configuration_files/1.xml
  def destroy
    @configuration_file = ConfigurationFile.find(params[:id])
    @configuration_file.destroy

    respond_to do |format|
      format.html { redirect_to(configuration_files_url) }
      format.xml  { head :ok }
    end
  end
  
  def preview
    @configuration_file = ConfigurationFile.new(params[:configuration_file])
    respond_to do |format|
      format.js { 
        render :update do |page|
          page.replace_html :preview, :partial => "preview", :locals => {:configuration_file => @configuration_file}
          page.show :preview_fieldset
        end
      }
    end
  end
  
end
