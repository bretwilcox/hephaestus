# Controller for the /aboutthisapp page
class AboutController < ApplicationController
  require 'socket'

  def index
    @pods = Pod.get_pods
    @replica_sets = ReplicaSet.get_replica_sets
    @ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address

    @current_pod_replica_set_name = AboutHelper.current_pod_replica_set_name
    @current_pod_replica_set = AboutHelper.current_replica_set

    @current_pod_name = AboutHelper.current_pod_name
    @current_pod = AboutHelper.current_pod

    @pods_in_current_replica_set = AboutHelper.pods_in_current_replica_set

    @services = Service.get_services
    @services_in_current_replica_set = AboutHelper.services_in_current_replica_set

    @annotations = Array.new
    @annotations << 'whereis.fullcontact.com/description'
    @annotations << ENV['ANNOTATION_1'] if ENV['ANNOTATION_1']
    @annotations << ENV['ANNOTATION_2'] if ENV['ANNOTATION_2']
    @annotations << ENV['ANNOTATION_3'] if ENV['ANNOTATION_3']
    @annotations << ENV['ANNOTATION_4'] if ENV['ANNOTATION_4']
  end

end
