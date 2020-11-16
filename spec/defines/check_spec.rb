require 'spec_helper'

describe 'monit::check' do
  let :pre_condition do
    'include ::monit'
  end
  let(:title) { 'test' }
  let(:facts) do
    {
      osfamily:        'Debian',
      lsbdistcodename: 'squeeze',
      monit_version:   '5',
    }
  end

  context 'with default values for parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('monit') }
    it do
      is_expected.to contain_file('/etc/monit/conf.d/test').with('ensure'  => 'present',
                                                                 'owner'   => 'root',
                                                                 'group'   => 'root',
                                                                 'mode'    => '0644',
                                                                 'source'  => nil,
                                                                 'content' => nil,
                                                                 'notify'  => 'Service[monit]',
                                                                 'require' => 'Package[monit]')
    end
  end

  ['absent', 'present'].each do |value|
    context "with ensure set to valid <#{value}>" do
      let(:params) do
        {
          ensure: value,
        }
      end

      it do
        is_expected.to contain_file('/etc/monit/conf.d/test').with('ensure'  => value,
                                                                   'owner'   => 'root',
                                                                   'group'   => 'root',
                                                                   'mode'    => '0644',
                                                                   'source'  => nil,
                                                                   'content' => nil,
                                                                   'notify'  => 'Service[monit]',
                                                                   'require' => 'Package[monit]')
      end
    end
  end

  context 'with content set to a valid value' do
    content = <<-END.gsub(%r{^\s+\|}, '')
      |check process ntpd with pidfile /var/run/ntpd.pid
      |start program = "/etc/init.d/ntpd start"
      |stop  program = "/etc/init.d/ntpd stop"
      |if failed host 127.0.0.1 port 123 type udp then alert
      |if 5 restarts within 5 cycles then timeout
    END
    let(:params) do
      {
        content: content,
      }
    end

    it do
      is_expected.to contain_file('/etc/monit/conf.d/test').with('ensure'  => 'present',
                                                                 'owner'   => 'root',
                                                                 'group'   => 'root',
                                                                 'mode'    => '0644',
                                                                 'source'  => nil,
                                                                 'content' => content,
                                                                 'notify'  => 'Service[monit]',
                                                                 'require' => 'Package[monit]')
    end
  end

  context 'with source set to a valid value' do
    let(:params) do
      {
        source: 'puppet:///modules/monit/ntp',
      }
    end

    it do
      is_expected.to contain_file('/etc/monit/conf.d/test').with('ensure'  => 'present',
                                                                 'owner'   => 'root',
                                                                 'group'   => 'root',
                                                                 'mode'    => '0644',
                                                                 'source'  => 'puppet:///modules/monit/ntp',
                                                                 'content' => nil,
                                                                 'notify'  => 'Service[monit]',
                                                                 'require' => 'Package[monit]')
    end
  end

  context 'with content and source set at the same time' do
    let(:params) do
      {
        content: 'content',
        source: 'puppet:///modules/subject/test',
      }
    end

    it 'fails' do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, %r{Parameters source and content are mutually exclusive})
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        osfamily:        'Debian',
        lsbdistcodename: 'squeeze',
        monit_version:   '5',
      }
    end
    let(:validation_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'regex_file_ensure' => {
        name: ['ensure'],
        valid: ['present', 'absent'],
        invalid: ['file', 'directory', 'link', ['array'], { 'ha' => 'sh' }, 3, 2.42, true, false, nil],
        message: 'match for Enum\[\'absent\', \'present\'\]',
      },
      'string' => {
        name: ['content'],
        valid: ['string'],
        invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false],
        message: 'value of type Undef or String',
      },
      'string_file_source' => {
        name: ['source'],
        valid: ['puppet:///modules/subject/test'],
        invalid: [['array'], { 'ha' => 'sh' }, 3, 2.42, true, false],
        message: 'value of type Undef or String',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge(:"#{var_name}" => valid) }

            it { is_expected.to compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge(:"#{var_name}" => invalid) }

            it 'fails' do
              expect {
                catalogue
              }.to raise_error(Puppet::PreformattedError, %r{expects a #{var[:message]}})
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
