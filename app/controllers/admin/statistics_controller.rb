class Admin::StatisticsController < Admin::BaseController
  skip_authorization_check

  def customers
    @data = StatisticsDataService.customers_data
  end

  def scenario
    @data = StatisticsDataService.scenario_data
  end

  def connections
    @data = StatisticsDataService.connections_data(
      params[:on_date]
    )
  end
end
