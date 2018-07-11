class BookingMailer < ApplicationMailer
    
    def booking_confirmation_email(booking)
        @booking = booking
        mail to: booking.email_address, subject: "Carob Cottage: Reservation Confirmation"
    end
end
