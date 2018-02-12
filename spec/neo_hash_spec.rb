require 'spec_helper'

describe NeoHash do
  subject { described_class.new(h) }

  let!(:h) do
    {
      'port' => 80,
      'log' => { 'level' => 'warn' }
    }
  end

  describe '#initialize' do
    it 'an instance that has accessors by method' do
      expect(subject.port).to eq(80)
      expect(subject.log.level).to eq('warn')
    end

    it 'an instance that has accessors by symbol' do
      expect(subject[:port]).to eq(80)
      expect(subject[:log][:level]).to eq('warn')
    end

    it 'an instance that has accessors by string' do
      expect(subject['port']).to eq(80)
      expect(subject['log']['level']).to eq('warn')
    end

    it 'an instance that has accessors by various ways' do
      expect(subject.log[:level]).to eq('warn')
      expect(subject.log['level']).to eq('warn')
      expect(subject[:log].level).to eq('warn')
      expect(subject[:log]['level']).to eq('warn')
      expect(subject['log'].level).to eq('warn')
      expect(subject['log'][:level]).to eq('warn')
    end
  end

  describe '#to_h' do
    let!(:h_symbol) do
      {
        port: 80,
        log: { level: 'warn' }
      }
    end

    it 'creates an hash with name as symbol' do
      expect(subject.to_h).to eq(h_symbol)
    end

    it 'creates an hash with name as symbol' do
      expect(subject.to_h(symbolize_keys: true)).to eq(h_symbol)
    end

    it 'creates an hash with name as string' do
      expect(subject.to_h(symbolize_keys: false)).to eq(h)
    end
  end

  describe 'dynamically change settings' do
    it 'can add new settings' do
      subject.log['file'] = '/var/log/app.log'
      subject[:backend] = { host: 'cms.example.com', "port" => 7080 }

      expect(subject.log.level).to eq('warn')
      expect(subject.log.file).to eq('/var/log/app.log')
      expect(subject.backend.host).to eq('cms.example.com')
      expect(subject.backend.port).to eq(7080)
    end

    it 'can update values' do
      subject['port'] = 8888
      expect(subject.port).to eq(8888)

      subject.port = 789
      expect(subject.port).to eq(789)

      subject.log.level = :trace
      expect(subject.log.level).to eq(:trace)

      subject.log = { file: '/var/log/app2.log' }
      expect{ subject.log.level }.to raise_error(NoMethodError)
      expect(subject.log.file).to eq('/var/log/app2.log')
    end
  end

  describe '#include?' do
    it 'call inner hash#include?' do
      expect(subject.include?(:port)).to be_truthy
      expect(subject.include?('port')).to be_truthy
    end
  end

  describe '#fetch' do
    it 'call inner hash#fetch' do
      expect(subject.fetch(:port)).to eq(80)
      expect(subject.fetch('port')).to eq(80)
      expect{ subject.fetch(:none) }.to raise_error(KeyError)
      expect(subject.fetch(:none, 'none')).to eq('none')
      expect(subject.fetch(:none) {|k| k }).to eq(:none)
    end
  end

  describe '#delete' do
    it 'call inner hash#delete' do
      expect(subject.delete(:none)).to be_nil
      expect(subject.delete('port')).to eq(80)
      expect(subject.delete(:log)).not_to be_nil
    end
  end

  describe '#method_missing' do
    it 'can call inner hash#each' do
      subject.each do |k, v|
        expect(k).to eq :port
        expect(v).to eq 80
        break
      end
    end

    it 'can call inner hash#empty?' do
      expect(subject.empty?).to be_falsey
    end

    it 'can call inner hash#keys' do
      expect(subject.keys).to eq([:port, :log])
    end

    it 'can call inner hash#map' do
      expect(subject.map {|k, v| k }).to eq [:port, :log]
    end

    it 'can call inner hash#select' do
      h = subject.select {|k, v| k == :port }
      expect(h[:port]).to eq(80)
    end

    it 'can call inner hash#store' do
      subject.store(:port, 999)
      expect(subject.port).to eq(999)
    end
  end
end
