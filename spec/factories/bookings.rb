FactoryBot.define do
  factory :booking do
    name "name"
    postcode "postcode"
    country "country"
    contact_number "contact_number"
    email_address "email@email.com"
    number_of_people "number_of_people"
    estimated_arrival_time "eta"
    preferred_payment_method "preferred_payment_method"
    arrival_date "arrival_date"
    departure_date "departure_date"
    cost "cost"
  end
end
