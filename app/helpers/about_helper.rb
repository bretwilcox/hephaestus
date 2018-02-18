# Helper methods for the about_controller.rb
module AboutHelper
  require 'socket'

  # Get the name of the replicaset that the pod rendering the webapp belongs to.  This is accomplished by pulling the IP address of the Pod and comparing that to the IP address of the Pods in the API.
  #
  # ==== Examples
  #
  #   AboutHelper.current_pod_replica_set_name
  def self.current_pod_replica_set_name
    ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
    pods = Pod.get_pods
    current_pod_replica_set_name = String.new

    pods.each do |pod|
      if ip_address == pod.to_h[:status][:podIP]
        current_pod_replica_set_name = pod.to_h[:metadata][:ownerReferences].first[:name].to_s
      end
    end

    return current_pod_replica_set_name
  end

  # Get the name of the pod rendering the webapp.
  #
  # ==== Examples
  #
  #   AboutHelper.current_pod_name
  def self.current_pod_name
    ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
    pods = Pod.get_pods
    current_pod_name = String.new

    pods.each do |pod|
      if ip_address == pod.to_h[:status][:podIP]
        current_pod_name = pod.to_h[:metadata][:name]
      end
    end

    return current_pod_name
  end

  # Get the pod that is rendering the webapp
  #
  # ==== Examples
  #
  #   AboutHelper.current_pod
  def self.current_pod
    ip_address = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
    pods = Pod.get_pods
    current_pod = Hash.new

    pods.each do |pod|
      if ip_address == pod.to_h[:status][:podIP]
        current_pod = pod.to_h
      end
    end

    return current_pod
  end

  # Get the replicaset that the pod rendering the webapp belongs to.  This is accomplished by pulling the IP address of the Pod and comparing that to the IP address of the Pods in the API.
  #
  # ==== Examples
  #
  #   AboutHelper.current_replica_set
  def self.current_replica_set
    current_replica_set = Hash.new
    replica_sets = ReplicaSet.get_replica_sets
    replica_sets.each do |rs|
      if self.current_pod_replica_set_name == rs["metadata"]["name"]
        current_replica_set = rs
      end
    end

    return current_replica_set
  end

  # Get the pods belonging to the replicaset that the pod rendering the webapp belongs to.  This is accomplished by pulling the IP address of the Pod and comparing that to the IP address of the Pods in the API.
  #
  # ==== Examples
  #
  #   AboutHelper.pods_in_current_replica_set
  def self.pods_in_current_replica_set
    pods_in_replica_set = Array.new
    current_replica_set_name = self.current_pod_replica_set_name
    pods = Pod.get_pods

    pods.each do |pod|
      pod_name = pod.to_h[:metadata][:ownerReferences].first[:name].to_s if pod.to_h[:metadata][:ownerReferences] != nil
      pods_in_replica_set << pod if pod_name == current_replica_set_name
    end

    return pods_in_replica_set
  end

  # Get the services belonging to the replicaset that the pod rendering the webapp belongs to.  This is accomplished by pulling the IP address of the Pod and comparing that to the IP address of the Pods in the API.
  #
  # ==== Examples
  #
  #   AboutHelper.services_in_current_replica_set
  def self.services_in_current_replica_set
    services_in_replica_set = Array.new
    services = Service.get_services

    replica_sets = ReplicaSet.get_replica_sets
    replica_sets.each do |rs|
      if self.current_pod_replica_set_name == rs["metadata"]["name"]
        services.each do |service|
          service_name =  service.to_h[:metadata][:name]
          services_in_replica_set << service if service_name == rs["metadata"]["labels"]["app"]
        end
      end
    end

    return services_in_replica_set
  end

  def self.find_annotations_in_ingresses(annotation)
    # This is a stub for this method
    return "Looking for #{annotation} in ingresses"
  end

  def self.find_annotations_in_services(annotation)
    # This is a stub for this method
    return "Looking for #{annotation} in services"
  end

  def self.find_annotations_in_replica_sets(annotation)
    # This is a stub for this method
    return "Looking for #{annotation} in replicasets"
  end

  def self.find_annotations_in_daemon_sets(annotation)
    # This is a stub for this method
    return "Looking for #{annotation} in daemonsets"
  end

end
