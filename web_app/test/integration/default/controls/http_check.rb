control "lb_check" do
    desc "Check LB is reachable"

    describe host attribute("lb_address_output") do
        it { should be_reachable }
    end
end

control "http_check" do
    desc "Check LB returns 200 status"

    describe http(attribute("lb_http_output")) do
        its('status') { should cmp 200 }
    end
end
