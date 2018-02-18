# Abstraction of the external Kuberneties API for ReplicaSets using the <i>rest-client</i> RubyGem.
module ReplicaSet
  require 'rest-client'
  require 'json'

  @host = 'https://kubernetes'
  @bearer_token = File.read('/var/run/secrets/kubernetes.io/serviceaccount/token')

  # This method configures the request that will be sent to the Kubernetes API to retrieve all replicasets
  #
  # ==== Options
  #
  # * +:headers+ - This is configured to use the bearer_token found on each Pod which contains credentials to login with the Service Account.
  # * +:verify_ssl+ - We need to turn off SSL validation to avoid a certificate verification failed when using the built in certificates.
  #
  # ==== Examples
  #
  #   ReplicaSet.get_replica_sets
  def self.get_replica_sets
    endpoint = '/apis/apps/v1beta2/replicasets'

    request = RestClient::Request.execute(method: :get, :url => @host + endpoint,
                                :verify_ssl => false,
                                headers: {:Authorization => "Bearer #{@bearer_token}"})

    return JSON.parse(request.body)["items"]
  end

end