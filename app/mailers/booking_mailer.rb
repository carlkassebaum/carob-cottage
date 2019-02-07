class BookingMailer < ApplicationMailer
    
    def booking_confirmation_email(booking)
        @booking = booking
        mail to: booking.email_address, subject: "Carob Cottage: Reservation Request"
    end
    
    def booking_admin_email(admin, booking)
        @booking = booking
        @admin = admin
        mail to: admin.email_address, subject: "Carob Cottage: New Reservation Request"
    end
end
