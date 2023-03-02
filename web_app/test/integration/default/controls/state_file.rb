
control "state_file" do
    desc "Verifies that the Terraform state file can be used in InSpec controls"
  
    describe json(attribute("terraform_state").chomp).terraform_version do
      it { should match /\d+\.\d+\.\d+/ }
    end
  end