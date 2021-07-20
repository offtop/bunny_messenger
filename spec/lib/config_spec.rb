# frozen_string_literal: true

describe BunnyMessenger::Config do
  describe '.auth_params' do
    it { expect(described_class).to respond_to(:auth_params) }
    it 'is expected to launch #load_config' do
      expect(described_class).to receive(:load_config).once
      described_class.auth_params
    end
    it 'is expected to launch default_auth_params' do
      expect(described_class).to receive(:default_auth_params).once
      described_class.auth_params
    end
  end
  describe '.connection_params' do
    it { expect(described_class).to respond_to(:connection_params) }
    it 'is expected to launch #load_config' do
      expect(described_class).to receive(:load_config).once
      described_class.connection_params
    end
    it 'is expected to launch default_connection_params' do
      expect(described_class).to receive(:default_connection_params).once
      described_class.connection_params
    end
  end

  describe '.web_host' do
    it { expect(described_class).to respond_to(:web_host) }
    it 'is expected to launch #load_config' do
      expect(described_class).to receive(:load_config).once
      described_class.web_host
    end
    it 'is expected to launch default_web_host' do
      expect(described_class).to receive(:default_web_host).once
      described_class.web_host
    end
  end

  describe '.structure_file_path' do
    it { expect(described_class).to respond_to(:structure_file_path) }
    it 'is expected to launch #load_config' do
      expect(described_class).to receive(:load_config).once
      described_class.structure_file_path
    end
    it 'is expected to launch default_structure_file_path' do
      expect(described_class).to receive(:default_structure_file_path).once
      described_class.structure_file_path
    end
  end

  describe '.migrations_path' do
    it { expect(described_class).to respond_to(:migrations_path) }
    it 'is expected to launch #load_config' do
      expect(described_class).to receive(:load_config).once
      described_class.migrations_path
    end
    it 'is expected to launch default_migrations_path' do
      expect(described_class).to receive(:default_migrations_path).once
      described_class.migrations_path
    end
  end

  describe '.logger_level' do
    it { expect(described_class).to respond_to(:logger_level) }
    it 'is expected to launch #load_config' do
      expect(described_class).to receive(:load_config).once
      described_class.logger_level
    end
    it 'is expected to launch default_logger_level' do
      expect(described_class).to receive(:default_logger_level).once
      described_class.logger_level
    end
  end
  
  describe '.logger' do
    it { expect(described_class).to respond_to(:logger) }
    it 'is expected to launch #logger_level' do
      expect(described_class).to receive(:logger_level).once.and_return(Logger::INFO)
      described_class.logger
    end
    it 'is expected to launch default_logger' do
      expect(described_class).to receive(:default_logger)
      described_class.logger
    end
  end
end