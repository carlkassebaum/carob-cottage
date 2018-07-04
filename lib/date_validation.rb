module DateValidation
    def valid_date?(date_string)
        begin
            Date.parse(date_string)
        rescue ArgumentError
            return false
        end
        
        return true if /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/.match(date_string)
        return true if /^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/.match date_string        
        
        return false
    end
    
    def date_less_than?(string_1,string_2)
        date_1 = Date.parse(string_1)
        date_2 = Date.parse(string_2)
        
        date_1 < date_2 ? true : false
    end
end