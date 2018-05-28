# Pre-flight checklist tests for installing Private Terraform Enterprise
# Uncomment and adjust these variables to match your environment

control 'os-release' do
  impact 1.0
  desc 'Checks to see that the RHEL/CentOS OS release is correct.'
  describe os.release do
    it { should cmp >= 7.2 }
  end
end

control 'docker-daemon' do
  impact 1.0
  desc 'Makes sure docker is installed and running.'
  describe service('docker') do
    it { should be_installed }
    it { should be_running }
  end
end

control 'docker-version' do
  impact 1.0
  desc 'Checks the version of the installed docker package.'
  describe docker.version do
    its('Server.Version') { should cmp >= '1.13' }
  end
end

control 'docker-config' do
  impact 1.0
  desc 'Check that auth plugins are disabled, to prevent an out of memory bug.'
  describe file('/usr/lib/systemd/system/docker.service') do
    its('content') { should_not include '--authorization-plugin=rhel-push-plugin' }
  end
  describe command('docker info 2> /dev/null | grep Authorization') do
    its('exit_status') { should eq 1 }
  end
end

control 'storage-config' do
  impact 0.5
  desc 'Checks that the root filesystem is mounted as XFS with ftype=1'
  describe command('uname -r') do
    its('stdout') { should cmp > '3.10.0-693' }
  end
  describe mount('/') do
    it { should be_mounted }
    its('type') { should eq 'xfs' }
  end
  describe command('xfs_info /') do
    its('stdout') { should include 'ftype=1'}
  end
  describe filesystem('/') do
    its('size') { should be >= 41943040 }
  end
end