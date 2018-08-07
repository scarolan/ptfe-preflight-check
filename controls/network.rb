# Network tests for PTFE preflight check
# Set these to match your environment
#proxy_url = 'http://my.proxy.server'
#vcs_url = 'https://my.bitbucket.server'

vcs_url = 'https://www.github.com'

if defined? proxy_url
  # Only runs if you have defined proxy_url above.
  control 'proxy_network_checks' do
    impact 1.0
    desc 'Check to see that we can reach the Internet, VCS server, and Cloud Providers'
    # Most users should not require a proxy to reach the VCS.
    describe command("curl #{vcs_url}") do
      its('exit_status') { should eq 0 }
    end
    describe command("curl --proxy #{proxy_url} https://ec2.amazonaws.com") do
      its('exit_status') { should eq 0 }
    end
    describe command("curl --proxy #{proxy_url} https://management.azure.com") do
        its('exit_status') { should eq 0 }
    end
  end
else
  # This control runs if you comment out proxy_url
  control 'network_checks' do
    impact 1.0
    desc 'Check to see that we can reach the Internet, VCS server, and Cloud Providers'
    describe command("curl #{vcs_url}") do
      its('exit_status') { should eq 0 }
    end
    describe command("curl https://ec2.amazonaws.com") do
      its('exit_status') { should eq 0 }
    end
    describe command("curl https://management.azure.com") do
      its('exit_status') { should eq 0 }
    end
  end
end

