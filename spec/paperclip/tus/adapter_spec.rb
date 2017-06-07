require 'spec_helper'

# missing dependency for Paperclip::ContentTypeDetector
require 'active_support/core_ext/object/try'

RSpec.describe Paperclip::Tus::Adapter do
  context 'a new instance' do
    let(:uid) { '16bfe9e51cfbc5e90a7c541a5404be26' }

    subject { Paperclip.io_adapters.for(uid) }

    before do
      Tus::Server.opts[:storage] = Tus::Storage::Filesystem.new('spec/fixtures')
    end

    it 'returns a file name' do
      expect(subject.original_filename).to eq('test.txt')
    end

    it 'returns a content type' do
      expect(subject.content_type).to eq('text/plain')
    end

    it 'returns the size of the data' do
      expect(subject.size).to eq(6)
    end

    it 'returns the length of the data' do
      expect(subject.length).to eq(6)
    end

    it 'generates an MD5 hash of the contents' do
      content = File.read(Tus::Server.opts[:storage].send(:file_path, uid))
      expect(subject.fingerprint).to eq(Digest::MD5.hexdigest(content))
    end

    it 'generates correct fingerprint after read' do
      fingerprint = Digest::MD5.hexdigest(subject.read)
      expect(subject.fingerprint).to eq(fingerprint)
    end

    it 'generates same fingerprint' do
      expect(subject.fingerprint).to eq(subject.fingerprint)
    end

    it 'returns the data contained in the file' do
      expect(subject.read).to eq("test\r\n")
    end

    it 'accepts an original_filename' do
      subject.original_filename = 'image.png'
      expect(subject.original_filename).to eq('image.png')
    end

    it 'does not generate filenames that include restricted characters' do
      subject.original_filename = 'image:restricted.png'
      expect(subject.original_filename).to eq('image_restricted.png')
    end

    it 'does not generate paths that include restricted characters' do
      subject.original_filename = 'image:restricted.png'
      expect(subject.path).to_not match(/:/)
    end

    context 'with invalid tus storage' do
      before do
        Tus::Server.opts[:storage] = Array.new
      end

      it 'raises an error' do
        expect { subject }.to raise_error(
          'Paperclip tus adapter does not support Array! ' \
          'Please set Tus::Server.opts[:storage] to ' \
          'Tus::Storage::Filesystem.new(cache_directory)'
        )
      end
    end
  end
end
