require 'spec_helper'

describe 'omd' do

  # default is Debian environment

  it { is_expected.to contain_class('omd::params') }
  it { is_expected.to contain_class('omd::install') }

  describe 'installation' do

    context 'on RedHat like systems' do
      let(:facts) {{ 
          :osfamily        => 'RedHat',
          :operatingsystem => 'CentOS',
      }}
  
      #it { is_expected.to contain_class('omd::install::redhat').that_comes_before('Package[omd]') }
      it { is_expected.to raise_error(/not supported/) }
    end

    context 'on Debian like systems' do
  
      it { is_expected.to contain_class('omd::install::debian').that_comes_before('Package[omd]') }
      it { is_expected.to contain_class('apt') }

      context 'on Debian' do
        it { is_expected.to contain_apt__source('omd').with({
            :location    => 'http://labs.consol.de/repo/stable/debian',
            :release     => 'wheezy',
            :repos       => 'main',
            :key         => 'F8C1CA08A57B9ED7',
            :key_content => /mI0EThw4TQEEA/,
            :include_src => false,
          })
        }
      end

      context 'on Ubuntu' do
        let(:facts) {{
          :operatingsystem => 'Ubuntu',
          :lsbdistid       => 'Ubuntu',
          :lsbdistcodename => 'trusty',
        }}
        it { is_expected.to contain_apt__source('omd').with({
            :location    => 'http://labs.consol.de/repo/stable/ubuntu',
            :release     => 'trusty',
            :repos       => 'main',
            :key         => 'F8C1CA08A57B9ED7',
            :key_content =>  /mI0EThw4TQEEA/,
            :include_src => false,
          }) 
        }
      end

    end

    it { is_expected.to contain_package('omd').with_ensure('installed') }
    ['latest','absent','purged'].each { |ver|
      context "with parameter ensure => #{ver}" do
        let(:params) {{ :ensure => ver }}
        it { is_expected.to contain_package('omd').with_ensure(ver).with_name('omd') }
      end
    }
    context 'with parameter ensure => 1.20' do
      let(:params) {{ :ensure => '1.20' }}
      it { is_expected.to contain_package('omd').with_ensure('present').with_name("omd-1.20") }
    end
    context 'with parameter ensure => breakme' do
      let(:params) {{ :ensure => 'breakme' }}
      it { is_expected.to raise_error(/does not match/) }
    end


  end


end
