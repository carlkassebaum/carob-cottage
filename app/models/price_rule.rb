class PriceRule < ApplicationRecord
    validates :name, presence: true
    
    def self.calculate_price(num_people, start_date, end_date)
        start_date = Date.parse(start_date)
        end_date   = Date.parse(end_date)
       
        stay_cost = 0
        stay_cost +=  apply_cost_type(num_people, start_date, end_date, { period_type: "per_night", rate_type: "all_guests" })
        stay_cost += apply_cost_type(num_people, start_date, end_date, { period_type: "per_night", rate_type: "per_person" })
        stay_cost += apply_cost_type(num_people, start_date, end_date, { period_type: "fixed",     rate_type: "all_guests" })
        stay_cost += apply_cost_type(num_people, start_date, end_date, { period_type: "fixed",     rate_type: "per_person" })
        
        return stay_cost
    end
    
    private
    
    def self.apply_cost_type(num_people, start_date, end_date, rule_type)
        total_cost = 0
        
        date_range = (start_date..(end_date-1.days)).to_a
        rules = PriceRule.where period_type: rule_type[:period_type], rate_type: rule_type[:rate_type]
        
        date_range.each do | current_date |
            applicable_rules = get_applicable_rules(rules, current_date, 0..num_people, date_range.length)
            total_cost += apply_rules(num_people, applicable_rules)
            return total_cost if rule_type[:period_type] == "fixed"
        end
        
        return total_cost
    end
    
    def self.get_applicable_rules(rules, current_date, guest_range, stay_duration)
        applicable_rules = price_rules_within_date_range(rules, current_date)
        applicable_rules = price_rules_within_guest_range(applicable_rules, guest_range)
        applicable_rules = price_rules_within_stay_range(applicable_rules, stay_duration)
        return applicable_rules
    end
    
    def self.apply_rules(num_people, applicable_rules)
        total_charged = 0
        applicable_rules = sort_rules_by_most_applicable(applicable_rules)
        
        applicable_rule = applicable_rules[0]
        total_charged += apply_rule(num_people, applicable_rule) unless applicable_rule.nil?
        
        return total_charged
    end
    
    #Apply the rule to the number of people given
    def self.apply_rule(num_people, rule)
        case rule.rate_type
        when "all_guests"
            return rule.value
        when "per_person"
            max_people = rule.max_people
            min_people = rule.min_people
            max_people = max_int if (rule.max_people.nil? || rule.max_people == 0)
            min_people = 1 if (min_people.nil? || min_people == 0)
            
            max_chargable = [num_people, max_people].min
            num_chargable = max_chargable - (min_people - 1)
            
            return num_chargable*rule.value
        end
    end
    
    def self.sort_rules_by_most_applicable(rules)
        rules.sort! do | rule_1, rule_2 | 
            rule_1_date_range = calculate_date_range_len(rule_1)
            rule_2_date_range = calculate_date_range_len(rule_2)
            rule_1_date_range <=> rule_2_date_range
        end
        
        return rules
    end
    
    def self.calculate_date_range_len(rule)
        return max_int if (rule.start_date.blank? || rule.end_date.blank?)
        
        start_date = Date.parse(rule.start_date)
        end_date = Date.parse(rule.end_date)
        
        return (start_date..end_date).to_a.length
    end
    
    #Returns all rules whose start and end date are within the given date range
    def self.price_rules_within_date_range(rules, current_date)
        resulting_rules = []
        
        rules.each do | rule |
            start_date = rule.start_date
            end_date   = rule.end_date
            
            if (start_date.nil? || start_date.empty?) || ( end_date.nil? || end_date.empty? )
                resulting_rules << rule
            else
                start_date = Date.parse(start_date)
                end_date   = Date.parse(end_date)
                resulting_rules << rule if current_date.between?(start_date, end_date)           
            end
        end
        
        return resulting_rules
    end
    
    def self.price_rules_within_guest_range(rules, guest_range)
        resulting_rules = []
        
        rules.each do | rule |
            min_people = rule.min_people
            max_people = rule.max_people
            
            if (min_people.nil? || min_people == 0) && (max_people.nil? || max_people == 0)
                resulting_rules << rule
            elsif (min_people.nil? || min_people == 0)
                resulting_rules << rule if guest_range.last <= max_people
            elsif (max_people.nil? || max_people == 0)
                resulting_rules << rule if guest_range.last >= min_people                
            else
                rule_guest_range = (rule.min_people)..(rule.max_people)
                resulting_rules << rule if guest_range.overlaps? rule_guest_range                
            end
        end
        
        return resulting_rules
    end
    
    def self.price_rules_within_stay_range(rules, stay_duration)
        resulting_rules = []
        
        rules.each do | rule |
            min_stay_duration = rule.min_stay_duration
            max_stay_duration = rule.max_stay_duration
            
            if (min_stay_duration.nil? || min_stay_duration == 0) && (max_stay_duration.nil? || max_stay_duration == 0)
                resulting_rules << rule
            elsif (min_stay_duration.nil? || min_stay_duration == 0) 
                resulting_rules << rule if stay_duration <= max_stay_duration
            elsif (max_stay_duration.nil? || max_stay_duration == 0) 
                resulting_rules << rule if stay_duration >= min_stay_duration
            else
                resulting_rules << rule if stay_duration.between?(min_stay_duration,max_stay_duration)
            end
        end
        
        return resulting_rules
    end
    
    def self.max_int
        n_bytes = [42].pack('i').size
        n_bits = n_bytes * 16
        return 2 ** (n_bits - 2) - 1           
    end
end
