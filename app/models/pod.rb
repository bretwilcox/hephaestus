# Abstraction of the external Kuberneties API for Pods using the <i>kubeclient</i> RubyGem
module Pod

  require 'kubeclient'

  # This method configures the request that will be sent to the Kubernetes API
  #
  # ==== Options
  #
  # * +:auth_options+ - This is configured to use the bearer_token found on each Pod which contains credentials to login with the Service Account.
  # * +:ssl_options+ - We need to turn off SSL validation to avoid a certificate verification failed when using the built in certificates.
  #
  # ==== Examples
  #
  #   Pod.login()

  def self.login
    auth_options = {
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token'
    }
    ssl_options = { verify_ssl: OpenSSL::SSL::VERIFY_NONE }

    @client = Kubeclient::Client.new 'https://kubernetes/api', 'v1', {ssl_options: ssl_options, auth_options: auth_options}
  end

  # This method sends a get request to the Kubernetes API to retrieve all Pods
  #
  # ==== Examples
  #
  #   Pod.get_pods

  def self.get_pods
    self.login
    @client.get_pods
  end

end