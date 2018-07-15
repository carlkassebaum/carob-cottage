RSpec.describe StaticPagesController, type: :routing do
    describe "get /" do
        it "routes get / to static_pages#home" do
            expect(get: "/").to route_to( controller: "static_pages", action: "home")
        end
    end
    
    describe "get /about_the_area" do
        it "routes get /about_the_area to static_pages#home" do
            expect(get: "/about_the_area").to route_to( controller: "static_pages", action: "location")
        end        
    end
end