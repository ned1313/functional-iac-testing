# frozen_string_literal: true

control "file_check" do
    describe file('./test/fixtures/tf_module/foobar') do
      it { should exist }
    end
  end
  