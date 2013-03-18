if Rails.env.development?
  Glimpse.into Glimpse::Views::Git, :nwo => 'YaanaLabs/subwire', :branch_name => 'master'
  Glimpse.into Glimpse::Views::Mysql2
  Glimpse.into Glimpse::Views::Rails
  Glimpse.into Glimpse::Views::PerformanceBar
end