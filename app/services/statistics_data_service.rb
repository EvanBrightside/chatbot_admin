class StatisticsDataService
  class << self
    def customers_data
      # customers = Customer.all.inject(Hash.new(0)) do |h, e|
      #   h[e.created_at.strftime("%d/%m/%Y")] += 1 ; h
      # end

      customers = Customer.all.inject(Hash.new(0)) do |h, e|
        h[e.adapter_name] += 1 ; h
      end

      customers.sort
    end

    def connections_data(on_date)
      customers = Customer.all.inject(Hash.new(0)) do |h, e|
        h[e.created_at.strftime("%d/%m/%Y")] += 1 ; h
      end
      customers.sort
    end

    def scenario_data
      all = Customer.find_each.map { |a| [a.adapter.to_sym, a.messenger_id]}

      all_keys = all.map { |s| DialogState.new(s[0], s[1]) }
      answers = all_keys.map { |e| e.answers}
      answers.map { |ans| ans&.values&.last }.inject(Hash.new(0)) { |h, e| h[e['message']] += 1 if e ; h }
    end
  end
end
