RSpec.describe StaticPagesController, type: :routing do
    describe "get /" do
        it "routes get / to static_pages#home" do
            expect(get: "/").to route_to( controller: "static_pages", action: "home")
        end
    end
end